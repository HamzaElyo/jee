<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Utilisateurs - LogMaster</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="container">
                <header>
                    <h1>👥 Gestion des Utilisateurs</h1>
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/dashboard">🏠 Dashboard</a>
                        <a href="${pageContext.request.contextPath}/users?action=list" class="active">👥
                            Utilisateurs</a>
                        <a href="${pageContext.request.contextPath}/logout">🚪 Déconnexion</a>
                    </div>
                </header>

                <div class="section">
                    <div
                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h2>Liste des Utilisateurs</h2>
                        <a href="${pageContext.request.contextPath}/users?action=new"
                            style="padding: 10px 20px; background: #667eea; color: white; text-decoration: none; border-radius: 5px;">
                            + Nouvel Utilisateur
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${not empty listUser}">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nom</th>
                                        <th>Email</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${listUser}">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>${user.name}</td>
                                            <td>${user.email}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/users?action=edit&id=${user.id}"
                                                    style="color: #4b6cb7;">✏️ Éditer</a>
                                                &nbsp;|&nbsp;
                                                <form action="${pageContext.request.contextPath}/users" method="post"
                                                    style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${user.id}">
                                                    <button type="submit"
                                                        style="background:none; border:none; color: #dc3545; cursor:pointer;"
                                                        onclick="return confirm('Êtes-vous sûr ?')">🗑️
                                                        Supprimer</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">Aucun utilisateur trouvé.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </body>

        </html>