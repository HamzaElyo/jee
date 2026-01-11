<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - BankFlow Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

</head>
<body>
<div class="container-fluid">
    <div class="row">

        <!-- Inclusion du Sidebar -->
        <jsp:include page="../includes/sidebar.jsp">
            <jsp:param name="activePage" value="dashboard"/>
        </jsp:include>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10 ms-sm-auto px-4 py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Tableau de Bord</h2>
            </div>

            <!-- Stats Cards -->
            <div class="row g-4 mb-4">
                <div class="col-xl-3 col-md-6">
                    <div class="card stat-card shadow">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <h6 class="card-title text-white-50">Total Clients</h6>
                                    <h3 class="mb-0 text-white">${totalClients}</h3>
                                </div>
                                <div class="flex-shrink-0">
                                    <i class="bi bi-people fs-1 text-white-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card stat-card shadow">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <h6 class="card-title text-white-50">Total Comptes</h6>
                                    <h3 class="mb-0 text-white">${totalComptes}</h3>
                                </div>
                                <div class="flex-shrink-0">
                                    <i class="bi bi-credit-card fs-1 text-white-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card bg-success text-white shadow">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <h6 class="card-title text-white-50">Transactions/jour</h6>
                                    <h3 class="mb-0">127</h3>
                                </div>
                                <div class="flex-shrink-0">
                                    <i class="bi bi-arrow-up-right fs-1 text-white-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card bg-info text-white shadow">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <h6 class="card-title text-white-50">Solde Total</h6>
                                    <h3 class="mb-0">2.4M €</h3>
                                </div>
                                <div class="flex-shrink-0">
                                    <i class="bi bi-cash-coin fs-1 text-white-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%-- Dans webapp/pages/dashboard.jsp --%>
            <div class="row">

                <!-- Nouveau widget pour les données externes -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5>Données Marché Externe</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty marketData}">
                                    <p><strong>EUR/USD:</strong> ${marketData.eurUsdRate}</p>
                                    <p><strong>Volatilité:</strong> ${marketData.marketVolatility}%</p>
                                    <p><strong>Tendance:</strong> ${marketData.marketTrend}</p>
                                    <small class="text-muted">Mise à jour: ${marketData.lastUpdate}</small>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-warning">Données marché non disponibles</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Transactions & Charts -->
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card shadow">
                        <div class="card-header bg-dark text-white">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-clock-history me-2"></i>Transactions Récentes
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Type</th>
                                        <th>Montant</th>
                                        <th>Description</th>
                                        <th>Compte</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <!-- Dans la section des transactions récentes -->
                                    <c:forEach var="transaction" items="${recentTransactions}">
                                        <tr>
                                            <td>${transaction.dateOperation}</td>
                                            <td>
                                                <span class="badge
                                                    <c:choose>
                                                        <c:when test="${transaction.credit}">bg-success</c:when>
                                                        <c:when test="${transaction.debit}">bg-danger</c:when>
                                                        <c:otherwise>bg-secondary</c:otherwise>
                                                    </c:choose>">
                                                        ${transaction.typeLibelle}
                                                </span>
                                            </td>
                                            <td class="fw-bold
                                                <c:choose>
                                                    <c:when test="${transaction.montant > 0}">text-success</c:when>
                                                    <c:when test="${transaction.montant < 0}">text-danger</c:when>
                                                    <c:otherwise>text-muted</c:otherwise>
                                                </c:choose>">
                                                    ${transaction.montant} €
                                            </td>
                                            <td>${transaction.description}</td>
                                            <td>${transaction.compte.numeroCompte}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card shadow">
                        <div class="card-header bg-dark text-white">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-pie-chart me-2"></i>Types de Comptes
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:forEach var="stat" items="${statsComptes}">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span>${stat[0]}</span>
                                    <span class="fw-bold">${stat[1]} €</span>
                                </div>
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar" role="progressbar"
                                         style="width: ${stat[1] / 10}%"></div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>