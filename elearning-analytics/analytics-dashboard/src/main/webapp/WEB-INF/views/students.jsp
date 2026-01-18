<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Students - E-Learning Analytics</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
        <style>
            .leaderboard-item {
                display: flex;
                align-items: center;
                gap: 1rem;
                padding: 1rem;
                background: var(--bg-card);
                border-radius: var(--radius-sm);
                margin-bottom: 0.75rem;
                box-shadow: var(--shadow-sm);
                transition: all 0.2s;
            }

            .leaderboard-item:hover {
                transform: translateX(4px);
            }

            .rank {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                font-size: 0.9rem;
            }

            .rank.gold {
                background: linear-gradient(135deg, #ffd700, #ffb300);
                color: #1a1a2e;
            }

            .rank.silver {
                background: linear-gradient(135deg, #c0c0c0, #9e9e9e);
                color: #1a1a2e;
            }

            .rank.bronze {
                background: linear-gradient(135deg, #cd7f32, #a0522d);
                color: white;
            }

            .rank.normal {
                background: var(--bg-body);
                color: var(--text-secondary);
            }

            .filter-section {
                background: var(--bg-card);
                border-radius: var(--radius-md);
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: var(--shadow-sm);
            }

            .filter-row {
                display: flex;
                gap: 1rem;
                flex-wrap: wrap;
                align-items: flex-end;
            }

            .filter-group {
                flex: 1;
                min-width: 200px;
            }

            .filter-group label {
                display: block;
                margin-bottom: 0.5rem;
                font-size: 0.875rem;
                font-weight: 500;
                color: var(--text-secondary);
            }

            .filter-group select {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                background: var(--bg-card);
                color: var(--text-primary);
            }
        </style>
    </head>

    <body>
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
            <jsp:param name="activePage" value="students" />
        </jsp:include>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1 class="page-title"><i class="fas fa-users"></i> Students</h1>
            </div>

            <!-- Filters -->
            <div class="filter-section">
                <h3 style="margin-bottom:1rem;"><i class="fas fa-filter"></i> Advanced Filters</h3>
                <div class="filter-row">
                    <div class="filter-group">
                        <label>Region</label>
                        <select id="filterRegion">
                            <option value="">All Regions</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label>Final Result</label>
                        <select id="filterResult">
                            <option value="">All Results</option>
                        </select>
                    </div>
                    <button class="btn btn-primary" onclick="applyFilters()"><i class="fas fa-search"></i>
                        Apply</button>
                </div>
                <div id="filteredResults" style="margin-top:1rem;display:none;">
                    <h4 style="color:var(--primary);margin-bottom:0.75rem;">Filtered Students (<span
                            id="filteredCount">0</span>)</h4>
                    <div id="filteredList" style="max-height:250px;overflow-y:auto;"></div>
                </div>
            </div>

            <!-- Leaderboard -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-trophy" style="color:#ffd700;"></i> Top Learners by
                        Engagement</h3>
                </div>
                <div id="leaderboard">Loading...</div>
            </div>
        </main>

        <script>
            var API_BASE = 'http://localhost:8080/analytics-api/api/v1/analytics';

            function loadLeaderboard() {
                fetch(API_BASE + '/users/leaderboard?limit=15')
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        var container = document.getElementById('leaderboard');
                        if (data.length === 0) {
                            container.innerHTML = '<p style="color:#718096;text-align:center;padding:2rem;">No student data</p>';
                            return;
                        }
                        container.innerHTML = data.map(function (s, i) {
                            var rankClass = i === 0 ? 'gold' : i === 1 ? 'silver' : i === 2 ? 'bronze' : 'normal';
                            return '<div class="leaderboard-item">' +
                                '<span class="rank ' + rankClass + '">' + (i + 1) + '</span>' +
                                '<div style="flex:1;"><div style="font-weight:600;">' + (s._id || 'Unknown') + '</div>' +
                                '<div style="font-size:0.8rem;color:#718096;">' + formatNumber(s.eventCount || 0) + ' events</div></div>' +
                                '<span class="badge badge-primary">' + formatNumber(s.totalClicks || 0) + ' clicks</span></div>';
                        }).join('');
                    });
            }

            function loadFilterOptions() {
                fetch(API_BASE + '/filters/options')
                    .then(function (r) { return r.json(); })
                    .then(function (options) {
                        var regionSelect = document.getElementById('filterRegion');
                        var resultSelect = document.getElementById('filterResult');
                        if (options.regions) options.regions.forEach(function (r) { if (r) regionSelect.innerHTML += '<option value="' + r + '">' + r + '</option>'; });
                        if (options.results) options.results.forEach(function (r) { if (r) resultSelect.innerHTML += '<option value="' + r + '">' + r + '</option>'; });
                    });
            }

            function applyFilters() {
                var region = document.getElementById('filterRegion').value;
                var result = document.getElementById('filterResult').value;
                var url = API_BASE + '/students/filter?limit=30';
                if (region) url += '&region=' + encodeURIComponent(region);
                if (result) url += '&result=' + encodeURIComponent(result);

                fetch(url)
                    .then(function (r) { return r.json(); })
                    .then(function (students) {
                        document.getElementById('filteredResults').style.display = 'block';
                        document.getElementById('filteredCount').textContent = students.length;
                        var list = document.getElementById('filteredList');
                        if (students.length === 0) { list.innerHTML = '<p style="color:#718096;">No students found</p>'; return; }
                        list.innerHTML = students.map(function (s) {
                            var color = s.finalResult === 'Pass' ? '#00c853' : s.finalResult === 'Withdrawn' ? '#ff5252' : s.finalResult === 'Fail' ? '#ffab00' : '#718096';
                            return '<div style="display:flex;justify-content:space-between;padding:0.75rem;background:var(--bg-body);border-radius:6px;margin-bottom:0.5rem;">' +
                                '<span><strong>' + s.studentId + '</strong> - ' + (s.region || 'N/A') + '</span>' +
                                '<span style="color:' + color + ';font-weight:600;">' + (s.finalResult || 'Unknown') + '</span></div>';
                        }).join('');
                    });
            }

            function formatNumber(n) { return n >= 1000 ? (n / 1000).toFixed(1) + 'K' : n; }

            document.addEventListener('DOMContentLoaded', function () {
                loadLeaderboard();
                loadFilterOptions();
            });
        </script>
    </body>

    </html>