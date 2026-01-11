<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Product Management - LogMaster</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body class="bg-light">

            <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
                <div class="container">
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/">LogMaster</a>
                    <div class="collapse navbar-collapse">
                        <ul class="navbar-nav me-auto">
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/orders">Orders</a></li>
                            <li class="nav-item"><a class="nav-link active"
                                    href="${pageContext.request.contextPath}/products">Products</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/users">Users</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/logs">Logs</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Products</h2>
                    <a href="${pageContext.request.contextPath}/products?action=form" class="btn btn-primary">Add New
                        Product</a>
                </div>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Category</th>
                                        <th>Price</th>
                                        <th>Stock</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${products}" var="product">
                                        <tr>
                                            <td>${product.id}</td>
                                            <td>${product.name}</td>
                                            <td>${product.category}</td>
                                            <td>$${product.price}</td>
                                            <td>${product.stock}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/products?action=form&id=${product.id}"
                                                    class="btn btn-sm btn-outline-secondary">Edit</a>
                                                <a href="${pageContext.request.contextPath}/products?action=delete&id=${product.id}"
                                                    class="btn btn-sm btn-outline-danger"
                                                    onclick="return confirm('Are you sure you want to delete this product?')">Delete</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty products}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted">No products found.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>