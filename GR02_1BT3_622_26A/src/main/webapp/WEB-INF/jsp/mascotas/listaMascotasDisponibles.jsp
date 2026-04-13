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
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .card { border: none; box-shadow: 0 2px 8px rgba(0,0,0,0.1); transition: transform 0.3s; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 5px 20px rgba(0,0,0,0.15); }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="/">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="/mascotas/lista">Todas</a></li>
                    <li class="nav-item"><a class="nav-link active" href="/mascotas/disponibles">Disponibles</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <h2><i class="fas fa-heart"></i> Mascotas Disponibles para Adopción</h2>
        <p>Total disponibles: <strong>${totalMascotas}</strong></p>

        <c:if test="${not empty mascotas}">
            <div class="row g-4">
                <c:forEach var="mascota" items="${mascotas}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card">
                            <div style="height: 250px; background-color: #e0e0e0; display: flex; align-items: center; justify-content: center;">
                                <i class="fas fa-image" style="font-size: 3rem; color: #999;"></i>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">${mascota.nombre}</h5>
                                <p class="card-text"><small><i class="fas fa-tag"></i> ${mascota.tipo}</small></p>
                                <p class="card-text"><small><i class="fas fa-birthday-cake"></i> ${mascota.edad} años</small></p>
                                <div class="d-grid gap-2">
                                    <a href="/mascotas/detalle/${mascota.id}" class="btn btn-info btn-sm">Ver Detalle</a>
                                    <a href="/solicitudes/formulario?mascotaId=${mascota.id}" class="btn btn-success btn-sm">
                                        <i class="fas fa-heart"></i> Solicitar Adopción
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty mascotas}">
            <div class="alert alert-info text-center" style="padding: 60px 20px;">
                <i class="fas fa-heart-broken" style="font-size: 3rem;"></i>
                <h2>No hay mascotas disponibles en este momento</h2>
                <p>Vuelve más tarde para encontrar tu mascota ideal</p>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

