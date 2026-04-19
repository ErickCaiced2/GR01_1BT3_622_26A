<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulario de Solicitud - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .form-container { background: white; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="form-container">
                    <h2 class="mb-4">Solicitar Adopción</h2>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form method="POST" action="/solicitudes/crear">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="usuarioId" class="form-label">Usuario *</label>
                                <input type="number" class="form-control" id="usuarioId" name="usuarioId" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="mascotaId" class="form-label">Selecciona una Mascota *</label>
                                <select class="form-select" id="mascotaId" name="mascotaId" required>
                                    <option value="">-- Selecciona una mascota --</option>
                                    <c:forEach var="mascota" items="${mascotas}">
                                        <option value="${mascota.id}">${mascota.nombre} - ${mascota.tipo}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="motivo" class="form-label">¿Por qué quieres adoptar? *</label>
                            <textarea class="form-control" id="motivo" name="motivo" rows="4" required></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="numeroMascotas" class="form-label">¿Cuántas mascotas tienes? *</label>
                                <input type="number" class="form-control" id="numeroMascotas" name="numeroMascotas" min="0" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="tipoVivienda" class="form-label">Tipo de Vivienda *</label>
                                <select class="form-select" id="tipoVivienda" name="tipoVivienda" required>
                                    <option value="">-- Selecciona tipo --</option>
                                    <option value="Casa">Casa</option>
                                    <option value="Departamento">Departamento</option>
                                    <option value="Finca">Finca</option>
                                    <option value="Otro">Otro</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="tieneJardin" name="tieneJardin">
                                <label class="form-check-label" for="tieneJardin">¿Tienes jardín?</label>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-check-circle"></i> Enviar Solicitud
                            </button>
                            <a href="/" class="btn btn-secondary">Cancelar</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

