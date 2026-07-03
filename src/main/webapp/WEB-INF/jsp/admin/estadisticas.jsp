<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estadísticas Generales - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --success-color: #198754;
            --warning-color: #f0ad4e;
            --dark-color: #2C3E50;
            --panel-bg: #f8f9fa;
        }

        body { background: var(--panel-bg); }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .sidebar {
            background-color: var(--dark-color);
            min-height: calc(100vh - 56px);
            padding-top: 20px;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 14px 20px;
            border-left: 3px solid transparent;
            transition: all 0.2s ease;
        }

        .sidebar a:hover, .sidebar a.active {
            background-color: rgba(255, 255, 255, 0.08);
            border-left-color: var(--primary-color);
        }

        .content { padding: 28px 20px 40px; }

        .page-title { color: var(--dark-color); font-weight: 700; margin-bottom: 6px; }
        .page-subtitle { color: #6c757d; margin-bottom: 28px; }

        .stat-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            padding: 22px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .stat-card.total { border-left-color: var(--primary-color); }
        .stat-card.disponibles { border-left-color: var(--success-color); }
        .stat-card.en-proceso { border-left-color: var(--warning-color); }
        .stat-card.adoptados { border-left-color: var(--secondary-color); }
        .stat-card.tasa { border-left-color: #6610f2; }

        .stat-number { font-size: 2.25rem; font-weight: 700; color: var(--dark-color); line-height: 1; }
        .stat-label { margin-top: 8px; color: #6c757d; text-transform: uppercase; font-size: 0.8rem; }

        .panel-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            padding: 18px;
            margin-top: 24px;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="/">
            <i class="fas fa-paw"></i> Sistema de Adopciones
        </a>
        <span class="navbar-text text-white">
            <i class="fas fa-user-shield"></i> Panel de Administracion
        </span>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <aside class="col-lg-2 sidebar">
            <a href="/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
            <a href="/admin/solicitudes/gestionar"><i class="fas fa-tasks"></i> Gestionar estados</a>
            <a href="/admin/documentos"><i class="fas fa-file-alt"></i> Documentos</a>
            <a href="/admin/bienestar"><i class="fas fa-heartbeat"></i> Bienestar</a>
            <a href="/admin/estadisticas" class="active"><i class="fas fa-chart-pie"></i> Estadísticas</a>
            <a href="/mascotas/lista"><i class="fas fa-list"></i> Lista de Mascotas</a>
            <a href="/mascotas/registrar"><i class="fas fa-plus-circle"></i> Registrar Mascota</a>
            <a href="/admin/reporte/mascotas"><i class="fas fa-chart-bar"></i> Reportes</a>
            <hr style="border-color: rgba(255,255,255,0.2);">
            <a href="/acceso"><i class="fas fa-home"></i> Ir al sitio</a>
        </aside>

        <main class="col-lg-10 content">
            <h1 class="page-title"><i class="fas fa-chart-pie"></i> Estadísticas Generales</h1>
            <p class="page-subtitle">Panorama completo de mascotas, solicitudes y adopciones del sistema.</p>

            <div class="row">
                <div class="col-md-3">
                    <div class="stat-card total">
                        <div class="stat-number">${estadisticasGenerales.total != null ? estadisticasGenerales.total : 0}</div>
                        <div class="stat-label"><i class="fas fa-paw"></i> Total de Mascotas</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card disponibles">
                        <div class="stat-number">${estadisticasGenerales.disponibles != null ? estadisticasGenerales.disponibles : 0}</div>
                        <div class="stat-label"><i class="fas fa-check-circle"></i> Disponibles</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card adoptados">
                        <div class="stat-number">${estadisticasGenerales.adopcionesCompletadas != null ? estadisticasGenerales.adopcionesCompletadas : 0}</div>
                        <div class="stat-label"><i class="fas fa-home"></i> Adopciones Completadas</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card tasa">
                        <div class="stat-number">${estadisticasGenerales.tasaAprobacion != null ? estadisticasGenerales.tasaAprobacion : 0}%</div>
                        <div class="stat-label"><i class="fas fa-percentage"></i> Tasa de Aprobación</div>
                    </div>
                </div>
            </div>

            <section class="panel-section">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="h5 mb-0">Solicitudes por estado</h2>
                    <span class="badge bg-dark">${estadisticasGenerales.totalSolicitudes} en total</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Estado</th>
                            <th class="text-end">Cantidad</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="entrada" items="${estadisticasGenerales.solicitudesPorEstado}">
                            <tr>
                                <td>${entrada.key}</td>
                                <td class="text-end">${entrada.value}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="panel-section">
                <h2 class="h5 mb-3">Mascota más solicitada</h2>
                <c:choose>
                    <c:when test="${not empty mascotaMasSolicitada}">
                        <p class="mb-0">
                            <i class="fas fa-star text-warning"></i>
                            <strong>${mascotaMasSolicitada.nombre}</strong>
                            (${mascotaMasSolicitada.tipo}<c:if test="${not empty mascotaMasSolicitada.raza}"> - ${mascotaMasSolicitada.raza}</c:if>)
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted mb-0">Aún no hay suficientes solicitudes para determinar una mascota más solicitada.</p>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
