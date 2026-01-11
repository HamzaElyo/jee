<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <title>Commandes - LogMaster</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <div class="container">
                    <header>
                        <h1>📦 Gestion des Commandes (PostgreSQL)</h1>
                        <div class="nav-links">
                            <a href="${pageContext.request.contextPath}/dashboard">🏠 Dashboard</a>
                            <a href="${pageContext.request.contextPath}/products">🛒 Produits</a>
                            <a href="${pageContext.request.contextPath}/orders?action=list">📦 Commandes</a>
                            <a href="${pageContext.request.contextPath}/logs?action=list">📋 Logs</a>
                        </div>
                    </header>

                    <div class="section">
                        <div style="margin-bottom: 20px;">
                            <a href="${pageContext.request.contextPath}/orders?action=form"
                                style="padding: 10px 20px; background: #28a745; color: white; text-decoration: none; border-radius: 5px;">
                                + Nouvelle Commande
                            </a>
                        </div>

                        <c:if test="${not empty orders}">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Date</th>
                                        <th>Client</th>
                                        <th>Montant</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td>#${order.id}</td>
                                            <td>
                                                <fmt:formatDate value="${order.orderDateAsDate}" type="both"
                                                    pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td>${order.user.name}</td>
                                            <td>${order.totalAmount} €</td>
                                            <td>
                                                <span
                                                    class="log-level ${order.status == 'CANCELLED' ? 'log-error' : (order.status == 'DELIVERED' ? 'log-info' : 'log-warning')}">
                                                    ${order.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="orders?action=details&id=${order.id}">Détails</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                        <c:if test="${empty orders}">
                            <div class="empty-state">Aucune commande trouvée.</div>
                        </c:if>
                    </div>
                </div>
            </body>

            </html>