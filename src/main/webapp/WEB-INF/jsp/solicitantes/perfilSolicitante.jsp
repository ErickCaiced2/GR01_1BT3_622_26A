<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil del Solicitante</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .info-card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px; border-left: 5px solid var(--secondary-color); }
        .info-label { font-weight: bold; color: var(--primary-color); }
        .badge-status { padding: 8px 12px; border-radius: 20px; }
        .btn-action { border-radius: 8px; margin: 5px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
        </div>
    </nav>

    <div class="container my-5">
        <c:if test="${not empty mensaje}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i> ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row">
            <div class="col-md-8">
                <h2><i class="fas fa-user-circle"></i> Perfil de ${solicitante.nombre} ${solicitante.apellido}</h2>
                <hr>

                <div class="info-card">
                    <h5><i class="fas fa-id-card"></i> Información Personal</h5>
                    <p><span class="info-label">Email:</span> ${solicitante.email}</p>
                    <p><span class="info-label">Teléfono:</span> ${solicitante.telefono}</p>
                    <p><span class="info-label">Tipo de Documento:</span> ${solicitante.tipoDocumento}</p>
                    <p><span class="info-label">Documento:</span> ${solicitante.documentoIdentidad}</p>
                    <c:if test="${not empty solicitante.fechaNacimiento}">
                        <p><span class="info-label">Fecha de Nacimiento:</span> <fmt:formatDate value="${solicitante.fechaNacimiento}" pattern="dd/MM/yyyy"/></p>
                    </c:if>
                </div>

                <div class="info-card">
                    <h5><i class="fas fa-map-marker-alt"></i> Información de Residencia</h5>
                    <p><span class="info-label">Dirección:</span> ${solicitante.direccion}</p>
                    <p><span class="info-label">Ciudad:</span> ${solicitante.ciudad}</p>
                </div>

                <div class="info-card">
                    <h5><i class="fas fa-info-circle"></i> Información General</h5>
                    <p><span class="info-label">Estado:</span>
                        <c:if test="${solicitante.estado == 'Activo'}">
                            <span class="badge bg-success badge-status">Activo</span>
                        </c:if>
                        <c:if test="${solicitante.estado == 'Inactivo'}">
                            <span class="badge bg-secondary badge-status">Inactivo</span>
                        </c:if>
                    </p>
                    <p><span class="info-label">Fecha de Registro:</span> <fmt:formatDate value="${solicitante.fechaRegistro}" pattern="dd/MM/yyyy HH:mm"/></p>
                </div>

                <div class="mt-4">
                    <a href="/solicitantes/${solicitante.id}/editar" class="btn btn-primary btn-action">
                        <i class="fas fa-edit"></i> Editar Información
                    </a>
                    <a href="/solicitudes/formulario" class="btn btn-success btn-action">
                        <i class="fas fa-paw"></i> Ver Mascotas para Adoptar
                    </a>
                    <a href="/" class="btn btn-secondary btn-action">
                        <i class="fas fa-home"></i> Volver al Inicio
                    </a>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="fas fa-user-circle fa-5x" style="color: var(--secondary-color);"></i>
                        <h5 class="card-title mt-3">${solicitante.nombre}</h5>
                        <p class="card-text text-muted">${solicitante.email}</p>
                        <span class="badge bg-info">ID: ${solicitante.id}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

