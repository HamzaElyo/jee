<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Create Order - LogMaster</title>
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
                            <li class="nav-item"><a class="nav-link active"
                                    href="${pageContext.request.contextPath}/orders">Orders</a></li>
                            <li class="nav-item"><a class="nav-link"
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
                    <div class="col-md-8">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h4 class="mb-0">Create New Order</h4>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/orders" method="post">
                                    <input type="hidden" name="action" value="create">

                                    <div class="mb-3">
                                        <label for="userId" class="form-label">User</label>
                                        <select class="form-select" id="userId" name="userId" required>
                                            <option value="">Select a user...</option>
                                            <c:forEach items="${users}" var="user">
                                                <option value="${user.id}">${user.name} (${user.email})</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label for="address" class="form-label">Shipping Address</label>
                                        <textarea class="form-control" id="address" name="address" rows="3"
                                            required></textarea>
                                    </div>

                                    <hr>
                                    <h5 class="mb-3">Select Products</h5>

                                    <div class="table-responsive mb-3">
                                        <table class="table table-bordered">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="width: 50px;">Select</th>
                                                    <th>Product</th>
                                                    <th>Price</th>
                                                    <th style="width: 150px;">Quantity</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${products}" var="product">
                                                    <tr>
                                                        <td class="text-center">
                                                            <input class="form-check-input product-check"
                                                                type="checkbox" name="productIds" value="${product.id}"
                                                                data-id="${product.id}">
                                                        </td>
                                                        <td>${product.name}</td>
                                                        <td>$${product.price}</td>
                                                        <td>
                                                            <input type="number" class="form-control"
                                                                name="qty_${product.id}" id="qty_${product.id}" min="1"
                                                                max="${product.stock}" value="1" disabled>
                                                            <small class="text-muted">Stock: ${product.stock}</small>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty products}">
                                                    <tr>
                                                        <td colspan="4" class="text-center text-muted">No products
                                                            available.</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/orders"
                                            class="btn btn-secondary">Cancel</a>
                                        <button type="submit" class="btn btn-primary" id="submitBtn">Create
                                            Order</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Enable/disable quantity input based on checkbox
                document.querySelectorAll('.product-check').forEach(checkbox => {
                    checkbox.addEventListener('change', function () {
                        const qtyInput = document.getElementById('qty_' + this.dataset.id);
                        qtyInput.disabled = !this.checked;
                        if (this.checked) {
                            qtyInput.focus();
                        }
                    });
                });
            </script>
        </body>

        </html>