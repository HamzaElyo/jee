<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Order Details - LogMaster</title>
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
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a
                                            href="${pageContext.request.contextPath}/orders">Orders</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Order #${order.id}</li>
                                </ol>
                            </nav>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-8">
                            <!-- Order Information -->
                            <div class="card shadow-sm mb-4">
                                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Order Information</h5>
                                    <span
                                        class="badge bg-${order.status == 'COMPLETED' ? 'success' : (order.status == 'CANCELLED' ? 'danger' : 'warning')}">
                                        ${order.status}
                                    </span>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <strong>Date:</strong>
                                            <p>${order.orderDate}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <strong>Total Amount:</strong>
                                            <p class="h4 text-primary">$${order.totalAmount}</p>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <strong>Customer:</strong>
                                            <p>${order.user.name} (${order.user.email})</p>
                                        </div>
                                        <div class="col-md-6">
                                            <strong>Shipping Address:</strong>
                                            <p>${order.shippingAddress}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Order Items -->
                            <div class="card shadow-sm">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">Order Items</h5>
                                </div>
                                <div class="card-body p-0">
                                    <table class="table table-striped mb-0">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th class="text-end">Price</th>
                                                <th class="text-center">Qty</th>
                                                <th class="text-end">Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${order.items}" var="item">
                                                <tr>
                                                    <td>${item.product.name}</td>
                                                    <td class="text-end">$${item.price}</td>
                                                    <td class="text-center">${item.quantity}</td>
                                                    <td class="text-end">$${item.price * item.quantity}</td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty order.items}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted">No items in this
                                                        order.</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th colspan="3" class="text-end">Total:</th>
                                                <th class="text-end">$${order.totalAmount}</th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <!-- Actions -->
                            <div class="card shadow-sm">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">Actions</h5>
                                </div>
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/orders" method="post"
                                        class="d-grid gap-2">
                                        <input type="hidden" name="orderId" value="${order.id}">

                                        <c:if test="${order.status == 'PENDING'}">
                                            <button type="submit" name="action" value="status" class="btn btn-success">
                                                <input type="hidden" name="status" value="SHIPPED">
                                                Mark as Shipped
                                            </button>

                                            <button type="button" class="btn btn-danger" data-bs-toggle="modal"
                                                data-bs-target="#cancelModal">
                                                Cancel Order
                                            </button>
                                        </c:if>

                                        <c:if test="${order.status == 'SHIPPED'}">
                                            <button type="submit" name="action" value="status" class="btn btn-primary">
                                                <input type="hidden" name="status" value="DELIVERED">
                                                Mark as Delivered
                                            </button>
                                        </c:if>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Cancel Modal -->
                <div class="modal fade" id="cancelModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form action="${pageContext.request.contextPath}/orders" method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title">Cancel Order</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <div class="mb-3">
                                        <label for="reason" class="form-label">Reason for cancellation</label>
                                        <textarea class="form-control" id="reason" name="reason" required></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-danger">Confirm Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>