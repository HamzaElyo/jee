# 🔧 MicroService JEE

Microservice Jakarta EE avec Docker.

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐
│  Docker Container   │     │   Jakarta EE 9.1     │
│                     │────▶│   JAX-RS API         │
└─────────────────────┘     └──────────────────────┘
```

## 🚀 Technologies

| Composant | Technologies |
|-----------|-------------|
| **Platform** | Jakarta EE Web 9.1 |
| **Containerisation** | Docker |
| **Build** | Maven |
| **Java** | 11 |

## 📦 Fonctionnalités

- ✅ API REST
- ✅ Conteneurisation Docker
- ✅ Microservice léger

## ⚙️ Installation

### Prérequis
- Java 11+
- Maven 3.8+
- Docker (optionnel)

### Compilation

```bash
# Compiler
mvn clean package
```

### Docker

```bash
# Build image
docker build -t microservice-jee .

# Run container
docker run -p 8080:8080 microservice-jee
```

### Accès
- API: http://localhost:8080/microService

---

## 👤 Auteur

**HamzaElyo** - Projet JEE S9 UEMF

## 📄 License

MIT License
