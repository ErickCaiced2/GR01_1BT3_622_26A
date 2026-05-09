<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Verificación de Documentos
    </title>

    <!-- Bootstrap -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"
    >

    <!-- Font Awesome -->
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    >

    <style>

        /*
         * 🔵 REFACTOR — T.2.5
         *
         * Vista alineada al diseño
         * visual existente del sistema.
         */

        :root {

            --primary-color: #FF6B6B;

            --secondary-color: #4ECDC4;
        }

        /*
         * Fondo general
         */
        body {

            background:
                    linear-gradient(
                            135deg,
                            var(--primary-color) 0%,
                            var(--secondary-color) 100%
                    );

            min-height: 100vh;
        }

        /*
         * Navbar sistema
         */
        .navbar {

            background:
                    linear-gradient(
                            135deg,
                            var(--primary-color) 0%,
                            var(--secondary-color) 100%
                    );
        }

        /*
         * Contenedor principal
         */
        .upload-container {

            background: white;

            padding: 40px;

            border-radius: 15px;

            box-shadow:
                    0 10px 40px rgba(0,0,0,0.2);
        }

        /*
         * Título principal
         */
        .upload-title {

            color: var(--primary-color);

            font-weight: bold;

            margin-bottom: 30px;
        }

        /*
         * Zona drag & drop
         */
        .drop-zone {

            border: 2px dashed var(--secondary-color);

            border-radius: 12px;

            padding: 50px;

            text-align: center;

            cursor: pointer;

            transition: all 0.3s ease;

            background-color: #f8f9fa;
        }

        /*
         * Hover visual
         */
        .drop-zone:hover {

            background-color: #e3f2fd;

            transform: translateY(-2px);
        }

        /*
         * Drag activo
         */
        .drop-zone.dragover {

            border-color: #28a745;

            background-color: #e8f5e9;

            box-shadow:
                    0 0 15px rgba(40,167,69,0.3);
        }

        /*
         * Tarjeta documento
         */
        .document-card {

            background: white;

            border-radius: 10px;

            padding: 15px;

            margin-bottom: 15px;

            box-shadow:
                    0 2px 8px rgba(0,0,0,0.1);

            border-left:
                    5px solid var(--secondary-color);
        }

        /*
         * Estados verificación
         */
        .verification-badge {

            padding: 6px 12px;

            border-radius: 20px;

            font-size: 12px;

            font-weight: bold;
        }

        .pending {

            background-color: #ffc107;

            color: #000;
        }

        .verified {

            background-color: #28a745;

            color: white;
        }

        .rejected {

            background-color: #dc3545;

            color: white;
        }

        /*
         * Barra progreso
         */
        .progress {

            height: 25px;

            border-radius: 10px;
        }

        /*
         * Responsive móvil
         */
        @media (max-width: 768px) {

            .upload-container {

                padding: 20px;
            }

            .drop-zone {

                padding: 25px;
            }
        }

    </style>

</head>

<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">

    <div class="container">

        <a class="navbar-brand" href="/">

            <i class="fas fa-paw"></i>

            Sistema de Adopciones
        </a>

    </div>

</nav>

<!-- Contenido -->
<div class="container my-5">

    <div class="row justify-content-center">

        <div class="col-md-10">

            <div class="upload-container">

                <!-- Título -->
                <h2 class="upload-title text-center">

                    <i class="fas fa-file-upload"></i>

                    Verificación de Documentos

                </h2>

                <!-- Mensajes -->
                <c:if test="${not empty mensaje}">

                    <div class="alert alert-success alert-dismissible fade show">

                        <i class="fas fa-check-circle"></i>

                        ${mensaje}

                        <button
                                type="button"
                                class="btn-close"
                                data-bs-dismiss="alert">
                        </button>

                    </div>

                </c:if>

                <!-- Drag & Drop -->
                <div

                        class="drop-zone"

                        id="dropZone"

                        role="button"

                        tabindex="0"

                        aria-label="Zona para subir documentos"
                >

                    <i
                            class="fas fa-cloud-upload-alt"
                            style="
                            font-size: 60px;
                            color: var(--secondary-color);
                        "
                    ></i>

                    <h4 class="mt-4">

                        Arrastra tus documentos aquí

                    </h4>

                    <p class="text-muted">

                        o haz clic para seleccionar archivos

                    </p>

                    <!-- Input oculto -->
                    <input

                            type="file"

                            id="fileInput"

                            hidden

                            multiple

                            accept="
                                image/png,
                                image/jpeg,
                                application/pdf
                            "
                    >

                </div>

                <!-- Barra progreso -->
                <div class="progress mt-4">

                    <div

                            class="progress-bar progress-bar-striped progress-bar-animated"

                            id="uploadProgress"

                            role="progressbar"

                            style="width: 0%;"

                            aria-valuemin="0"

                            aria-valuemax="100"
                    >

                        0%

                    </div>

                </div>

                <!-- Lista documentos -->
                <div class="mt-5">

                    <h4>

                        <i class="fas fa-folder-open"></i>

                        Documentos Cargados

                    </h4>

                    <div id="documentList">

                        <!-- Ejemplo -->
                        <div class="document-card">

                            <div>

                                <strong>
                                    cedula.pdf
                                </strong>

                                <br>

                                <small class="text-muted">

                                    Documento de identidad

                                </small>

                            </div>

                            <span class="verification-badge pending">

                                Pendiente

                            </span>

                        </div>

                    </div>

                </div>

                <!-- Botones -->
                <div class="d-grid gap-2 mt-4">

                    <a
                            href="/"
                            class="btn btn-outline-secondary"
                    >

                        <i class="fas fa-arrow-left"></i>

                        Volver al Inicio

                    </a>

                </div>

            </div>

        </div>

    </div>

</div>

<!-- Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- JS Upload -->
<script src="/js/document-upload.js"></script>

</body>
</html>