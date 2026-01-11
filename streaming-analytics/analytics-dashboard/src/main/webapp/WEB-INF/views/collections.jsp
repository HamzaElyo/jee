<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Collections - Streaming Analytics</title>
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

            .collection-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
            }

            .collection-card {
                background: var(--bg-secondary);
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 24px;
                transition: all 0.2s;
            }

            .collection-card:hover {
                border-color: var(--accent-purple);
            }

            .collection-icon {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                background: rgba(139, 92, 246, 0.15);
                color: var(--accent-purple);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
                margin-bottom: 16px;
            }

            .collection-name {
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 8px;
            }

            .collection-count {
                font-size: 2rem;
                font-weight: 700;
                color: var(--accent-blue);
                margin-bottom: 8px;
            }

            .collection-label {
                font-size: 0.85rem;
                color: var(--text-secondary);
            }

            .collection-fields {
                margin-top: 16px;
                padding-top: 16px;
                border-top: 1px solid var(--border-color);
            }

            .field-tag {
                display: inline-block;
                padding: 4px 8px;
                margin: 4px;
                background: var(--bg-card);
                border-radius: 4px;
                font-size: 0.75rem;
                font-family: monospace;
                color: var(--accent-green);
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
                    <a href="dashboard?page=collections" class="nav-item active"><i class="fas fa-database"></i>
                        Collections</a>
                    <a href="dashboard?page=events" class="nav-item"><i class="fas fa-stream"></i> Événements</a>
                    <a href="dashboard?page=settings" class="nav-item"><i class="fas fa-cog"></i> Paramètres</a>
                </div>
            </aside>

            <main class="main">
                <div class="header">
                    <h1><i class="fas fa-database"
                            style="color: var(--accent-purple); margin-right: 12px;"></i>Collections MongoDB</h1>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-layer-group"></i> Collections Disponibles</h3>
                    </div>
                    <div class="collection-grid" id="collectionGrid">
                        <div class="collection-card">
                            <div class="collection-icon"><i class="fas fa-film"></i></div>
                            <div class="collection-name">Video</div>
                            <div class="collection-count" id="videoCount">-</div>
                            <div class="collection-label">documents</div>
                            <div class="collection-fields">
                                <span class="field-tag">videoId</span>
                                <span class="field-tag">title</span>
                                <span class="field-tag">category</span>
                                <span class="field-tag">duration</span>
                                <span class="field-tag">uploadDate</span>
                                <span class="field-tag">views</span>
                                <span class="field-tag">likes</span>
                            </div>
                        </div>

                        <div class="collection-card">
                            <div class="collection-icon"
                                style="background: rgba(16, 185, 129, 0.15); color: var(--accent-green);"><i
                                    class="fas fa-stream"></i></div>
                            <div class="collection-name">events</div>
                            <div class="collection-count" id="eventCount">-</div>
                            <div class="collection-label">documents</div>
                            <div class="collection-fields">
                                <span class="field-tag">eventId</span>
                                <span class="field-tag">userId</span>
                                <span class="field-tag">videoId</span>
                                <span class="field-tag">timestamp</span>
                                <span class="field-tag">action</span>
                                <span class="field-tag">duration</span>
                                <span class="field-tag">quality</span>
                                <span class="field-tag">deviceType</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-info-circle"></i> Informations Base de Données</h3>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
                        <div style="text-align: center; padding: 20px;">
                            <div style="font-size: 1.5rem; font-weight: 700; color: var(--accent-purple);">
                                streaming_analytics</div>
                            <div style="color: var(--text-secondary); font-size: 0.85rem;">Nom de la base</div>
                        </div>
                        <div style="text-align: center; padding: 20px;">
                            <div style="font-size: 1.5rem; font-weight: 700; color: var(--accent-blue);">2</div>
                            <div style="color: var(--text-secondary); font-size: 0.85rem;">Collections</div>
                        </div>
                        <div style="text-align: center; padding: 20px;">
                            <div style="font-size: 1.5rem; font-weight: 700; color: var(--accent-green);">MongoDB</div>
                            <div style="color: var(--text-secondary); font-size: 0.85rem;">Type de base</div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script>
            const API_BASE = '/analytics_api_war_exploded/api/v1/analytics';

            async function loadStats() {
                try {
                    const response = await fetch(API_BASE + '/stats/global');
                    const stats = await response.json();
                    document.getElementById('videoCount').textContent = (stats.totalVideos || 0).toLocaleString();
                    document.getElementById('eventCount').textContent = (stats.totalEvents || 0).toLocaleString();
                } catch (e) {
                    console.error('Error loading stats:', e);
                }
            }

            document.addEventListener('DOMContentLoaded', loadStats);
        </script>
    </body>

    </html>