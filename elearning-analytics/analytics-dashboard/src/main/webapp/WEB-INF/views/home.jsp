<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - E-Learning Analytics</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>

    <body>
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <i class="fas fa-graduation-cap"></i>
                    <span>EduAnalytics</span>
                </div>
            </div>

            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
                        <i class="fas fa-home"></i><span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/courses" class="nav-link">
                        <i class="fas fa-book"></i><span>Courses</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/videos" class="nav-link">
                        <i class="fab fa-youtube"></i><span>Videos</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/students" class="nav-link">
                        <i class="fas fa-users"></i><span>Students</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/predictions" class="nav-link">
                        <i class="fas fa-chart-line"></i><span>Risk Analysis</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/analytics" class="nav-link">
                        <i class="fas fa-chart-bar"></i><span>Analytics</span>
                    </a>
                </li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1 class="page-title"><i class="fas fa-tachometer-alt"></i> Dashboard Overview</h1>
                <button class="btn btn-primary" onclick="refreshData()">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="fas fa-book"></i></div>
                    <div class="stat-content">
                        <div class="stat-value" id="coursesCount">-</div>
                        <div class="stat-label">Total Courses</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange"><i class="fab fa-youtube"></i></div>
                    <div class="stat-content">
                        <div class="stat-value" id="videosCount">-</div>
                        <div class="stat-label">Video Lessons</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fas fa-user-graduate"></i></div>
                    <div class="stat-content">
                        <div class="stat-value" id="studentsCount">-</div>
                        <div class="stat-label">Active Students</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon purple"><i class="fas fa-mouse-pointer"></i></div>
                    <div class="stat-content">
                        <div class="stat-value" id="eventsCount">-</div>
                        <div class="stat-label">Learning Events</div>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="grid-2" style="margin-bottom: 1.5rem;">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-chart-pie"></i> Student Results</h3>
                    </div>
                    <div style="height: 280px;">
                        <canvas id="resultsChart"></canvas>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-chart-bar"></i> Weekly Activity</h3>
                    </div>
                    <div style="height: 280px;">
                        <canvas id="activityChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Recent Activity & Top Courses -->
            <div class="grid-2">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-clock"></i> Recent Events</h3>
                    </div>
                    <div id="recentEvents" style="max-height: 300px; overflow-y: auto;">Loading...</div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-star"></i> Top Courses</h3>
                    </div>
                    <div id="topCourses" style="max-height: 300px; overflow-y: auto;">Loading...</div>
                </div>
            </div>
        </main>

        <script>
            var API_BASE = 'http://localhost:8080/analytics-api/api/v1/analytics';

            function formatNumber(n) {
                if (n >= 1000000) return (n / 1000000).toFixed(1) + 'M';
                if (n >= 1000) return (n / 1000).toFixed(1) + 'K';
                return n;
            }

            function loadGlobalStats() {
                fetch(API_BASE + '/stats/global')
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        document.getElementById('coursesCount').textContent = formatNumber(data.coursesCount || 0);
                        document.getElementById('videosCount').textContent = formatNumber(data.videosCount || 0);
                        document.getElementById('studentsCount').textContent = formatNumber(data.studentsCount || 0);
                        document.getElementById('eventsCount').textContent = formatNumber(data.eventsCount || 0);
                    })
                    .catch(function (e) { console.error('Error loading stats:', e); });
            }

            function loadResultsChart() {
                fetch(API_BASE + '/students/stats/results')
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        new Chart(document.getElementById('resultsChart'), {
                            type: 'doughnut',
                            data: {
                                labels: data.map(function (d) { return d._id || 'Unknown'; }),
                                datasets: [{
                                    data: data.map(function (d) { return d.count; }),
                                    backgroundColor: ['#00c853', '#1e88e5', '#ff5252', '#ffab00'],
                                    borderWidth: 0
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { position: 'right' } }
                            }
                        });
                    });
            }

            function loadActivityChart() {
                fetch(API_BASE + '/events/stats/activities')
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        new Chart(document.getElementById('activityChart'), {
                            type: 'bar',
                            data: {
                                labels: data.slice(0, 7).map(function (d) { return d._id || 'Unknown'; }),
                                datasets: [{
                                    label: 'Events',
                                    data: data.slice(0, 7).map(function (d) { return d.count; }),
                                    backgroundColor: '#1e88e5',
                                    borderRadius: 4
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { display: false } },
                                scales: {
                                    y: { beginAtZero: true, grid: { color: '#e2e8f0' } },
                                    x: { grid: { display: false } }
                                }
                            }
                        });
                    });
            }

            function loadRecentEvents() {
                fetch(API_BASE + '/events/recent?limit=5')
                    .then(function (r) { return r.json(); })
                    .then(function (events) {
                        var container = document.getElementById('recentEvents');
                        if (events.length === 0) {
                            container.innerHTML = '<p style="color:#718096;text-align:center;padding:2rem;">No recent events</p>';
                            return;
                        }
                        container.innerHTML = events.map(function (e) {
                            return '<div style="display:flex;align-items:center;gap:1rem;padding:0.75rem 0;border-bottom:1px solid #e2e8f0;">' +
                                '<div style="width:40px;height:40px;border-radius:8px;background:linear-gradient(135deg,#1e88e5,#42a5f5);display:flex;align-items:center;justify-content:center;color:white;"><i class="fas fa-mouse-pointer"></i></div>' +
                                '<div style="flex:1;"><div style="font-weight:500;">' + (e.activityType || 'Activity') + '</div>' +
                                '<div style="font-size:0.8rem;color:#718096;">Student: ' + (e.studentId || 'N/A') + '</div></div>' +
                                '<div style="font-size:0.8rem;color:#718096;">' + (e.sumClick || 0) + ' clicks</div></div>';
                        }).join('');
                    });
            }

            function loadTopCourses() {
                fetch(API_BASE + '/courses/top?limit=5')
                    .then(function (r) { return r.json(); })
                    .then(function (courses) {
                        var container = document.getElementById('topCourses');
                        if (courses.length === 0) {
                            container.innerHTML = '<p style="color:#718096;text-align:center;padding:2rem;">No courses available</p>';
                            return;
                        }
                        container.innerHTML = courses.map(function (c, i) {
                            return '<div style="display:flex;align-items:center;gap:1rem;padding:0.75rem 0;border-bottom:1px solid #e2e8f0;">' +
                                '<div style="width:32px;height:32px;border-radius:50%;background:' + (i < 3 ? '#1e88e5' : '#e2e8f0') + ';color:' + (i < 3 ? 'white' : '#718096') + ';display:flex;align-items:center;justify-content:center;font-weight:600;font-size:0.8rem;">' + (i + 1) + '</div>' +
                                '<div style="flex:1;"><div style="font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:200px;">' + (c.title || 'Untitled') + '</div>' +
                                '<div style="font-size:0.8rem;color:#718096;">' + (c.category || 'General') + '</div></div>' +
                                '<span class="badge badge-primary">' + formatNumber(c.students || 0) + ' students</span></div>';
                        }).join('');
                    });
            }

            function refreshData() {
                loadGlobalStats();
                loadRecentEvents();
                loadTopCourses();
            }

            document.addEventListener('DOMContentLoaded', function () {
                loadGlobalStats();
                loadResultsChart();
                loadActivityChart();
                loadRecentEvents();
                loadTopCourses();
            });
        </script>
    </body>

    </html>