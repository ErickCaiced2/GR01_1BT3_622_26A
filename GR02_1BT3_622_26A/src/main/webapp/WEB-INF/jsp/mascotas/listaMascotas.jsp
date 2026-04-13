<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UC02 - Consultar Mascotas - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --dark-color: #2C3E50;
        }
        body { background-color: #f8f9fa; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .page-header { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); color: white; padding: 30px 0; margin-bottom: 30px; }
        .card { border: none; box-shadow: 0 2px 8px rgba(0,0,0,0.1); transition: transform 0.3s; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 5px 20px rgba(0,0,0,0.15); }
        .card-img-top { height: 250px; object-fit: cover; background-color: #e0e0e0; }
        .badge-disponible { background-color: #28a745; }
        .badge-adoptado { background-color: #007bff; }
        .badge-proceso { background-color: #ffc107; color: #000; }
        .search-box { background: white; padding: 20px; border-radius: 10px; margin-bottom: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="/">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link active" href="/mascotas/lista">Mascotas</a></li>
                    <li class="nav-item"><a class="nav-link" href="/mascotas/registrar">Registrar Mascota</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="page-header">
        <div class="container">
            <h1><i class="fas fa-list"></i> Consultar Mascotas (UC02)</h1>
            <p>Total registradas: <strong>${totalMascotas}</strong></p>
        </div>
    </div>

    <div class="container">
        <!-- Búsqueda -->
        <div class="search-box">
            <form action="/mascotas/buscar" method="GET" class="d-flex gap-2">
                <input type="text" name="nombre" class="form-control" placeholder="Buscar por nombre..." value="${nombre}">
                <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Buscar</button>
                <a href="/mascotas/registrar" class="btn btn-success"><i class="fas fa-plus"></i> Nueva</a>
            </form>
        </div>

        <c:if test="${not empty mascotas}">
            <div class="row g-4">
                <c:forEach var="mascota" items="${mascotas}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card">
                            <div style="height: 250px; background-color: #e0e0e0; display: flex; align-items: center; justify-content: center; border-top-left-radius: 10px; border-top-right-radius: 10px;">
                                <i class="fas fa-image" style="font-size: 3rem; color: #999;"></i>
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="card-title">${mascota.nombre}</h5>
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
                                <p class="card-text"><small class="text-muted"><i class="fas fa-tag"></i> ${mascota.tipo} - ${mascota.raza}</small></p>
                                <p class="card-text"><small><i class="fas fa-birthday-cake"></i> ${mascota.edad} años</small></p>
                                <c:if test="${not empty mascota.color}">
                                    <p class="card-text"><small><i class="fas fa-palette"></i> ${mascota.color}</small></p>
                                </c:if>
                                <div class="d-grid gap-2 mt-3">
                                    <a href="/mascotas/detalle/${mascota.id}" class="btn btn-sm btn-info text-white"><i class="fas fa-eye"></i> Ver Detalle</a>
                                    <a href="/mascotas/editar/${mascota.id}" class="btn btn-sm btn-warning"><i class="fas fa-edit"></i> Editar</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty mascotas}">
            <div class="alert alert-info text-center" style="padding: 60px 20px;">
                <i class="fas fa-inbox" style="font-size: 3rem;"></i>
                <h2>No hay mascotas registradas</h2>
                <p>Haz clic en el botón "Nueva Mascota" para comenzar a registrar.</p>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

