<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>${product != null ? 'Edit Product' : 'New Product'} - LogMaster</title>
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
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h4 class="mb-0">${product != null ? 'Edit Product' : 'Create New Product'}</h4>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/products" method="post">
                                    <input type="hidden" name="action" value="${product != null ? 'update' : 'create'}">
                                    <c:if test="${product != null}">
                                        <input type="hidden" name="id" value="${product.id}">
                                    </c:if>

                                    <div class="mb-3">
                                        <label for="name" class="form-label">Product Name</label>
                                        <input type="text" class="form-control" id="name" name="name"
                                            value="${product != null ? product.name : ''}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="category" class="form-label">Category</label>
                                        <input type="text" class="form-control" id="category" name="category"
                                            value="${product != null ? product.category : ''}">
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="price" class="form-label">Price</label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input type="number" class="form-control" id="price" name="price"
                                                    step="0.01" min="0" value="${product != null ? product.price : ''}"
                                                    required>
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="stock" class="form-label">Stock Quantity</label>
                                            <input type="number" class="form-control" id="stock" name="stock" min="0"
                                                value="${product != null ? product.stock : ''}" required>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/products"
                                            class="btn btn-secondary">Cancel</a>
                                        <button type="submit" class="btn btn-success">Save Product</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>