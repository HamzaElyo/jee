# Student Risk Prediction API - Hugging Face Space

Ce dossier contient le code pour déployer un modèle ML de prédiction de risque étudiant sur Hugging Face Spaces.

## Fichiers

- `app.py` - Application Gradio avec API de prédiction
- `train_model.py` - Script d'entraînement du modèle (exécuter une fois)
- `requirements.txt` - Dépendances Python

## Déploiement sur Hugging Face Spaces

1. Créer un compte sur https://huggingface.co
2. Créer un nouveau Space (SDK: Gradio)
3. Uploader les fichiers: `app.py`, `requirements.txt`, `model.pkl`
4. L'URL de l'API sera: `https://YOUR_USERNAME-YOUR_SPACE.hf.space/api/predict`

## Test local

```bash
pip install -r requirements.txt
python train_model.py  # Entraîner le modèle d'abord
python app.py          # Lancer l'app
```
