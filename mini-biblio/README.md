# 📚 Mini Biblio

Application de gestion de bibliothèque avec CDI (Contexts and Dependency Injection).

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐
│  Main Application   │     │   Weld SE Container  │
│  (Console/UI)       │────▶│   CDI Beans          │
└─────────────────────┘     └──────────────────────┘
```

## 🚀 Technologies

| Composant | Technologies |
|-----------|-------------|
| **CDI** | Jakarta CDI 4.0.1 |
| **Container** | Weld SE 5.1.0 |
| **Annotations** | Jakarta Annotation 2.1.1 |
| **EL** | Jakarta EL 5.0 |
| **Java** | 7+ |

## 📦 Fonctionnalités

- ✅ Injection de dépendances (CDI)
- ✅ Gestion des livres
- ✅ Gestion des emprunts
- ✅ Architecture modulaire

## ⚙️ Installation

### Prérequis
- Java 7+
- Maven 3.8+

### Compilation et Exécution

```bash
# Compiler
mvn clean compile

# Exécuter
mvn exec:java -Dexec.mainClass="com.example.Main"
```

---

## 📁 Structure du Projet

```
mini-biblio/
└── biblio/
    ├── src/main/java/     # Code source
    └── pom.xml            # Configuration Maven
```

---

## 👤 Auteur

**HamzaElyo** - Projet JEE S9 UEMF

## 📄 License

MIT License
