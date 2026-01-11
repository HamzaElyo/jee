<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BankFlow Manager - Système de Gestion Bancaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .card-hover {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        .feature-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
    </style>
</head>
<body class="gradient-bg min-vh-100">
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark bg-opacity-50">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="bi bi-bank2 me-2"></i>BankFlow Manager
        </a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="dashboard">
                <i class="bi bi-box-arrow-in-right me-1"></i>Connexion
            </a>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="container py-5">
    <div class="row align-items-center min-vh-75">
        <div class="col-lg-6 text-white">
            <h1 class="display-4 fw-bold mb-4">
                Gestion Bancaire <span class="text-warning">Moderne</span>
            </h1>
            <p class="lead mb-4">
                BankFlow Manager révolutionne la gestion bancaire avec une interface intuitive,
                des fonctionnalités avancées et une sécurité renforcée.
            </p>
            <div class="d-flex gap-3">
                <a href="dashboard" class="btn btn-warning btn-lg px-4">
                    <i class="bi bi-play-circle me-2"></i>Démarrer
                </a>
                <a href="#features" class="btn btn-outline-light btn-lg px-4">
                    <i class="bi bi-info-circle me-2"></i>En savoir plus
                </a>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card border-0 shadow-lg card-hover">
                <div class="card-body p-4">
                    <h4 class="card-title text-center mb-4">Accéder au système</h4>
                    <div class="d-grid gap-3">
                        <a href="dashboard" class="btn btn-primary btn-lg">
                            <i class="bi bi-speedometer2 me-2"></i>Tableau de Bord
                        </a>
                        <a href="clients" class="btn btn-outline-primary btn-lg">
                            <i class="bi bi-people me-2"></i>Gestion des Clients
                        </a>
                        <a href="transactions" class="btn btn-outline-primary btn-lg">
                            <i class="bi bi-arrow-left-right me-2"></i>Transactions
                        </a>
                    </div>
                    <hr>
                    <div class="text-center">
                        <small class="text-muted">
                            <i class="bi bi-shield-check me-1"></i>
                            Système sécurisé Jakarta EE
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Features Section -->
<section id="features" class="py-5 bg-light">
    <div class="container">
        <div class="row text-center mb-5">
            <div class="col">
                <h2 class="display-5 fw-bold">Fonctionnalités Principales</h2>
                <p class="lead">Découvrez les capacités exceptionnelles de BankFlow Manager</p>
            </div>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm card-hover h-100">
                    <div class="card-body text-center p-4">
                        <div class="feature-icon">
                            <i class="bi bi-people text-white fs-4"></i>
                        </div>
                        <h5 class="card-title">Gestion des Clients</h5>
                        <p class="card-text">
                            Gérez efficacement les profils clients avec toutes les informations
                            nécessaires pour un service optimal.
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm card-hover h-100">
                    <div class="card-body text-center p-4">
                        <div class="feature-icon">
                            <i class="bi bi-credit-card text-white fs-4"></i>
                        </div>
                        <h5 class="card-title">Comptes Multiples</h5>
                        <p class="card-text">
                            Support des comptes courants, épargne, joints et entreprises
                            avec des fonctionnalités spécifiques.
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm card-hover h-100">
                    <div class="card-body text-center p-4">
                        <div class="feature-icon">
                            <i class="bi bi-graph-up text-white fs-4"></i>
                        </div>
                        <h5 class="card-title">Analytique Avancée</h5>
                        <p class="card-text">
                            Tableaux de bord détaillés et rapports analytiques pour une
                            prise de décision éclairée.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>