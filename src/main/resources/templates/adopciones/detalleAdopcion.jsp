<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Adopción - Paws & Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a5490;
            --accent-color: #ff6b35;
            --success-color: #28a745;
            --light-bg: #f8f9fa;
        }

        body {
            background-color: var(--light-bg);
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, #0d3d7a 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, #0d3d7a 100%);
            color: white;
            padding: 30px;
            margin-bottom: 30px;
            border-radius: 8px;
        }

        .info-card {
            border-left: 4px solid var(--accent-color);
            margin-bottom: 20px;
            padding: 15px;
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .info-label {
            color: var(--primary-color);
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        .section-title {
            font-size: 18px;
            font-weight: bold;
            color: var(--primary-color);
            margin-top: 30px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--accent-color);
        }

        .btn-descarga-contrato {
            background: linear-gradient(135deg, var(--success-color) 0%, #1e7e34 100%);
            border: none;
            color: white;
            padding: 12px 25px;
            font-weight: bold;
            border-radius: 5px;
            transition: all 0.3s ease;
            display: inline-block;
            margin: 10px 0;
        }

        .btn-descarga-contrato:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            color: white;
            text-decoration: none;
        }

        .checklist-item {
            padding: 10px;
            margin-bottom: 8px;
            background-color: white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .checklist-item i {
            margin-right: 10px;
            font-size: 18px;
        }

        .checklist-item.completado i {
            color: var(--success-color);
        }

        .checklist-item.pendiente i {
            color: #ffc107;
        }

        .alert-info-contrato {
            background-color: #e7f3ff;
            border-left: 4px solid var(--primary-color);
            color: #003d99;
        }

        footer {
            background: var(--primary-color);
            color: white;
            padding: 20px 0;
            margin-top: 40px;
        }
    </style>
</head>
<body>
    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="fas fa-paw"></i> Paws & Home
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="/">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="/mascotas/lista">Mascotas</a></li>
                    <li class="nav-item"><a class="nav-link" href="/adopciones/lista">Adopciones</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="container mt-5 mb-5">
        <!--- HEADER -->
        <div class="header-section">
            <h1><i class="fas fa-handshake"></i> Detalle de Adopción</h1>
            <p class="mb-0">ID: <strong>${adopcion.id}</strong></p>
        </div>

        <!-- MENSAJES -->
        <c:if test="${not empty mensaje}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle"></i> ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- INFORMACIÓN DEL ADOPTANTE -->
        <div class="section-title">
            <i class="fas fa-user"></i> Información del Adoptante
        </div>
        <div class="row">
            <div class="col-md-6">
                <div class="info-card">
                    <span class="info-label">Nombre:</span>
                    ${adopcion.solicitante.nombre}
                </div>
                <div class="info-card">
                    <span class="info-label">Email:</span>
                    <a href="mailto:${adopcion.solicitante.email}">${adopcion.solicitante.email}</a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="info-card">
                    <span class="info-label">Teléfono:</span>
                    <a href="tel:${adopcion.solicitante.telefono}">${adopcion.solicitante.telefono}</a>
                </div>
                <div class="info-card">
                    <span class="info-label">Documento:</span>
                    ${adopcion.solicitante.documentoIdentidad}
                </div>
            </div>
        </div>

        <!-- INFORMACIÓN DE LA MASCOTA -->
        <div class="section-title">
            <i class="fas fa-paw"></i> Información de la Mascota
        </div>
        <div class="row">
            <div class="col-md-6">
                <div class="info-card">
                    <span class="info-label">Nombre:</span>
                    ${adopcion.mascota.nombre}
                </div>
                <div class="info-card">
                    <span class="info-label">Tipo:</span>
                    ${adopcion.mascota.tipo}
                </div>
                <div class="info-card">
                    <span class="info-label">Raza:</span>
                    ${adopcion.mascota.raza}
                </div>
            </div>
            <div class="col-md-6">
                <div class="info-card">
                    <span class="info-label">Edad:</span>
                    ${adopcion.mascota.edad} años
                </div>
                <div class="info-card">
                    <span class="info-label">Color:</span>
                    ${not empty adopcion.mascota.color ? adopcion.mascota.color : 'No especificado'}
                </div>
                <div class="info-card">
                    <span class="info-label">Descripción:</span>
                    ${not empty adopcion.mascota.descripcion ? adopcion.mascota.descripcion : 'Sin descripción'}
                </div>
            </div>
        </div>

        <!-- CHECKLIST DE DOCUMENTOS -->
        <div class="section-title">
            <i class="fas fa-clipboard-check"></i> Estado de Documentos
        </div>
        <div style="max-width: 400px;">
            <div class="checklist-item ${adopcion.contratoFirmado ? 'completado' : 'pendiente'}">
                <i class="fas ${adopcion.contratoFirmado ? 'fa-check-circle' : 'fa-clock'}"></i>
                <span>Contrato Firmado</span>
            </div>
            <div class="checklist-item ${adopcion.vacunasAplicadas ? 'completado' : 'pendiente'}">
                <i class="fas ${adopcion.vacunasAplicadas ? 'fa-check-circle' : 'fa-clock'}"></i>
                <span>Vacunas Aplicadas</span>
            </div>
            <div class="checklist-item ${adopcion.desparasitacion ? 'completado' : 'pendiente'}">
                <i class="fas ${adopcion.desparasitacion ? 'fa-check-circle' : 'fa-clock'}"></i>
                <span>Desparasitación</span>
            </div>
            <div class="checklist-item ${adopcion.microchipColocado ? 'completado' : 'pendiente'}">
                <i class="fas ${adopcion.microchipColocado ? 'fa-check-circle' : 'fa-clock'}"></i>
                <span>Microchip</span>
            </div>
        </div>

        <!-- DESCARGA DE CONTRATO -->
        <div class="alert alert-info-contrato mt-4">
            <p><i class="fas fa-file-pdf"></i> <strong>Contrato PDF:</strong> Descargue el contrato formal de adopción</p>
        </div>
        <div style="text-align: center; margin: 30px 0;">
            <button class="btn-descarga-contrato" id="btnDescargarContrato" onclick="descargarContrato(${adopcion.id})">
                <i class="fas fa-download"></i> Descargar Contrato PDF
            </button>
        </div>

        <!-- BOTONES DE ACCIÓN -->
        <div style="text-align: center; margin-top: 30px;">
            <a href="/adopciones/lista" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Volver a Lista
            </a>
        </div>
    </div>

    <!-- FOOTER -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Paws & Home</h5>
                    <p>🐾 Sistema de Adopciones Responsables</p>
                </div>
                <div class="col-md-6 text-end">
                    <p>&copy; 2026 Todos los derechos reservados</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- SCRIPTS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function descargarContrato(adopcionId) {
            const btnDescargar = document.getElementById('btnDescargarContrato');
            btnDescargar.disabled = true;
            btnDescargar.textContent = '⏳ Generando PDF...';

            fetch(`/adopciones/${adopcionId}/contrato/descargar`, { method: 'GET' })
                .then(response => response.ok ? response.blob() : Promise.reject(response))
                .then(blob => {
                    const url = window.URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = `contrato_adopcion_${adopcionId}.pdf`;
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                    window.URL.revokeObjectURL(url);
                    mostrarAlerta('PDF descargado correctamente', 'success');
                })
                .catch(error => mostrarAlerta('Error al descargar: ' + error.statusText, 'danger'))
                .finally(() => {
                    btnDescargar.disabled = false;
                    btnDescargar.textContent = '📥 Descargar Contrato PDF';
                });
        }

        function mostrarAlerta(mensaje, tipo) {
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${tipo} alert-dismissible fade show`;
            alertDiv.innerHTML = `${mensaje}<button type="button" class="btn-close" data-bs-dismiss="alert"></button>`;
            document.querySelector('.container').insertBefore(alertDiv, document.querySelector('.container').firstChild);
            setTimeout(() => alertDiv.remove(), 5000);
        }
    </script>
</body>
</html>

