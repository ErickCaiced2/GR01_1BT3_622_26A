<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mascotas Disponibles - Sistema de Adopciones</title>
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
            padding: 40px 0;
            margin-bottom: 40px;
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
            height: 280px;
            background-color: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card-img-top i {
            font-size: 4rem;
            color: #999;
        }

        .mascota-nombre {
            font-size: 1.4rem;
            font-weight: bold;
            color: var(--dark-color);
        }

        .badge-disponible {
            background-color: #28a745;
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
                        <a class="nav-link active" href="/mascotas/disponibles">Disponibles</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/mascotas/registrar">Registrar Mascota</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <h1>
                <i class="fas fa-heart"></i> Mascotas Disponibles para Adopción
            </h1>
            <p>Encuentra tu compañero perfecto - Total disponibles: <strong>${totalMascotas}</strong></p>
        </div>
    </div>

    <div class="container my-5">
        <c:if test="${not empty mascotas}">
            <div class="row g-4">
                <c:forEach var="mascota" items="${mascotas}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card">
                            <div class="card-img-top">
                                <i class="fas fa-image"></i>
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="mascota-nombre">${mascota.nombre}</h5>
                                    <span class="badge badge-disponible">
                                        <i class="fas fa-check-circle"></i> Disponible
                                    </span>
                                </div>

                                <p class="card-text text-muted mb-2">
                                    <i class="fas fa-tag"></i> ${mascota.tipo}
                                    <c:if test="${not empty mascota.raza}">
                                        - ${mascota.raza}
                                    </c:if>
                                </p>

                                <p class="card-text text-muted mb-2">
                                    <i class="fas fa-birthday-cake"></i> ${mascota.edad} años
                                    <c:if test="${mascota.genero == 'Macho'}">
                                        <i class="fas fa-mars" style="color: #007bff; margin-left: 10px;"></i>
                                    </c:if>
                                    <c:if test="${mascota.genero == 'Hembra'}">
                                        <i class="fas fa-venus" style="color: #ff1493; margin-left: 10px;"></i>
                                    </c:if>
                                </p>

                                <c:if test="${not empty mascota.descripcion}">
                                    <p class="card-text" style="font-size: 0.9rem; color: #666;">
                                        ${mascota.descripcion.substring(0, Math.min(mascota.descripcion.length(), 100))}...
                                    </p>
                                </c:if>

                                <a href="/mascotas/detalle/${mascota.id}" class="btn btn-primary w-100">
                                    <i class="fas fa-heart"></i> Conocer Más
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty mascotas}">
            <div class="empty-state">
                <i class="fas fa-search"></i>
                <h2>No hay mascotas disponibles en este momento</h2>
                <p>Por favor, vuelve más tarde para nuevas mascotas</p>
                <a href="/" class="btn btn-primary btn-lg mt-3">
                    <i class="fas fa-home"></i> Volver al Inicio
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

