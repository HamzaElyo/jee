<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Relevés de Consommation</title>
    <style>
        body { font-family: 'Roboto', Arial, sans-serif; margin: 40px; background: #f8fbfd;}
        h2 { color: #2c3e50;}
        .form-card { background:#fcfcfd; border:1px solid #e0e0e0; border-radius:6px; padding:20px; margin-bottom:30px; width: 380px;}
        .stats-block { margin-top:30px; background:#fffde7; border-radius:6px; padding:18px; box-shadow:0 2px 10px rgba(52,152,219,0.06);}
        label { font-weight: bold; display:block; margin-bottom:6px;}
        input, select { padding:7px; width:96%; margin-bottom:14px; border:1px solid #ccc; border-radius:4px;}
        button { background:#27ae60;color:white;padding:9px 18px;border:none;border-radius:4px;font-weight:bold;}
        button:hover{background:#219150;}
        table { border-collapse: collapse; width: 85%; margin-top:20px;}
        th, td { padding:9px 13px; border-bottom:1px solid #e0e0e0;}
        th { background: #27ae60; color: white;}
        tr:nth-child(even) { background: #ecf8f3;}
        a {text-decoration:none;color:#27ae60;font-weight:bold;}
    </style>
</head>
<body>
<h2>📈 Relevés et Statistiques</h2>
<div class="form-card">
    <form method="post" action="releves">
        <label>Valeur</label><input name="valeur" type="number" step="0.01" required />
        <label>Unité</label><input name="unite" required />
        <label>Compteur</label>
        <select name="compteurId" required>
            <c:forEach var="c" items="${compteurs}">
                <option value="${c.id}">${c.code} (${c.type})</option>
            </c:forEach>
        </select>
        <button type="submit">Ajouter</button>
    </form>
</div>
<div class="stats-block">
    <h3>Statistiques par type d'énergie</h3>
    <table>
        <tr><th>Type</th><th>Moyenne</th><th>Min</th><th>Max</th></tr>
        <c:forEach var="s" items="${stats}">
            <tr>
                <td>${s[0]}</td>
                <td>${s[1]}</td>
                <td>${s[2]}</td>
                <td>${s[3]}</td>
            </tr>
        </c:forEach>
    </table>
</div>
<p><a href="index.jsp">⏪ Tableau de bord</a></p>
</body>
</html>
