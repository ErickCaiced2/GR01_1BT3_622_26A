<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle Solicitud de Adopción</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
        }
        body { background-color: #f5f7fa; }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            border-radius: 0 0 15px 15px;
        }

        .info-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            padding: 25px;
            margin-bottom: 20px;
            border-left: 5px solid var(--secondary-color);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .info-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
        }
        .info-card h5 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .info-card.estado {
            border-left-color: var(--warning-color);
            background: linear-gradient(135deg, rgba(255,255,255,1) 0%, rgba(255,193,7,0.05) 100%);
        }
        .info-card.solicitante {
            border-left-color: var(--primary-color);
        }
        .info-card.mascota {
            border-left-color: var(--secondary-color);
        }
        .info-card.detalles {
            border-left-color: #6c757d;
        }
        .badge-pendiente {
            background-color: var(--warning-color);
            color: #000;
            font-size: 1rem;
            padding: 10px 20px;
        }
        .badge-aprobada {
            background-color: var(--success-color);
            font-size: 1rem;
            padding: 10px 20px;
        }
        .badge-rechazada {
            background-color: var(--danger-color);
            font-size: 1rem;
            padding: 10px 20px;
        }
        .info-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 15px;
        }
        .info-item {
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 3px solid var(--secondary-color);
        }
        .info-item label {
            font-weight: 600;
            color: var(--primary-color);
            display: block;
            margin-bottom: 5px;
            font-size: 0.9rem;
        }
        .info-item p {
            margin: 0;
            color: #333;
            word-break: break-word;
        }
        .icon-box {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border-radius: 8px;
            font-size: 1.3rem;
        }
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .back-btn:hover {
            gap: 12px;
            color: var(--secondary-color);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/navbar.jsp" />

    <div class="page-header">
        <div class="container">
            <h1 class="mb-0">
                <i class="fas fa-file-alt"></i> Solicitud de Adopción #${solicitud.id}
            </h1>
        </div>
    </div>

    <div class="container my-5">
        <div class="row">
            <div class="col-lg-10">
                <a href="/" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Volver al inicio
                </a>

                <c:if test="${not empty mensaje}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- ESTADO -->
                <div class="info-card estado">
                    <h5>
                        <div class="icon-box">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        Estado de tu Solicitud
                    </h5>
                    <c:choose>
                        <c:when test="${solicitud.estado == 'Pendiente'}">
                            <span class="badge badge-pendiente">
                                <i class="fas fa-hourglass-half"></i> Pendiente de Revisión
                            </span>
                            <p class="mt-2 text-muted small">
                                Tu solicitud está siendo revisada. Nos pondremos en contacto pronto.
                            </p>
                        </c:when>
                        <c:when test="${solicitud.estado == 'Aprobada'}">
                            <span class="badge badge-aprobada">
                                <i class="fas fa-check-circle"></i> Aprobada
                            </span>
                            <p class="mt-2 text-muted small">
                                ¡Felicidades! Tu solicitud ha sido aprobada. Nos contactaremos contigo para los próximos pasos.
                            </p>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-rechazada">
                                <i class="fas fa-times-circle"></i> Rechazada
                            </span>
                            <p class="mt-2 text-muted small">
                                Lamentablemente, tu solicitud fue rechazada. Puedes contactarnos para más información.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- SOLICITANTE -->
                <div class="info-card solicitante">
                    <h5>
                        <div class="icon-box">
                            <i class="fas fa-user"></i>
                        </div>
                        Mi Información
                    </h5>
                    <div class="info-row">
                        <div class="info-item">
                            <label>Nombre Completo</label>
                            <p>${solicitud.solicitante.nombre} ${solicitud.solicitante.apellido}</p>
                        </div>
                        <div class="info-item">
                            <label>Correo Electrónico</label>
                            <p>${solicitud.solicitante.email}</p>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-item">
                            <label>Teléfono</label>
                            <p>${solicitud.solicitante.telefono}</p>
                        </div>
                        <div class="info-item">
                            <label>Ciudad</label>
                            <p>${solicitud.solicitante.ciudad}</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <label>Dirección</label>
                        <p>${solicitud.solicitante.direccion}</p>
                    </div>
                </div>

                <!-- MASCOTA -->
                <div class="info-card mascota">
                    <h5>
                        <div class="icon-box">
                            <i class="fas fa-heart"></i>
                        </div>
                        Mascota Solicitada
                    </h5>
                    <div class="info-row">
                        <div class="info-item">
                            <label>Nombre</label>
                            <p><strong>${solicitud.mascota.nombre}</strong></p>
                        </div>
                        <div class="info-item">
                            <label>Tipo</label>
                            <p>${solicitud.mascota.tipo}</p>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-item">
                            <label>Raza</label>
                            <p>${solicitud.mascota.raza}</p>
                        </div>
                        <div class="info-item">
                            <label>Edad</label>
                            <p>${solicitud.mascota.edad} años</p>
                        </div>
                    </div>
                </div>

                <!-- DETALLES -->
                <div class="info-card detalles">
                    <h5>
                        <div class="icon-box">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        Detalles de mi Solicitud
                    </h5>
                    <div class="info-item">
                        <label>Fecha de Solicitud</label>
                        <p>
                            <i class="fas fa-calendar"></i> ${solicitud.fechaSolicitud}
                        </p>
                    </div>
                    <div class="info-item" style="margin-top: 15px;">
                        <label>¿Por qué deseas adoptar?</label>
                        <p>${solicitud.motivo}</p>
                    </div>
                    <div class="info-row" style="margin-top: 15px;">
                        <div class="info-item">
                            <label>Mascotas que tienes</label>
                            <p>${solicitud.numeroMascotas}</p>
                        </div>
                        <div class="info-item">
                            <label>Tipo de Vivienda</label>
                            <p>${solicitud.tipoVivienda}</p>
                        </div>
                    </div>
                    <div class="info-item" style="margin-top: 15px;">
                        <label>¿Tienes Jardín?</label>
                        <p>
                            <c:choose>
                                <c:when test="${solicitud.tieneJardin}">
                                    <i class="fas fa-check-circle" style="color: var(--success-color);"></i> Sí
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-times-circle" style="color: var(--danger-color);"></i> No
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <!-- DESCARGA DE CONTRATO (Solo si está aprobada) -->
                <c:if test="${solicitud.estado == 'Aprobada'}">
                    <div class="mt-4 p-4 bg-success bg-opacity-10 rounded border border-success">
                        <p class="text-success mb-3">
                            <i class="fas fa-file-pdf"></i>
                            <strong>¡Solicitud Aprobada!</strong> Descarga tu contrato de adopción.
                        </p>
                        <a href="/solicitudes/${solicitud.id}/contrato/descargar" class="btn btn-success">
                            <i class="fas fa-download"></i> Descargar Contrato PDF
                        </a>
                    </div>
                </c:if>

                <!-- FOOTER -->
                <div class="mt-5 p-4 bg-light rounded text-center">
                    <p class="text-muted mb-3">
                        <i class="fas fa-info-circle"></i>
                        ¿Alguna duda? Contáctanos a través de nuestros canales de soporte.
                    </p>
                    <a href="/" class="btn btn-primary">
                        <i class="fas fa-home"></i> Volver al Inicio
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
