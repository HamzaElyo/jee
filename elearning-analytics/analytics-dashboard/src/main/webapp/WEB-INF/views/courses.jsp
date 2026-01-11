<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Courses - E-Learning Analytics</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
        <style>
            .courses-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 1.5rem;
            }

            .course-card {
                background: var(--bg-card);
                border-radius: var(--radius-md);
                overflow: hidden;
                box-shadow: var(--shadow-sm);
                transition: all 0.2s ease;
            }

            .course-card:hover {
                transform: translateY(-4px);
                box-shadow: var(--shadow-lg);
            }

            .course-image {
                width: 100%;
                height: 160px;
                object-fit: cover;
                background: linear-gradient(135deg, #1e88e5, #42a5f5);
            }

            .course-content {
                padding: 1.25rem;
            }

            .course-title {
                font-weight: 600;
                font-size: 1rem;
                margin-bottom: 0.5rem;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .course-meta {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 1rem;
                padding-top: 1rem;
                border-top: 1px solid var(--border);
            }

            .search-box {
                display: flex;
                gap: 0.75rem;
                margin-bottom: 2rem;
            }

            .search-box input {
                flex: 1;
                padding: 0.75rem 1rem;
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                font-size: 0.9rem;
            }

            .search-box input:focus {
                outline: none;
                border-color: var(--primary);
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
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/courses"
                        class="nav-link active"><i class="fas fa-book"></i><span>Courses</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/videos" class="nav-link"><i
                            class="fab fa-youtube"></i><span>Videos</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/students" class="nav-link"><i
                            class="fas fa-users"></i><span>Students</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/predictions"
                        class="nav-link"><i class="fas fa-chart-line"></i><span>Risk Analysis</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/analytics"
                        class="nav-link"><i class="fas fa-chart-bar"></i><span>Analytics</span></a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1 class="page-title"><i class="fas fa-book"></i> Courses</h1>
            </div>

            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search courses...">
                <button class="btn btn-primary" onclick="searchCourses()"><i class="fas fa-search"></i> Search</button>
            </div>

            <div class="courses-grid" id="coursesGrid">Loading...</div>
        </main>

        <script>
            var API_BASE = 'http://localhost:8080/analytics-api/api/v1/analytics';

            function loadTopCourses() {
                fetch(API_BASE + '/courses/top?limit=20')
                    .then(function (r) { return r.json(); })
                    .then(function (courses) { renderCourses(courses); })
                    .catch(function () { document.getElementById('coursesGrid').innerHTML = '<p>Error loading courses</p>'; });
            }

            function searchCourses() {
                var query = document.getElementById('searchInput').value;
                if (!query) { loadTopCourses(); return; }
                fetch(API_BASE + '/courses/search?q=' + encodeURIComponent(query))
                    .then(function (r) { return r.json(); })
                    .then(function (courses) { renderCourses(courses); });
            }

            function renderCourses(courses) {
                var grid = document.getElementById('coursesGrid');
                if (courses.length === 0) {
                    grid.innerHTML = '<p style="color:#718096;text-align:center;padding:2rem;">No courses found</p>';
                    return;
                }
                grid.innerHTML = courses.map(function (c) {
                    return '<div class="course-card">' +
                        '<img src="' + (c.imageUrl || 'https://via.placeholder.com/300x160/1e88e5/ffffff?text=Course') + '" alt="' + (c.title || '') + '" class="course-image" onerror="this.src=\'https://via.placeholder.com/300x160/1e88e5/ffffff?text=Course\'">' +
                        '<div class="course-content">' +
                        '<div class="course-title">' + (c.title || 'Untitled Course') + '</div>' +
                        '<span class="badge badge-primary">' + (c.category || 'General') + '</span>' +
                        '<div class="course-meta">' +
                        '<span style="color:#718096;font-size:0.85rem;"><i class="fas fa-users"></i> ' + formatNumber(c.students || 0) + '</span>' +
                        '<span style="color:#ffab00;font-size:0.85rem;"><i class="fas fa-star"></i> ' + (c.rating || 'N/A') + '</span>' +
                        '</div></div></div>';
                }).join('');
            }

            function formatNumber(n) { return n >= 1000 ? (n / 1000).toFixed(1) + 'K' : n; }

            document.getElementById('searchInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter') searchCourses();
            });

            document.addEventListener('DOMContentLoaded', loadTopCourses);
        </script>
    </body>

    </html>