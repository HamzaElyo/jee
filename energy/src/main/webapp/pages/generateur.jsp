<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Générateur de Données Énergie</title>
    <style>
        body { font-family: 'Roboto', Arial, sans-serif; margin:40px; background: #eef7ff;}
        h2 { color:#34495e;}
        .form-card{ background:#fff; border:2px dashed #3498db; border-radius:10px; padding:24px; max-width:500px;}
        label { font-weight:bold; display:block; margin-bottom:7px; }
        input { padding:8px; width:98%; margin-bottom:15px; border-radius:4px; border:1px solid #b5b5b5;}
        button { background:#3498db;color:white;padding:13px 30px;border:none;border-radius:6px;font-weight:bold; font-size:1.1em;}
        button:hover{background:#217dbb;}
        .info { font-size:1.16em; margin-top:16px;}
        .icon { font-size:2em; margin-bottom:14px; }
        a {text-decoration:none;color:#3498db;font-weight:bold;}
    </style>
</head>
<body>
<div class="icon">🔄</div>
<h2>Génération Massive de Données de Consommation</h2>
<div class="info">
    Utilisez ce formulaire pour créer un jeu de données de test volumineux.<br>
    (Exemple : 50 000 relevés pour un compteur précis)
</div>
<div class="form-card">
    <form method="post" action="generateur">
        <label>Code Compteur</label><input name="code" required />
        <label>Type d'énergie</label><input name="type" value="Electricité" required />
        <label>Adresse</label><input name="adresse" required />
        <label>Nombre de relevés à générer</label><input name="n" type="number" value="50000" min="100" step="100" required />
        <label>Unité (ex : kWh, m3,...)</label><input name="unite" value="kWh" required />
        <button type="submit">Lancer la génération</button>
    </form>
    <c:if test="${not empty message}">
        <div class="info" style="color:green;font-weight:bold;">${message}</div>
    </c:if>
</div>
<p style="margin-top:30px;"><a href="index.jsp">⏪ Tableau de bord</a></p>
</body>
</html>
