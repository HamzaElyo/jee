<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Comptes - BankFlow Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Inclusion du Sidebar -->
        <jsp:include page="../includes/sidebar.jsp">
            <jsp:param name="activePage" value="comptes"/>
        </jsp:include>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10 ms-sm-auto px-4 py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Gestion des Comptes</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCompteModal">
                    <i class="bi bi-plus-circle me-2"></i>Nouveau Compte
                </button>
            </div>

            <!-- Liste des comptes -->
            <div class="card shadow">
                <div class="card-header bg-dark text-white">
                    <h5 class="card-title mb-0">
                        <i class="bi bi-list-ul me-2"></i>Liste des Comptes
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Numéro</th>
                                <th>Type</th>
                                <th>Solde</th>
                                <th>Client</th>
                                <th>Date Création</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="compte" items="${comptes}">
                                <tr>
                                    <td>
                                        <strong>${compte.numeroCompte}</strong>
                                    </td>
                                    <td>
                                                <span class="badge
                                                    <c:choose>
                                                        <c:when test="${compte.type == 'COMPTE_COURANT'}">bg-primary</c:when>
                                                        <c:when test="${compte.type == 'COMPTE_EPARGNE'}">bg-success</c:when>
                                                        <c:when test="${compte.type == 'COMPTE_JOINT'}">bg-info</c:when>
                                                        <c:otherwise>bg-secondary</c:otherwise>
                                                    </c:choose>">
                                                        ${compte.type}
                                                </span>
                                    </td>
                                    <td class="fw-bold ${compte.solde.doubleValue() >= 0 ? 'text-success' : 'text-danger'}">
                                            ${compte.solde} €
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${compte.client != null}">
                                                ${compte.client.nomComplet}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Client non assigné</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${compte.dateCreation}</td>
                                    <td>
                                                <span class="badge ${compte.actif ? 'bg-success' : 'bg-danger'}">
                                                        ${compte.actif ? 'Actif' : 'Inactif'}
                                                </span>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="transactions?compteId=${compte.id}"
                                               class="btn btn-outline-primary">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </div>
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

<!-- Modal Ajout Compte -->
<div class="modal fade" id="addCompteModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Nouveau Compte</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="comptes">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Numéro de compte *</label>
                                <input type="text" name="numeroCompte" class="form-control" required
                                       placeholder="FR76 XXXX XXXX XXXX">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Type de compte *</label>
                                <select name="type" class="form-select" required>
                                    <option value="COMPTE_COURANT">Compte Courant</option>
                                    <option value="COMPTE_EPARGNE">Compte Épargne</option>
                                    <option value="COMPTE_JOINT">Compte Joint</option>
                                    <option value="COMPTE_ENTREPRISE">Compte Entreprise</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Client *</label>
                        <select name="clientId" class="form-select" required>
                            <c:forEach var="client" items="${clients}">
                                <option value="${client.id}">${client.nomComplet} - ${client.email}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Découvert Autorisé</label>
                                <input type="number" name="decouvertAutorise" class="form-control"
                                       step="0.01" value="0">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Taux d'intérêt (%)</label>
                                <input type="number" name="tauxInteret" class="form-control"
                                       step="0.01" value="0">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Créer le Compte</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>