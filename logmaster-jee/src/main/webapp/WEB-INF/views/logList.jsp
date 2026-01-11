<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <title>Logs - LogMaster</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <div class="container">
                    <header>
                        <h1>📋 Logs Applicatifs (MongoDB)</h1>
                        <div class="nav-links">
                            <a href="${pageContext.request.contextPath}/dashboard">🏠 Dashboard</a>
                            <a href="${pageContext.request.contextPath}/products">🛒 Produits</a>
                            <a href="${pageContext.request.contextPath}/orders?action=list">📦 Commandes</a>
                            <a href="${pageContext.request.contextPath}/logs?action=list">📋 Logs</a>
                        </div>
                    </header>

                    <div class="section">
                        <form action="logs" method="get" style="display: flex; gap: 10px; margin-bottom: 20px;">
                            <input type="hidden" name="action" value="filter">
                            <select name="level">
                                <option value="">-- Tous les niveaux --</option>
                                <option value="INFO" ${filterType=='Level' && filterValue=='INFO' ? 'selected' : '' }>
                                    INFO</option>
                                <option value="WARNING" ${filterType=='Level' && filterValue=='WARNING' ? 'selected'
                                    : '' }>WARNING</option>
                                <option value="ERROR" ${filterType=='Level' && filterValue=='ERROR' ? 'selected' : '' }>
                                    ERROR</option>
                            </select>
                            <input type="text" name="service" placeholder="Service (ex: order-service)"
                                value="${filterType == 'Service' ? filterValue : ''}">
                            <button type="submit">Filtrer</button>
                            <a href="logs?action=list"
                                style="padding: 10px; background: #999; color: white; text-decoration: none; border-radius: 5px;">Reset</a>
                        </form>

                        <c:if test="${not empty logs}">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Timestamp</th>
                                        <th>Niveau</th>
                                        <th>Service</th>
                                        <th>Type</th>
                                        <th>Message</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="log" items="${logs}">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${log.timestamp}"
                                                    pattern="dd/MM/yyyy HH:mm:ss" />
                                            </td>
                                            <td>
                                                <span
                                                    class="log-level ${log.level == 'ERROR' ? 'log-error' : (log.level == 'WARNING' ? 'log-warning' : 'log-info')}">
                                                    ${log.level}
                                                </span>
                                            </td>
                                            <td>${log.service}</td>
                                            <td>${log.event_type}</td>
                                            <td>${log.message}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                        <c:if test="${empty logs}">
                            <div class="empty-state">Aucun log trouvé.</div>
                        </c:if>
                    </div>
                </div>
            </body>

            </html>