package com.elearning.analytics.service;

import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static com.mongodb.client.model.Accumulators.*;
import static com.mongodb.client.model.Sorts.*;

/**
 * Service de prédiction de risque de décrochage étudiant
 * Calcule un score de risque basé sur l'engagement et l'activité
 */
@ApplicationScoped
public class PredictionService {

    @Inject
    private MongoDatabase database;

    /**
     * Calcule le score de risque de décrochage pour un étudiant
     * Score de 0-100 (0 = pas de risque, 100 = risque très élevé)
     */
    public Document predictStudentRisk(String studentId) {
        // Récupérer les infos de l'étudiant
        Document student = database.getCollection("students")
                .find(Filters.eq("studentId", studentId))
                .first();

        if (student == null) {
            return new Document("error", "Student not found");
        }

        // Calculer les métriques d'engagement
        Document engagement = calculateEngagementMetrics(studentId);

        // Calculer le score de risque
        int riskScore = calculateRiskScore(student, engagement);
        String riskLevel = getRiskLevel(riskScore);

        return new Document()
                .append("studentId", studentId)
                .append("riskScore", riskScore)
                .append("riskLevel", riskLevel)
                .append("engagement", engagement)
                .append("student", new Document()
                        .append("region", student.getString("region"))
                        .append("highestEducation", student.getString("highestEducation"))
                        .append("ageBand", student.getString("ageBand"))
                        .append("finalResult", student.getString("finalResult")))
                .append("recommendations", generateRecommendations(riskScore, engagement));
    }

    /**
     * Retourne les étudiants à risque avec calcul basé sur les quartiles
     */
    public List<Document> getAtRiskStudents(int limit) {
        List<Document> allStudents = new ArrayList<>();
        List<Integer> allClicks = new ArrayList<>();
        List<Integer> allDays = new ArrayList<>();

        // 1. Récupérer tous les étudiants avec leur engagement
        List<Bson> pipeline = Arrays.asList(
                Aggregates.group("$studentId",
                        sum("totalClicks", "$sumClick"),
                        sum("activeDays", 1)));

        List<Document> aggregated = database.getCollection("events")
                .aggregate(pipeline)
                .into(new ArrayList<>());

        // Collecter les valeurs pour calculer les quartiles
        for (Document event : aggregated) {
            allClicks.add(event.getInteger("totalClicks", 0));
            allDays.add(event.getInteger("activeDays", 0));
        }

        // 2. Calculer les quartiles
        Collections.sort(allClicks);
        Collections.sort(allDays);
        int n = allClicks.size();
        if (n == 0)
            return allStudents;

        int[] clicksQ = {
                allClicks.get(Math.max(0, n / 4 - 1)),
                allClicks.get(Math.max(0, n / 2 - 1)),
                allClicks.get(Math.max(0, 3 * n / 4 - 1))
        };
        int[] daysQ = {
                allDays.get(Math.max(0, n / 4 - 1)),
                allDays.get(Math.max(0, n / 2 - 1)),
                allDays.get(Math.max(0, 3 * n / 4 - 1))
        };

        // 3. Calculer le score de risque pour chaque étudiant
        for (Document event : aggregated) {
            String studentId = event.getString("_id");
            if (studentId == null)
                continue;

            int totalClicks = event.getInteger("totalClicks", 0);
            int activeDays = event.getInteger("activeDays", 0);

            // Calculer le score basé sur les quartiles
            int riskScore = 0;

            // Score clicks (0-50)
            if (totalClicks <= clicksQ[0])
                riskScore += 50;
            else if (totalClicks <= clicksQ[1])
                riskScore += 35;
            else if (totalClicks <= clicksQ[2])
                riskScore += 20;
            else
                riskScore += 5;

            // Score jours actifs (0-50)
            if (activeDays <= daysQ[0])
                riskScore += 50;
            else if (activeDays <= daysQ[1])
                riskScore += 35;
            else if (activeDays <= daysQ[2])
                riskScore += 20;
            else
                riskScore += 5;

            // Chercher l'étudiant dans la collection students
            Document student = database.getCollection("students")
                    .find(Filters.eq("studentId", studentId))
                    .first();

            String region = student != null ? student.getString("region") : "Unknown";
            String finalResult = student != null ? student.getString("finalResult") : "In Progress";

            // Bonus/malus selon le résultat final
            if ("Withdrawn".equals(finalResult))
                riskScore = Math.min(100, riskScore + 15);
            else if ("Fail".equals(finalResult))
                riskScore = Math.min(100, riskScore + 10);
            else if ("Pass".equals(finalResult))
                riskScore = Math.max(0, riskScore - 15);
            else if ("Distinction".equals(finalResult))
                riskScore = Math.max(0, riskScore - 25);

            allStudents.add(new Document()
                    .append("studentId", studentId)
                    .append("riskScore", riskScore)
                    .append("riskLevel", getRiskLevel(riskScore))
                    .append("region", region)
                    .append("finalResult", finalResult)
                    .append("totalClicks", totalClicks)
                    .append("activeDays", activeDays));
        }

        // Trier par score de risque décroissant
        allStudents.sort((a, b) -> Integer.compare(b.getInteger("riskScore"), a.getInteger("riskScore")));

        return allStudents.subList(0, Math.min(limit, allStudents.size()));
    }

    /**
     * Calcule les métriques d'engagement d'un étudiant
     */
    private Document calculateEngagementMetrics(String studentId) {
        List<Bson> pipeline = Arrays.asList(
                Aggregates.match(Filters.eq("studentId", studentId)),
                Aggregates.group(null,
                        sum("totalClicks", "$sumClick"),
                        sum("activeDays", 1),
                        max("lastActivity", "$date"),
                        avg("avgClicksPerDay", "$sumClick")));

        Document result = database.getCollection("events")
                .aggregate(pipeline)
                .first();

        if (result == null) {
            return new Document()
                    .append("totalClicks", 0)
                    .append("activeDays", 0)
                    .append("lastActivity", 0)
                    .append("avgClicksPerDay", 0.0)
                    .append("engagementLevel", "None");
        }

        int totalClicks = result.getInteger("totalClicks", 0);
        int activeDays = result.getInteger("activeDays", 0);
        double avgClicks = result.getDouble("avgClicksPerDay") != null ? result.getDouble("avgClicksPerDay") : 0.0;

        String engagementLevel;
        if (avgClicks > 50)
            engagementLevel = "High";
        else if (avgClicks > 20)
            engagementLevel = "Medium";
        else if (avgClicks > 5)
            engagementLevel = "Low";
        else
            engagementLevel = "Very Low";

        return new Document()
                .append("totalClicks", totalClicks)
                .append("activeDays", activeDays)
                .append("lastActivity", result.getInteger("lastActivity", 0))
                .append("avgClicksPerDay", Math.round(avgClicks * 10.0) / 10.0)
                .append("engagementLevel", engagementLevel);
    }

    /**
     * Calcule le score de risque basé sur plusieurs facteurs
     */
    private int calculateRiskScore(Document student, Document engagement) {
        int score = 0;

        // Facteur 1: Résultat final (si déjà connu)
        String finalResult = student.getString("finalResult");
        if ("Withdrawn".equals(finalResult))
            score += 40;
        else if ("Fail".equals(finalResult))
            score += 30;
        else if ("Pass".equals(finalResult))
            score -= 20;
        else if ("Distinction".equals(finalResult))
            score -= 30;

        // Facteur 2: Niveau d'engagement
        int totalClicks = engagement.getInteger("totalClicks", 0);
        if (totalClicks < 50)
            score += 25;
        else if (totalClicks < 200)
            score += 15;
        else if (totalClicks < 500)
            score += 5;
        else
            score -= 10;

        // Facteur 3: Jours actifs
        int activeDays = engagement.getInteger("activeDays", 0);
        if (activeDays < 5)
            score += 20;
        else if (activeDays < 15)
            score += 10;
        else if (activeDays > 50)
            score -= 10;

        // Facteur 4: Dernière activité
        int lastActivity = engagement.getInteger("lastActivity", 0);
        if (lastActivity > 200)
            score += 15; // Plus de 200 jours sans activité
        else if (lastActivity > 100)
            score += 10;

        // Normaliser entre 0 et 100
        return Math.max(0, Math.min(100, score + 30));
    }

    private String getRiskLevel(int score) {
        if (score >= 70)
            return "Critical";
        if (score >= 50)
            return "High";
        if (score >= 30)
            return "Medium";
        return "Low";
    }

    private List<String> generateRecommendations(int riskScore, Document engagement) {
        List<String> recommendations = new ArrayList<>();

        if (riskScore >= 70) {
            recommendations.add("Contact étudiant urgent recommandé");
            recommendations.add("Proposer un tuteur personnel");
        }

        if (engagement.getInteger("activeDays", 0) < 10) {
            recommendations.add("Envoyer rappels de connexion");
        }

        if (engagement.getInteger("totalClicks", 0) < 100) {
            recommendations.add("Encourager participation aux activités");
        }

        if ("Very Low".equals(engagement.getString("engagementLevel"))) {
            recommendations.add("Programme de réengagement requis");
        }

        if (recommendations.isEmpty()) {
            recommendations.add("Continuer le suivi standard");
        }

        return recommendations;
    }
}
