<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Stages</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        h1 { color: #007acc; }
        form {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            margin-top: 15px;
            padding: 10px 20px;
            background: #007acc;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover { background: #005a9e; }
        #result {
            margin-top: 20px;
            padding: 15px;
            background: #e8f5e9;
            border-radius: 4px;
            display: none;
        }
    </style>
</head>
<body>
<h1>📚 Créer un Étudiant</h1>
<form id="studentForm">
    <label>Prénom</label>
    <input type="text" id="firstName" required>

    <label>Nom</label>
    <input type="text" id="lastName" required>

    <label>Email</label>
    <input type="email" id="email" required>

    <label>Promotion</label>
    <input type="text" id="promotion" required>

    <button type="submit">Créer</button>
</form>

<div id="result"></div>

<script>
    document.getElementById('studentForm').addEventListener('submit', async (e) => {
        e.preventDefault();

        const student = {
            firstName: document.getElementById('firstName').value,
            lastName: document.getElementById('lastName').value,
            email: document.getElementById('email').value,
            promotion: document.getElementById('promotion').value
        };

        try {
            const response = await fetch('/internship-management/api/students', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(student)
            });

            const data = await response.json();
            const resultDiv = document.getElementById('result');

            if (response.ok) {
                resultDiv.style.display = 'block';
                resultDiv.style.background = '#e8f5e9';
                resultDiv.innerHTML = `✅ Étudiant créé : ${data.firstName} ${data.lastName} (ID: ${data.id})`;
            } else {
                resultDiv.style.display = 'block';
                resultDiv.style.background = '#ffebee';
                resultDiv.innerHTML = `❌ Erreur : ${data.message}`;
            }
        } catch (error) {
            alert('Erreur réseau : ' + error.message);
        }
    });
</script>
</body>
</html>