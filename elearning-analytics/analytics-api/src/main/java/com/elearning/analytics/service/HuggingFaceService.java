package com.elearning.analytics.service;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;
import org.bson.Document;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Service pour appeler le modèle ML hébergé sur Hugging Face Spaces (Gradio)
 */
@ApplicationScoped
public class HuggingFaceService {

    // URL du Hugging Face Space - Gradio API endpoint
    private static final String HF_SPACE_BASE = "https://hamzaelyo-elearning.hf.space/gradio_api/call/predict";

    // Timeout en millisecondes
    private static final int TIMEOUT_MS = 30000;

    /**
     * Prédit le risque d'un étudiant en appelant l'API Hugging Face (Gradio)
     */
    public Document predictStudentRisk(int totalClicks, int activeDays, int numAssessments, double avgScore) {
        try {
            // Étape 1: POST pour obtenir un event_id
            // Format Gradio: {"data": [param1, param2, param3, param4]}
            String requestBody = String.format(
                    "{\"data\": [%d, %d, %d, %.1f]}",
                    totalClicks, activeDays, numAssessments, avgScore);

            String eventId = postAndGetEventId(requestBody);

            // Étape 2: GET pour récupérer le résultat
            String result = getResultFromEventId(eventId);

            // Parser le résultat (format SSE avec markdown)
            return parseGradioResult(result, totalClicks, activeDays, numAssessments, avgScore);

        } catch (Exception e) {
            // En cas d'erreur, utiliser le calcul local
            return fallbackPrediction(totalClicks, activeDays, numAssessments, avgScore, e.getMessage());
        }
    }

    /**
     * POST initial pour obtenir l'event_id
     */
    private String postAndGetEventId(String requestBody) throws Exception {
        URL url = new URL(HF_SPACE_BASE);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        try {
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setConnectTimeout(TIMEOUT_MS);
            conn.setReadTimeout(TIMEOUT_MS);
            conn.setDoOutput(true);

            // Envoyer la requête
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = requestBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        response.append(line);
                    }

                    // Parser le JSON pour extraire event_id
                    try (JsonReader jsonReader = Json.createReader(new StringReader(response.toString()))) {
                        JsonObject json = jsonReader.readObject();
                        return json.getString("event_id");
                    }
                }
            } else {
                throw new Exception("POST Error: " + responseCode);
            }
        } finally {
            conn.disconnect();
        }
    }

    /**
     * GET le résultat en utilisant l'event_id
     */
    private String getResultFromEventId(String eventId) throws Exception {
        URL url = new URL(HF_SPACE_BASE + "/" + eventId);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        try {
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(TIMEOUT_MS);
            conn.setReadTimeout(TIMEOUT_MS);

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        response.append(line).append("\n");
                    }
                    return response.toString();
                }
            } else {
                throw new Exception("GET Error: " + responseCode);
            }
        } finally {
            conn.disconnect();
        }
    }

    /**
     * Parse le résultat SSE de Gradio
     * Format: event: complete\ndata: ["## Résultat..."]
     */
    private Document parseGradioResult(String sseResponse, int clicks, int days, int assessments, double score) {
        try {
            // Chercher la ligne "data:" qui contient le résultat
            String dataLine = null;
            for (String line : sseResponse.split("\n")) {
                if (line.startsWith("data:")) {
                    dataLine = line.substring(5).trim();
                }
            }

            if (dataLine != null && dataLine.startsWith("[")) {
                // Parser le JSON array
                try (JsonReader reader = Json.createReader(new StringReader(dataLine))) {
                    String markdown = reader.readArray().getString(0);

                    // Extraire les informations du markdown
                    String riskLevel = extractRiskLevel(markdown);
                    int riskScore = extractRiskScore(markdown);

                    return new Document()
                            .append("riskLevel", riskLevel)
                            .append("riskScore", riskScore)
                            .append("source", "huggingface_ml")
                            .append("model", "RandomForest")
                            .append("input", new Document()
                                    .append("totalClicks", clicks)
                                    .append("activeDays", days)
                                    .append("numAssessments", assessments)
                                    .append("avgScore", score));
                }
            }

            throw new Exception("Could not parse SSE response");

        } catch (Exception e) {
            return fallbackPrediction(clicks, days, assessments, score, "Parse error: " + e.getMessage());
        }
    }

    private String extractRiskLevel(String markdown) {
        if (markdown.contains("Critical"))
            return "Critical";
        if (markdown.contains("High"))
            return "High";
        if (markdown.contains("Medium"))
            return "Medium";
        return "Low";
    }

    private int extractRiskScore(String markdown) {
        // Chercher "Score de Risque:** XX%"
        try {
            int idx = markdown.indexOf("Score de Risque:**");
            if (idx > 0) {
                String after = markdown.substring(idx + 18).trim();
                StringBuilder num = new StringBuilder();
                for (char c : after.toCharArray()) {
                    if (Character.isDigit(c))
                        num.append(c);
                    else if (num.length() > 0)
                        break;
                }
                if (num.length() > 0) {
                    return Integer.parseInt(num.toString());
                }
            }
        } catch (Exception ignored) {
        }
        return 50;
    }

    /**
     * Calcul de fallback si l'API Hugging Face n'est pas accessible
     */
    private Document fallbackPrediction(int totalClicks, int activeDays, int numAssessments, double avgScore,
            String error) {
        int riskScore = 0;

        if (totalClicks < 200)
            riskScore += 30;
        else if (totalClicks < 500)
            riskScore += 15;

        if (activeDays < 10)
            riskScore += 25;
        else if (activeDays < 30)
            riskScore += 10;

        if (numAssessments < 5)
            riskScore += 25;
        else if (numAssessments < 10)
            riskScore += 10;

        if (avgScore < 50)
            riskScore += 20;
        else if (avgScore < 70)
            riskScore += 10;

        String riskLevel;
        if (riskScore >= 70)
            riskLevel = "Critical";
        else if (riskScore >= 50)
            riskLevel = "High";
        else if (riskScore >= 30)
            riskLevel = "Medium";
        else
            riskLevel = "Low";

        return new Document()
                .append("riskLevel", riskLevel)
                .append("riskScore", riskScore)
                .append("source", "fallback_rules")
                .append("warning", "Hugging Face API unavailable: " + error);
    }
}
