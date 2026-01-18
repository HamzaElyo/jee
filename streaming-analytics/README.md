# 📺 Streaming Analytics Platform

Plateforme d'analyse Big Data pour streaming vidéo avec intégration YouTube et analytics en temps réel.

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐     ┌─────────────────┐
│  analytics-dashboard│     │   analytics-api      │     │   MongoDB       │
│  (JSP + CSS)        │────▶│   (JAX-RS REST)      │────▶│   (NoSQL)       │
│  Port: 8080         │     │   Port: 8080         │     │   Port: 27017   │
└─────────────────────┘     └──────────────────────┘     └─────────────────┘
                                       │
                                       ▼
                             ┌──────────────────────┐
                             │   data-generator     │
                             │   (JSON Generator)   │
                             └──────────────────────┘
```

## 🚀 Technologies

| Composant | Technologies |
|-----------|-------------|
| **Frontend** | JSP, JSTL, CSS, JavaScript |
| **Backend API** | Jakarta EE 10, JAX-RS, CDI |
| **Base de données** | MongoDB 6+ |
| **ORM** | Hibernate OGM |
| **Serveur** | WildFly 30 |
| **Sérialisation** | Jackson JSON |

## 📦 Modules

### 1. analytics-api
API REST pour l'accès aux données d'analytics:
- Endpoints vidéos et statistiques
- Gestion des utilisateurs
- Profils et recommandations
- Server-Sent Events (SSE) temps réel

### 2. analytics-dashboard
Dashboard web avec visualisations:
- Statistiques globales
- Tendances vidéos
- Analyses par catégorie
- Graphiques interactifs

### 3. data-generator
Générateur de données de test:
- Catalogue vidéos (JSON)
- Events streaming (100k+)

## ⚙️ Installation

### Prérequis
- Java 11+
- Maven 3.8+
- MongoDB 6+
- WildFly 30+

### Déploiement

```bash
# 1. Compiler tous les modules
mvn clean package -DskipTests

# 2. Déployer sur WildFly
cp analytics-api/target/analytics-api.war $WILDFLY_HOME/standalone/deployments/
cp analytics-dashboard/target/analytics-dashboard.war $WILDFLY_HOME/standalone/deployments/

# 3. Démarrer MongoDB et WildFly
mongod
$WILDFLY_HOME/bin/standalone.bat
```

### Accès
- Dashboard: http://localhost:8080/analytics-dashboard
- API: http://localhost:8080/analytics-api/api

---

## 📚 Documentation

Voir `DOCUMENTATION.md` pour plus de détails sur l'architecture et l'API.

## 👤 Auteur

**HamzaElyo** - Projet JEE S9 UEMF

## 📄 License

MIT License
