<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Vidéos - Streaming Analytics</title>
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

            .search-box {
                display: flex;
                gap: 16px;
                margin-bottom: 24px;
            }

            .search-input {
                flex: 1;
                padding: 12px 16px;
                background: var(--bg-secondary);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                color: var(--text-primary);
                font-size: 0.9rem;
            }

            .search-input:focus {
                outline: none;
                border-color: var(--accent-purple);
            }

            .filter-select {
                padding: 12px 16px;
                background: var(--bg-secondary);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                color: var(--text-primary);
                font-size: 0.9rem;
                cursor: pointer;
            }

            .video-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }

            .video-card {
                background: var(--bg-secondary);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 16px;
                transition: all 0.2s;
            }

            .video-card:hover {
                border-color: var(--accent-purple);
                transform: translateY(-2px);
            }

            .video-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 12px;
            }

            .video-id {
                font-family: 'Monaco', monospace;
                font-size: 0.9rem;
                color: var(--accent-blue);
            }

            .video-category {
                padding: 4px 10px;
                border-radius: 4px;
                font-size: 0.75rem;
                background: rgba(139, 92, 246, 0.15);
                color: var(--accent-purple);
            }

            .video-title {
                font-size: 1rem;
                font-weight: 500;
                margin-bottom: 8px;
            }

            .video-meta {
                display: flex;
                gap: 16px;
                color: var(--text-secondary);
                font-size: 0.85rem;
            }

            .video-meta span {
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .stats-row {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 16px;
                margin-bottom: 24px;
            }

            .stat-mini {
                background: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                padding: 16px;
                text-align: center;
            }

            .stat-mini-value {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--accent-purple);
            }

            .stat-mini-label {
                font-size: 0.75rem;
                color: var(--text-secondary);
            }

            .table-wrapper {
                overflow-x: auto;
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
            }

            .data-table th {
                text-align: left;
                padding: 12px 16px;
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: var(--text-secondary);
                border-bottom: 1px solid var(--border-color);
            }

            .data-table td {
                padding: 16px;
                border-bottom: 1px solid var(--border-color);
            }

            .data-table tr:hover {
                background: rgba(255, 255, 255, 0.02);
            }

            .loading {
                text-align: center;
                padding: 40px;
                color: var(--text-secondary);
            }

            @media (max-width: 1200px) {
                .stats-row {
                    grid-template-columns: repeat(2, 1fr);
                }

                .video-grid {
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
            <!-- Sidebar -->
            <aside class="sidebar">
                <a href="dashboard" class="logo">
                    <div class="logo-icon"><i class="fas fa-chart-line"></i></div>
                    <span class="logo-text">StreamStats</span>
                </a>
                <div class="nav-section">
                    <div class="nav-title">Menu Principal</div>
                    <a href="dashboard" class="nav-item"><i class="fas fa-home"></i> Dashboard</a>
                    <a href="dashboard?page=videos" class="nav-item active"><i class="fas fa-video"></i> Vidéos</a>
                    <a href="dashboard?page=users" class="nav-item"><i class="fas fa-users"></i> Utilisateurs</a>
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

            <!-- Main Content -->
            <main class="main">
                <div class="header">
                    <h1><i class="fas fa-video" style="color: var(--accent-purple); margin-right: 12px;"></i>Catalogue
                        Vidéos</h1>
                </div>

                <!-- Stats Row -->
                <div class="stats-row">
                    <div class="stat-mini">
                        <div class="stat-mini-value" id="totalVideos">-</div>
                        <div class="stat-mini-label">Total Vidéos</div>
                    </div>
                    <div class="stat-mini">
                        <div class="stat-mini-value" id="totalViews">-</div>
                        <div class="stat-mini-label">Vues Totales</div>
                    </div>
                    <div class="stat-mini">
                        <div class="stat-mini-value" id="avgDuration">-</div>
                        <div class="stat-mini-label">Durée Moyenne</div>
                    </div>
                    <div class="stat-mini">
                        <div class="stat-mini-value" id="categoryCount">-</div>
                        <div class="stat-mini-label">Catégories</div>
                    </div>
                </div>

                <!-- Search and Filter -->
                <div class="search-box">
                    <input type="text" class="search-input" id="searchInput" placeholder="Rechercher une vidéo...">
                    <select class="filter-select" id="categoryFilter">
                        <option value="">Toutes les catégories</option>
                    </select>
                </div>

                <!-- Videos Grid -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-film"></i> Vidéos du Catalogue</h3>
                    </div>
                    <div class="video-grid" id="videoGrid">
                        <div class="loading">Chargement des vidéos...</div>
                    </div>
                </div>

                <!-- Top Videos Table -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-trophy"></i> Top Vidéos par Vues</h3>
                    </div>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>ID Vidéo</th>
                                    <th>Catégorie</th>
                                    <th>Vues</th>
                                    <th>Durée Moy.</th>
                                </tr>
                            </thead>
                            <tbody id="topVideosBody">
                                <tr>
                                    <td colspan="5" class="loading">Chargement...</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>

        <script>
            const API_BASE = '/analytics_api_war_exploded/api/v1/analytics';
            let allVideos = [];
            let categories = new Set();

            async function loadTopVideos() {
                try {
                    const response = await fetch(API_BASE + '/videos/top?limit=20');
                    const videos = await response.json();

                    const tbody = document.getElementById('topVideosBody');
                    tbody.innerHTML = videos.map(function (v, i) {
                        return '<tr>' +
                            '<td>' + (i + 1) + '</td>' +
                            '<td style="color: var(--accent-blue); font-family: monospace;">' + v.videoId + '</td>' +
                            '<td><span class="video-category">' + (v.category || 'N/A') + '</span></td>' +
                            '<td>' + (v.totalViews || 0) + '</td>' +
                            '<td>' + (v.avgDuration ? v.avgDuration.toFixed(1) : 0) + 's</td>' +
                            '</tr>';
                    }).join('');
                    // Stats are now calculated in loadCategoryStats from all videos
                } catch (e) {
                    console.error('Error loading top videos:', e);
                }
            }

            async function loadCategoryStats() {
                try {
                    const response = await fetch(API_BASE + '/categories/stats');
                    const stats = await response.json();

                    const categoryNames = Object.keys(stats);
                    document.getElementById('categoryCount').textContent = categoryNames.length;

                    // Calculate totals from all categories
                    let totalVideos = 0;
                    let totalViews = 0;
                    let totalDuration = 0;
                    categoryNames.forEach(function (cat) {
                        totalVideos += stats[cat].videoCount || 0;
                        totalViews += stats[cat].totalViews || 0;
                        totalDuration += (stats[cat].avgDuration || 0) * (stats[cat].videoCount || 0);
                        categories.add(cat);
                    });
                    document.getElementById('totalVideos').textContent = totalVideos.toLocaleString();
                    document.getElementById('totalViews').textContent = totalViews.toLocaleString();
                    document.getElementById('avgDuration').textContent = (totalVideos > 0 ? (totalDuration / totalVideos).toFixed(0) : 0) + 's';

                    // Populate filter dropdown
                    const filter = document.getElementById('categoryFilter');
                    categoryNames.forEach(function (cat) {
                        const option = document.createElement('option');
                        option.value = cat;
                        option.textContent = cat + ' (' + stats[cat].videoCount + ')';
                        filter.appendChild(option);
                    });

                    // Create video cards from category data
                    displayVideoCards(stats);
                } catch (e) {
                    console.error('Error loading category stats:', e);
                }
            }

            function displayVideoCards(categoryStats) {
                const grid = document.getElementById('videoGrid');
                const cards = [];

                Object.entries(categoryStats).forEach(function (entry) {
                    var category = entry[0];
                    var stats = entry[1];
                    cards.push(
                        '<div class="video-card" data-category="' + category + '">' +
                        '<div class="video-header">' +
                        '<span class="video-id">' + category + '</span>' +
                        '<span class="video-category">' + stats.videoCount + ' vidéos</span>' +
                        '</div>' +
                        '<div class="video-title">Catégorie: ' + category + '</div>' +
                        '<div class="video-meta">' +
                        '<span><i class="fas fa-eye"></i> ' + (stats.totalViews || 0).toLocaleString() + ' vues</span>' +
                        '<span><i class="fas fa-clock"></i> ' + Math.round(stats.avgDuration || 0) + 's moy.</span>' +
                        '</div>' +
                        '</div>'
                    );
                });

                grid.innerHTML = cards.join('');
            }

            // Search functionality
            document.getElementById('searchInput').addEventListener('input', function (e) {
                const query = e.target.value.toLowerCase();
                const cards = document.querySelectorAll('.video-card');
                cards.forEach(card => {
                    const text = card.textContent.toLowerCase();
                    card.style.display = text.includes(query) ? '' : 'none';
                });
            });

            // Filter functionality
            document.getElementById('categoryFilter').addEventListener('change', function (e) {
                const category = e.target.value;
                const cards = document.querySelectorAll('.video-card');
                cards.forEach(card => {
                    if (!category || card.dataset.category === category) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });

            document.addEventListener('DOMContentLoaded', function () {
                loadTopVideos();
                loadCategoryStats();
                setInterval(loadTopVideos, 10000);
            });
        </script>
    </body>

    </html>