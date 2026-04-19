<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Mascotas - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --dark-color: #2C3E50;
        }

        body {
            background-color: #f8f9fa;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            border-radius: 0 0 10px 10px;
        }

        .card {
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            height: 100%;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .card-img-top {
            height: 250px;
            object-fit: cover;
            background-color: #e0e0e0;
        }

        .card-body {
            padding: 15px;
        }

        .mascota-nombre {
            font-size: 1.3rem;
            font-weight: bold;
            color: var(--dark-color);
        }

        .mascota-info {
            font-size: 0.9rem;
            color: #666;
            margin: 8px 0;
        }

        .badge-disponible {
            background-color: #28a745;
        }

        .badge-adoptado {
            background-color: #007bff;
        }

        .badge-proceso {
            background-color: #ffc107;
            color: #000;
        }

        .btn-group-sm {
            gap: 5px;
        }

        .search-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state i {
            font-size: 4rem;
            color: #ccc;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="fas fa-paw"></i> Sistema de Adopciones
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="/mascotas/lista">Mascotas</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/mascotas/disponibles">Disponibles</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/mascotas/registrar">Registrar Mascota</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Página Header -->
    <div class="page-header">
        <div class="container">
            <h1><i class="fas fa-list"></i> Lista de Mascotas</h1>
            <p>Total de mascotas registradas: <strong>${totalMascotas}</strong></p>
        </div>
    </div>

    <div class="container">
        <!-- Búsqueda -->
        <div class="search-box">
            <div class="row">
                <div class="col-md-8">
                    <form action="/mascotas/buscar" method="GET" class="d-flex gap-2">
                        <input type="text" name="nombre" class="form-control"
                               placeholder="Buscar por nombre..." value="">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Buscar
                        </button>
                    </form>
                </div>
                <div class="col-md-4 text-end">
                    <a href="/mascotas/registrar" class="btn btn-success">
                        <i class="fas fa-plus"></i> Nueva Mascota
                    </a>
                </div>
            </div>
        </div>

        <!-- Mensajes de alerta -->
        <c:if test="${param.exito != null}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong><i class="fas fa-check-circle"></i> ¡Éxito!</strong> Operación realizada correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong><i class="fas fa-exclamation-circle"></i> Error!</strong> Ocurrió un problema al procesar la solicitud.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Grid de Mascotas -->
        <c:if test="${not empty mascotas}">
            <div class="row g-4">
                <c:forEach var="mascota" items="${mascotas}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card">
                            <!-- Imagen -->
                            <div style="height: 250px; background-color: #e0e0e0; display: flex; align-items: center; justify-content: center; border-top-left-radius: 10px; border-top-right-radius: 10px;">
                                <i class="fas fa-image" style="font-size: 3rem; color: #999;"></i>
                            </div>

                            <div class="card-body">
                                <!-- Nombre y Estado -->
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="mascota-nombre">${mascota.nombre}</h5>
                                    <c:choose>
                                        <c:when test="${mascota.estado == 'Disponible'}">
                                            <span class="badge badge-disponible">Disponible</span>
                                        </c:when>
                                        <c:when test="${mascota.estado == 'Adoptado'}">
                                            <span class="badge badge-adoptado">Adoptado</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-proceso">${mascota.estado}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Información -->
                                <div class="mascota-info">
                                    <i class="fas fa-tag"></i> <strong>${mascota.tipo}</strong>
                                    <c:if test="${not empty mascota.raza}">
                                        - ${mascota.raza}
                                    </c:if>
                                </div>

                                <div class="mascota-info">
                                    <i class="fas fa-birthday-cake"></i> ${mascota.edad} años
                                    <c:if test="${mascota.genero == 'Macho'}">
                                        <i class="fas fa-mars"></i>
                                    </c:if>
                                    <c:if test="${mascota.genero == 'Hembra'}">
                                        <i class="fas fa-venus"></i>
                                    </c:if>
                                </div>

                                <c:if test="${not empty mascota.color}">
                                    <div class="mascota-info">
                                        <i class="fas fa-palette"></i> ${mascota.color}
                                    </div>
                                </c:if>

                                <!-- Botones de Acción -->
                                <div class="d-grid gap-2 mt-3">
                                    <a href="/mascotas/detalle/${mascota.id}" class="btn btn-sm btn-info text-white">
                                        <i class="fas fa-eye"></i> Ver Detalle
                                    </a>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <a href="/mascotas/editar/${mascota.id}" class="btn btn-warning">
                                            <i class="fas fa-edit"></i> Editar
                                        </a>
                                        <form action="/mascotas/eliminar/${mascota.id}" method="POST" style="display:inline;"
                                              onsubmit="return confirm('¿Está seguro de que desea eliminar esta mascota?');">
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="fas fa-trash"></i> Eliminar
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Estado Vacío -->
        <c:if test="${empty mascotas}">
            <div class="empty-state">
                <i class="fas fa-inbox"></i>
                <h2>No hay mascotas registradas</h2>
                <p>Haz clic en el botón "Nueva Mascota" para comenzar a registrar.</p>
                <a href="/mascotas/registrar" class="btn btn-primary btn-lg mt-3">
                    <i class="fas fa-plus"></i> Registrar Primera Mascota
                </a>
            </div>
        </c:if>
    </div>

    <!-- Footer -->
    <footer style="background-color: var(--dark-color); color: white; padding: 20px 0; margin-top: 40px;">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Sistema de Adopciones</h5>
                    <p>Ayudando a encontrar el hogar perfecto para cada mascota</p>
                </div>
                <div class="col-md-6 text-end">
                    <p>&copy; 2026 Todos los derechos reservados</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

