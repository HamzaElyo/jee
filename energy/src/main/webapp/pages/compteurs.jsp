<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Liste des Compteurs</title>
    <style>
        body { font-family: 'Roboto', Arial, sans-serif; margin: 40px; background: #f8fbfd;}
        h2 { color: #2c3e50; }
        .form-card { background: #fcfcfd; border: 1px solid #e0e0e0; border-radius: 6px; padding: 20px; margin-bottom: 30px; width: 380px;}
        label { font-weight: bold; display:block; margin-bottom:6px;}
        input { padding: 7px; width: 96%; margin-bottom: 14px; border-radius:4px; border:1px solid #ccc; }
        button { background:#3498db;color:white;padding:9px 18px;border:none;border-radius:4px;font-weight:bold;}
        button:hover{background:#217dbb;}
        table { border-collapse: collapse; width: 85%; margin-top: 20px;}
        th, td { padding: 10px 13px; border-bottom: 1px solid #e0e0e0; }
        th { background: #3498db; color: white; }
        tr:nth-child(even) { background: #f4f8fc;}
        a {text-decoration:none;color:#3498db;font-weight:bold;}
    </style>
</head>
<body>
<h2>🟦 Liste des Compteurs</h2>
<div class="form-card">
    <form method="post" action="compteurs">
        <label>Code</label><input name="code" required />
        <label>Type</label><input name="type" required />
        <label>Adresse</label><input name="adresse" required />
        <button type="submit">Ajouter</button>
    </form>
</div>
<table>
    <tr><th>ID</th><th>Code</th><th>Type</th><th>Adresse</th></tr>
    <c:forEach var="c" items="${compteurs}">
        <tr>
            <td>${c.id}</td><td>${c.code}</td><td>${c.type}</td><td>${c.adresse}</td>
        </tr>
    </c:forEach>
</table>
<p><a href="index.jsp">⏪ Tableau de bord</a></p>
</body>
</html>
