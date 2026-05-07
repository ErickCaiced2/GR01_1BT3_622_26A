<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Solicitante - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .form-container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .form-title { color: var(--primary-color); margin-bottom: 30px; font-weight: bold; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="/">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="/mascotas/disponibles">Mascotas</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="form-container">
                    <h2 class="form-title text-center">
                        <i class="fas fa-user-edit"></i> Editar Información
                    </h2>

                    <form:form method="post"
                               action="/solicitantes/${solicitante.id}/actualizar"
                               modelAttribute="solicitante"
                               novalidate="novalidate">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nombre *</label>
                                <form:input path="nombre" class="form-control" required="required"/>
                                <form:errors path="nombre" cssClass="text-danger small"/>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Apellido *</label>
                                <form:input path="apellido" class="form-control" required="required"/>
                                <form:errors path="apellido" cssClass="text-danger small"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email *</label>
                                <form:input path="email" type="email" class="form-control" required="required"/>
                                <form:errors path="email" cssClass="text-danger small"/>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Teléfono *</label>
                                <form:input path="telefono" class="form-control" required="required"/>
                                <form:errors path="telefono" cssClass="text-danger small"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Tipo de Documento</label>
                                <form:select path="tipoDocumento" class="form-select">
                                    <form:option value="">Selecciona...</form:option>
                                    <form:option value="CC">Cédula de Ciudadanía</form:option>
                                    <form:option value="TI">Tarjeta de Identidad</form:option>
                                    <form:option value="Pasaporte">Pasaporte</form:option>
                                </form:select>
                            </div>
                            <div class="col-md-8 mb-3">
                                <label class="form-label">Número de Documento</label>
                                <form:input path="documentoIdentidad" class="form-control"/>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Dirección</label>
                            <form:input path="direccion" class="form-control"/>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ciudad</label>
                                <form:input path="ciudad" class="form-control"/>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha de Nacimiento</label>
                                <form:input path="fechaNacimiento" type="date" class="form-control"/>
                            </div>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                            <a href="/solicitantes/${solicitante.id}" class="btn btn-secondary me-md-2">
                                <i class="fas fa-times"></i> Cancelar
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

