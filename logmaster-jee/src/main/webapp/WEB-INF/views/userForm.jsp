<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${user != null ? 'Modifier' : 'Ajouter'} Utilisateur - LogMaster</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="container">
                <header>
                    <h1>${user != null ? '✏️ Modifier' : '➕ Ajouter'} un Utilisateur</h1>
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/users?action=list">🔙 Retour à la liste</a>
                    </div>
                </header>

                <div class="section">
                    <form action="${pageContext.request.contextPath}/users" method="post"
                        style="max-width: 500px; margin: 0 auto;">
                        <input type="hidden" name="action" value="${user != null ? 'update' : 'create'}">
                        <c:if test="${user != null}">
                            <input type="hidden" name="id" value="${user.id}">
                        </c:if>

                        <div style="margin-bottom: 20px;">
                            <label for="name" style="display: block; margin-bottom: 8px;">Nom complet</label>
                            <input type="text" id="name" name="name" value="${user.name}" required
                                style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box;">
                        </div>

                        <div style="margin-bottom: 20px;">
                            <label for="email" style="display: block; margin-bottom: 8px;">Email</label>
                            <input type="email" id="email" name="email" value="${user.email}" required
                                style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box;">
                        </div>

                        <div style="margin-bottom: 20px;">
                            <label for="password" style="display: block; margin-bottom: 8px;">Mot de passe ${user !=
                                null ? '(Laisser vide pour ne pas changer)' : ''}</label>
                            <input type="password" id="password" name="password" ${user==null ? 'required' : '' }
                                style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box;">
                        </div>

                        <button type="submit"
                            style="width: 100%; padding: 12px; background: #667eea; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 16px;">
                            ${user != null ? 'Mettre à jour' : 'Créer'}
                        </button>
                    </form>
                </div>
            </div>
        </body>

        </html>