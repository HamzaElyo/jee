<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<h2>Liste des Capteurs de Trafic</h2>

<form method="post" action="capteursTrafic">
    Nom: <input name="nom" required />
    Type: <input name="type" required />
    Localisation: <input name="localisation" required />
    Zone: <input name="zone" required />
    <button type="submit">Ajouter</button>
</form>

<table border="1" cellpadding="6">
    <tr>
        <th>ID</th>
        <th>Nom</th>
        <th>Type</th>
        <th>Localisation</th>
        <th>Zone</th>
    </tr>
    <c:forEach var="c" items="${capteurs}">
        <tr>
            <td>${c.id}</td>
            <td>${c.nom}</td>
            <td>${c.type}</td>
            <td>${c.localisation}</td>
            <td>${c.zone}</td>
        </tr>
    </c:forEach>
</table>

<p>
    <a href="../mini_projet_war_exploded/index.jsp">Retour accueil</a>
</p>
