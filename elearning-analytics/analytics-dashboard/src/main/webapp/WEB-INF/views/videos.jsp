<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Videos - E-Learning Analytics</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
        <style>
            .videos-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 1.5rem;
            }

            .video-card {
                background: var(--bg-card);
                border-radius: var(--radius-md);
                overflow: hidden;
                box-shadow: var(--shadow-sm);
                transition: all 0.2s ease;
            }

            .video-card:hover {
                transform: translateY(-4px);
                box-shadow: var(--shadow-lg);
            }

            .video-thumbnail {
                position: relative;
                width: 100%;
                height: 180px;
                background: #000;
            }

            .video-thumbnail img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .video-duration {
                position: absolute;
                bottom: 8px;
                right: 8px;
                background: rgba(0, 0, 0, 0.8);
                color: white;
                padding: 0.25rem 0.5rem;
                border-radius: 4px;
                font-size: 0.75rem;
            }

            .video-content {
                padding: 1.25rem;
            }

            .video-title {
                font-weight: 600;
                font-size: 1rem;
                margin-bottom: 0.5rem;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .video-stats {
                display: flex;
                gap: 1rem;
                margin-top: 0.75rem;
                font-size: 0.85rem;
                color: var(--text-secondary);
            }

            .video-stats span {
                display: flex;
                align-items: center;
                gap: 0.25rem;
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
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/videos"
                        class="nav-link active"><i class="fab fa-youtube"></i><span>Videos</span></a></li>
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
                <h1 class="page-title"><i class="fab fa-youtube" style="color:#ff0000;"></i> Video Lessons</h1>
            </div>

            <div class="videos-grid" id="videosGrid">Loading...</div>
        </main>

        <script>
            var API_BASE = 'http://localhost:8080/analytics-api/api/v1/analytics';

            function loadVideos() {
                fetch(API_BASE + '/videos/trending?limit=20')
                    .then(function (r) { return r.json(); })
                    .then(function (videos) {
                        var grid = document.getElementById('videosGrid');
                        if (videos.length === 0) {
                            grid.innerHTML = '<p style="color:#718096;text-align:center;padding:2rem;">No videos available</p>';
                            return;
                        }
                        grid.innerHTML = videos.map(function (v) {
                            return '<div class="video-card">' +
                                '<div class="video-thumbnail">' +
                                '<img src="' + (v.thumbnailUrl || 'https://via.placeholder.com/320x180/ff0000/ffffff?text=Video') + '" alt="' + (v.title || '') + '" onerror="this.src=\'https://via.placeholder.com/320x180/ff0000/ffffff?text=Video\'">' +
                                '</div>' +
                                '<div class="video-content">' +
                                '<div class="video-title">' + (v.title || 'Untitled Video') + '</div>' +
                                '<div class="video-stats">' +
                                '<span><i class="fas fa-eye"></i> ' + formatNumber(v.viewCount || 0) + '</span>' +
                                '<span><i class="fas fa-thumbs-up"></i> ' + formatNumber(v.likeCount || 0) + '</span>' +
                                '<span><i class="fas fa-comment"></i> ' + formatNumber(v.commentCount || 0) + '</span>' +
                                '</div></div></div>';
                        }).join('');
                    })
                    .catch(function () { document.getElementById('videosGrid').innerHTML = '<p>Error loading videos</p>'; });
            }

            function formatNumber(n) {
                if (n >= 1000000) return (n / 1000000).toFixed(1) + 'M';
                if (n >= 1000) return (n / 1000).toFixed(1) + 'K';
                return n;
            }

            document.addEventListener('DOMContentLoaded', loadVideos);
        </script>
    </body>

    </html>