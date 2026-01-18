# 🏦 Bank Analytics Manager

Application web JEE pour la gestion et l'analyse des flux bancaires.

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐     ┌─────────────────┐
│  Frontend JSP       │     │   Servlets/Controllers│     │   MySQL         │
│  (JSTL + CSS)       │────▶│   + Services Layer   │────▶│   Database      │
│                     │     │   + DAO Layer        │     │                 │
└─────────────────────┘     └──────────────────────┘     └─────────────────┘
```

## 🚀 Technologies

| Composant | Technologies |
|-----------|-------------|
| **Frontend** | JSP, JSTL, HTML, CSS, JavaScript |
| **Backend** | Jakarta EE 10, Servlets, JAX-RS |
| **Persistence** | JPA, Hibernate 6.4.5 |
| **Base de données** | MySQL 8.0 |
| **Connection Pool** | HikariCP |
| **Sérialisation** | Jackson JSON |
| **Serveur** | WildFly 30 / Tomcat 10+ |

## 📦 Fonctionnalités

- ✅ Gestion des comptes bancaires
- ✅ Suivi des transactions
- ✅ Analyse des flux financiers
- ✅ Rapports et statistiques
- ✅ Validation des données

## ⚙️ Installation

### Prérequis
- Java 17+
- Maven 3.8+
- MySQL 8+
- WildFly 30+ ou Tomcat 10+

### Configuration Base de Données

```sql
CREATE DATABASE bank_analytics;
CREATE USER 'bankuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON bank_analytics.* TO 'bankuser'@'localhost';
```

### Compilation et Déploiement

```bash
# Compiler le projet
mvn clean package

# Déployer sur WildFly
cp target/BankFlowManager.war $WILDFLY_HOME/standalone/deployments/

# Démarrer le serveur
$WILDFLY_HOME/bin/standalone.bat
```

### Accès
- Application: http://localhost:8080/BankFlowManager

---

## 👤 Auteur

**HamzaElyo** - Projet JEE S9 UEMF
