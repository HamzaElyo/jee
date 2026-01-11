<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Utilisateurs - Streaming Analytics</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --bg-primary: #0a0a0f;
                --bg-secondary: #12121a;
                --bg-card: #1a1a24;
                --border-color: #2a2a3a;
                --text-primary: #ffffff;
                --text-secondary: #8b8b9a;
                --accent-purple: #8b5cf6;
                --accent-blue: #3b82f6;
                --accent-green: #10b981;
                --accent-orange: #f59e0b;
                --accent-pink: #ec4899;
                --accent-red: #ef4444;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: var(--bg-primary);
                color: var(--text-primary);
                min-height: 100vh;
            }

            .dashboard {
                display: grid;
                grid-template-columns: 260px 1fr;
                min-height: 100vh;
            }

            .sidebar {
                background: var(--bg-secondary);
                border-right: 1px solid var(--border-color);
                padding: 24px;
                display: flex;
                flex-direction: column;
            }

            .logo {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 40px;
                text-decoration: none;
                color: inherit;
            }

            .logo-icon {
                width: 40px;
                height: 40px;
                background: linear-gradient(135deg, var(--accent-purple), var(--accent-blue));
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .logo-icon i {
                font-size: 18px;
            }

            .logo-text {
                font-size: 1.2rem;
                font-weight: 700;
            }

            .nav-section {
                margin-bottom: 32px;
            }

            .nav-title {
                font-size: 0.7rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: var(--text-secondary);
                margin-bottom: 16px;
            }

            .nav-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 16px;
                border-radius: 8px;
                color: var(--text-secondary);
                cursor: pointer;
                transition: all 0.2s;
                margin-bottom: 4px;
                text-decoration: none;
            }

            .nav-item:hover,
            .nav-item.active {
                background: rgba(139, 92, 246, 0.1);
                color: var(--accent-purple);
            }

            .nav-item.active {
                background: rgba(139, 92, 246, 0.15);
            }

            .nav-item i {
                width: 20px;
                text-align: center;
            }

            .main {
                padding: 24px 32px;
                overflow-y: auto;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 32px;
            }

            .header h1 {
                font-size: 1.75rem;
                font-weight: 600;
            }

            .card {
                background: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .card-title {
                font-size: 1rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .card-title i {
                color: var(--accent-purple);
            }

            .user-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .user-list {
                max-height: 500px;
                overflow-y: auto;
            }

            .user-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px;
                border-radius: 8px;
                background: var(--bg-secondary);
                margin-bottom: 8px;
                cursor: pointer;
                transition: all 0.2s;
            }

            .user-item:hover,
            .user-item.selected {
                border-left: 3px solid var(--accent-purple);
                background: rgba(139, 92, 246, 0.1);
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--accent-purple), var(--accent-blue));
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
            }

            .user-info {
                flex: 1;
            }

            .user-id {
                font-size: 0.9rem;
                font-weight: 500;
                color: var(--accent-blue);
            }

            .user-meta {
                font-size: 0.75rem;
                color: var(--text-secondary);
            }

            .recommendations-panel {
                background: var(--bg-secondary);
                border-radius: 12px;
                padding: 20px;
            }

            .reco-header {
                margin-bottom: 20px;
            }

            .reco-title {
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 8px;
            }

            .reco-subtitle {
                font-size: 0.85rem;
                color: var(--text-secondary);
            }

            .reco-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px;
                border-radius: 8px;
                background: var(--bg-card);
                margin-bottom: 8px;
            }

            .reco-icon {
                width: 36px;
                height: 36px;
                border-radius: 8px;
                background: rgba(16, 185, 129, 0.15);
                color: var(--accent-green);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .reco-info {
                flex: 1;
            }

            .reco-video-id {
                font-size: 0.85rem;
                font-weight: 500;
                color: var(--accent-blue);
            }

            .reco-category {
                font-size: 0.75rem;
                color: var(--text-secondary);
            }

            .search-input {
                width: 100%;
                padding: 12px 16px;
                background: var(--bg-secondary);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                color: var(--text-primary);
                font-size: 0.9rem;
                margin-bottom: 16px;
            }

            .search-input:focus {
                outline: none;
                border-color: var(--accent-purple);
            }

            .empty-state {
                text-align: center;
                padding: 40px;
                color: var(--text-secondary);
            }

            @media (max-width: 1200px) {
                .user-grid {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 768px) {
                .dashboard {
                    grid-template-columns: 1fr;
                }

                .sidebar {
                    display: none;
                }
            }
        </style>
    </head>

    <body>
        <div class="dashboard">
            <aside class="sidebar">
                <a href="dashboard" class="logo">
                    <div class="logo-icon"><i class="fas fa-chart-line"></i></div>
                    <span class="logo-text">StreamStats</span>
                </a>
                <div class="nav-section">
                    <div class="nav-title">Menu Principal</div>
                    <a href="dashboard" class="nav-item"><i class="fas fa-home"></i> Dashboard</a>
                    <a href="dashboard?page=videos" class="nav-item"><i class="fas fa-video"></i> Vidéos</a>
                    <a href="dashboard?page=users" class="nav-item active"><i class="fas fa-users"></i> Utilisateurs</a>
                    <a href="dashboard?page=analytics" class="nav-item"><i class="fas fa-chart-bar"></i> Analytics</a>
                </div>
                <div class="nav-section">
                    <div class="nav-title">Données</div>
                    <a href="dashboard?page=collections" class="nav-item"><i class="fas fa-database"></i>
                        Collections</a>
                    <a href="dashboard?page=events" class="nav-item"><i class="fas fa-stream"></i> Événements</a>
                    <a href="dashboard?page=settings" class="nav-item"><i class="fas fa-cog"></i> Paramètres</a>
                </div>
            </aside>

            <main class="main">
                <div class="header">
                    <h1><i class="fas fa-users"
                            style="color: var(--accent-purple); margin-right: 12px;"></i>Utilisateurs</h1>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-user-circle"></i> Utilisateurs et Recommandations</h3>
                    </div>

                    <div class="user-grid">
                        <div>
                            <input type="text" class="search-input" id="userSearch"
                                placeholder="Rechercher un utilisateur...">
                            <div class="user-list" id="userList">
                                <div class="empty-state">Chargement des utilisateurs...</div>
                            </div>
                        </div>

                        <div class="recommendations-panel" id="recommendationsPanel">
                            <div class="reco-header">
                                <div class="reco-title">Recommandations</div>
                                <div class="reco-subtitle">Sélectionnez un utilisateur pour voir ses recommandations
                                </div>
                            </div>
                            <div id="recommendationsList">
                                <div class="empty-state"><i class="fas fa-arrow-left"></i> Choisissez un utilisateur
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script>
            const API_BASE = '/analytics_api_war_exploded/api/v1/analytics';
            var allUsers = [];

            async function loadUsers() {
                try {
                    const response = await fetch(API_BASE + '/users?limit=50');
                    allUsers = await response.json();
                    displayUsers(allUsers);
                } catch (e) {
                    console.error('Error loading users:', e);
                    document.getElementById('userList').innerHTML = '<div class="empty-state">Erreur lors du chargement</div>';
                }
            }

            function displayUsers(users) {
                const list = document.getElementById('userList');
                if (users.length === 0) {
                    list.innerHTML = '<div class="empty-state">Aucun utilisateur trouvé</div>';
                    return;
                }
                list.innerHTML = users.map(function (u) {
                    var avatarText = u.userId.split('_')[1] ? u.userId.split('_')[1].substring(0, 2) : 'U';
                    return '<div class="user-item" data-user-id="' + u.userId + '" onclick="loadRecommendations(\'' + u.userId + '\')">' +
                        '<div class="user-avatar">' + avatarText + '</div>' +
                        '<div class="user-info">' +
                        '<div class="user-id">' + u.userId + '</div>' +
                        '<div class="user-meta">' + u.watchCount + ' vidéos regardées</div>' +
                        '</div>' +
                        '<i class="fas fa-chevron-right" style="color: var(--text-secondary);"></i>' +
                        '</div>';
                }).join('');
            }

            async function loadRecommendations(userId) {
                // Highlight selected user
                document.querySelectorAll('.user-item').forEach(function (item) { item.classList.remove('selected'); });
                var selectedItem = document.querySelector('[data-user-id="' + userId + '"]');
                if (selectedItem) selectedItem.classList.add('selected');

                const panel = document.getElementById('recommendationsList');
                panel.innerHTML = '<div class="empty-state">Chargement...</div>';

                try {
                    const response = await fetch(API_BASE + '/users/' + userId + '/recommendations');
                    const recommendations = await response.json();

                    document.querySelector('.reco-subtitle').textContent = recommendations.length + ' recommandations pour ' + userId;

                    if (recommendations.length === 0) {
                        panel.innerHTML = '<div class="empty-state">Aucune recommandation disponible</div>';
                        return;
                    }

                    panel.innerHTML = recommendations.map(function (v) {
                        return '<div class="reco-item">' +
                            '<div class="reco-icon"><i class="fas fa-play"></i></div>' +
                            '<div class="reco-info">' +
                            '<div class="reco-video-id">' + v.videoId + '</div>' +
                            '<div class="reco-category">' + (v.category || 'N/A') + ' - ' + (v.duration || 0) + 's</div>' +
                            '</div>' +
                            '</div>';
                    }).join('');
                } catch (e) {
                    console.error('Error loading recommendations:', e);
                    panel.innerHTML = '<div class="empty-state">Erreur lors du chargement</div>';
                }
            }

            document.getElementById('userSearch').addEventListener('input', function (e) {
                const query = e.target.value.toLowerCase();
                const filtered = allUsers.filter(function (u) { return u.userId.toLowerCase().includes(query); });
                displayUsers(filtered);
            });

            document.addEventListener('DOMContentLoaded', function () {
                loadUsers();
            });
        </script>
    </body>

    </html>