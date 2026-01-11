<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord IoT</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f8fb;
            margin: 0;
            padding: 30px 0;
        }
        h1 {
            color: #1582c5;
            border-bottom: 2px solid #61a5e4;
            display: inline-block;
        }
        form {
            background: #fff;
            border: 1px solid #b8e0f9;
            border-radius: 8px;
            padding: 16px 20px;
            margin-bottom: 35px;
            max-width: 380px;
            box-shadow: 0 2px 8px #0001;
        }
        form label {
            display: block;
            margin: 10px 0 5px 0;
        }
        form input {
            padding: 6px 8px;
            margin-bottom: 10px;
            border: 1px solid #b8e0f9;
            border-radius: 3px;
            width: 90%;
        }
        button {
            background: #1582c5;
            color: white;
            padding: 8px 18px;
            border: none;
            border-radius: 15px;
            margin-top: 8px;
            font-weight: bold;
            transition: background 0.2s;
            cursor: pointer;
        }
        button:hover {
            background: #135c92;
        }
        .lecture-list {
            background: #fff;
            border: 1px solid #b8e0f9;
            border-radius: 8px;
            padding: 18px 24px;
            max-width: 580px;
            box-shadow: 0 1px 8px #0001;
            margin: 0 0 30px 0;
        }
        .lecture-item {
            margin: 0 0 16px 0;
            padding: 8px;
            border-bottom: 1px solid #e9eef3;
        }
        .lecture-item:last-child {
            border-bottom: none;
        }
        .lecture-key {
            color: #166787;
            font-weight: bold;
        }
    </style>
</head>
<body>
<h1>Tableau de Bord IoT</h1>

<h2>Ajouter une lecture</h2>
<form action="${pageContext.request.contextPath}/iot-dashboard" method="post">
    <label>Sensor ID: <input type="text" name="sensorId" required></label>
    <label>Sensor Type: <input type="text" name="sensorType" required></label>
    <label>Valeur: <input type="number" step="any" name="value" required></label>
    <label>Unité: <input type="text" name="unit"></label>
    <label>Emplacement: <input type="text" name="location"></label>
    <button type="submit">Ajouter</button>
</form>

<h2>Lectures de capteurs</h2>
<div class="lecture-list">
    <c:if test="${empty readings}">
        <p>Aucune lecture enregistrée.</p>
    </c:if>

    <c:forEach var="reading" items="${readings}">
        <div class="lecture-item">
            <span class="lecture-key">Capteur:</span> ${reading.sensorId} (${reading.sensorType}),
            <span class="lecture-key">Valeur:</span> ${reading.value} ${reading.unit},
            <span class="lecture-key">Lieu:</span> ${reading.location},
            <span class="lecture-key">Timestamp:</span> ${reading.timestamp}
        </div>
    </c:forEach>
</div>
</body>
</html>
