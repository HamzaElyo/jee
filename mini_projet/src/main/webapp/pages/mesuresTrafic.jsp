<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<h2>Ajout d'une Mesure de Trafic</h2>
<form method="post" action="mesuresTrafic">
    Type véhicule:
    <input name="typeVehicule" required />
    Vitesse moyenne (km/h):
    <input name="vitesseMoy" type="number" step="0.1" required />
    Nb véhicules:
    <input name="vehicules" type="number" required />
    Taux d'embouteillage (0-1):
    <input name="tauxEmbouteillage" type="number" min="0" max="1" step="0.01" required />
    Capteur:
    <select name="capteurId" required>
        <c:forEach var="c" items="${capteurs}">
            <option value="${c.id}">${c.nom} (${c.zone})</option>
        </c:forEach>
    </select>
    <button type="submit">Ajouter</button>
</form>

<h3>Statistiques par voiture/type</h3>
<table border="1" cellpadding="6">
    <tr>
        <th>Type véhicule</th>
        <th>Vitesse Moyenne</th>
        <th>Vitesse Min</th>
        <th>Vitesse Max</th>
    </tr>
    <c:forEach var="s" items="${stats}">
        <tr>
            <td>${s[0]}</td>
            <td>${s[1]}</td>
            <td>${s[2]}</td>
            <td>${s[3]}</td>
        </tr>
    </c:forEach>
</table>

<h3>Statistiques par zone</h3>
<table border="1" cellpadding="6">
    <tr>
        <th>Zone</th>
        <th>Nb véhicules (moy)</th>
        <th>Embouteillage (moy)</th>
    </tr>
    <c:forEach var="s" items="${statsZone}">
        <tr>
            <td>${s[0]}</td>
            <td>${s[1]}</td>
            <td>${s[2]}</td>
        </tr>
    </c:forEach>
</table>

<p><a href="../mini_projet_war_exploded/index.jsp">Retour accueil</a></p>
