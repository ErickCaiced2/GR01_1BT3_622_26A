<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil de Usuario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .info-section { background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
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
                <h2>Perfil de ${usuario.nombre} ${usuario.apellido}</h2>

                <c:if test="${not empty mensaje}">
                    <div class="alert alert-success">${mensaje}</div>
                </c:if>

                <div class="info-section">
                    <h5>Información Personal</h5>
                    <p><strong>Email:</strong> ${usuario.email}</p>
                    <p><strong>Teléfono:</strong> ${usuario.telefono}</p>
                    <p><strong>Documento:</strong> ${usuario.documentoIdentidad}</p>
                    <p><strong>Tipo Documento:</strong> ${usuario.tipoDocumento}</p>
                </div>

                <div class="info-section">
                    <h5>Información de Residencia</h5>
                    <p><strong>Dirección:</strong> ${usuario.direccion}</p>
                    <p><strong>Ciudad:</strong> ${usuario.ciudad}</p>
                </div>

                <div class="info-section">
                    <h5>Información General</h5>
                    <p><strong>Estado:</strong>
                        <c:if test="${usuario.estado == 'Activo'}">
                            <span class="badge bg-success">Activo</span>
                        </c:if>
                        <c:if test="${usuario.estado == 'Inactivo'}">
                            <span class="badge bg-secondary">Inactivo</span>
                        </c:if>
                    </p>
                    <p><strong>Fecha de Registro:</strong> ${usuario.fechaRegistro}</p>
                </div>

                <a href="/usuarios/${usuario.id}/editar" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Editar
                </a>
                <a href="/" class="btn btn-secondary">Volver</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

