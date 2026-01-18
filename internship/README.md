# 🎓 Internship Management System

Système de gestion des stages avec Jakarta EE 10 Platform.

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐     ┌─────────────────┐
│  Frontend JSP       │     │   Jakarta EE 10      │     │   MySQL         │
│  (UI Layer)         │────▶│   CDI, JPA, JAX-RS   │────▶│   Database      │
└─────────────────────┘     └──────────────────────┘     └─────────────────┘
```

## 🚀 Technologies

| Composant | Technologies |
|-----------|-------------|
| **Platform** | Jakarta EE 10 |
| **Persistence** | JPA, Hibernate 6.6.26 |
| **Connection Pool** | HikariCP (Hibernate intégré) |
| **Base de données** | MySQL 8.0 |
| **Serveur** | WildFly 30 |

## 📦 Fonctionnalités

- ✅ Gestion des étudiants
- ✅ Gestion des stages
- ✅ Gestion des entreprises
- ✅ Suivi des candidatures
- ✅ API REST

## ⚙️ Installation

### Prérequis
- Java 17+
- Maven 3.8+
- MySQL 8+
- WildFly 30+

### Configuration Base de Données

```sql
CREATE DATABASE internship_db;
```

### Compilation et Déploiement

```bash
# Compiler
mvn clean package

# Déployer sur WildFly
cp target/internship.war $WILDFLY_HOME/standalone/deployments/
```

### Accès
- Application: http://localhost:8080/internship

---

## 👤 Auteur

**HamzaElyo** - Projet JEE S9 UEMF


