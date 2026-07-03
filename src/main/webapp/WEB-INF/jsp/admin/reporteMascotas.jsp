<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Mascotas - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --dark-color: #2C3E50;
            --panel-bg: #f8f9fa;
        }

        body {
            background-color: #f8f9fa;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .sidebar {
            background-color: var(--dark-color);
            min-height: calc(100vh - 56px);
            padding-top: 20px;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 14px 20px;
            border-left: 3px solid transparent;
            transition: all 0.2s ease;
        }

        .sidebar a:hover, .sidebar a.active {
            background-color: rgba(255, 255, 255, 0.08);
            border-left-color: var(--primary-color);
        }

        .content {
            padding: 28px 20px 40px;
        }

        .report-header {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        table {
            margin: 0;
        }

        thead {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
        }

        @media print {
            .btn, .navbar, .sidebar, .print-btn {
                display: none;
            }
            .content {
                padding: 0;
            }
            .table-container {
                box-shadow: none;
            }
        }

        @media (max-width: 991px) {
            .sidebar {
                min-height: auto;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">
                <i class="fas fa-paw"></i> Sistema de Adopciones
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-user-shield"></i> Panel de Administracion
            </span>
        </div>
    </nav>

    <div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/jsp/admin/_sidebar.jsp">
            <jsp:param name="activo" value="reportes"/>
        </jsp:include>

        <main class="col-lg-10 content">
        <!-- Report Header -->
        <div class="report-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2><i class="fas fa-chart-bar"></i> Reporte de Mascotas</h2>
                    <p class="text-muted">
                        Generado el: <strong><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></strong>
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="/admin/reporte/mascotas/descargar" class="btn btn-success">
                        <i class="fas fa-file-pdf"></i> Descargar PDF
                    </a>
                    <button onclick="window.print()" class="btn btn-primary print-btn">
                        <i class="fas fa-print"></i> Imprimir
                    </button>
                    <a href="/admin/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Volver
                    </a>
                </div>
            </div>
        </div>

        <!-- Statistics Summary -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Total</h5>
                        <h2 style="color: var(--primary-color);">${estadisticas.total}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Disponibles</h5>
                        <h2 style="color: #28a745;">${estadisticas.disponibles}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">En Proceso</h5>
                        <h2 style="color: #ffc107;">${estadisticas.en_proceso}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Adoptadas</h5>
                        <h2 style="color: #17a2b8;">${estadisticas.adoptados}</h2>
                    </div>
                </div>
            </div>
        </div>

        <!-- Data Table -->
        <div class="table-container">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Nombre</th>
                        <th>Tipo</th>
                        <th>Raza</th>
                        <th>Edad</th>
                        <th>Género</th>
                        <th>Color</th>
                        <th>Peso</th>
                        <th>Estado</th>
                        <th>Fecha Registro</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="mascota" items="${mascotas}" varStatus="status">
                        <tr>
                            <td>${status.count}</td>
                            <td><strong>${mascota.nombre}</strong></td>
                            <td>${mascota.tipo}</td>
                            <td>${mascota.raza != null ? mascota.raza : 'N/A'}</td>
                            <td>${mascota.edad} años</td>
                            <td>${mascota.genero}</td>
                            <td>${mascota.color != null ? mascota.color : 'N/A'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${mascota.pesoKg != null}">${mascota.pesoKg} kg</c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${mascota.estado == 'Disponible'}">
                                        <span class="badge bg-success">Disponible</span>
                                    </c:when>
                                    <c:when test="${mascota.estado == 'Adoptado'}">
                                        <span class="badge bg-info">Adoptado</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning">En Proceso</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatDate value="${mascota.fechaRegistro}" pattern="dd/MM/yyyy"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Footer -->
        <div class="text-center mt-5 text-muted">
            <p>Sistema de Adopciones © 2026 - Todos los derechos reservados</p>
        </div>
        </main>
    </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

