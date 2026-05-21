<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
        .form-container { background: white; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px; }
        .error-field { border-color: #dc3545 !important; }
        .error-text { color: #dc3545; font-size: 0.875rem; margin-top: 0.25rem; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/navbar.jsp" />

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="form-container">
                    <h2 class="mb-4">Solicitar Adopción</h2>

                    <!-- TAREA 4: Mostrar errores generales -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <!-- TAREA 4: Mostrar errores de validación -->
                    <c:if test="${not empty solicitud}">
                        <form:errors path="solicitud" cssClass="alert alert-danger" element="div" />
                    </c:if>

                    <form:form method="POST" action="/solicitudes/crear" modelAttribute="solicitud">
                        <!-- TAREA 5: Campo usuarioId eliminado (se obtiene de sesión en TAREA 3) -->

                        <!-- Mostrar mascota pre-seleccionada o selector según corresponda -->
                        <c:choose>
                            <c:when test="${tieneMascotaPreSeleccionada}">
                                <!-- Mostrar información de la mascota pre-seleccionada (read-only) -->
                                <div class="mb-3">
                                    <label class="form-label"><strong>Mascota Seleccionada</strong></label>
                                    <div class="card p-3 bg-light">
                                        <div class="row">
                                            <div class="col-md-3 text-center">
                                                <c:if test="${not empty mascotaPreSeleccionada.fotos and mascotaPreSeleccionada.fotos.size() > 0}">
                                                    <img src="${mascotaPreSeleccionada.fotos[0].rutaFoto}" alt="${mascotaPreSeleccionada.nombre}" class="img-fluid rounded" style="max-height: 150px;">
                                                </c:if>
                                                <c:if test="${empty mascotaPreSeleccionada.fotos or mascotaPreSeleccionada.fotos.size() == 0}">
                                                    <i class="fas fa-paw fa-4x text-secondary"></i>
                                                </c:if>
                                            </div>
                                            <div class="col-md-9">
                                                <h5>${mascotaPreSeleccionada.nombre}</h5>
                                                <p class="mb-1"><strong>Tipo:</strong> ${mascotaPreSeleccionada.tipo}</p>
                                                <p class="mb-1"><strong>Raza:</strong> ${mascotaPreSeleccionada.raza}</p>
                                                <p class="mb-1"><strong>Edad:</strong> ${mascotaPreSeleccionada.edad} años</p>
                                                <p class="mb-1"><strong>Sexo:</strong> ${mascotaPreSeleccionada.genero}</p>
                                                <p class="mb-0"><strong>Descripción:</strong> ${mascotaPreSeleccionada.descripcion}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Campo oculto para enviar el ID de la mascota -->
                                    <form:hidden path="mascota.id" value="${mascotaPreSeleccionada.id}" />
                                </div>
                                <hr>
                            </c:when>
                            <c:otherwise>
                                <!-- Mostrar selector de mascotas -->
                                <div class="mb-3">
                                    <form:label path="mascota.id" cssClass="form-label">Selecciona una Mascota *</form:label>
                                    <form:select path="mascota.id" cssClass="form-select ${solicitud.mascota.id == null ? 'error-field' : ''}" required="required">
                                        <form:option value="">-- Selecciona una mascota --</form:option>
                                        <c:forEach var="mascota" items="${mascotas}">
                                            <form:option value="${mascota.id}">${mascota.nombre} - ${mascota.tipo}</form:option>
                                        </c:forEach>
                                    </form:select>
                                    <form:errors path="mascota.id" cssClass="error-text" element="div" />
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="mb-3">
                            <form:label path="motivo" cssClass="form-label">¿Por qué quieres adoptar? *</form:label>
                            <form:textarea path="motivo" cssClass="form-control ${not empty solicitud.motivo ? 'is-invalid' : ''}" rows="4" required="required" />
                            <form:errors path="motivo" cssClass="error-text" element="div" />
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <form:label path="numeroMascotas" cssClass="form-label">¿Cuántas mascotas tienes? *</form:label>
                                <form:input path="numeroMascotas" type="number" cssClass="form-control" min="0" required="required" />
                                <form:errors path="numeroMascotas" cssClass="error-text" element="div" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <form:label path="tipoVivienda" cssClass="form-label">Tipo de Vivienda *</form:label>
                                <form:select path="tipoVivienda" cssClass="form-select" required="required">
                                    <form:option value="">-- Selecciona tipo --</form:option>
                                    <form:option value="Casa">Casa</form:option>
                                    <form:option value="Departamento">Departamento</form:option>
                                    <form:option value="Finca">Finca</form:option>
                                    <form:option value="Otro">Otro</form:option>
                                </form:select>
                                <form:errors path="tipoVivienda" cssClass="error-text" element="div" />
                            </div>
                        </div>

                        <div class="mb-3">
                            <form:label path="tieneJardin" cssClass="form-label">¿Tienes jardín? *</form:label>
                            <div id="tieneJardinContainer">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" id="tieneJardinSi" name="tieneJardin" value="true" required>
                                    <label class="form-check-label" for="tieneJardinSi">
                                        <i class="fas fa-check-circle text-success"></i> Sí
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" id="tieneJardinNo" name="tieneJardin" value="false" required>
                                    <label class="form-check-label" for="tieneJardinNo">
                                        <i class="fas fa-times-circle text-danger"></i> No
                                    </label>
                                </div>
                            </div>
                            <!-- Sincronizar el valor con el campo oculto de Spring Form -->
                            <form:hidden path="tieneJardin" id="tieneJardinHidden" />
                            <small class="text-muted d-block mt-2">Por favor selecciona una opción</small>
                        </div>

                        <script>
                            // Sincronizar radio buttons con el campo hidden de Spring Form
                            document.getElementById('tieneJardinSi').addEventListener('change', function() {
                                if (this.checked) {
                                    document.getElementById('tieneJardinHidden').value = 'true';
                                }
                            });
                            document.getElementById('tieneJardinNo').addEventListener('change', function() {
                                if (this.checked) {
                                    document.getElementById('tieneJardinHidden').value = 'false';
                                }
                            });

                            // Sincronizar el valor inicial si existe
                            window.addEventListener('load', function() {
                                const hiddenValue = document.getElementById('tieneJardinHidden').value;
                                if (hiddenValue === 'true') {
                                    document.getElementById('tieneJardinSi').checked = true;
                                } else if (hiddenValue === 'false') {
                                    document.getElementById('tieneJardinNo').checked = true;
                                }
                            });
                        </script>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-check-circle"></i> Enviar Solicitud
                            </button>
                            <a href="/" class="btn btn-secondary">Cancelar</a>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

