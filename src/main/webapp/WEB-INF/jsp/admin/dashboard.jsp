<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --success-color: #198754;
            --warning-color: #f0ad4e;
            --danger-color: #dc3545;
            --dark-color: #2C3E50;
            --panel-bg: #f8f9fa;
        }

        body {
            background: var(--panel-bg);
        }

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

        .sidebar a:hover,
        .sidebar a.active {
            background-color: rgba(255, 255, 255, 0.08);
            border-left-color: var(--primary-color);
            color: #fff;
        }

        .content {
            padding: 28px 20px 40px;
        }

        .page-title {
            color: var(--dark-color);
            margin-bottom: 20px;
            font-weight: 700;
        }

        .page-subtitle {
            color: #6c757d;
            margin-bottom: 28px;
        }

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

        .stat-number {
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--dark-color);
            line-height: 1;
        }

        .stat-label {
            margin-top: 8px;
            color: #6c757d;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0;
        }

        .panel-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            padding: 18px;
            margin-top: 24px;
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
        }

        .table thead {
            background: #f8f9fa;
        }

        .table td,
        .table th {
            vertical-align: middle;
        }

        .action-group {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .toast-container {
            z-index: 1080;
        }

        .modal-header.approve {
            background: #eaf7ef;
        }

        .modal-header.reject {
            background: #fdeeee;
        }

        @media (max-width: 991px) {
            .sidebar {
                min-height: auto;
            }
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
            <a href="/admin/dashboard" class="active">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
            <a href="/admin/solicitudes/gestionar">
                <i class="fas fa-tasks"></i> Gestionar estados
            </a>
            <a href="/mascotas/lista">
                <i class="fas fa-list"></i> Lista de Mascotas
            </a>
            <a href="/mascotas/registrar">
                <i class="fas fa-plus-circle"></i> Registrar Mascota
            </a>
            <a href="/admin/reporte/mascotas">
                <i class="fas fa-chart-bar"></i> Reportes
            </a>
            <hr style="border-color: rgba(255,255,255,0.2);">
            <a href="/acceso">
                <i class="fas fa-home"></i> Ir al sitio
            </a>
        </aside>

        <main class="col-lg-10 content">
            <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                <div>
                    <h1 class="page-title"><i class="fas fa-tachometer-alt"></i> Dashboard de administracion</h1>
                    <p class="page-subtitle">Resumen operativo y solicitudes recientes en revision.</p>
                </div>
                <a href="/admin/solicitudes/gestionar" class="btn btn-dark">
                    <i class="fas fa-sliders-h"></i> Gestionar estados
                </a>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <div class="stat-card total">
                        <div class="stat-number">${totalMascotas != null ? totalMascotas : 0}</div>
                        <div class="stat-label"><i class="fas fa-paw"></i> Total de Mascotas</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card disponibles">
                        <div class="stat-number">${mascotasDisponiblesCount != null ? mascotasDisponiblesCount : 0}</div>
                        <div class="stat-label"><i class="fas fa-check-circle"></i> Disponibles</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card en-proceso">
                        <div class="stat-number">${mascotasEnProceso != null ? mascotasEnProceso : 0}</div>
                        <div class="stat-label"><i class="fas fa-hourglass-half"></i> En proceso</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card adoptados">
                        <div class="stat-number">${mascotasAdoptadas != null ? mascotasAdoptadas : 0}</div>
                        <div class="stat-label"><i class="fas fa-home"></i> Adoptadas</div>
                    </div>
                </div>
            </div>

            <section class="panel-section">
                <div class="panel-header">
                    <div>
                        <h2 class="h5 mb-1">Solicitudes pendientes</h2>
                        <p class="text-muted mb-0">Ultimas 10 solicitudes en estado En revision.</p>
                    </div>
                    <span class="badge bg-dark">${solicitudesPendientesCount != null ? solicitudesPendientesCount : 0} en revision</span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Solicitante</th>
                            <th>Mascota</th>
                            <th>Fecha</th>
                            <th>Motivo</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty solicitudesPendientes}">
                                <c:forEach var="solicitud" items="${solicitudesPendientes}">
                                    <tr>
                                        <td>#${solicitud.id}</td>
                                        <td>
                                            <div class="fw-semibold">${solicitud.solicitante.nombre}</div>
                                            <small class="text-muted">${solicitud.solicitante.email}</small>
                                        </td>
                                        <td>${solicitud.mascota.nombre}</td>
                                        <td>${solicitud.fechaSolicitud}</td>
                                        <td>${solicitud.motivo}</td>
                                        <td class="text-end">
                                            <div class="action-group justify-content-end">
                                                <button type="button"
                                                        class="btn btn-success btn-sm"
                                                        data-solicitud-id="${solicitud.id}"
                                                        data-solicitante="${solicitud.solicitante.nombre}"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#aprobarModal">
                                                    <i class="fas fa-check"></i> Aprobar
                                                </button>
                                                <button type="button"
                                                        class="btn btn-danger btn-sm"
                                                        data-solicitud-id="${solicitud.id}"
                                                        data-solicitante="${solicitud.solicitante.nombre}"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#rechazarModal">
                                                    <i class="fas fa-times"></i> Rechazar
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">
                                        No hay solicitudes en revision para mostrar.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</div>

<div class="toast-container position-fixed top-0 end-0 p-3">
    <div id="estadoToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body" id="estadoToastBody">
                Estado actualizado correctamente.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
        </div>
    </div>
</div>

<div class="modal fade" id="aprobarModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header approve">
                <h5 class="modal-title"><i class="fas fa-check text-success"></i> Aprobar solicitud</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <form id="aprobarForm" data-endpoint="/solicitudes" data-action="aprobar">
                <div class="modal-body">
                    <p class="mb-3">Aprobaras la solicitud de <strong id="aprobarSolicitante"></strong>.</p>
                    <input type="hidden" name="observaciones" id="aprobarObservaciones">
                    <div class="mb-3">
                        <label for="observacionesTexto" class="form-label">Observaciones opcionales</label>
                        <textarea class="form-control" id="observacionesTexto" rows="3" placeholder="Agrega una observacion breve"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-success">Confirmar aprobacion</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="rechazarModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header reject">
                <h5 class="modal-title"><i class="fas fa-times text-danger"></i> Rechazar solicitud</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <form id="rechazarForm" data-endpoint="/solicitudes" data-action="rechazar">
                <div class="modal-body">
                    <p class="mb-3">Rechazaras la solicitud de <strong id="rechazarSolicitante"></strong>.</p>
                    <div class="mb-3">
                        <label for="razonRechazo" class="form-label">Razon del rechazo</label>
                        <textarea class="form-control" id="razonRechazo" name="razon" rows="4" required placeholder="Explica la razon del rechazo"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-danger">Confirmar rechazo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const aprobarModal = document.getElementById('aprobarModal');
    const rechazarModal = document.getElementById('rechazarModal');
    const aprobarForm = document.getElementById('aprobarForm');
    const rechazarForm = document.getElementById('rechazarForm');
    const toast = new bootstrap.Toast(document.getElementById('estadoToast'));
    let solicitudActual = null;

    aprobarModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        solicitudActual = button.getAttribute('data-solicitud-id');
        document.getElementById('aprobarSolicitante').textContent = button.getAttribute('data-solicitante');
    });

    rechazarModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        solicitudActual = button.getAttribute('data-solicitud-id');
        document.getElementById('rechazarSolicitante').textContent = button.getAttribute('data-solicitante');
    });

    aprobarForm.addEventListener('submit', async function (event) {
        event.preventDefault();
        const observaciones = document.getElementById('observacionesTexto').value.trim();
        const body = new URLSearchParams();
        if (observaciones) {
            body.append('observaciones', observaciones);
        }

        await enviarCambioEstado(`/solicitudes/${solicitudActual}/aprobar`, body);
        document.getElementById('estadoToastBody').textContent = 'Solicitud aprobada exitosamente.';
        toast.show();
        bootstrap.Modal.getInstance(aprobarModal).hide();
        setTimeout(() => window.location.reload(), 700);
    });

    rechazarForm.addEventListener('submit', async function (event) {
        event.preventDefault();
        const razon = document.getElementById('razonRechazo').value.trim();
        if (!razon) {
            return;
        }

        const body = new URLSearchParams();
        body.append('razon', razon);

        await enviarCambioEstado(`/solicitudes/${solicitudActual}/rechazar`, body);
        document.getElementById('estadoToastBody').textContent = 'Solicitud rechazada exitosamente.';
        toast.show();
        bootstrap.Modal.getInstance(rechazarModal).hide();
        setTimeout(() => window.location.reload(), 700);
    });

    async function enviarCambioEstado(url, body) {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
            },
            body: body.toString()
        });

        if (!response.ok) {
            throw new Error('No fue posible actualizar el estado');
        }
    }
</script>
</body>
</html>
