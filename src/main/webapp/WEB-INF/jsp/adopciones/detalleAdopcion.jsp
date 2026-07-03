<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle Adopción</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .info-section { background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        .check-item { margin: 10px 0; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
        </div>
    </nav>

    <div class="container my-5">
        <h2>Adopción #${adopcion.id}</h2>

        <c:if test="${not empty mensaje}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="info-section">
            <h5>Estado</h5>
            <span class="badge bg-info">${adopcion.estado}</span>
        </div>

        <div class="info-section">
            <h5>Información de Adopción</h5>
            <p><strong>Fecha:</strong> <fmt:formatDate value="${adopcion.fechaAdopcion}" pattern="dd/MM/yyyy"/></p>
            <p><strong>Adoptante:</strong> ${adopcion.solicitante.nombre} ${adopcion.solicitante.apellido}</p>
            <p><strong>Mascota:</strong> ${adopcion.mascota.nombre}</p>
        </div>

        <div class="info-section">
            <h5>Requisitos Completados</h5>
            <div class="check-item">
                <i class="fas fa-${adopcion.contratoFirmado ? 'check-circle text-success' : 'times-circle text-danger'}"></i>
                <span>Contrato Firmado</span>
            </div>
            <div class="check-item">
                <i class="fas fa-${adopcion.vacunasAplicadas ? 'check-circle text-success' : 'times-circle text-danger'}"></i>
                <span>Vacunas Aplicadas</span>
            </div>
            <div class="check-item">
                <i class="fas fa-${adopcion.desparasitacion ? 'check-circle text-success' : 'times-circle text-danger'}"></i>
                <span>Desparasitación</span>
            </div>
            <div class="check-item">
                <i class="fas fa-${adopcion.microchipColocado ? 'check-circle text-success' : 'times-circle text-danger'}"></i>
                <span>Microchip Colocado</span>
            </div>
        </div>

        <c:if test="${not empty adopcion.observaciones}">
            <div class="info-section">
                <h5>Observaciones</h5>
                <p>${adopcion.observaciones}</p>
            </div>
        </c:if>

        <!-- HU15: Registro de actualización de bienestar -->
        <div class="info-section">
            <h5><i class="fas fa-heartbeat"></i> Registrar actualización de bienestar</h5>
            <form method="post" action="/adopciones/${adopcion.id}/bienestar">
                <div class="mb-3">
                    <label for="estadoMascota" class="form-label">¿Cómo está ${adopcion.mascota.nombre}?</label>
                    <select class="form-select" id="estadoMascota" name="estadoMascota" required>
                        <option value="Feliz">😊 Feliz</option>
                        <option value="Adaptándose">🤔 Adaptándose</option>
                        <option value="Con problemas">😟 Con problemas</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="comentario" class="form-label">Comentario</label>
                    <textarea class="form-control" id="comentario" name="comentario" rows="3"
                              placeholder="Cuéntanos cómo va la adaptación, salud, comportamiento..."></textarea>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i> Registrar actualización
                </button>
            </form>
        </div>

        <!-- HU15: Historial de actualizaciones de bienestar -->
        <c:if test="${not empty actualizacionesBienestar}">
            <div class="info-section">
                <h5><i class="fas fa-history"></i> Historial de bienestar</h5>
                <c:forEach var="actualizacion" items="${actualizacionesBienestar}">
                    <div class="border-start border-3 border-info ps-3 mb-3">
                        <p class="mb-1">
                            <span class="badge bg-info">${actualizacion.estadoMascota}</span>
                            <small class="text-muted">${actualizacion.fechaRegistro}</small>
                        </p>
                        <c:if test="${not empty actualizacion.comentario}">
                            <p class="mb-1">${actualizacion.comentario}</p>
                        </c:if>
                        <c:if test="${not empty actualizacion.respuestaAdmin}">
                            <div class="alert alert-secondary mt-2 mb-0">
                                <strong>Respuesta del refugio:</strong> ${actualizacion.respuestaAdmin}
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <a href="/adopciones/lista" class="btn btn-secondary">Volver</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

