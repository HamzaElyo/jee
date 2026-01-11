<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Risk Analysis - E-Learning Analytics</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
        <style>
            .risk-stats {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 1rem;
                margin-bottom: 1.5rem;
            }

            .risk-stat {
                background: var(--bg-card);
                border-radius: var(--radius-md);
                padding: 1.25rem;
                text-align: center;
                box-shadow: var(--shadow-sm);
            }

            .risk-stat h4 {
                font-size: 0.8rem;
                color: var(--text-secondary);
                margin-bottom: 0.5rem;
            }

            .risk-stat .value {
                font-size: 2rem;
                font-weight: 700;
            }

            .risk-stat.critical .value {
                color: #ff5252;
            }

            .risk-stat.high .value {
                color: #ffab00;
            }

            .risk-stat.medium .value {
                color: #ffd54f;
            }

            .risk-stat.low .value {
                color: #00c853;
            }

            .score-bar {
                width: 80px;
                height: 8px;
                background: #e2e8f0;
                border-radius: 4px;
                overflow: hidden;
                display: inline-block;
                margin-right: 0.5rem;
            }

            .score-bar .fill {
                height: 100%;
                border-radius: 4px;
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
                        class="nav-link active"><i class="fas fa-chart-line"></i><span>Risk Analysis</span></a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard/analytics"
                        class="nav-link"><i class="fas fa-chart-bar"></i><span>Analytics</span></a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1 class="page-title"><i class="fas fa-exclamation-triangle" style="color:#ff5252;"></i> Students at
                    Risk</h1>
                <button class="btn btn-primary" onclick="loadStudents()"><i class="fas fa-sync-alt"></i>
                    Refresh</button>
            </div>

            <div class="risk-stats">
                <div class="risk-stat critical">
                    <h4>Critical Risk</h4>
                    <div class="value" id="criticalCount">0</div>
                </div>
                <div class="risk-stat high">
                    <h4>High Risk</h4>
                    <div class="value" id="highCount">0</div>
                </div>
                <div class="risk-stat medium">
                    <h4>Medium Risk</h4>
                    <div class="value" id="mediumCount">0</div>
                </div>
                <div class="risk-stat low">
                    <h4>Low Risk</h4>
                    <div class="value" id="lowCount">0</div>
                </div>
            </div>

            <!-- ML Prediction Widget -->
            <div class="card" style="margin-bottom: 1.5rem; padding: 1.5rem;">
                <h3 style="margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-robot" style="color: var(--primary);"></i>
                    ML Risk Prediction (Hugging Face)
                </h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1rem;">
                    Entrez les métriques d'un étudiant pour prédire son niveau de risque avec notre modèle Random
                    Forest.
                </p>
                <div style="display: grid; grid-template-columns: repeat(4, 1fr) auto; gap: 1rem; align-items: end;">
                    <div>
                        <label
                            style="display: block; font-size: 0.8rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Total
                            Clicks</label>
                        <input type="number" id="mlClicks" value="500"
                            style="width: 100%; padding: 0.5rem; border: 1px solid #e2e8f0; border-radius: 6px;">
                    </div>
                    <div>
                        <label
                            style="display: block; font-size: 0.8rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Active
                            Days</label>
                        <input type="number" id="mlDays" value="30"
                            style="width: 100%; padding: 0.5rem; border: 1px solid #e2e8f0; border-radius: 6px;">
                    </div>
                    <div>
                        <label
                            style="display: block; font-size: 0.8rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Assessments</label>
                        <input type="number" id="mlAssessments" value="10"
                            style="width: 100%; padding: 0.5rem; border: 1px solid #e2e8f0; border-radius: 6px;">
                    </div>
                    <div>
                        <label
                            style="display: block; font-size: 0.8rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Avg
                            Score</label>
                        <input type="number" id="mlScore" value="65" min="0" max="100" step="1"
                            style="width: 100%; padding: 0.5rem; border: 1px solid #e2e8f0; border-radius: 6px;">
                    </div>
                    <button class="btn btn-primary" onclick="predictML()" style="height: 38px;">
                        <i class="fas fa-brain"></i> Prédire
                    </button>
                </div>
                <div id="mlResult" style="margin-top: 1rem; display: none;">
                    <div
                        style="display: flex; align-items: center; gap: 1.5rem; padding: 1rem; background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); border-radius: 8px;">
                        <div style="text-align: center;">
                            <div style="font-size: 2.5rem; font-weight: 700;" id="mlRiskScore">--</div>
                            <div style="font-size: 0.8rem; color: var(--text-secondary);">Risk Score</div>
                        </div>
                        <div>
                            <span class="badge" id="mlRiskBadge"
                                style="font-size: 1rem; padding: 0.5rem 1rem;">--</span>
                        </div>
                        <div style="flex: 1;">
                            <div style="font-size: 0.8rem; color: var(--text-secondary);">Source: <span
                                    id="mlSource">--</span></div>
                            <div style="font-size: 0.8rem; color: var(--text-secondary);">Model: <span
                                    id="mlModel">--</span></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Student ID</th>
                            <th>Risk Score</th>
                            <th>Risk Level</th>
                            <th>Region</th>
                            <th>Total Clicks</th>
                            <th>Active Days</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody id="studentsBody">
                        <tr>
                            <td colspan="7" style="text-align:center;padding:2rem;color:#718096;">Loading...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </main>

        <script>
            var API_BASE = 'http://localhost:8080/analytics-api/api/v1/analytics';

            function loadStudents() {
                document.getElementById('studentsBody').innerHTML = '<tr><td colspan="7" style="text-align:center;padding:2rem;color:#718096;">Loading...</td></tr>';

                fetch(API_BASE + '/predictions/at-risk?limit=50')
                    .then(function (r) {
                        if (!r.ok) throw new Error('API error');
                        return r.json();
                    })
                    .then(function (students) {
                        if (!students || students.length === 0) {
                            document.getElementById('studentsBody').innerHTML = '<tr><td colspan="7" style="text-align:center;padding:2rem;color:#718096;">No at-risk students found</td></tr>';
                            return;
                        }
                        renderStudents(students);
                        updateStats(students);
                    })
                    .catch(function (e) {
                        console.error('Error:', e);
                        document.getElementById('studentsBody').innerHTML = '<tr><td colspan="7" style="text-align:center;padding:2rem;color:#ff5252;">Error loading data. Please redeploy analytics-api.war</td></tr>';
                    });
            }

            function renderStudents(students) {
                var tbody = document.getElementById('studentsBody');
                tbody.innerHTML = students.map(function (s) {
                    var badgeClass = s.riskLevel === 'Critical' ? 'badge-danger' :
                        s.riskLevel === 'High' ? 'badge-warning' :
                            s.riskLevel === 'Medium' ? 'badge-primary' : 'badge-success';
                    var barColor = s.riskScore >= 70 ? '#ff5252' : s.riskScore >= 50 ? '#ffab00' : s.riskScore >= 30 ? '#ffd54f' : '#00c853';
                    return '<tr>' +
                        '<td><strong>' + (s.studentId || 'N/A') + '</strong></td>' +
                        '<td><div class="score-bar"><div class="fill" style="width:' + (s.riskScore || 0) + '%;background:' + barColor + '"></div></div>' + (s.riskScore || 0) + '%</td>' +
                        '<td><span class="badge ' + badgeClass + '">' + (s.riskLevel || 'Unknown') + '</span></td>' +
                        '<td>' + (s.region || 'N/A') + '</td>' +
                        '<td>' + formatNumber(s.totalClicks || 0) + '</td>' +
                        '<td>' + (s.activeDays || 0) + '</td>' +
                        '<td>' + (s.finalResult || 'Unknown') + '</td>' +
                        '</tr>';
                }).join('');
            }

            function updateStats(students) {
                var counts = { Critical: 0, High: 0, Medium: 0, Low: 0 };
                students.forEach(function (s) { if (counts.hasOwnProperty(s.riskLevel)) counts[s.riskLevel]++; });
                document.getElementById('criticalCount').textContent = counts.Critical;
                document.getElementById('highCount').textContent = counts.High;
                document.getElementById('mediumCount').textContent = counts.Medium;
                document.getElementById('lowCount').textContent = counts.Low;
            }

            function formatNumber(n) { return n >= 1000 ? (n / 1000).toFixed(1) + 'K' : n; }

            // ML Prediction function
            function predictML() {
                var clicks = document.getElementById('mlClicks').value;
                var days = document.getElementById('mlDays').value;
                var assessments = document.getElementById('mlAssessments').value;
                var score = Math.min(100, Math.max(0, parseFloat(document.getElementById('mlScore').value) || 0));

                var resultDiv = document.getElementById('mlResult');
                resultDiv.style.display = 'block';
                document.getElementById('mlRiskScore').textContent = '...';
                document.getElementById('mlRiskBadge').textContent = 'Loading';
                document.getElementById('mlRiskBadge').className = 'badge';

                fetch(API_BASE + '/ml/predict?clicks=' + clicks + '&days=' + days + '&assessments=' + assessments + '&score=' + score)
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        var scoreColor = data.riskScore >= 70 ? '#ff5252' :
                            data.riskScore >= 50 ? '#ffab00' :
                                data.riskScore >= 30 ? '#ffd54f' : '#00c853';
                        var badgeClass = data.riskLevel === 'Critical' ? 'badge-danger' :
                            data.riskLevel === 'High' ? 'badge-warning' :
                                data.riskLevel === 'Medium' ? 'badge-primary' : 'badge-success';

                        document.getElementById('mlRiskScore').textContent = data.riskScore + '%';
                        document.getElementById('mlRiskScore').style.color = scoreColor;
                        document.getElementById('mlRiskBadge').textContent = data.riskLevel;
                        document.getElementById('mlRiskBadge').className = 'badge ' + badgeClass;
                        document.getElementById('mlSource').textContent = data.source || 'unknown';
                        document.getElementById('mlModel').textContent = data.model || 'unknown';
                    })
                    .catch(function (e) {
                        document.getElementById('mlRiskScore').textContent = 'Error';
                        document.getElementById('mlRiskBadge').textContent = 'Failed';
                    });
            }

            document.addEventListener('DOMContentLoaded', loadStudents);
        </script>
    </body>

    </html>