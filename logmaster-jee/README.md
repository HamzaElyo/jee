# 📋 LogMaster JEE

Application JEE de gestion de logs avec persistence polyglotte (PostgreSQL + MongoDB).

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐     ┌─────────────────┐
│  Frontend JSP       │     │   EJB Services       │     │   PostgreSQL    │
│  (JSTL + CSS)       │────▶│   + DAOs             │────▶│   (Données)     │
└─────────────────────┘     └──────────────────────┘     └─────────────────┘
                                       │
                                       ▼
                             ┌──────────────────────┐
                             │   MongoDB            │
                             │   (Logs NoSQL)       │
                             └──────────────────────┘
```

## 🚀 Technologies

| Composant | Technologies |
|-----------|-------------|
| **Frontend** | JSP, JSTL, HTML, CSS |
| **Backend** | Jakarta EE 10, CDI, EJB, JAX-RS |
| **Persistence SQL** | JPA, Hibernate 6.4.4, PostgreSQL |
| **Persistence NoSQL** | MongoDB Driver 4.11.1 |
| **Cache** | Ehcache 3.10 |
| **Serveur** | WildFly 30 |

## 📦 Fonctionnalités

- ✅ Persistence polyglotte (SQL + NoSQL)
- ✅ Gestion des utilisateurs (PostgreSQL)
- ✅ Logging centralisé (MongoDB)
- ✅ Cache distribué (Ehcache)
- ✅ API REST (JAX-RS)
- ✅ Interface web JSP

## ⚙️ Installation

### Prérequis
- Java 17+
- Maven 3.8+
- PostgreSQL 14+
- MongoDB 6+
- WildFly 30+

### Configuration PostgreSQL

```sql
CREATE DATABASE logmaster;
CREATE USER logmaster_user WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE logmaster TO logmaster_user;
```

### Compilation et Déploiement

```bash
# Compiler le projet
mvn clean package

# Déployer sur WildFly
cp target/logmaster-jee.war $WILDFLY_HOME/standalone/deployments/

# Démarrer les services
mongod
pg_ctl start
$WILDFLY_HOME/bin/standalone.bat
```

### Accès
- Application: http://localhost:8080/logmaster-jee

---

## 👤 Auteur

**HamzaElyo** - Projet JEE S9 UEMF

## 📄 License

MIT License
