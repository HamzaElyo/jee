---
title: Student Risk Prediction
emoji: 🎓
colorFrom: blue
colorTo: purple
sdk: gradio
sdk_version: "5.9.1"
app_file: app.py
pinned: false
---

# 🎓 Student Risk Prediction

Prédit le niveau de risque de décrochage d'un étudiant basé sur son engagement.

## Modèle

- **Algorithme**: Random Forest (100 arbres)
- **Dataset**: OULAD (Open University Learning Analytics Dataset)
- **Accuracy**: 64%

## Features

| Feature | Description |
|---------|-------------|
| Total Clicks | Nombre de clicks sur la plateforme |
| Active Days | Jours d'activité |
| Assessments | Évaluations complétées |
| Avg Score | Score moyen (0-100) |

## Output

- **Risk Level**: Critical, High, Medium, Low
- **Risk Score**: 0-100%
- **Probabilities**: Pour chaque niveau

## API Usage

```python
from gradio_client import Client

client = Client("HamzaElyo/elearning")
result = client.predict(
    total_clicks=500,
    active_days=30,
    num_assessments=10,
    avg_score=65,
    api_name="/predict"
)
```

## Author

HamzaElyo - UEMF S9 JEE Project
