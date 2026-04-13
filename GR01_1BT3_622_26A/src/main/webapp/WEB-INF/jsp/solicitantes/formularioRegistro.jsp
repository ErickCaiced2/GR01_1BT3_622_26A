<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Solicitante</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        body { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); min-height: 100vh; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .form-container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
        .form-title { color: var(--primary-color); margin-bottom: 30px; font-weight: bold; }
        .btn-register { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); border: none; color: white; font-weight: bold; }
        .btn-register:hover { transform: translateY(-2px); box-shadow: 0 5px 20px rgba(0,0,0,0.3); }
        .alert { border-radius: 10px; }
        .form-group label { color: #2C3E50; font-weight: 500; }
        .form-control:focus { border-color: var(--secondary-color); box-shadow: 0 0 0 0.2rem rgba(78, 205, 196, 0.25); }
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
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="form-container">
                    <h2 class="form-title text-center"><i class="fas fa-user-plus"></i> Registro de Solicitante</h2>

                    <form:form method="post" action="/solicitantes/registrar" modelAttribute="solicitante" novalidate="novalidate">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nombre" class="form-label">Nombre *</label>
                                <form:input path="nombre" class="form-control" placeholder="Ej: Juan Carlos" required="required"/>
                                <form:errors path="nombre" cssClass="text-danger small"/>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="apellido" class="form-label">Apellido *</label>
                                <form:input path="apellido" class="form-control" placeholder="Ej: García López" required="required"/>
                                <form:errors path="apellido" cssClass="text-danger small"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Email *</label>
                                <form:input path="email" type="email" class="form-control" placeholder="correo@example.com" required="required"/>
                                <form:errors path="email" cssClass="text-danger small"/>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="telefono" class="form-label">Teléfono *</label>
                                <form:input path="telefono" class="form-control" placeholder="320 123 4567" required="required"/>
                                <form:errors path="telefono" cssClass="text-danger small"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="tipoDocumento" class="form-label">Tipo de Documento *</label>
                                <form:select path="tipoDocumento" class="form-control" required="required">
                                    <form:option value="">Selecciona...</form:option>
                                    <form:option value="CC">Cédula de Ciudadanía</form:option>
                                    <form:option value="TI">Tarjeta de Identidad</form:option>
                                    <form:option value="Pasaporte">Pasaporte</form:option>
                                </form:select>
                                <form:errors path="tipoDocumento" cssClass="text-danger small"/>
                            </div>
                            <div class="col-md-8 mb-3">
                                <label for="documentoIdentidad" class="form-label">Número de Documento *</label>
                                <form:input path="documentoIdentidad" class="form-control" placeholder="123456789" required="required"/>
                                <form:errors path="documentoIdentidad" cssClass="text-danger small"/>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="direccion" class="form-label">Dirección *</label>
                            <form:input path="direccion" class="form-control" placeholder="Calle 1 # 2-3, Apt 4" required="required"/>
                            <form:errors path="direccion" cssClass="text-danger small"/>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="ciudad" class="form-label">Ciudad</label>
                                <form:input path="ciudad" class="form-control" placeholder="Bogotá"/>
                                <form:errors path="ciudad" cssClass="text-danger small"/>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="fechaNacimiento" class="form-label">Fecha de Nacimiento</label>
                                <form:input path="fechaNacimiento" type="date" class="form-control"/>
                                <form:errors path="fechaNacimiento" cssClass="text-danger small"/>
                            </div>
                        </div>

                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="aceptoTerminos" required>
                            <label class="form-check-label" for="aceptoTerminos">
                                Acepto los términos y condiciones *
                            </label>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-register btn-lg"><i class="fas fa-user-check"></i> Registrarme</button>
                            <a href="/" class="btn btn-outline-secondary"><i class="fas fa-arrow-left"></i> Volver</a>
                        </div>
                    </form:form>
                </div>

                <div class="alert alert-info mt-4" role="alert">
                    <i class="fas fa-info-circle"></i> <strong>Nota:</strong> Los campos marcados con * son obligatorios.
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

