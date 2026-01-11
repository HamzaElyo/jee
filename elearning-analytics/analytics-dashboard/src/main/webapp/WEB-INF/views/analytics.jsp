<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Analytics - E-Learning Analytics</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .charts-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 1.5rem;
            }

            .chart-card {
                background: var(--bg-card);
                border-radius: var(--radius-md);
                padding: 1.5rem;
                box-shadow: var(--shadow-sm);
            }

            .chart-card h3 {
                margin-bottom: 1rem;
                font-size: 1rem;
                color: var(--text-primary);
            }

            .chart-container {
                height: 300px;
            }
        </style>
    </head>

    <body>
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo"><i class="fas fa-graduation-cap"></i><span>EduAnalytics</span></div>
            </div>
            <ul class="nav-menu">
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" class="nav-link"><i
                            class="fas fa-home"></i><span>Dashboard</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/courses" class="nav-link"><i
                            class="fas fa-book"></i><span>Courses</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/videos" class="nav-link"><i
                            class="fab fa-youtube"></i><span>Videos</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/students" class="nav-link"><i
                            class="fas fa-users"></i><span>Students</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/predictions"
                        class="nav-link"><i class="fas fa-chart-line"></i><span>Risk Analysis</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/analytics"
                        class="nav-link active"><i class="fas fa-chart-bar"></i><span>Analytics</span></a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1 class="page-title"><i class="fas fa-chart-bar"></i> Analytics</h1>
            </div>

            <div class="charts-grid">
                <div class="chart-card">
                    <h3><i class="fas fa-trophy" style="color:#ffd700;"></i> Student Results Distribution</h3>
                    <div class="chart-container"><canvas id="resultsChart"></canvas></div>
                </div>
                <div class="chart-card">
                    <h3><i class="fas fa-tasks" style="color:#1e88e5;"></i> Activity Types</h3>
                    <div class="chart-container"><canvas id="activityChart"></canvas></div>
                </div>
                <div class="chart-card">
                    <h3><i class="fas fa-globe" style="color:#26c6da;"></i> Students by Region</h3>
                    <div class="chart-container"><canvas id="regionChart"></canvas></div>
                </div>
                <div class="chart-card">
                    <h3><i class="fas fa-layer-group" style="color:#7c4dff;"></i> Courses by Category</h3>
                    <div class="chart-container"><canvas id="categoryChart"></canvas></div>
                </div>
            </div>
        </main>

        <script>
            var API_BASE = 'http://localhost:8080/analytics-api/api/v1/analytics';
            var chartColors = ['#1e88e5', '#00c853', '#ff5252', '#ffab00', '#7c4dff', '#26c6da', '#ff6d00', '#9c27b0'];

            function loadCharts() {
                // Results Chart
                fetch(API_BASE + '/students/stats/results')
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        new Chart(document.getElementById('resultsChart'), {
                            type: 'doughnut',
                            data: {
                                labels: data.map(function (d) { return d._id || 'Unknown'; }),
                                datasets: [{ data: data.map(function (d) { return d.count; }), backgroundColor: ['#00c853', '#1e88e5', '#ff5252', '#ffab00'], borderWidth: 0 }]
                            },
                            options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'right' } } }
                        });
                    });

                // Activity Chart
                fetch(API_BASE + '/events/stats/activities')
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        new Chart(document.getElementById('activityChart'), {
                            type: 'bar',
                            data: {
                                labels: data.map(function (d) { return d._id || 'Unknown'; }),
                                datasets: [{ data: data.map(function (d) { return d.count; }), backgroundColor: '#1e88e5', borderRadius: 4 }]
                            },
                            options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
                        });
                    });

                // Region Chart
                fetch(API_BASE + '/students/stats/regions')
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        new Chart(document.getElementById('regionChart'), {
                            type: 'bar',
                            data: {
                                labels: data.slice(0, 8).map(function (d) { return d._id || 'Unknown'; }),
                                datasets: [{ data: data.slice(0, 8).map(function (d) { return d.count; }), backgroundColor: '#26c6da', borderRadius: 4 }]
                            },
                            options: { indexAxis: 'y', responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
                        });
                    });

                // Category Chart
                fetch(API_BASE + '/categories/stats')
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        new Chart(document.getElementById('categoryChart'), {
                            type: 'pie',
                            data: {
                                labels: data.map(function (d) { return d._id || 'Unknown'; }),
                                datasets: [{ data: data.map(function (d) { return d.count; }), backgroundColor: chartColors, borderWidth: 0 }]
                            },
                            options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'right' } } }
                        });
                    });
            }

            document.addEventListener('DOMContentLoaded', loadCharts);
        </script>
    </body>

    </html>