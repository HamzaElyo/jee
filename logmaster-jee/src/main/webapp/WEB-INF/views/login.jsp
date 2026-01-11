<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>S'identifier - LogMaster</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .login-container {
                max-width: 400px;
                margin: 50px auto;
                background: white;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .login-header {
                text-align: center;
                margin-bottom: 25px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
            }

            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 6px;
                box-sizing: border-box;
            }

            .btn-submit {
                width: 100%;
                padding: 12px;
                background: #667eea;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 500;
            }

            .btn-submit:hover {
                background: #5a6fd1;
            }

            .error-message {
                background: #ffebee;
                color: #c62828;
                padding: 10px;
                border-radius: 6px;
                margin-bottom: 20px;
                text-align: center;
            }
        </style>
    </head>

    <body>
        <div class="login-container">
            <div class="login-header">
                <h1>🚀 LogMaster</h1>
                <p>Connexion</p>
            </div>

            <% if (request.getAttribute("error") !=null) { %>
                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                    <% if ("true".equals(request.getParameter("registered"))) { %>
                        <div class="error-message" style="background: #e8f5e9; color: #2e7d32;">
                            Compte créé avec succès ! Connectez-vous.
                        </div>
                        <% } %>

                            <form action="${pageContext.request.contextPath}/login" method="post">
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" required>
                                </div>

                                <div class="form-group">
                                    <label for="password">Mot de passe</label>
                                    <input type="password" id="password" name="password" required>
                                </div>

                                <button type="submit" class="btn-submit">Se connecter</button>
                            </form>

                            <div style="text-align: center; margin-top: 15px;">
                                <a href="${pageContext.request.contextPath}/register">Créer un compte</a>
                            </div>
        </div>
    </body>

    </html>