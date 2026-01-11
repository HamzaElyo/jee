<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rapports et Statistiques - BankFlow Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <!-- Inclusion du Sidebar -->
        <jsp:include page="../includes/sidebar.jsp">
            <jsp:param name="activePage" value="rapports"/>
        </jsp:include>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10 ms-sm-auto px-4 py-4">
            <h2>Rapports et Statistiques</h2>

            <!-- Statistiques Globales -->
            <div class="row g-4 mb-4">
                <div class="col-xl-3 col-md-6">
                    <div class="card stat-card bg-primary text-white shadow">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <h6 class="card-title text-white-50">Clients Actifs</h6>
                                    <h3 class="mb-0">${totalClients}</h3>
                                </div>
                                <div class="flex-shrink-0">
                                    <i class="bi bi-people fs-1 text-white-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card stat-card bg-success text-white shadow">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <h6 class="card-title text-white-50">Comptes Ouverts</h6>
                                    <h3 class="mb-0">${totalComptes}</h3>
                                </div>
                                <div class="flex-shrink-0">
                                    <i class="bi bi-credit-card fs-1 text-white-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card stat-card bg-info text-white shadow">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <h6 class="card-title text-white-50">Transactions/Mois</h6>
                                    <h3 class="mb-0">
                                        <c:set var="totalTransactionsMois" value="0" />
                                        <c:forEach var="stat" items="${statsTransactions}">
                                            <c:set var="totalTransactionsMois" value="${totalTransactionsMois + stat[2]}" />
                                        </c:forEach>
                                        ${totalTransactionsMois}
                                    </h3>
                                </div>
                                <div class="flex-shrink-0">
                                    <i class="bi bi-arrow-left-right fs-1 text-white-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card stat-card bg-warning text-dark shadow">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <h6 class="card-title">Volume Total</h6>
                                    <h3 class="mb-0">
                                        <c:set var="volumeTotal" value="0" />
                                        <c:forEach var="stat" items="${statsTransactions}">
                                            <c:if test="${stat[3] != null}">
                                                <c:set var="volumeTotal" value="${volumeTotal + stat[3].doubleValue()}" />
                                            </c:if>
                                        </c:forEach>
                                        ${volumeTotal} €
                                    </h3>
                                </div>
                                <div class="flex-shrink-0">
                                    <i class="bi bi-cash-coin fs-1 text-dark-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Graphiques et Statistiques détaillées -->
            <div class="row g-4">
                <!-- Statistiques par type de compte -->
                <div class="col-lg-6">
                    <div class="card shadow">
                        <div class="card-header bg-dark text-white">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-pie-chart me-2"></i>Solde Moyen par Type de Compte
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:forEach var="stat" items="${statsComptes}">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div>
                                        <span class="fw-bold">${stat[0]}</span>
                                        <small class="text-muted d-block">Solde moyen</small>
                                    </div>
                                    <span class="fw-bold text-primary">
                                            <c:if test="${stat[1] != null}">
                                                ${stat[1]} €
                                            </c:if>
                                            <c:if test="${stat[1] == null}">
                                                0 €
                                            </c:if>
                                        </span>
                                </div>
                                <div class="progress mb-4" style="height: 10px;">
                                    <c:set var="pourcentage" value="${stat[1] != null ? (stat[1].doubleValue() / 10000 * 100) : 0}" />
                                    <div class="progress-bar" role="progressbar"
                                         style="width: ${pourcentage > 100 ? 100 : pourcentage}%"
                                         aria-valuenow="${pourcentage}" aria-valuemin="0" aria-valuemax="100">
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Statistiques des transactions par mois -->
                <div class="col-lg-6">
                    <div class="card shadow">
                        <div class="card-header bg-dark text-white">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-bar-chart me-2"></i>Transactions par Mois
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                    <tr>
                                        <th>Période</th>
                                        <th>Nb Transactions</th>
                                        <th>Volume</th>
                                        <th>Moyenne</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="stat" items="${statsTransactions}">
                                        <tr>
                                            <td>${stat[1]}/${stat[0]}</td>
                                            <td>${stat[2]}</td>
                                            <td class="fw-bold">
                                                <c:if test="${stat[3] != null}">
                                                    ${stat[3]} €
                                                </c:if>
                                            </td>
                                            <td class="text-muted">
                                                <c:if test="${stat[3] != null && stat[2] != 0}">
                                                    ${stat[3].doubleValue() / stat[2]} €
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
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