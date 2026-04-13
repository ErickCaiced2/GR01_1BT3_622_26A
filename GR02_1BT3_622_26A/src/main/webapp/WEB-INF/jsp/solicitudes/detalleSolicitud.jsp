<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle Solicitud</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .badge-pendiente { background-color: #ffc107; } .badge-aprobada { background-color: #28a745; }
        .badge-rechazada { background-color: #dc3545; } .info-section { background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row">
            <div class="col-md-8">
                <h2>Solicitud #${solicitud.id}</h2>

                <c:if test="${not empty mensaje}">
                    <div class="alert alert-success">${mensaje}</div>
                </c:if>

                <div class="info-section">
                    <h4>Estado</h4>
                    <c:choose>
                        <c:when test="${solicitud.estado == 'Pendiente'}">
                            <span class="badge badge-pendiente">Pendiente</span>
                        </c:when>
                        <c:when test="${solicitud.estado == 'Aprobada'}">
                            <span class="badge badge-aprobada">Aprobada</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-rechazada">Rechazada</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="info-section">
                    <h5>Información del Usuario</h5>
                    <p><strong>Nombre:</strong> ${solicitud.usuario.nombre} ${solicitud.usuario.apellido}</p>
                    <p><strong>Email:</strong> ${solicitud.usuario.email}</p>
                    <p><strong>Teléfono:</strong> ${solicitud.usuario.telefono}</p>
                    <p><strong>Dirección:</strong> ${solicitud.usuario.direccion}, ${solicitud.usuario.ciudad}</p>
                </div>

                <div class="info-section">
                    <h5>Información de la Mascota</h5>
                    <p><strong>Nombre:</strong> ${solicitud.mascota.nombre}</p>
                    <p><strong>Tipo:</strong> ${solicitud.mascota.tipo}</p>
                    <p><strong>Raza:</strong> ${solicitud.mascota.raza}</p>
                    <p><strong>Edad:</strong> ${solicitud.mascota.edad} años</p>
                </div>

                <div class="info-section">
                    <h5>Detalles de la Solicitud</h5>
                    <p><strong>Fecha:</strong> <fmt:formatDate value="${solicitud.fechaSolicitud}" pattern="dd/MM/yyyy HH:mm"/></p>
                    <p><strong>Motivo:</strong> ${solicitud.motivo}</p>
                    <p><strong>Mascotas que tiene:</strong> ${solicitud.numeroMascotas}</p>
                    <p><strong>Tipo de Vivienda:</strong> ${solicitud.tipoVivienda}</p>
                    <p><strong>¿Tiene jardín?:</strong> <c:choose><c:when test="${solicitud.tieneJardin}">Sí</c:when><c:otherwise>No</c:otherwise></c:choose></p>
                </div>

                <div class="mt-4">
                    <c:if test="${solicitud.estado == 'Pendiente'}">
                        <form method="POST" action="/solicitudes/${solicitud.id}/aprobar" style="display: inline;">
                            <button type="submit" class="btn btn-success"><i class="fas fa-check"></i> Aprobar</button>
                        </form>

                        <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rechazarModal">
                            <i class="fas fa-times"></i> Rechazar
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para rechazar -->
    <div class="modal fade" id="rechazarModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="/solicitudes/${solicitud.id}/rechazar">
                    <div class="modal-header">
                        <h5 class="modal-title">Rechazar Solicitud</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <label for="razon" class="form-label">Razón del rechazo:</label>
                        <textarea class="form-control" id="razon" name="razon" rows="4" required></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-danger">Rechazar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

