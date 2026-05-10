<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty titulo ? titulo : 'Lista de Adopciones'} - Paws & Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a5490;
            --accent-color: #ff6b35;
            --light-bg: #f8f9fa;
        }

        body {
            background-color: var(--light-bg);
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, #0d3d7a 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, #0d3d7a 100%);
            color: white;
            padding: 30px;
            margin-bottom: 30px;
            border-radius: 8px;
        }

        .adopcion-card {
            border-left: 4px solid var(--accent-color);
            transition: all 0.3s ease;
            margin-bottom: 20px;
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .adopcion-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .estado-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .btn-detalles {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 12px;
            transition: all 0.3s ease;
        }

        .btn-detalles:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(26, 84, 144, 0.4);
            color: white;
            text-decoration: none;
        }

        footer {
            background: var(--primary-color);
            color: white;
            padding: 20px 0;
            margin-top: 40px;
        }
    </style>
</head>
<body>
    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="fas fa-paw"></i> Paws & Home
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="/">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="/mascotas/lista">Mascotas</a></li>
                    <li class="nav-item"><a class="nav-link" href="/adopciones/lista">Adopciones</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="container mt-5 mb-5">
        <!-- HEADER -->
        <div class="header-section">
            <h1><i class="fas fa-handshake"></i> ${not empty titulo ? titulo : 'Lista de Adopciones'}</h1>
            <p class="mb-0">Gestione y consulte las adopciones registradas</p>
        </div>

        <!-- MENSAJES -->
        <c:if test="${not empty mensaje}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle"></i> ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- LISTA VACÍA -->
        <c:if test="${empty adopciones or adopciones.size() == 0}">
            <div class="alert alert-info" role="alert">
                <i class="fas fa-inbox"></i> No hay adopciones registradas en este momento.
            </div>
        </c:if>

        <!-- ADOPCIONES -->
        <c:forEach items="${adopciones}" var="adopcion">
            <div class="card adopcion-card">
                <div class="card-body">
                    <div class="row align-items-center">
                        <!-- INFO -->
                        <div class="col-md-8">
                            <h5 class="card-title mb-2">
                                <strong>${adopcion.mascota.nombre}</strong>
                                <span class="estado-badge badge bg-${adopcion.estado == 'Completada' ? 'success' : 'info'}">
                                    ${adopcion.estado}
                                </span>
                            </h5>
                            <p class="mb-1">
                                <i class="fas fa-paw"></i> ${adopcion.mascota.tipo} - ${adopcion.mascota.raza} (${adopcion.mascota.edad} años)
                            </p>
                            <p class="mb-0">
                                <i class="fas fa-user"></i> ${adopcion.solicitante.nombre} |
                                <i class="fas fa-calendar"></i> <fmt:formatDate value="${adopcion.fechaAdopcion}" pattern="dd/MM/yyyy" />
                            </p>
                        </div>

                        <!-- ACCIONES -->
                        <div class="col-md-4 text-end">
                            <a href="/adopciones/${adopcion.id}" class="btn btn-detalles">
                                <i class="fas fa-eye"></i> Detalles
                            </a>
                            <c:if test="${adopcion.estado == 'Completada'}">
                                <button class="btn btn-detalles" style="background: #28a745; margin-top: 5px;" onclick="descargarContrato(${adopcion.id})">
                                    <i class="fas fa-download"></i> PDF
                                </button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <!-- BOTÓN REGRESO -->
        <div style="text-align: center; margin-top: 30px;">
            <a href="/admin/dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Volver
            </a>
        </div>
    </div>

    <!-- FOOTER -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Paws & Home</h5>
                    <p>🐾 Sistema de Adopciones Responsables</p>
                </div>
                <div class="col-md-6 text-end">
                    <p>&copy; 2026 Todos los derechos reservados</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- SCRIPTS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function descargarContrato(adopcionId) {
            window.location.href = `/adopciones/${adopcionId}/contrato/descargar`;
        }
    </script>
</body>
</html>

