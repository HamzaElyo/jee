<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!-- Sidebar Component -->
    <aside class="sidebar">
        <div class="logo">
            <i class="fas fa-graduation-cap"></i>
            <span>E-Learning Analytics</span>
        </div>

        <ul class="nav-menu">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/dashboard" class="nav-link" id="nav-home">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/dashboard/courses" class="nav-link" id="nav-courses">
                    <i class="fas fa-book"></i>
                    <span>Courses</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/dashboard/videos" class="nav-link" id="nav-videos">
                    <i class="fab fa-youtube"></i>
                    <span>Videos</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/dashboard/students" class="nav-link" id="nav-students">
                    <i class="fas fa-users"></i>
                    <span>Students</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/dashboard/predictions" class="nav-link"
                    id="nav-predictions">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>Risk Analysis</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/dashboard/analytics" class="nav-link" id="nav-analytics">
                    <i class="fas fa-chart-bar"></i>
                    <span>Analytics</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/dashboard/settings" class="nav-link" id="nav-settings">
                    <i class="fas fa-cog"></i>
                    <span>Settings</span>
                </a>
            </li>
        </ul>
    </aside>