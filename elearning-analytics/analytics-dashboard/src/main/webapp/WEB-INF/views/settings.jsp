<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <title>Settings - E-Learning Analytics</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary: #5e35b1;
                --secondary: #00bfa5;
                --success: #00c853;
                --danger: #ff1744;
                --bg-dark: #1a1a2e;
                --bg-card: #16213e;
                --text-primary: #ffffff;
                --text-secondary: #b0b8c8;
                --border: #2a3f5f;
                --gradient-primary: linear-gradient(135deg, #5e35b1 0%, #7c4dff 100%);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: var(--bg-dark);
                color: var(--text-primary);
                min-height: 100vh;
                padding: 2rem;
                margin-left: 270px;
            }

            .header {
                margin-bottom: 2rem;
            }

            .header h1 {
                font-size: 1.875rem;
                font-weight: 700;
                background: var(--gradient-primary);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .settings-card {
                background: var(--bg-card);
                border-radius: 1rem;
                padding: 1.75rem;
                border: 1px solid var(--border);
                margin-bottom: 1.5rem;
                max-width: 700px;
            }

            .settings-card h3 {
                margin-bottom: 1.25rem;
                font-size: 1.1rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .settings-card h3 i {
                color: var(--primary);
            }

            .status-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 1rem;
            }

            .status-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 1rem;
                background: var(--bg-dark);
                border-radius: 0.75rem;
            }

            .status-dot {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                flex-shrink: 0;
            }

            .status-dot.online {
                background: var(--success);
                box-shadow: 0 0 8px var(--success);
            }

            .status-dot.offline {
                background: var(--danger);
            }

            .config-item {
                display: flex;
                justify-content: space-between;
                padding: 1rem 0;
                border-bottom: 1px solid var(--border);
            }

            .config-item:last-child {
                border: none;
            }

            .config-label {
                color: var(--text-secondary);
            }

            .config-value {
                font-weight: 500;
                font-family: monospace;
                font-size: 0.9rem;
            }

            .btn {
                padding: 0.875rem 1.75rem;
                background: var(--gradient-primary);
                color: white;
                border: none;
                border-radius: 0.75rem;
                cursor: pointer;
                font-weight: 600;
                margin-top: 1rem;
                transition: all 0.3s;
                box-shadow: 0 4px 15px rgba(94, 53, 177, 0.3);
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(94, 53, 177, 0.4);
            }

            .back-link {
                color: var(--secondary);
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 1.5rem;
                font-weight: 500;
                transition: all 0.2s;
            }

            .back-link:hover {
                color: var(--text-primary);
                transform: translateX(-4px);
            }
        </style>
    </head>

    <body>
        <a href="${pageContext.request.contextPath}/dashboard" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        <div class="header">
            <h1><i class="fas fa-cog"></i> Settings</h1>
        </div>

        <div class="settings-card">
            <h3><i class="fas fa-server"></i> Service Status</h3>
            <div class="status-grid">
                <div class="status-item">
                    <span class="status-dot" id="apiStatus"></span>
                    <span>Analytics API</span>
                </div>
                <div class="status-item">
                    <span class="status-dot" id="mongoStatus"></span>
                    <span>MongoDB</span>
                </div>
                <div class="status-item">
                    <span class="status-dot" id="sseStatus"></span>
                    <span>SSE Stream</span>
                </div>
            </div>
            <button class="btn" onclick="checkStatus()">
                <i class="fas fa-sync"></i> Check Status
            </button>
        </div>

        <div class="settings-card">
            <h3><i class="fas fa-plug"></i> API Configuration</h3>
            <div class="config-item">
                <span class="config-label">API Base URL</span>
                <span class="config-value">http://localhost:8080/analytics-api/api/v1</span>
            </div>
            <div class="config-item">
                <span class="config-label">MongoDB Database</span>
                <span class="config-value">elearning_analytics</span>
            </div>
            <div class="config-item">
                <span class="config-label">SSE Endpoint</span>
                <span class="config-value">/realtime/stream</span>
            </div>
        </div>

        <div class="settings-card">
            <h3><i class="fas fa-database"></i> Data Sources</h3>
            <div class="config-item">
                <span class="config-label">RapidAPI (Udemy)</span>
                <span class="config-value" style="color: var(--success);">Configured</span>
            </div>
            <div class="config-item">
                <span class="config-label">YouTube Data API</span>
                <span class="config-value" style="color: var(--success);">Configured</span>
            </div>
            <div class="config-item">
                <span class="config-label">OULAD Dataset</span>
                <span class="config-value">Local CSV</span>
            </div>
        </div>

        <script>
            function checkStatus() {
                fetch('http://localhost:8080/analytics-api/api/v1/analytics/stats/global')
                    .then(function (res) {
                        document.getElementById('apiStatus').className = 'status-dot ' + (res.ok ? 'online' : 'offline');
                        document.getElementById('mongoStatus').className = 'status-dot ' + (res.ok ? 'online' : 'offline');
                    })
                    .catch(function () {
                        document.getElementById('apiStatus').className = 'status-dot offline';
                        document.getElementById('mongoStatus').className = 'status-dot offline';
                    });

                try {
                    var evtSource = new EventSource('http://localhost:8080/analytics-api/api/v1/realtime/stream');
                    evtSource.onopen = function () {
                        document.getElementById('sseStatus').className = 'status-dot online';
                        evtSource.close();
                    };
                    evtSource.onerror = function () {
                        document.getElementById('sseStatus').className = 'status-dot offline';
                        evtSource.close();
                    };
                } catch (e) {
                    document.getElementById('sseStatus').className = 'status-dot offline';
                }
            }

            document.addEventListener('DOMContentLoaded', checkStatus);
        </script>
    </body>

    </html>