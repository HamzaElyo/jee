<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Smart City Traffic Monitor</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #2c5530; }
        .form-group { margin: 15px 0; }
        label { display: inline-block; width: 150px; font-weight: bold; }
        input, select { padding: 8px; margin: 5px; width: 200px; }
        button { padding: 10px 20px; background: #4CAF50; color: white; border: none; cursor: pointer; margin: 10px 5px; }
        button:hover { background: #45a049; }
        .nav-links { margin: 20px 0; }
        .nav-links a {
            display: inline-block;
            padding: 10px 15px;
            background: #007bff;
            color: white;
            text-decoration: none;
            margin: 5px;
            border-radius: 5px;
        }
        .nav-links a:hover { background: #0056b3; }
        .form-container {
            border: 1px solid #ddd;
            padding: 20px;
            margin: 20px 0;
            border-radius: 5px;
            background: #f9f9f9;
        }
    </style>
</head>
<body>
<h1>🚦 Smart City Traffic Monitor</h1>

<!-- Navigation -->
<div class="nav-links">
    <a href="capteursTrafic">📊 Liste des Capteurs</a>
    <a href="mesuresTrafic">📈 Mesures & Statistiques</a>
</div>

<!-- Formulaire génération massive -->
<div class="form-container">
    <h2>🚀 Génération Massive de Mesures de Trafic</h2>
    <p>Créer un capteur urbain et générer automatiquement de nombreuses mesures de test</p>

    <form method="post" action="generateTrafic">
        <div class="form-group">
            <label for="zone">Zone urbaine:</label>
            <input id="zone" name="zone" type="text" value="Centre Ville" required/>
        </div>
        <div class="form-group">
            <label for="typeVehicule">Type de véhicule:</label>
            <input id="typeVehicule" name="typeVehicule" type="text" value="Voiture" required/>
        </div>
        <div class="form-group">
            <label for="n">Nombre de mesures:</label>
            <input id="n" name="n" type="number" value="10000" min="100" step="100" required/>
        </div>
        <button type="submit">🔄 Générer les Données</button>
    </form>
</div>
</body>
</html>
