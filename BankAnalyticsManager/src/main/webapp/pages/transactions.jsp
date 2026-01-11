<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transactions - BankFlow Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <!-- Inclusion du Sidebar -->
        <jsp:include page="../includes/sidebar.jsp">
            <jsp:param name="activePage" value="transactions"/>
        </jsp:include>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10 ms-sm-auto px-4 py-4">
            <h2>Gestion des Transactions</h2>

            <!-- Messages d'erreur -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Opérations bancaires -->
            <div class="row g-4 mb-4">
                <!-- Dépôt -->
                <div class="col-md-4">
                    <div class="card shadow">
                        <div class="card-header bg-success text-white">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-plus-circle me-2"></i>Dépôt
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="transactions">
                                <input type="hidden" name="action" value="depot">
                                <div class="mb-3">
                                    <label class="form-label">Compte</label>
                                    <select name="compteId" class="form-select" required>
                                        <c:forEach var="compte" items="${comptes}">
                                            <option value="${compte.id}">${compte.numeroCompte} - ${compte.client.nomComplet}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Montant</label>
                                    <input type="number" name="montant" step="0.01" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <input type="text" name="description" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-success w-100">
                                    <i class="bi bi-check-circle me-2"></i>Effectuer le dépôt
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Retrait -->
                <div class="col-md-4">
                    <div class="card shadow">
                        <div class="card-header bg-warning text-dark">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-dash-circle me-2"></i>Retrait
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="transactions">
                                <input type="hidden" name="action" value="retrait">
                                <div class="mb-3">
                                    <label class="form-label">Compte</label>
                                    <select name="compteId" class="form-select" required>
                                        <c:forEach var="compte" items="${comptes}">
                                            <option value="${compte.id}">${compte.numeroCompte} - ${compte.client.nomComplet}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Montant</label>
                                    <input type="number" name="montant" step="0.01" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <input type="text" name="description" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-warning w-100">
                                    <i class="bi bi-check-circle me-2"></i>Effectuer le retrait
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Virement -->
                <div class="col-md-4">
                    <div class="card shadow">
                        <div class="card-header bg-info text-white">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-arrow-left-right me-2"></i>Virement
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="transactions">
                                <input type="hidden" name="action" value="virement">
                                <div class="mb-3">
                                    <label class="form-label">Compte Source</label>
                                    <select name="compteId" class="form-select" required>
                                        <c:forEach var="compte" items="${comptes}">
                                            <option value="${compte.id}">${compte.numeroCompte} - ${compte.client.nomComplet}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Compte Destination</label>
                                    <select name="compteDestId" class="form-select" required>
                                        <c:forEach var="compte" items="${comptes}">
                                            <option value="${compte.id}">${compte.numeroCompte} - ${compte.client.nomComplet}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Montant</label>
                                    <input type="number" name="montant" step="0.01" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <input type="text" name="description" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-info w-100">
                                    <i class="bi bi-check-circle me-2"></i>Effectuer le virement
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Liste des transactions -->
            <div class="card shadow">
                <div class="card-header bg-dark text-white">
                    <h5 class="card-title mb-0">
                        <i class="bi bi-list-ul me-2"></i>Historique des Transactions
                    </h5>
                </div>
                <div class="card-body">
                    <!-- Filtre par compte -->
                    <form method="get" class="row g-3 mb-4">
                        <div class="col-md-6">
                            <select name="compteId" class="form-select" onchange="this.form.submit()">
                                <option value="">Tous les comptes</option>
                                <c:forEach var="compte" items="${comptes}">
                                    <option value="${compte.id}" ${param.compteId == compte.id ? 'selected' : ''}>
                                            ${compte.numeroCompte} - ${compte.client.nomComplet}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Type</th>
                                <th>Montant</th>
                                <th>Description</th>
                                <th>Compte</th>
                                <th>Client</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="transaction" items="${transactions}">
                                <tr>
                                    <td>${transaction.dateOperation}</td>
                                    <td>
                                                <span class="badge
                                                    <c:choose>
                                                        <c:when test="${transaction.type == 'DEPOT' || transaction.type == 'VIREMENT_RECU'}">bg-success</c:when>
                                                        <c:when test="${transaction.type == 'RETRAIT' || transaction.type == 'VIREMENT_EMIS'}">bg-danger</c:when>
                                                        <c:otherwise>bg-secondary</c:otherwise>
                                                    </c:choose>">
                                                        ${transaction.type}
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
                                    <td>${transaction.compte.client.nomComplet}</td>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>