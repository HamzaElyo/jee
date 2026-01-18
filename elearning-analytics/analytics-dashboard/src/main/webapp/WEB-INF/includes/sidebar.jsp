<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%-- Sidebar Component - Include with: <jsp:include page="/WEB-INF/includes/sidebar.jsp">
        <jsp:param name="activePage" value="home" />
        </jsp:include> --%>
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <i class="fas fa-graduation-cap"></i>
                    <span>EduAnalytics</span>
                </div>
            </div>

            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard"
                        class="nav-link ${param.activePage == 'home' ? 'active' : ''}">
                        <i class="fas fa-home"></i><span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/courses"
                        class="nav-link ${param.activePage == 'courses' ? 'active' : ''}">
                        <i class="fas fa-book"></i><span>Courses</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/videos"
                        class="nav-link ${param.activePage == 'videos' ? 'active' : ''}">
                        <i class="fab fa-youtube"></i><span>Videos</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/students"
                        class="nav-link ${param.activePage == 'students' ? 'active' : ''}">
                        <i class="fas fa-users"></i><span>Students</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/predictions"
                        class="nav-link ${param.activePage == 'predictions' ? 'active' : ''}">
                        <i class="fas fa-chart-line"></i><span>Risk Analysis</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard/analytics"
                        class="nav-link ${param.activePage == 'analytics' ? 'active' : ''}">
                        <i class="fas fa-chart-bar"></i><span>Analytics</span>
                    </a>
                </li>
            </ul>
        </aside>