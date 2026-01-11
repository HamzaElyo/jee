<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!-- Sidebar -->
<div class="col-md-3 col-lg-2 sidebar p-0">
    <div class="d-flex flex-column p-3">
        <h4 class="text-white text-center mb-4">
            <i class="bi bi-bank2 me-2"></i>BankFlow
        </h4>
        <ul class="nav nav-pills flex-column">
            <li class="nav-item">
                <a href="dashboard" class="nav-link ${param.activePage == 'dashboard' ? 'active' : ''}">
                    <i class="bi bi-speedometer2 me-2"></i>Tableau de Bord
                </a>
            </li>
            <li class="nav-item">
                <a href="clients" class="nav-link ${param.activePage == 'clients' ? 'active' : ''}">
                    <i class="bi bi-people me-2"></i>Clients
                </a>
            </li>
            <li class="nav-item">
                <a href="comptes" class="nav-link ${param.activePage == 'comptes' ? 'active' : ''}">
                    <i class="bi bi-credit-card me-2"></i>Comptes
                </a>
            </li>
            <li class="nav-item">
                <a href="transactions" class="nav-link ${param.activePage == 'transactions' ? 'active' : ''}">
                    <i class="bi bi-arrow-left-right me-2"></i>Transactions
                </a>
            </li>
            <li class="nav-item">
                <a href="rapports" class="nav-link ${param.activePage == 'rapports' ? 'active' : ''}">
                    <i class="bi bi-graph-up me-2"></i>Rapports
                </a>
            </li>
        </ul>

        <!-- Bouton Génération Données Test -->
        <hr class="text-white mt-3">
        <form method="post" action="generate-data" class="mt-auto">
            <button type="submit" class="btn btn-warning w-100 btn-sm">
                <i class="bi bi-database-add me-2"></i>Données Test
            </button>
        </form>
    </div>
</div>

<style>
    .sidebar {
        background: linear-gradient(180deg, #2c3e50 0%, #3498db 100%);
        min-height: 100vh;
    }
    .sidebar .nav-link {
        color: #ecf0f1;
        padding: 0.75rem 1rem;
        margin: 0.25rem 0;
        border-radius: 0.5rem;
        transition: all 0.3s ease;
    }
    .sidebar .nav-link:hover {
        background: rgba(255,255,255,0.15);
        color: #fff;
        transform: translateX(5px);
    }
    .sidebar .nav-link.active {
        background: rgba(255,255,255,0.2);
        color: #fff;
        font-weight: 600;
        border-left: 4px solid #f39c12;
    }
</style>