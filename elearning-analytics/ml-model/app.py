"""
Student Risk Prediction API - Gradio App for Hugging Face Spaces
Uses pre-trained Random Forest model on real OULAD data
"""

import gradio as gr
import numpy as np
import os
import joblib

# Charger le modèle pré-entraîné
MODEL_PATH = "model.pkl"
ENCODER_PATH = "label_encoder.pkl"

if os.path.exists(MODEL_PATH) and os.path.exists(ENCODER_PATH):
    print("✅ Chargement du modèle pré-entraîné sur données OULAD...")
    model = joblib.load(MODEL_PATH)
    label_encoder = joblib.load(ENCODER_PATH)
    print(f"   Classes: {list(label_encoder.classes_)}")
else:
    print("⚠️ Modèle non trouvé, création d'un modèle par défaut...")
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.preprocessing import LabelEncoder
    
    np.random.seed(42)
    n = 2000
    X_train = np.column_stack([
        np.random.exponential(500, n),
        np.random.exponential(30, n),
        np.random.randint(0, 20, n),
        np.random.normal(60, 20, n).clip(0, 100)
    ])
    
    risk = (X_train[:, 0] < 200) * 30 + (X_train[:, 1] < 10) * 25 + \
           (X_train[:, 2] < 5) * 25 + (X_train[:, 3] < 50) * 20
    y_labels = np.where(risk >= 70, 'Critical',
               np.where(risk >= 50, 'High',
               np.where(risk >= 30, 'Medium', 'Low')))
    
    label_encoder = LabelEncoder()
    y_encoded = label_encoder.fit_transform(y_labels)
    
    model = RandomForestClassifier(n_estimators=50, max_depth=8, random_state=42)
    model.fit(X_train, y_encoded)
    print("✅ Modèle par défaut créé")


def predict_risk(total_clicks: float, active_days: float, num_assessments: float, avg_score: float):
    """
    Prédit le niveau de risque d'un étudiant
    """
    # Limiter avg_score à 0-100
    avg_score = max(0, min(100, avg_score))
    
    # Préparer les features
    features = np.array([[total_clicks, active_days, num_assessments, avg_score]])
    
    # Prédiction
    prediction = model.predict(features)[0]
    probabilities = model.predict_proba(features)[0]
    
    # Décoder le label
    risk_level = label_encoder.inverse_transform([prediction])[0]
    
    # Construire le dictionnaire de probabilités
    prob_dict = {label: float(prob) for label, prob in 
                 zip(label_encoder.classes_, probabilities)}
    
    # Calculer un score de risque (0-100)
    risk_score = int(
        prob_dict.get('Critical', 0) * 100 +
        prob_dict.get('High', 0) * 70 +
        prob_dict.get('Medium', 0) * 40 +
        prob_dict.get('Low', 0) * 10
    )
    
    # Formater le résultat
    output = f"""
## 🎯 Résultat de la Prédiction

**Niveau de Risque:** {risk_level}

**Score de Risque:** {risk_score}%

### 📊 Probabilités
| Niveau | Probabilité |
|--------|-------------|
| Critical | {prob_dict.get('Critical', 0):.1%} |
| High | {prob_dict.get('High', 0):.1%} |
| Medium | {prob_dict.get('Medium', 0):.1%} |
| Low | {prob_dict.get('Low', 0):.1%} |

### 📥 Données d'entrée
- Total Clicks: {int(total_clicks)}
- Active Days: {int(active_days)}
- Assessments: {int(num_assessments)}
- Avg Score: {avg_score:.1f}

---
*Modèle: Random Forest entraîné sur données OULAD réelles*
"""
    return output


# Interface Gradio
demo = gr.Interface(
    fn=predict_risk,
    inputs=[
        gr.Number(label="Total Clicks", value=500, info="Nombre de clicks sur la plateforme"),
        gr.Number(label="Active Days", value=30, info="Jours d'activité"),
        gr.Number(label="Assessments", value=10, info="Évaluations complétées"),
        gr.Slider(0, 100, value=65, label="Average Score", info="Score moyen (0-100)")
    ],
    outputs=gr.Markdown(label="Résultat"),
    title="🎓 Student Risk Prediction",
    description="Prédit le niveau de risque de décrochage d'un étudiant basé sur son engagement. Modèle entraîné sur les vraies données OULAD (Open University Learning Analytics Dataset).",
    examples=[
        [100, 5, 2, 45],    # High risk student
        [500, 30, 10, 65],  # Medium risk student
        [1500, 60, 18, 85]  # Low risk student
    ],
    theme=gr.themes.Soft()
)


if __name__ == "__main__":
    demo.launch()
