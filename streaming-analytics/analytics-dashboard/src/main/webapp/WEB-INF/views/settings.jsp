<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Paramètres - Streaming Analytics</title>
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

            .setting-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 16px 0;
                border-bottom: 1px solid var(--border-color);
            }

            .setting-item:last-child {
                border-bottom: none;
            }

            .setting-info h4 {
                margin-bottom: 4px;
            }

            .setting-info p {
                font-size: 0.85rem;
                color: var(--text-secondary);
            }

            .setting-value {
                font-family: monospace;
                background: var(--bg-secondary);
                padding: 8px 12px;
                border-radius: 6px;
                color: var(--accent-blue);
            }

            .status-indicator {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .status-dot {
                width: 10px;
                height: 10px;
                border-radius: 50%;
            }

            .status-dot.online {
                background: var(--accent-green);
            }

            .status-dot.offline {
                background: var(--accent-red);
            }

            .btn {
                padding: 10px 20px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.2s;
            }

            .btn-primary {
                background: var(--accent-purple);
                color: white;
            }

            .btn-primary:hover {
                opacity: 0.9;
            }

            .version-info {
                text-align: center;
                padding: 20px;
                color: var(--text-secondary);
                font-size: 0.85rem;
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
                    <a href="dashboard?page=events" class="nav-item"><i class="fas fa-stream"></i> Événements</a>
                    <a href="dashboard?page=settings" class="nav-item active"><i class="fas fa-cog"></i> Paramètres</a>
                </div>
            </aside>

            <main class="main">
                <div class="header">
                    <h1><i class="fas fa-cog" style="color: var(--accent-purple); margin-right: 12px;"></i>Paramètres
                    </h1>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-server"></i> Configuration API</h3>
                    </div>
                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>URL de l'API Analytics</h4>
                            <p>Endpoint de l'API REST pour les données</p>
                        </div>
                        <span class="setting-value">/analytics_api_war_exploded/api/v1/analytics</span>
                    </div>
                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>Base de données MongoDB</h4>
                            <p>Nom de la base de données utilisée</p>
                        </div>
                        <span class="setting-value">streaming_analytics</span>
                    </div>
                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>Hôte MongoDB</h4>
                            <p>Serveur de base de données</p>
                        </div>
                        <span class="setting-value">localhost:27017</span>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-heartbeat"></i> État des Services</h3>
                    </div>
                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>API Analytics</h4>
                            <p>Service REST principal</p>
                        </div>
                        <div class="status-indicator" id="apiStatus">
                            <span class="status-dot offline"></span>
                            <span>Vérification...</span>
                        </div>
                    </div>
                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>MongoDB</h4>
                            <p>Base de données</p>
                        </div>
                        <div class="status-indicator" id="dbStatus">
                            <span class="status-dot offline"></span>
                            <span>Vérification...</span>
                        </div>
                    </div>
                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>Flux SSE</h4>
                            <p>Streaming temps réel</p>
                        </div>
                        <div class="status-indicator" id="sseStatus">
                            <span class="status-dot offline"></span>
                            <span>Non connecté</span>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-sync-alt"></i> Actions</h3>
                    </div>
                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>Vérifier les connexions</h4>
                            <p>Tester la connectivité des services</p>
                        </div>
                        <button class="btn btn-primary" onclick="checkHealth()">
                            <i class="fas fa-check"></i> Vérifier
                        </button>
                    </div>
                </div>

                <div class="version-info">
                    <p>Streaming Analytics Dashboard v1.0</p>
                    <p>© 2024 - Big Data Analytics Platform TP</p>
                </div>
            </main>
        </div>

        <script>
            const API_BASE = '/analytics_api_war_exploded/api/v1/analytics';

            async function checkHealth() {
                // Check API
                try {
                    const response = await fetch(API_BASE + '/stats/global');
                    const data = await response.json();
                    if (data && data.totalEvents !== undefined) {
                        setStatus('apiStatus', true, 'Opérationnel');
                        setStatus('dbStatus', true, 'Connecté');
                        // Test SSE
                        testSSE();
                    } else {
                        setStatus('apiStatus', false, 'Erreur');
                    }
                } catch (e) {
                    setStatus('apiStatus', false, 'Hors ligne');
                    setStatus('dbStatus', false, 'Non accessible');
                }
            }

            function testSSE() {
                try {
                    const evtSource = new EventSource(API_BASE + '/realtime/stream');
                    evtSource.onopen = function () {
                        setStatus('sseStatus', true, 'Connecté');
                    };
                    evtSource.onerror = function () {
                        setStatus('sseStatus', false, 'Erreur');
                    };
                } catch (e) {
                    setStatus('sseStatus', false, 'Non disponible');
                }
            }

            function setStatus(id, online, text) {
                const el = document.getElementById(id);
                el.querySelector('.status-dot').className = 'status-dot ' + (online ? 'online' : 'offline');
                el.querySelector('span:last-child').textContent = text;
            }

            document.addEventListener('DOMContentLoaded', checkHealth);
        </script>
    </body>

    </html>