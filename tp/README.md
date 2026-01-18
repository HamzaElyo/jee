# 🌐 IoT Platform

Plateforme IoT avec Jakarta EE 10 pour la gestion des appareils connectés.

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐
│  Frontend JSP       │     │   Jakarta EE 10      │
│  (JSTL + UI)        │────▶│   Servlets + API     │
└─────────────────────┘     └──────────────────────┘
```

## 🚀 Technologies

| Composant | Technologies |
|-----------|-------------|
| **Platform** | Jakarta EE 10 |
| **Frontend** | JSP, JSTL |
| **Backend** | Jakarta Servlet 6.1 |
| **Java** | 19 |
| **Serveur** | WildFly 30 |

## 📦 Fonctionnalités

- ✅ Gestion des appareils IoT
- ✅ Monitoring en temps réel
- ✅ Dashboard de visualisation
- ✅ API REST

## ⚙️ Installation

### Prérequis
- Java 19+
- Maven 3.8+
- WildFly 30+

### Compilation et Déploiement

```bash
# Compiler
mvn clean package

# Déployer
cp target/iotplatform.war $WILDFLY_HOME/standalone/deployments/
```

### Accès
- Application: http://localhost:8080/iotplatform

---

## 👤 Auteur

**HamzaElyo** - Projet JEE S9 UEMF

## 📄 License

MIT License
