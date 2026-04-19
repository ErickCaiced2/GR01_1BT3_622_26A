<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${mascota.nombre} - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --dark-color: #2C3E50;
        }

        body {
            background-color: #f8f9fa;
        }

        .detail-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .gallery-main {
            height: 400px;
            background-color: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-bottom: 2px solid #f0f0f0;
        }

        .gallery-main i {
            font-size: 5rem;
            color: #999;
        }

        .gallery-thumbnails {
            display: flex;
            gap: 10px;
            padding: 15px;
            background-color: #f8f9fa;
            overflow-x: auto;
        }

        .thumbnail {
            width: 80px;
            height: 80px;
            background-color: #e0e0e0;
            border-radius: 5px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: border-color 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .thumbnail:hover, .thumbnail.active {
            border-color: var(--primary-color);
        }

        .thumbnail i {
            font-size: 2rem;
            color: #999;
        }

        .info-section {
            padding: 30px;
        }

        .mascota-header {
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }

        .mascota-nombre {
            font-size: 2.5rem;
            color: var(--dark-color);
            font-weight: bold;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }

        .info-item {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid var(--primary-color);
        }

        .info-label {
            font-size: 0.85rem;
            color: #666;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 1.1rem;
            color: var(--dark-color);
            font-weight: 600;
        }

        .description {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid var(--secondary-color);
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn-action {
            flex: 1;
            min-width: 150px;
        }

        .upload-section {
            margin-top: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            border: 2px dashed var(--primary-color);
        }

        .badge-disponible {
            background-color: #28a745;
        }

        .badge-adoptado {
            background-color: #007bff;
        }

        .badge-proceso {
            background-color: #ffc107;
            color: #000;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="fas fa-paw"></i> Sistema de Adopciones
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/mascotas/lista">Mascotas</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/mascotas/disponibles">Disponibles</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/mascotas/registrar">Registrar Mascota</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <!-- Mensajes -->
        <c:if test="${param.exito != null}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong><i class="fas fa-check-circle"></i> ¡Éxito!</strong> Operación realizada correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong><i class="fas fa-exclamation-circle"></i> Error!</strong> Ocurrió un problema.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="detail-container">
            <div class="row">
                <!-- Galería -->
                <div class="col-md-5">
                    <div class="gallery-main" id="galeryMain">
                        <i class="fas fa-image"></i>
                    </div>

                    <c:if test="${not empty fotos}">
                        <div class="gallery-thumbnails">
                            <c:forEach var="foto" items="${fotos}">
                                <div class="thumbnail active" onclick="cambiarImagen(this)">
                                    <i class="fas fa-image"></i>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <!-- Información -->
                <div class="col-md-7 info-section">
                    <!-- Header -->
                    <div class="mascota-header">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h1 class="mascota-nombre">${mascota.nombre}</h1>
                                <c:choose>
                                    <c:when test="${mascota.estado == 'Disponible'}">
                                        <span class="badge badge-disponible" style="font-size: 1rem;">
                                            <i class="fas fa-check-circle"></i> Disponible
                                        </span>
                                    </c:when>
                                    <c:when test="${mascota.estado == 'Adoptado'}">
                                        <span class="badge badge-adoptado" style="font-size: 1rem;">
                                            <i class="fas fa-home"></i> Adoptado
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-proceso" style="font-size: 1rem;">
                                            <i class="fas fa-hourglass-half"></i> ${mascota.estado}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Grid de Información -->
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label"><i class="fas fa-tag"></i> Tipo</div>
                            <div class="info-value">${mascota.tipo}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label"><i class="fas fa-list"></i> Raza</div>
                            <div class="info-value">${not empty mascota.raza ? mascota.raza : 'Sin especificar'}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label"><i class="fas fa-birthday-cake"></i> Edad</div>
                            <div class="info-value">${mascota.edad} años</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label"><i class="fas fa-venus-mars"></i> Género</div>
                            <div class="info-value">
                                ${mascota.genero}
                                <c:if test="${mascota.genero == 'Macho'}">
                                    <i class="fas fa-mars" style="color: #007bff;"></i>
                                </c:if>
                                <c:if test="${mascota.genero == 'Hembra'}">
                                    <i class="fas fa-venus" style="color: #ff1493;"></i>
                                </c:if>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-label"><i class="fas fa-palette"></i> Color</div>
                            <div class="info-value">${not empty mascota.color ? mascota.color : 'Sin especificar'}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label"><i class="fas fa-weight"></i> Peso</div>
                            <div class="info-value">${not empty mascota.pesoKg ? mascota.pesoKg + ' kg' : 'Sin especificar'}</div>
                        </div>
                    </div>

                    <!-- Descripción -->
                    <c:if test="${not empty mascota.descripcion}">
                        <div class="description">
                            <h5><i class="fas fa-info-circle"></i> Descripción</h5>
                            <p>${mascota.descripcion}</p>
                        </div>
                    </c:if>

                    <!-- Fecha de Registro -->
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-calendar"></i> Fecha de Registro</div>
                        <div class="info-value">
                            <fmt:formatDate value="${mascota.fechaRegistro}" pattern="dd/MM/yyyy"/>
                        </div>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="action-buttons">
                        <a href="/mascotas/lista" class="btn btn-secondary btn-action">
                            <i class="fas fa-arrow-left"></i> Volver
                        </a>
                        <a href="/mascotas/editar/${mascota.id}" class="btn btn-warning btn-action">
                            <i class="fas fa-edit"></i> Editar
                        </a>
                        <form action="/mascotas/eliminar/${mascota.id}" method="POST" style="display:inline; flex: 1; min-width: 150px;"
                              onsubmit="return confirm('¿Está seguro de que desea eliminar esta mascota?');">
                            <button type="submit" class="btn btn-danger btn-action" style="width: 100%;">
                                <i class="fas fa-trash"></i> Eliminar
                            </button>
                        </form>
                    </div>

                    <!-- Sección de Carga de Fotos -->
                    <div class="upload-section">
                        <h5><i class="fas fa-cloud-upload-alt"></i> Cargar Nueva Foto</h5>
                        <form action="/mascotas/cargarFoto/${mascota.id}" method="POST" enctype="multipart/form-data" class="mt-3">
                            <div class="mb-3">
                                <input type="file" name="foto" class="form-control" accept="image/*" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-upload"></i> Subir Foto
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer style="background-color: var(--dark-color); color: white; padding: 20px 0; margin-top: 40px;">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Sistema de Adopciones</h5>
                    <p>Ayudando a encontrar el hogar perfecto para cada mascota</p>
                </div>
                <div class="col-md-6 text-end">
                    <p>&copy; 2026 Todos los derechos reservados</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cambiarImagen(elemento) {
            document.querySelectorAll('.thumbnail').forEach(el => el.classList.remove('active'));
            elemento.classList.add('active');
        }
    </script>
</body>
</html>

