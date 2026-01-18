# 🛒 Mini Projet JEE

Application web Jakarta EE avec Servlets, JSP et Hibernate.

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

- ✅ CRUD complet
- ✅ Interface utilisateur JSP
- ✅ Persistence avec Hibernate
- ✅ Connection pooling

## ⚙️ Installation

### Prérequis
- Java 17+
- Maven 3.8+
- MySQL 8+
- WildFly 30+ ou Tomcat 10+

### Configuration Base de Données

```sql
CREATE DATABASE mini_projet;
```

### Compilation et Déploiement

```bash
# Compiler
mvn clean package

# Déployer
cp target/mini_projet.war $WILDFLY_HOME/standalone/deployments/
```

### Accès
- Application: http://localhost:8080/mini_projet

---

## 👤 Auteur

**HamzaElyo** - Projet JEE S9 UEMF

## 📄 License

MIT License
