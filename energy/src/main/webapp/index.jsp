<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Plateforme Énergie Connectée - Tableau de bord</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,700">
    <style>
        body { font-family: 'Roboto', Arial, sans-serif; background: #f6f8fa; margin: 0; min-height:100vh;}
        header { background: #3498db; color: white; padding:34px 0 16px 0; text-align:center; border-bottom:8px solid #2874a6; }
        .container { max-width: 1100px; margin: 0 auto; padding: 32px;}
        .cards { display: flex; gap:40px; margin:42px 0;}
        .card { flex:1; background:#fff; border-radius:10px; box-shadow:0 7px 22px rgba(52,152,219,0.10);
            padding: 38px 26px; text-align:center; transition: 0.2s; border-top:6px solid #3498db;}
        .card strong { font-size:2.3em; color:#2874a6; }
        .card small { color:#666; font-size:1em; display:block; margin-top:8px;}
        .nav-links { display: flex; gap:32px; justify-content:center; margin:34px 0; flex-wrap: wrap;}
        .nav-links a { background: #27ae60; color: white; font-weight: bold; text-decoration: none;
            padding: 16px 30px; border-radius: 8px; box-shadow: 0 2px 7px rgba(39,174,96,0.08);
            font-size:1.15em; transition:all 0.2s;}
        .nav-links a:hover { background:#219150; }
        .section { margin-top:60px;}
        .explanation { background: #e3f2fd; border-left: 5px solid #3498db; padding: 22px; border-radius: 8px; color: #333; margin-top:25px; max-width:950px; margin-left:auto; margin-right:auto; box-shadow: 0 2px 10px rgba(52,152,219,0.08);}
        @media (max-width:900px) { .cards { flex-direction:column; gap:15px;} .container{padding:10px;} }
    </style>
</head>
<body>
<header>
    <h1>⚡ Plateforme Énergie Connectée</h1>
    <p>Tableau de bord analytique et accès rapide</p>
</header>
<div class="container">
    <div class="cards">
        <div class="card">
            <div>🟦 <strong>${totalCompteurs}</strong></div>
            <small>Compteurs connectés</small>
        </div>
        <div class="card">
            <div>📈 <strong>${nbReleves}</strong></div>
            <small>Relevés enregistrés</small>
        </div>
        <div class="card">
            <div>♻️ <strong>${moyenneJour}</strong> <span style="font-size:0.7em;">kWh/j</span></div>
            <small>Moyenne de consommation aujourd'hui</small>
        </div>
    </div>
    <div class="nav-links">
        <a href="compteurs">🟦 Consulter les Compteurs</a>
        <a href="releves">📈 Voir les Relevés</a>
        <a href="generateur">🔄 Générer des Données</a>

    </div>
    <div class="section">
        <h2 style="color:#2874a6;">Résumé projet</h2>
        <div class="explanation">
            <strong>À quoi sert la plateforme ?</strong>
            <ul>
                <li>&#9989; Surveillez la consommation d’énergie depuis des milliers de compteurs connectés.</li>
                <li>&#9989; Ajoutez, consultez des compteurs et gérez les adresses par quartier ou zone.</li>
                <li>&#9989; Enregistrez les relevés et suivez la progression en temps réel : affichage, stats, historique.</li>
                <li>&#9989; Générer des datasets volumineux pour tester l’architecture big data.</li>
                <li>&#9989; Visualisez les tendances, les pics de consommation et filtrez/recherchez les infos.</li>
            </ul>
            <strong>Comment utiliser ?</strong>
            <ul>
                <li>Cliquez sur <b>“Consulter les Compteurs”</b> pour gérer les équipements physiques.</li>
                <li>Ajoutez des relevés à la main ou par import, puis consultez les statistiques via <b>“Voir les Relevés”</b>.</li>
                <li>Testez la génération massive via <b>“Générer des Données”</b> pour simuler le Big Data réel.</li>
                <li>Accédez à <b>“Statistiques & Graphiques”</b> pour des visualisations interactives.</li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
s