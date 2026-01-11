<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <title>Erreur - LogMaster</title>
        <style>
            body {
                font-family: sans-serif;
                text-align: center;
                padding: 50px;
                background: #f8d7da;
                color: #721c24;
            }

            h1 {
                font-size: 3em;
            }

            p {
                font-size: 1.2em;
            }

            a {
                color: #721c24;
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <h1>⚠️ Oups ! Une erreur est survenue.</h1>
        <p>${error}</p>
        <br>
        <a href="${pageContext.request.contextPath}/dashboard">Retour au Dashboard</a>
    </body>

    </html>