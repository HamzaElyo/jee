# ⚡ Energy Management System

Application web de gestion et suivi de la consommation énergétique.

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐     ┌─────────────────┐
│  Frontend JSP       │     │   Servlets           │     │   MySQL         │
│  (JSTL + CSS)       │────▶│   + Services         │────▶│   Database      │
└─────────────────────┘     └──────────────────────┘     └─────────────────┘
```

## 🚀 Technologies

| Composant | Technologies |
|-----------|-------------|
| **Frontend** | JSP, JSTL, HTML, CSS |
| **Backend** | Jakarta Servlet 6.0 |
| **Persistence** | JPA, Hibernate 6.4.5 |
| **Base de données** | MySQL 8.0 |
| **Connection Pool** | HikariCP 5.1 |
| **Serveur** | WildFly 30 / Tomcat 10+ |

## 📦 Fonctionnalités

- ✅ Suivi consommation énergétique
- ✅ Gestion des sites/compteurs
- ✅ Rapports et statistiques
- ✅ Alertes de consommation
- ✅ Dashboard analytique

## ⚙️ Installation

### Prérequis
- Java 17+
- Maven 3.8+
- MySQL 8+
- WildFly 30+ ou Tomcat 10+

### Configuration Base de Données

```sql
CREATE DATABASE energy_db;
```

### Compilation et Déploiement

```bash
# Compiler
mvn clean package

# Déployer
cp target/energy.war $WILDFLY_HOME/standalone/deployments/
```

### Accès
- Application: http://localhost:8080/energy

---

## 👤 Auteur

**HamzaElyo** - Projet JEE S9 UEMF

