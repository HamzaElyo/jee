<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Événements - Streaming Analytics</title>
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

            .header-right {
                display: flex;
                align-items: center;
                gap: 12px;
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

            .filter-row {
                display: flex;
                gap: 12px;
                margin-bottom: 20px;
            }

            .filter-btn {
                padding: 8px 16px;
                background: var(--bg-secondary);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                color: var(--text-secondary);
                cursor: pointer;
                transition: all 0.2s;
            }

            .filter-btn:hover,
            .filter-btn.active {
                background: rgba(139, 92, 246, 0.15);
                border-color: var(--accent-purple);
                color: var(--accent-purple);
            }

            .events-list {
                max-height: 600px;
                overflow-y: auto;
            }

            .event-item {
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 16px;
                background: var(--bg-secondary);
                border-radius: 8px;
                margin-bottom: 8px;
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

            .event-icon {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .event-icon.play {
                background: rgba(16, 185, 129, 0.15);
                color: var(--accent-green);
            }

            .event-icon.pause {
                background: rgba(245, 158, 11, 0.15);
                color: var(--accent-orange);
            }

            .event-icon.stop {
                background: rgba(239, 68, 68, 0.15);
                color: var(--accent-red);
            }

            .event-icon.seek {
                background: rgba(59, 130, 246, 0.15);
                color: var(--accent-blue);
            }

            .event-content {
                flex: 1;
            }

            .event-action {
                font-weight: 600;
                margin-bottom: 4px;
            }

            .event-meta {
                font-size: 0.85rem;
                color: var(--text-secondary);
            }

            .event-time {
                font-size: 0.75rem;
                color: var(--text-secondary);
            }

            .event-badges {
                display: flex;
                gap: 8px;
            }

            .badge {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 0.7rem;
            }

            .badge-device {
                background: rgba(139, 92, 246, 0.15);
                color: var(--accent-purple);
            }

            .badge-quality {
                background: rgba(59, 130, 246, 0.15);
                color: var(--accent-blue);
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
                    <a href="dashboard?page=analytics" class="nav-item"><i class="fas fa-chart-bar"></i> Analytics</a>
                </div>
                <div class="nav-section">
                    <div class="nav-title">Données</div>
                    <a href="dashboard?page=collections" class="nav-item"><i class="fas fa-database"></i>
                        Collections</a>
                    <a href="dashboard?page=events" class="nav-item active"><i class="fas fa-stream"></i> Événements</a>
                    <a href="dashboard?page=settings" class="nav-item"><i class="fas fa-cog"></i> Paramètres</a>
                </div>
            </aside>

            <main class="main">
                <div class="header">
                    <h1><i class="fas fa-stream" style="color: var(--accent-purple); margin-right: 12px;"></i>Événements
                    </h1>
                    <div class="header-right">
                        <div class="status-badge">
                            <div class="status-dot"></div>
                            <span>En temps réel</span>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-filter"></i> Filtres</h3>
                    </div>
                    <div class="filter-row">
                        <button class="filter-btn active" data-filter="all">Tous</button>
                        <button class="filter-btn" data-filter="WATCH">WATCH</button>
                        <button class="filter-btn" data-filter="PAUSE">PAUSE</button>
                        <button class="filter-btn" data-filter="SEEK">SEEK</button>
                        <button class="filter-btn" data-filter="STOP">STOP</button>
                        <button class="filter-btn" data-filter="RESUME">RESUME</button>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-list"></i> Événements Récents</h3>
                        <span id="eventCount"
                            style="color: var(--text-secondary); font-size: 0.85rem;">Chargement...</span>
                    </div>
                    <div class="events-list" id="eventsList">
                        <div style="text-align: center; padding: 40px; color: var(--text-secondary);">Chargement des
                            événements...</div>
                    </div>
                </div>
            </main>
        </div>

        <script>
            const API_BASE = '/analytics_api_war_exploded/api/v1/analytics';
            var currentFilter = 'all';
            var allEvents = [];

            async function loadEvents() {
                try {
                    const response = await fetch(API_BASE + '/events/recent?limit=100');
                    allEvents = await response.json();
                    displayEvents();
                } catch (e) {
                    console.error('Error loading events:', e);
                    document.getElementById('eventsList').innerHTML = '<div style="text-align: center; padding: 40px; color: var(--text-secondary);">Erreur lors du chargement</div>';
                }
            }

            function displayEvents() {
                var filtered = currentFilter === 'all' ? allEvents : allEvents.filter(function (e) { return e.action === currentFilter; });
                document.getElementById('eventCount').textContent = filtered.length + ' événements';

                if (filtered.length === 0) {
                    document.getElementById('eventsList').innerHTML = '<div style="text-align: center; padding: 40px; color: var(--text-secondary);">Aucun événement</div>';
                    return;
                }

                document.getElementById('eventsList').innerHTML = filtered.map(function (e) {
                    var iconClass = (e.action || 'play').toLowerCase();
                    var iconMap = { WATCH: 'play', PAUSE: 'pause', STOP: 'stop', SEEK: 'forward', RESUME: 'redo' };
                    var icon = iconMap[e.action] || 'play';
                    var timestamp = e.timestamp || 'N/A';
                    return '<div class="event-item">' +
                        '<div class="event-icon ' + iconClass + '"><i class="fas fa-' + icon + '"></i></div>' +
                        '<div class="event-content">' +
                        '<div class="event-action">' + (e.action || 'N/A') + '</div>' +
                        '<div class="event-meta">User: ' + (e.userId || 'N/A') + ' - Video: ' + (e.videoId || 'N/A') + '</div>' +
                        '</div>' +
                        '<div class="event-badges">' +
                        '<span class="badge badge-device">' + (e.deviceType || 'N/A') + '</span>' +
                        '<span class="badge badge-quality">' + (e.quality || 'N/A') + '</span>' +
                        '</div>' +
                        '<div class="event-time">' + timestamp + '</div>' +
                        '</div>';
                }).join('');
            }

            document.querySelectorAll('.filter-btn').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    document.querySelectorAll('.filter-btn').forEach(function (b) { b.classList.remove('active'); });
                    this.classList.add('active');
                    currentFilter = this.dataset.filter;
                    displayEvents();
                });
            });

            document.addEventListener('DOMContentLoaded', function () {
                loadEvents();
                setInterval(loadEvents, 10000);
            });
        </script>
    </body>

    </html>