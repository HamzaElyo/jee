<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Streaming Analytics Dashboard</title>
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

            /* Sidebar */
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

            /* Main Content */
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

            .header-right {
                display: flex;
                align-items: center;
                gap: 16px;
            }

            .status-badge {
                display: flex;
                align-items: center;
                gap: 8px;
                background: rgba(16, 185, 129, 0.1);
                border: 1px solid rgba(16, 185, 129, 0.3);
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 0.85rem;
            }

            .status-dot {
                width: 8px;
                height: 8px;
                background: var(--accent-green);
                border-radius: 50%;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {

                0%,
                100% {
                    opacity: 1;
                }

                50% {
                    opacity: 0.4;
                }
            }

            /* Stats Grid */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                margin-bottom: 24px;
            }

            .stat-card {
                background: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 20px;
            }

            .stat-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 16px;
            }

            .stat-icon {
                width: 44px;
                height: 44px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.1rem;
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

            .stat-trend {
                display: flex;
                align-items: center;
                gap: 4px;
                font-size: 0.75rem;
                padding: 4px 8px;
                border-radius: 4px;
            }

            .stat-trend.up {
                background: rgba(16, 185, 129, 0.1);
                color: var(--accent-green);
            }

            .stat-trend.down {
                background: rgba(239, 68, 68, 0.1);
                color: var(--accent-red);
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

            /* Charts Grid */
            .charts-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 20px;
                margin-bottom: 24px;
            }

            .card {
                background: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 20px;
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

            .chart-container {
                height: 280px;
                position: relative;
            }

            /* Data Table */
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

            .rank-badge {
                width: 28px;
                height: 28px;
                border-radius: 6px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                font-size: 0.8rem;
            }

            .rank-badge.gold {
                background: linear-gradient(135deg, #fbbf24, #f59e0b);
            }

            .rank-badge.silver {
                background: linear-gradient(135deg, #9ca3af, #6b7280);
            }

            .rank-badge.bronze {
                background: linear-gradient(135deg, #d97706, #b45309);
            }

            .rank-badge.normal {
                background: var(--bg-secondary);
                color: var(--text-secondary);
            }

            .video-info {
                display: flex;
                flex-direction: column;
            }

            .video-id {
                font-family: 'Monaco', monospace;
                font-size: 0.85rem;
                color: var(--accent-blue);
            }

            .video-category {
                font-size: 0.75rem;
                color: var(--text-secondary);
            }

            .views-cell {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .views-bar {
                width: 60px;
                height: 6px;
                background: var(--bg-secondary);
                border-radius: 3px;
                overflow: hidden;
            }

            .views-bar-fill {
                height: 100%;
                background: linear-gradient(90deg, var(--accent-purple), var(--accent-blue));
                border-radius: 3px;
            }

            /* Live Feed */
            .live-feed {
                max-height: 300px;
                overflow-y: auto;
            }

            .feed-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 8px;
                background: var(--bg-secondary);
                animation: slideIn 0.3s ease;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(-10px);
                }

                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            .feed-icon {
                width: 36px;
                height: 36px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .feed-icon.play {
                background: rgba(16, 185, 129, 0.15);
                color: var(--accent-green);
            }

            .feed-icon.pause {
                background: rgba(245, 158, 11, 0.15);
                color: var(--accent-orange);
            }

            .feed-icon.stop {
                background: rgba(239, 68, 68, 0.15);
                color: var(--accent-red);
            }

            .feed-content {
                flex: 1;
            }

            .feed-title {
                font-size: 0.85rem;
                margin-bottom: 2px;
            }

            .feed-meta {
                font-size: 0.75rem;
                color: var(--text-secondary);
            }

            .feed-time {
                font-size: 0.75rem;
                color: var(--text-secondary);
            }

            /* Bottom Grid */
            .bottom-grid {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr;
                gap: 20px;
            }

            .mini-chart {
                height: 180px;
            }

            @media (max-width: 1200px) {
                .stats-grid {
                    grid-template-columns: repeat(2, 1fr);
                }

                .charts-grid {
                    grid-template-columns: 1fr;
                }

                .bottom-grid {
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
                <div class="logo">
                    <div class="logo-icon"><i class="fas fa-chart-line"></i></div>
                    <span class="logo-text">StreamStats</span>
                </div>

                <div class="nav-section">
                    <div class="nav-title">Menu Principal</div>
                    <a href="dashboard" class="nav-item active"><i class="fas fa-home"></i> Dashboard</a>
                    <a href="dashboard?page=videos" class="nav-item"><i class="fas fa-video"></i> Vidéos</a>
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
                    <h1>Dashboard Analytics</h1>
                    <div class="header-right">
                        <div class="status-badge">
                            <div class="status-dot"></div>
                            <span>Live</span>
                        </div>
                    </div>
                </div>

                <!-- YouTube Trending Section (TOP) -->
                <div class="card" style="margin-bottom: 24px;">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fab fa-youtube" style="color: #ff0000;"></i> 🔥 Tendances
                            YouTube</h3>
                        <div style="display: flex; gap: 12px; align-items: center;">
                            <select id="youtubeRegion" onchange="loadYoutubeTrending()"
                                style="background: var(--bg-secondary); color: var(--text-primary); border: 1px solid var(--border-color); padding: 8px 12px; border-radius: 6px; cursor: pointer;">
                                <option value="MA">🇲🇦 Maroc</option>
                                <option value="FR">🇫🇷 France</option>
                                <option value="US">🇺🇸 États-Unis</option>
                                <option value="ES">🇪🇸 Espagne</option>
                                <option value="SA">🇸🇦 Arabie Saoudite</option>
                                <option value="EG">🇪🇬 Égypte</option>
                                <option value="AE">🇦🇪 Émirats</option>
                                <option value="GB">🇬🇧 Royaume-Uni</option>
                                <option value="DE">🇩🇪 Allemagne</option>
                                <option value="TR">🇹🇷 Turquie</option>
                            </select>
                            <button onclick="loadYoutubeTrending()"
                                style="background: #ff0000; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer;">
                                <i class="fas fa-sync-alt"></i> Actualiser
                            </button>
                        </div>
                    </div>
                    <div id="youtubeTrendingContainer"
                        style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px;">
                        <div style="text-align: center; color: var(--text-secondary); padding: 40px;">
                            <i class="fab fa-youtube" style="font-size: 48px; color: #ff0000; opacity: 0.5;"></i>
                            <p style="margin-top: 16px;">Chargement des tendances YouTube...</p>
                        </div>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon purple"><i class="fas fa-play-circle"></i></div>
                        </div>
                        <div class="stat-value" id="totalEvents">8,000</div>
                        <div class="stat-label">Total Événements</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon blue"><i class="fas fa-film"></i></div>
                        </div>
                        <div class="stat-value" id="totalVideos">1,000</div>
                        <div class="stat-label">Vidéos Catalogue</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon green"><i class="fas fa-eye"></i></div>
                        </div>
                        <div class="stat-value" id="totalViews">-</div>
                        <div class="stat-label">Vues Totales</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon orange"><i class="fas fa-clock"></i></div>
                        </div>
                        <div class="stat-value" id="avgDuration">-</div>
                        <div class="stat-label">Durée Moyenne</div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="charts-grid">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title"><i class="fas fa-trophy"></i> Top 10 Vidéos par Vues</h3>
                        </div>
                        <div class="table-wrapper">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Vidéo</th>
                                        <th>Vues</th>
                                        <th>Durée Moy.</th>
                                    </tr>
                                </thead>
                                <tbody id="topVideosBody">
                                    <tr>
                                        <td colspan="4" style="text-align:center; color: var(--text-secondary);">
                                            Chargement...</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title"><i class="fas fa-bolt"></i> Événements Live</h3>
                        </div>
                        <div class="live-feed" id="liveFeed">
                            <div style="text-align: center; color: var(--text-secondary); padding: 40px;">
                                Connexion au flux...
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bottom Charts -->
                <div class="bottom-grid">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title"><i class="fas fa-tags"></i> Par Catégorie</h3>
                        </div>
                        <div class="chart-container mini-chart">
                            <canvas id="categoryChart"></canvas>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title"><i class="fas fa-mouse-pointer"></i> Types d'Actions</h3>
                        </div>
                        <div class="chart-container mini-chart">
                            <canvas id="actionsChart"></canvas>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title"><i class="fas fa-desktop"></i> Par Appareil</h3>
                        </div>
                        <div class="chart-container mini-chart">
                            <canvas id="deviceChart"></canvas>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script>
            const API_BASE = '/analytics_api_war_exploded/api/v1/analytics';
            let categoryChart, actionsChart, deviceChart;

            // Chart.js defaults
            Chart.defaults.color = '#8b8b9a';
            Chart.defaults.borderColor = '#2a2a3a';

            function initCharts() {
                // Category Doughnut
                categoryChart = new Chart(document.getElementById('categoryChart'), {
                    type: 'doughnut',
                    data: {
                        labels: ['Action', 'Drama', 'Comedy', 'Documentary', 'Romance'],
                        datasets: [{
                            data: [25, 20, 18, 22, 15],
                            backgroundColor: ['#8b5cf6', '#3b82f6', '#10b981', '#f59e0b', '#ec4899'],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '65%',
                        plugins: { legend: { position: 'bottom', labels: { padding: 15, usePointStyle: true } } }
                    }
                });

                // Actions Pie
                actionsChart = new Chart(document.getElementById('actionsChart'), {
                    type: 'pie',
                    data: {
                        labels: ['WATCH', 'PAUSE', 'SEEK', 'STOP', 'RESUME'],
                        datasets: [{
                            data: [40, 25, 20, 15, 10],
                            backgroundColor: ['#10b981', '#f59e0b', '#3b82f6', '#ef4444', '#8b5cf6'],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { position: 'bottom', labels: { padding: 15, usePointStyle: true } } }
                    }
                });

                // Device Bar
                deviceChart = new Chart(document.getElementById('deviceChart'), {
                    type: 'bar',
                    data: {
                        labels: ['Desktop', 'Mobile', 'Tablet', 'TV', 'Console'],
                        datasets: [{
                            data: [45, 38, 17, 10, 5],
                            backgroundColor: ['#8b5cf6', '#3b82f6', '#10b981', '#f59e0b', '#ec4899'],
                            borderRadius: 6,
                            barThickness: 30
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        indexAxis: 'y',
                        plugins: { legend: { display: false } },
                        scales: {
                            x: { beginAtZero: true, grid: { display: false } },
                            y: { grid: { display: false } }
                        }
                    }
                });
            }

            async function loadTopVideos() {
                try {
                    const response = await fetch(`\${API_BASE}/videos/top?limit=10`);
                    const videos = await response.json();

                    if (!videos || videos.length === 0) return;

                    const maxViews = Math.max(...videos.map(v => v.totalViews));
                    // Stats are now calculated correctly in loadCategoryStats

                    const tbody = document.getElementById('topVideosBody');
                    tbody.innerHTML = videos.map((v, i) => {
                        const rankClass = i === 0 ? 'gold' : i === 1 ? 'silver' : i === 2 ? 'bronze' : 'normal';
                        const barWidth = (v.totalViews / maxViews * 100).toFixed(0);
                        return `
                        <tr>
                            <td><div class="rank-badge \${rankClass}">\${i + 1}</div></td>
                            <td>
                                <div class="video-info">
                                    <span class="video-id">\${v.videoId}</span>
                                </div>
                            </td>
                            <td>
                                <div class="views-cell">
                                    <span>\${v.totalViews}</span>
                                    <div class="views-bar"><div class="views-bar-fill" style="width: \${barWidth}%"></div></div>
                                </div>
                            </td>
                            <td>\${v.avgDuration ? v.avgDuration.toFixed(1) : '0'}s</td>
                        </tr>
                    `;
                    }).join('');
                } catch (e) {
                    console.error('Error:', e);
                }
            }

            async function loadCategoryStats() {
                try {
                    const response = await fetch(`\${API_BASE}/categories/stats`);
                    const stats = await response.json();

                    const labels = Object.keys(stats);
                    const data = labels.map(k => stats[k].videoCount || 0);

                    // Calculate correct totals from all categories
                    let totalViews = 0;
                    let totalDuration = 0;
                    let totalVideos = 0;
                    labels.forEach(k => {
                        totalViews += stats[k].totalViews || 0;
                        totalDuration += (stats[k].avgDuration || 0) * (stats[k].videoCount || 0);
                        totalVideos += stats[k].videoCount || 0;
                    });
                    document.getElementById('totalViews').textContent = totalViews.toLocaleString();
                    document.getElementById('avgDuration').textContent = (totalVideos > 0 ? (totalDuration / totalVideos).toFixed(0) : 0) + 's';

                    if (labels.length > 0) {
                        categoryChart.data.labels = labels;
                        categoryChart.data.datasets[0].data = data;
                        categoryChart.data.datasets[0].backgroundColor = [
                            '#8b5cf6', '#3b82f6', '#10b981', '#f59e0b', '#ec4899', '#ef4444'
                        ];
                        categoryChart.update('none');
                    }
                } catch (e) { console.error('Category stats error:', e); }
            }

            function connectSSE() {
                const evtSource = new EventSource(`\${API_BASE}/realtime/stream`);
                const feed = document.getElementById('liveFeed');

                evtSource.addEventListener('stats-update', function (event) {
                    try {
                        const data = JSON.parse(event.data);
                        const icons = { WATCH: 'play', PAUSE: 'pause', STOP: 'stop', RESUME: 'redo' };
                        const iconClass = icons[data.action] || 'play';

                        const item = document.createElement('div');
                        item.className = 'feed-item';
                        item.innerHTML = `
                        <div class="feed-icon \${iconClass}">
                            <i class="fas fa-\${iconClass === 'play' ? 'play' : iconClass === 'pause' ? 'pause' : 'stop'}"></i>
                        </div>
                        <div class="feed-content">
                            <div class="feed-title">\${data.topVideos ? data.topVideos.length + ' vidéos mises à jour' : 'Mise à jour reçue'}</div>
                            <div class="feed-meta">Événement SSE</div>
                        </div>
                        <div class="feed-time">\${new Date().toLocaleTimeString()}</div>
                    `;
                        feed.prepend(item);

                        while (feed.children.length > 8) {
                            feed.removeChild(feed.lastChild);
                        }
                    } catch (e) { }
                });
            }

            async function loadActionStats() {
                try {
                    const response = await fetch(`\${API_BASE}/events/stats/actions`);
                    const stats = await response.json();

                    const actionOrder = ['WATCH', 'PAUSE', 'SEEK', 'STOP', 'RESUME'];
                    const labels = actionOrder.filter(a => stats[a] !== undefined);
                    const data = labels.map(a => stats[a] || 0);

                    if (labels.length > 0) {
                        actionsChart.data.labels = labels;
                        actionsChart.data.datasets[0].data = data;
                        actionsChart.update('none');
                    }
                } catch (e) { console.error('Action stats error:', e); }
            }

            async function loadDeviceStats() {
                try {
                    const response = await fetch(`\${API_BASE}/events/stats/devices`);
                    const stats = await response.json();

                    const deviceOrder = ['desktop', 'mobile', 'tablet', 'tv', 'console'];
                    const labels = deviceOrder.filter(d => stats[d] !== undefined);
                    const data = labels.map(d => stats[d] || 0);

                    if (labels.length > 0) {
                        deviceChart.data.labels = labels.map(d => d.charAt(0).toUpperCase() + d.slice(1));
                        deviceChart.data.datasets[0].data = data;
                        deviceChart.update('none');
                    }
                } catch (e) { console.error('Device stats error:', e); }
            }

            async function loadGlobalStats() {
                try {
                    const response = await fetch(`\${API_BASE}/stats/global`);
                    const stats = await response.json();

                    document.getElementById('totalEvents').textContent = (stats.totalEvents || 0).toLocaleString();
                    document.getElementById('totalVideos').textContent = (stats.totalVideos || 0).toLocaleString();
                } catch (e) { console.error('Global stats error:', e); }
            }

            document.addEventListener('DOMContentLoaded', function () {
                initCharts();
                loadTopVideos();
                loadCategoryStats();
                loadActionStats();
                loadDeviceStats();
                loadGlobalStats();
                connectSSE();
                loadYoutubeTrending();

                setInterval(loadTopVideos, 5000);
                setInterval(loadCategoryStats, 30000);
                setInterval(loadActionStats, 30000);
                setInterval(loadDeviceStats, 30000);
            });

            // YouTube Trending Function
            async function loadYoutubeTrending() {
                try {
                    var region = document.getElementById('youtubeRegion').value || 'MA';
                    const response = await fetch(API_BASE + '/youtube/trending?limit=8&region=' + region);
                    const videos = await response.json();

                    const container = document.getElementById('youtubeTrendingContainer');

                    if (!videos || videos.length === 0) {
                        container.innerHTML = '<div style="text-align: center; color: var(--text-secondary); padding: 40px;">Aucune vidéo tendance disponible</div>';
                        return;
                    }

                    container.innerHTML = videos.map(function (video) {
                        var viewCount = video.viewCount || 0;
                        var formattedViews = viewCount >= 1000000
                            ? (viewCount / 1000000).toFixed(1) + 'M'
                            : viewCount >= 1000
                                ? (viewCount / 1000).toFixed(0) + 'K'
                                : viewCount;

                        return '<div style="background: var(--bg-secondary); border-radius: 12px; overflow: hidden; border: 1px solid var(--border-color); transition: transform 0.2s;" onmouseover="this.style.transform=\'translateY(-4px)\'" onmouseout="this.style.transform=\'translateY(0)\'">' +
                            '<a href="https://www.youtube.com/watch?v=' + (video.youtubeId || '') + '" target="_blank" style="text-decoration: none; color: inherit;">' +
                            '<div style="position: relative;">' +
                            '<img src="' + (video.thumbnail || 'https://via.placeholder.com/320x180?text=YouTube') + '" alt="' + (video.title || 'Video').substring(0, 30) + '" style="width: 100%; height: 160px; object-fit: cover;">' +
                            '<div style="position: absolute; bottom: 8px; right: 8px; background: rgba(0,0,0,0.8); color: white; padding: 2px 6px; border-radius: 4px; font-size: 12px;">' +
                            '<i class="fas fa-eye"></i> ' + formattedViews +
                            '</div>' +
                            '</div>' +
                            '<div style="padding: 12px;">' +
                            '<h4 style="font-size: 14px; margin-bottom: 6px; line-height: 1.3; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">' + (video.title || 'Sans titre').substring(0, 60) + '</h4>' +
                            '<p style="font-size: 12px; color: var(--text-secondary);"><i class="fas fa-user"></i> ' + (video.channelTitle || 'Chaîne inconnue') + '</p>' +
                            '</div>' +
                            '</a>' +
                            '</div>';
                    }).join('');
                } catch (e) {
                    console.error('Erreur YouTube:', e);
                    document.getElementById('youtubeTrendingContainer').innerHTML = '<div style="text-align: center; color: #ef4444; padding: 40px;"><i class="fas fa-exclamation-triangle"></i> Erreur de chargement YouTube API</div>';
                }
            }
        </script>
    </body>

    </html>