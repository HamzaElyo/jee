"""
Script d'entraînement du modèle Random Forest pour la prédiction de risque étudiant
Utilise les vraies données OULAD depuis les fichiers CSV
"""

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import classification_report, accuracy_score
import joblib
import os

# Chemin vers les données OULAD
DATA_PATH = "../data/oulad"

def load_oulad_data():
    """
    Charge les données OULAD depuis les fichiers CSV
    """
    print("📂 Chargement des données OULAD depuis CSV...")
    
    # 1. Charger studentVle (activité des étudiants sur le VLE)
    print("   📊 Chargement studentVle.csv (peut prendre un moment)...")
    vle_path = os.path.join(DATA_PATH, "studentVle.csv")
    student_vle = pd.read_csv(vle_path)
    
    # Agréger par étudiant: totalClicks et activeDays
    print("   🔄 Agrégation des clicks par étudiant...")
    vle_agg = student_vle.groupby('id_student').agg({
        'sum_click': 'sum',
        'date': 'nunique'  # Nombre de jours uniques d'activité
    }).reset_index()
    vle_agg.columns = ['id_student', 'totalClicks', 'activeDays']
    
    print(f"   ✅ {len(vle_agg)} étudiants avec activité VLE")
    
    # 2. Charger studentInfo (infos étudiants avec finalResult)
    print("   👥 Chargement studentInfo.csv...")
    info_path = os.path.join(DATA_PATH, "studentInfo.csv")
    student_info = pd.read_csv(info_path)
    
    # Garder les colonnes utiles
    student_info = student_info[['id_student', 'code_module', 'code_presentation', 
                                   'final_result', 'region', 'studied_credits']]
    
    print(f"   ✅ {len(student_info)} enregistrements étudiants")
    
    # 3. Charger studentAssessment (évaluations)
    print("   📝 Chargement studentAssessment.csv...")
    assessment_path = os.path.join(DATA_PATH, "studentAssessment.csv")
    student_assessment = pd.read_csv(assessment_path)
    
    # Agréger par étudiant: nombre d'évaluations et score moyen
    assessment_agg = student_assessment.groupby('id_student').agg({
        'id_assessment': 'count',
        'score': 'mean'
    }).reset_index()
    assessment_agg.columns = ['id_student', 'numAssessments', 'avgScore']
    assessment_agg['avgScore'] = assessment_agg['avgScore'].fillna(50)
    
    print(f"   ✅ {len(assessment_agg)} étudiants avec évaluations")
    
    # 4. Joindre toutes les données
    print("   🔗 Fusion des données...")
    
    # Joindre VLE avec Info
    df = vle_agg.merge(student_info, on='id_student', how='inner')
    
    # Joindre avec Assessments
    df = df.merge(assessment_agg, on='id_student', how='left')
    
    # Remplir les valeurs manquantes
    df['numAssessments'] = df['numAssessments'].fillna(0).astype(int)
    df['avgScore'] = df['avgScore'].fillna(50.0)
    
    # 5. Créer les labels de risque basés sur final_result
    print("   🏷️ Création des labels de risque...")
    
    def get_risk_from_result(result):
        if result == "Withdrawn":
            return "Critical"
        elif result == "Fail":
            return "High"
        elif result == "Pass":
            return "Medium"
        elif result == "Distinction":
            return "Low"
        else:
            return "Medium"
    
    df["riskLevel"] = df["final_result"].apply(get_risk_from_result)
    
    # Supprimer les doublons (garder le premier enregistrement par étudiant)
    df = df.drop_duplicates(subset=['id_student'], keep='first')
    
    print(f"\n✅ Dataset final: {len(df)} étudiants")
    print(f"   Distribution des risques:")
    print(df["riskLevel"].value_counts())
    
    return df


def train_model():
    """Entraîne et sauvegarde le modèle Random Forest avec données OULAD"""
    
    # Charger les vraies données
    df = load_oulad_data()
    
    if len(df) == 0:
        print("❌ Aucune donnée trouvée!")
        return
    
    # Préparer les features et le target
    features = ['totalClicks', 'activeDays', 'numAssessments', 'avgScore']
    X = df[features]
    y = df['riskLevel']
    
    # Encoder les labels
    le = LabelEncoder()
    y_encoded = le.fit_transform(y)
    
    print(f"\n📊 Features: {features}")
    print(f"📊 Classes: {list(le.classes_)}")
    
    # Split train/test
    X_train, X_test, y_train, y_test = train_test_split(
        X, y_encoded, test_size=0.2, random_state=42, stratify=y_encoded
    )
    
    print(f"\n🔀 Split: {len(X_train)} train, {len(X_test)} test")
    
    print("\n🌲 Entraînement du modèle Random Forest...")
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
    
    # Afficher les importances des features
    feature_importance = dict(zip(features, model.feature_importances_))
    print("\n🔍 Importance des features:")
    for feat, imp in sorted(feature_importance.items(), key=lambda x: -x[1]):
        print(f"   {feat}: {imp:.3f}")
    
    print("\n✅ Modèle sauvegardé: model.pkl")
    print("✅ Encoder sauvegardé: label_encoder.pkl")
    
    return model, le


if __name__ == "__main__":
    train_model()
