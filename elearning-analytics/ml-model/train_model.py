"""
Script d'entraînement du modèle Random Forest pour la prédiction de risque étudiant
Basé sur le dataset OULAD (Open University Learning Analytics Dataset)
"""

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import classification_report, accuracy_score
import joblib
import os

# Simuler des données OULAD pour l'entraînement
# Dans un vrai cas, charger depuis MongoDB ou CSV
def generate_training_data(n_samples=5000):
    """
    Génère des données d'entraînement simulées basées sur OULAD
    Features: totalClicks, activeDays, numAssessments
    Target: riskLevel (Critical, High, Medium, Low)
    """
    np.random.seed(42)
    
    # Générer des features
    data = {
        'totalClicks': np.random.exponential(scale=500, size=n_samples).astype(int),
        'activeDays': np.random.exponential(scale=30, size=n_samples).astype(int),
        'numAssessments': np.random.randint(0, 20, size=n_samples),
        'avgScore': np.random.normal(loc=60, scale=20, size=n_samples).clip(0, 100),
    }
    
    df = pd.DataFrame(data)
    
    # Calculer un score de risque basé sur les features
    risk_score = (
        (df['totalClicks'] < 200).astype(int) * 30 +
        (df['activeDays'] < 10).astype(int) * 25 +
        (df['numAssessments'] < 5).astype(int) * 25 +
        (df['avgScore'] < 50).astype(int) * 20
    )
    
    # Ajouter du bruit
    risk_score += np.random.randint(-10, 10, size=n_samples)
    risk_score = risk_score.clip(0, 100)
    
    # Convertir en catégories
    def get_risk_level(score):
        if score >= 70: return 'Critical'
        elif score >= 50: return 'High'
        elif score >= 30: return 'Medium'
        else: return 'Low'
    
    df['riskLevel'] = risk_score.apply(get_risk_level)
    
    return df

def train_model():
    """Entraîne et sauvegarde le modèle Random Forest"""
    print("📊 Génération des données d'entraînement...")
    df = generate_training_data(5000)
    
    # Préparer les features et le target
    X = df[['totalClicks', 'activeDays', 'numAssessments', 'avgScore']]
    y = df['riskLevel']
    
    # Encoder les labels
    le = LabelEncoder()
    y_encoded = le.fit_transform(y)
    
    # Split train/test
    X_train, X_test, y_train, y_test = train_test_split(
        X, y_encoded, test_size=0.2, random_state=42, stratify=y_encoded
    )
    
    print("🌲 Entraînement du modèle Random Forest...")
    model = RandomForestClassifier(
        n_estimators=100,
        max_depth=10,
        random_state=42,
        n_jobs=-1
    )
    model.fit(X_train, y_train)
    
    # Évaluation
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    print(f"\n✅ Accuracy: {accuracy:.2%}")
    print("\n📈 Classification Report:")
    print(classification_report(y_test, y_pred, target_names=le.classes_))
    
    # Sauvegarder le modèle et l'encoder
    print("\n💾 Sauvegarde du modèle...")
    joblib.dump(model, 'model.pkl')
    joblib.dump(le, 'label_encoder.pkl')
    
    # Sauvegarder les importances des features
    feature_importance = dict(zip(X.columns, model.feature_importances_))
    print("\n🔍 Importance des features:")
    for feat, imp in sorted(feature_importance.items(), key=lambda x: -x[1]):
        print(f"  {feat}: {imp:.3f}")
    
    print("\n✅ Modèle sauvegardé: model.pkl")
    print("✅ Encoder sauvegardé: label_encoder.pkl")

if __name__ == "__main__":
    train_model()
