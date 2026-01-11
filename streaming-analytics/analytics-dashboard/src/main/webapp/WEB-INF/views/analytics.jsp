<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Analytics - Streaming Analytics</title>
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

            .charts-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .chart-container {
                height: 300px;
                position: relative;
            }

            .stats-row {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 16px;
                margin-bottom: 24px;
            }

            .stat-card {
                background: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 20px;
            }

            .stat-value {
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 4px;
            }

            .stat-label {
                color: var(--text-secondary);
                font-size: 0.85rem;
            }

            .stat-icon {
                width: 44px;
                height: 44px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.1rem;
                margin-bottom: 12px;
            }

            .stat-icon.purple {
                background: rgba(139, 92, 246, 0.15);
                color: var(--accent-purple);
            }

            .stat-icon.blue {
                background: rgba(59, 130, 246, 0.15);
                color: var(--accent-blue);
            }

            .stat-icon.green {
                background: rgba(16, 185, 129, 0.15);
                color: var(--accent-green);
            }

            .stat-icon.orange {
                background: rgba(245, 158, 11, 0.15);
                color: var(--accent-orange);
            }

            @media (max-width: 1200px) {
                .charts-grid {
                    grid-template-columns: 1fr;
                }

                .stats-row {
                    grid-template-columns: repeat(2, 1fr);
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
                    <a href="dashboard?page=users" class="nav-item"><i class="fas fa-users"></i> Utilisateurs</a>
                    <a href="dashboard?page=analytics" class="nav-item active"><i class="fas fa-chart-bar"></i>
                        Analytics</a>
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
                    <h1><i class="fas fa-chart-bar"
                            style="color: var(--accent-purple); margin-right: 12px;"></i>Analytics Avancées</h1>
                </div>

                <!-- Stats Row -->
                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-icon purple"><i class="fas fa-play-circle"></i></div>
                        <div class="stat-value" id="totalEvents">-</div>
                        <div class="stat-label">Total Événements</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon blue"><i class="fas fa-film"></i></div>
                        <div class="stat-value" id="totalVideos">-</div>
                        <div class="stat-label">Vidéos Catalogue</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon green"><i class="fas fa-tags"></i></div>
                        <div class="stat-value" id="totalCategories">-</div>
                        <div class="stat-label">Catégories</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon orange"><i class="fas fa-fire"></i></div>
                        <div class="stat-value" id="trendingCount">-</div>
                        <div class="stat-label">Vidéos Tendance</div>
                    </div>
                </div>

                <!-- Charts Grid -->
                <div class="charts-grid">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title"><i class="fas fa-tags"></i> Répartition par Catégorie</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="categoryChart"></canvas>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title"><i class="fas fa-mouse-pointer"></i> Types d'Actions</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="actionsChart"></canvas>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title"><i class="fas fa-desktop"></i> Par Appareil</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="deviceChart"></canvas>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title"><i class="fas fa-eye"></i> Vues par Catégorie</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="viewsChart"></canvas>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script>
            const API_BASE = '/analytics_api_war_exploded/api/v1/analytics';
            var categoryChart, actionsChart, deviceChart, viewsChart;

            Chart.defaults.color = '#8b8b9a';
            Chart.defaults.borderColor = '#2a2a3a';

            function initCharts() {
                categoryChart = new Chart(document.getElementById('categoryChart'), {
                    type: 'doughnut',
                    data: { labels: [], datasets: [{ data: [], backgroundColor: ['#8b5cf6', '#3b82f6', '#10b981', '#f59e0b', '#ec4899', '#ef4444'], borderWidth: 0 }] },
                    options: { responsive: true, maintainAspectRatio: false, cutout: '60%', plugins: { legend: { position: 'right', labels: { padding: 15, usePointStyle: true } } } }
                });

                actionsChart = new Chart(document.getElementById('actionsChart'), {
                    type: 'pie',
                    data: { labels: [], datasets: [{ data: [], backgroundColor: ['#10b981', '#f59e0b', '#3b82f6', '#ef4444', '#8b5cf6'], borderWidth: 0 }] },
                    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'right', labels: { padding: 15, usePointStyle: true } } } }
                });

                deviceChart = new Chart(document.getElementById('deviceChart'), {
                    type: 'bar',
                    data: { labels: [], datasets: [{ data: [], backgroundColor: ['#8b5cf6', '#3b82f6', '#10b981', '#f59e0b', '#ec4899'], borderRadius: 6, barThickness: 40 }] },
                    options: { responsive: true, maintainAspectRatio: false, indexAxis: 'y', plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true, grid: { display: false } }, y: { grid: { display: false } } } }
                });

                viewsChart = new Chart(document.getElementById('viewsChart'), {
                    type: 'bar',
                    data: { labels: [], datasets: [{ label: 'Total Vues', data: [], backgroundColor: '#8b5cf6', borderRadius: 4 }] },
                    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } }, y: { grid: { color: '#2a2a3a' } } } }
                });
            }

            async function loadGlobalStats() {
                try {
                    const response = await fetch(API_BASE + '/stats/global');
                    const stats = await response.json();
                    document.getElementById('totalEvents').textContent = (stats.totalEvents || 0).toLocaleString();
                    document.getElementById('totalVideos').textContent = (stats.totalVideos || 0).toLocaleString();
                } catch (e) { console.error('Global stats error:', e); }
            }

            async function loadCategoryStats() {
                try {
                    const response = await fetch(API_BASE + '/categories/stats');
                    const stats = await response.json();

                    const labels = Object.keys(stats);
                    const videoCounts = labels.map(function (k) { return stats[k].videoCount || 0; });
                    const viewCounts = labels.map(function (k) { return stats[k].totalViews || 0; });

                    document.getElementById('totalCategories').textContent = labels.length;

                    categoryChart.data.labels = labels;
                    categoryChart.data.datasets[0].data = videoCounts;
                    categoryChart.update('none');

                    viewsChart.data.labels = labels;
                    viewsChart.data.datasets[0].data = viewCounts;
                    viewsChart.update('none');
                } catch (e) { console.error('Category stats error:', e); }
            }

            async function loadActionStats() {
                try {
                    const response = await fetch(API_BASE + '/events/stats/actions');
                    const stats = await response.json();
                    const actionOrder = ['WATCH', 'PAUSE', 'SEEK', 'STOP', 'RESUME'];
                    const labels = actionOrder.filter(function (a) { return stats[a] !== undefined; });
                    const data = labels.map(function (a) { return stats[a] || 0; });

                    actionsChart.data.labels = labels;
                    actionsChart.data.datasets[0].data = data;
                    actionsChart.update('none');
                } catch (e) { console.error('Action stats error:', e); }
            }

            async function loadDeviceStats() {
                try {
                    const response = await fetch(API_BASE + '/events/stats/devices');
                    const stats = await response.json();
                    const deviceOrder = ['desktop', 'mobile', 'tablet', 'tv', 'console'];
                    const labels = deviceOrder.filter(function (d) { return stats[d] !== undefined; });
                    const data = labels.map(function (d) { return stats[d] || 0; });

                    deviceChart.data.labels = labels.map(function (d) { return d.charAt(0).toUpperCase() + d.slice(1); });
                    deviceChart.data.datasets[0].data = data;
                    deviceChart.update('none');
                } catch (e) { console.error('Device stats error:', e); }
            }

            async function loadTrending() {
                try {
                    const response = await fetch(API_BASE + '/trending?limit=10');
                    const trending = await response.json();
                    document.getElementById('trendingCount').textContent = trending.length;
                } catch (e) { console.error('Trending error:', e); }
            }

            document.addEventListener('DOMContentLoaded', function () {
                initCharts();
                loadGlobalStats();
                loadCategoryStats();
                loadActionStats();
                loadDeviceStats();
                loadTrending();

                setInterval(function () { loadGlobalStats(); loadCategoryStats(); loadActionStats(); loadDeviceStats(); }, 30000);
            });
        </script>
    </body>

    </html>