<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>LogMaster Dashboard</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <div class="container">
                    <header>
                        <h1>🚀 LogMaster Dashboard</h1>
                        <div class="nav-links">
                            <a href="${pageContext.request.contextPath}/dashboard">🏠 Dashboard</a>
                            <a href="${pageContext.request.contextPath}/users?action=list">👥 Utilisateurs</a>
                            <a href="${pageContext.request.contextPath}/products">🛒 Produits</a>
                            <a href="${pageContext.request.contextPath}/orders?action=list">📦 Commandes</a>
                            <a href="${pageContext.request.contextPath}/logs?action=list">📋 Logs</a>
                            <a href="${pageContext.request.contextPath}/logout" style="color: #dc3545;">🚪 Logout</a>
                        </div>
                    </header>

                    <!-- Order Stats -->
                    <div class="section">
                        <h2>📊 Statistiques des Commandes (PostgreSQL)</h2>

                        <div class="stats-grid">
                            <div class="stat-card">
                                <h3>${stats.totalOrders}</h3>
                                <p>Total Commandes</p>
                            </div>

                            <div class="stat-card">
                                <h3>${stats.pendingOrders}</h3>
                                <p>⏳ En Attente</p>
                            </div>

                            <div class="stat-card">
                                <h3>${stats.confirmedOrders}</h3>
                                <p>✅ Confirmées</p>
                            </div>

                            <div class="stat-card">
                                <h3>${stats.shippedOrders}</h3>
                                <p>🚚 Expédiées</p>
                            </div>

                            <div class="stat-card">
                                <h3>${stats.deliveredOrders}</h3>
                                <p>🎉 Livrées</p>
                            </div>

                            <div class="stat-card"
                                style="background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);">
                                <h3>${stats.cancelledOrders}</h3>
                                <p>❌ Annulées</p>
                            </div>
                        </div>

                        <div class="stats-grid">
                            <div class="stat-card"
                                style="background: linear-gradient(135deg, #28a745 0%, #218838 100%);">
                                <h3>
                                    <fmt:formatNumber value="${stats.successRate}" maxFractionDigits="1" />%
                                </h3>
                                <p>Taux de Succès</p>
                            </div>

                            <div class="stat-card"
                                style="background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);">
                                <h3>
                                    <fmt:formatNumber value="${stats.cancellationRate}" maxFractionDigits="1" />%
                                </h3>
                                <p>Taux d'Annulation</p>
                            </div>
                        </div>
                    </div>

                    <!-- Log Stats -->
                    <div class="section">
                        <h2>📈 Statistiques des Logs (MongoDB)</h2>

                        <div class="stats-grid">
                            <div class="stat-card"
                                style="background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);">
                                <h3>${stats.errorCount}</h3>
                                <p>❌ Erreurs</p>
                            </div>

                            <div class="stat-card"
                                style="background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);">
                                <h3>${stats.warningCount}</h3>
                                <p>⚠️ Avertissements</p>
                            </div>
                        </div>
                    </div>

                    <!-- Top Users -->
                    <div class="section">
                        <h2>👥 Top 5 Utilisateurs Actifs (MongoDB Aggregation)</h2>

                        <c:choose>
                            <c:when test="${not empty stats.topActiveUsers}">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Position</th>
                                            <th>Utilisateur</th>
                                            <th>Nombre de Commandes</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${stats.topActiveUsers}" varStatus="status">
                                            <tr>
                                                <td><strong>#${status.index + 1}</strong></td>
                                                <td>${user._id}</td>
                                                <td>${user.order_count} commandes</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">Aucune donnée disponible</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Event Stats -->
                    <div class="section">
                        <h2>📊 Répartition des Événements (MongoDB Aggregation)</h2>

                        <c:choose>
                            <c:when test="${not empty stats.eventStatistics}">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Type d'Événement</th>
                                            <th>Nombre</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="event" items="${stats.eventStatistics}">
                                            <tr>
                                                <td>${event._id}</td>
                                                <td><strong>${event.count}</strong></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">Aucune donnée disponible</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Recent Logs -->
                    <div class="section">
                        <h2>📋 Logs Récents</h2>

                        <c:choose>
                            <c:when test="${not empty stats.recentLogs}">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Timestamp</th>
                                            <th>Niveau</th>
                                            <th>Service</th>
                                            <th>Message</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="log" items="${stats.recentLogs}">
                                            <tr>
                                                <td>
                                                    <fmt:formatDate value="${log.timestamp}"
                                                        pattern="dd/MM/yyyy HH:mm:ss" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${log.level == 'ERROR'}">
                                                            <span class="log-level log-error">ERROR</span>
                                                        </c:when>
                                                        <c:when test="${log.level == 'WARNING'}">
                                                            <span class="log-level log-warning">WARNING</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="log-level log-info">INFO</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${log.service}</td>
                                                <td>${log.message}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <div style="text-align: center; margin-top: 20px;">
                                    <a href="${pageContext.request.contextPath}/logs?action=list"
                                        style="padding: 10px 20px; background: #667eea; color: white; text-decoration: none; border-radius: 5px;">
                                        Voir tous les logs →
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">Aucun log disponible</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </body>

            </html>