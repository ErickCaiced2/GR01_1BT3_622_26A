<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultados de Búsqueda - Sistema de Adopciones</title>
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

        .search-bar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 40px;
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
            background-color: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card-img-top i {
            font-size: 4rem;
            color: #999;
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
        }

        .empty-state i {
            font-size: 5rem;
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
                        <a class="nav-link" href="/mascotas/lista">Mascotas</a>
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

    <!-- Search Bar -->
    <div class="search-bar">
        <div class="container">
            <h2><i class="fas fa-search"></i> Resultados de Búsqueda</h2>
            <form action="/mascotas/buscar" method="GET" class="mt-3">
                <div class="input-group">
                    <input type="text" name="nombre" class="form-control" placeholder="Buscar por nombre..." value="${nombre}">
                    <button class="btn btn-light" type="submit">
                        <i class="fas fa-search"></i> Buscar
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="container">
        <!-- Resultados -->
        <c:if test="${not empty mascotas}">
            <div class="mb-3">
                <p class="text-muted">
                    <strong>Búsqueda:</strong> "${nombre}" - <strong>Resultados encontrados:</strong> ${totalMascotas}
                </p>
            </div>

            <div class="row g-4">
                <c:forEach var="mascota" items="${mascotas}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card">
                            <div class="card-img-top">
                                <i class="fas fa-image"></i>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">${mascota.nombre}</h5>
                                <p class="card-text text-muted">
                                    <i class="fas fa-tag"></i> ${mascota.tipo}
                                    <c:if test="${not empty mascota.raza}">
                                        - ${mascota.raza}
                                    </c:if>
                                </p>
                                <p class="card-text text-muted">
                                    <i class="fas fa-birthday-cake"></i> ${mascota.edad} años
                                </p>
                                <a href="/mascotas/detalle/${mascota.id}" class="btn btn-primary w-100">
                                    <i class="fas fa-eye"></i> Ver Detalle
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Sin Resultados -->
        <c:if test="${empty mascotas}">
            <div class="empty-state">
                <i class="fas fa-search"></i>
                <h2>No se encontraron resultados</h2>
                <p>No hay mascotas que coincidan con tu búsqueda de "<strong>${nombre}</strong>"</p>
                <a href="/mascotas/lista" class="btn btn-primary btn-lg mt-3">
                    <i class="fas fa-list"></i> Ver Todas las Mascotas
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

