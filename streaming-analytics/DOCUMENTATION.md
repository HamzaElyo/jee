# 📊 Streaming Analytics Platform - Documentation Complète

## 🎯 Objectif du Projet

Plateforme d'analyse de streaming vidéo qui simule et visualise les données d'utilisation d'un service de streaming (type Netflix/YouTube). Ce projet démontre l'utilisation de **Jakarta EE**, **MongoDB**, et **SSE (Server-Sent Events)** pour le temps réel.

---

## 🏗️ Architecture Globale

```
streaming-analytics/
├── data-generator/          # Module de génération de données
├── analytics-api/           # API REST Backend (JAX-RS)
├── analytics-dashboard/     # Interface Web (JSP/Servlet)
├── files/                   # Configuration Docker & scripts
└── pom.xml                  # POM parent Maven
```

---

## 📦 Module 1 : data-generator

**But** : Génère des données de test (vidéos et événements) et les insère dans MongoDB.

### Structure
```
data-generator/
└── src/main/java/com/streaming/datagenerator/
    └── DataGenerator.java    # Classe principale
```

### DataGenerator.java
| Méthode | Description |
|---------|-------------|
| `main()` | Point d'entrée, connecte à MongoDB et lance la génération |
| `generateVideo(int id)` | Crée une vidéo avec titre, catégorie, durée, vues aléatoires |
| `generateEvent()` | Crée un événement (WATCH, PAUSE, SEEK, STOP, RESUME) |
| `sendVideosToMongo()` | Insère les vidéos dans la collection `videos` |
| `sendEventsToMongo()` | Insère les événements dans la collection `events` |

### Données Générées
- **1000+ vidéos** : 8 catégories (Action, Comedy, Drama, Documentary, SciFi, Horror, Romance, Thriller)
- **2000+ événements** : 5 actions, 5 types d'appareils
- **Format videoId** : `vid_1`, `vid_2`, ...
- **Format eventId** : `evt_UUID`

### Exécution
```bash
cd data-generator
mvn compile exec:java "-Dexec.mainClass=com.streaming.datagenerator.DataGenerator"
```

---

## 📦 Module 2 : analytics-api

**But** : API REST qui expose les données MongoDB pour le dashboard.

### Structure
```
analytics-api/
└── src/main/java/com/streaming/analytics/
    ├── api/
    │   └── AnalyticsResource.java      # Endpoints REST (JAX-RS)
    ├── model/
    │   ├── Video.java                  # Entité vidéo
    │   ├── VideoStats.java             # Statistiques vidéo
    │   ├── ViewEvent.java              # Événement de visionnage
    │   └── UserProfile.java            # Profil utilisateur
    ├── repository/
    │   ├── VideoRepository.java        # Accès données Video
    │   ├── VideoStatsRepository.java   # Accès stats (agrégation events)
    │   └── UserProfileRepository.java  # Accès profils
    ├── service/
    │   ├── AnalyticsService.java       # Logique métier principale
    │   └── EventProcessorService.java  # Traitement événements SSE
    └── util/
        └── MongoProducer.java          # Configuration MongoDB (CDI)
```

### Endpoints REST (AnalyticsResource.java)

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/videos/top` | GET | Top 10 vidéos par vues |
| `/videos/{id}/stats` | GET | Stats d'une vidéo spécifique |
| `/categories/stats` | GET | Stats agrégées par catégorie |
| `/users/{id}/recommendations` | GET | Recommandations personnalisées |
| `/users` | GET | Liste des utilisateurs avec stats |
| `/events/stats/actions` | GET | Répartition par type d'action |
| `/events/stats/devices` | GET | Répartition par appareil |
| `/events/recent` | GET | Derniers événements |
| `/realtime/stream` | GET (SSE) | Flux temps réel |
| `/stats/global` | GET | Compteurs globaux (videos, events) |

### AnalyticsService.java - Méthodes Principales

| Méthode | Description |
|---------|-------------|
| `aggregateByCategory()` | Agrège les vidéos par catégorie avec stats |
| `aggregateByAction()` | Compte les événements par type d'action |
| `aggregateByDevice()` | Compte les événements par appareil |
| `getRecommendations(userId)` | **Algorithme de recommandation dynamique** |
| `getTopVideosByViews(limit)` | Top vidéos par nombre de vues |
| `getTotalEventCount()` | Compte total d'événements |
| `getTotalVideoCount()` | Compte total de vidéos |
| `getUsersWithStats()` | Liste utilisateurs depuis events |

### Algorithme de Recommandation

```
1. Récupérer les événements de l'utilisateur
2. Identifier les vidéos qu'il a déjà regardées
3. Calculer ses catégories préférées (par fréquence)
4. Collecter ~50 vidéos candidates (populaires dans ses catégories)
5. Mélanger aléatoirement (seed = userId.hashCode())
6. Retourner 10 recommandations uniques
```

### Configuration MongoDB (MongoProducer.java)
- **URI** : `mongodb://admin:admin123@localhost:27017/streaming_analytics?authSource=admin`
- **Base** : `streaming_analytics`
- **Collections** : `videos`, `events`

---

## 📦 Module 3 : analytics-dashboard

**But** : Interface web pour visualiser les données analytiques.

### Structure
```
analytics-dashboard/
├── src/main/java/com/streaming/dashboard/servlet/
│   └── DashboardServlet.java           # Router principal
└── src/main/webapp/
    └── WEB-INF/
        ├── home.jsp                    # Page d'accueil principale
        └── views/
            ├── videos.jsp              # Page catalogue vidéos
            ├── users.jsp               # Page utilisateurs
            ├── analytics.jsp           # Page analytics détaillée
            ├── events.jsp              # Page événements
            ├── collections.jsp         # Page collections MongoDB
            └── settings.jsp            # Page paramètres
```

### Pages du Dashboard

#### home.jsp
- **Stats header** : Total événements, Vidéos catalogue, Vues totales, Durée moyenne
- **Top 10 vidéos** : Tableau avec barres de progression
- **Graphique catégories** : Pie chart par catégorie
- **Graphique actions** : Pie chart (WATCH, PAUSE, SEEK, STOP, RESUME)
- **Graphique appareils** : Bar chart horizontal (desktop, mobile, tablet, tv, console)
- **Événements Live** : Flux SSE temps réel

#### videos.jsp
- Liste des vidéos par catégorie
- Stats par catégorie
- Top vidéos

#### users.jsp
- Liste des utilisateurs (depuis events)
- Recommandations personnalisées par utilisateur
- Vidéos regardées

#### analytics.jsp
- Graphiques détaillés
- Filtres et analyses

#### events.jsp
- Liste des événements récents
- Filtres par action (WATCH, PAUSE, STOP, RESUME, SEEK)
- Filtres par appareil

#### collections.jsp
- Vue des collections MongoDB
- Compteurs de documents

#### settings.jsp
- Configuration API
- État des services (API, MongoDB, SSE)
- Bouton "Vérifier" pour tester les connexions

### Technologies Frontend
- **Chart.js** : Graphiques interactifs
- **CSS moderne** : Variables CSS, flexbox, grid
- **Font Awesome** : Icônes
- **SSE** : Événements temps réel

---

## 🐳 Configuration Docker

### fichier files/docker-compose.yml

```yaml
services:
  mongodb:
    image: mongo:7.0
    ports: "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin123
      
  mongo-express:
    image: mongo-express
    ports: "8081:8081"
```

### Commandes Docker
```bash
# Démarrer
docker-compose up -d

# Voir les logs
docker-compose logs mongodb

# Arrêter
docker-compose down
```

---

## 📊 Collections MongoDB

### Collection `videos`
```json
{
  "videoId": "vid_123",
  "title": "Action Movie 123",
  "category": "Action",
  "duration": 7200,
  "uploadDate": "2024-01-15T10:30:00Z",
  "views": 45000,
  "likes": 3200
}
```

### Collection `events`
```json
{
  "eventId": "evt_uuid-here",
  "userId": "user_42",
  "videoId": "vid_123",
  "timestamp": "2024-12-28T19:30:00Z",
  "action": "WATCH",
  "duration": 1800,
  "quality": "1080p",
  "deviceType": "desktop"
}
```

---

## 🔄 Flux de Données

```
┌─────────────────┐   Generate    ┌─────────────────┐
│  DataGenerator  │ ────────────► │    MongoDB      │
│                 │               │                 │
│  - 1000+ videos │               │  - videos       │
│  - 2000+ events │               │  - events       │
└─────────────────┘               └────────┬────────┘
                                           │
                                           │ Query
                                           ▼
┌─────────────────┐   REST/SSE   ┌─────────────────┐
│   Dashboard     │ ◄──────────── │   Analytics API │
│                 │               │                 │
│  - Charts       │               │  - Agrégation   │
│  - Tables       │               │  - Recommand.   │
│  - Live Events  │               │  - Stats        │
└─────────────────┘               └─────────────────┘
```

---

## 🚀 Démarrage Rapide

### 1. Prérequis
- Java 11+
- Maven 3.6+
- Docker & Docker Compose
- WildFly 26+ (ou autre serveur JEE)

### 2. Démarrer MongoDB
```bash
cd files
docker-compose up -d
```

### 3. Générer les données
```bash
cd data-generator
mvn compile exec:java "-Dexec.mainClass=com.streaming.datagenerator.DataGenerator"
```

### 4. Compiler le projet
```bash
mvn clean package -DskipTests
```

### 5. Déployer les WARs
Copier dans WildFly :
- `analytics-api/target/analytics-api.war`
- `analytics-dashboard/target/analytics-dashboard.war`

### 6. Accéder au Dashboard
- Dashboard : http://localhost:8080/analytics_dashboard_war_exploded/dashboard
- API : http://localhost:8080/analytics_api_war_exploded/api/v1/analytics
- Mongo Express : http://localhost:8081

---

## 📝 Auteur
Projet TP Big Data Analytics - UEMF S9 JEE
