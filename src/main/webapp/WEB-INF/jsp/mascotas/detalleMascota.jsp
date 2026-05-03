<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Mascota - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .info-section { background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        .badge-disponible { background-color: #28a745; }
        .badge-adoptado { background-color: #007bff; }
        .badge-proceso { background-color: #ffc107; color: #000; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="/">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="/mascotas/lista">Mascotas</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <c:if test="${param.exito}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle"></i> Operación realizada exitosamente
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row">
            <div class="col-md-3">
                <div style="height: 300px; background-color: #e0e0e0; display: flex; align-items: center; justify-content: center; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    <i class="fas fa-image" style="font-size: 5rem; color: #999;"></i>
                </div>
            </div>

            <div class="col-md-9">
                <div class="d-flex justify-content-between align-items-start mb-4">
                    <div>
                        <h2>${mascota.nombre}</h2>
                        <c:choose>
                            <c:when test="${mascota.estado == 'Disponible'}">
                                <span class="badge badge-disponible" style="font-size: 1rem;"><i class="fas fa-check-circle"></i> Disponible</span>
                            </c:when>
                            <c:when test="${mascota.estado == 'Adoptado'}">
                                <span class="badge badge-adoptado" style="font-size: 1rem;"><i class="fas fa-home"></i> Adoptado</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-proceso" style="font-size: 1rem;"><i class="fas fa-hourglass-half"></i> En Proceso</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <a href="/mascotas/editar/${mascota.id}" class="btn btn-warning"><i class="fas fa-edit"></i> Editar</a>
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#eliminarModal">
                            <i class="fas fa-trash"></i> Eliminar
                        </button>
                    </div>
                </div>

                <div class="info-section">
                    <h5>Información Básica</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong><i class="fas fa-tag"></i> Tipo:</strong> ${mascota.tipo}</p>
                            <p><strong><i class="fas fa-dna"></i> Raza:</strong> ${mascota.raza != null ? mascota.raza : 'No especificada'}</p>
                            <p><strong><i class="fas fa-mars"></i> Género:</strong> ${mascota.genero}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong><i class="fas fa-birthday-cake"></i> Edad:</strong> ${mascota.edad} años</p>
                            <p><strong><i class="fas fa-weight"></i> Peso:</strong> ${mascota.pesoKg != null ? mascota.pesoKg : 'No especificado'} kg</p>
                            <p><strong><i class="fas fa-palette"></i> Color:</strong> ${mascota.color != null ? mascota.color : 'No especificado'}</p>
                        </div>
                    </div>
                </div>

                <div class="info-section">
                    <h5>Descripción</h5>
                    <p>${mascota.descripcion != null ? mascota.descripcion : 'Sin descripción'}</p>
                </div>

                <div class="info-section">
                    <h5>Información del Registro</h5>
                    <p><strong><i class="fas fa-calendar"></i> Fecha de Registro:</strong> <fmt:formatDate value="${mascota.fechaRegistro}" pattern="dd/MM/yyyy"/></p>
                    <p><strong><i class="fas fa-info-circle"></i> ID:</strong> #${mascota.id}</p>
                </div>

                <div class="mt-4">
                    <a href="/mascotas/lista" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Volver</a>
                    <c:if test="${mascota.estado == 'Disponible'}">
                        <a href="/solicitudes/formulario?mascotaId=${mascota.id}" class="btn btn-success">
                            <i class="fas fa-heart"></i> Solicitar Adopción
                        </a>
                    </c:if>
                </div>

                <c:if test="${not empty mascotasRelacionadas}">
                    <div class="info-section mt-3">
                        <h5><i class="fas fa-paw"></i> Tambien te puede interesar</h5>
                        <div class="row">
                            <c:forEach var="relacionada" items="${mascotasRelacionadas}">
                                <div class="col-md-6 mb-2">
                                    <div class="border rounded p-2 d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong>${relacionada.nombre}</strong>
                                            <div class="text-muted small">${relacionada.tipo} - ${relacionada.raza}</div>
                                        </div>
                                        <a href="/mascotas/detalle/${relacionada.id}" class="btn btn-sm btn-outline-primary">Ver</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Modal para eliminar -->
    <div class="modal fade" id="eliminarModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="/mascotas/eliminar/${mascota.id}">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirmar Eliminación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        ¿Estás seguro de que deseas eliminar a <strong>${mascota.nombre}</strong>? Esta acción no se puede deshacer.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-danger">Eliminar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

