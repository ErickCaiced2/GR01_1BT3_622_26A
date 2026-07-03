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
        <jsp:include page="/WEB-INF/jsp/admin/_sidebar.jsp">
            <jsp:param name="activo" value="dashboard"/>
        </jsp:include>

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
                                                <a href="/admin/documentos?solicitanteId=${solicitud.solicitante.id}"
                                                   class="btn btn-outline-secondary btn-sm">
                                                    <i class="fas fa-file-alt"></i> Documentos
                                                </a>
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
                <!-- Campo oculto para guardar el ID de la solicitud -->
                <input type="hidden" id="aprobarSolicitudId" value="">
                <div class="modal-body">
                    <p class="mb-3">Aprobaras la solicitud de <strong id="aprobarSolicitante"></strong>.</p>
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
                <!-- Campo oculto para guardar el ID de la solicitud -->
                <input type="hidden" id="rechazarSolicitudId" value="">
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

    // Usar event delegation para capturar clicks en botones
    document.addEventListener('click', function(event) {
        // Ignorar clicks en botones dentro de modales
        if (event.target.closest('.modal')) {
            return;
        }

        const buttonAprobar = event.target.closest('button[data-bs-target="#aprobarModal"]');
        if (buttonAprobar) {
            solicitudActual = buttonAprobar.getAttribute('data-solicitud-id');
            const solicitante = buttonAprobar.getAttribute('data-solicitante');
            console.log('✓ Botón de aprobación clickeado. ID:', solicitudActual, 'Solicitante:', solicitante);

            if (!solicitudActual || solicitudActual.trim() === '') {
                console.error('✗ ERROR: El atributo data-solicitud-id está vacío en el HTML');
                alert('Error: No se pudo obtener el ID de la solicitud. Revisa la consola.');
                return;
            }

            document.getElementById('aprobarSolicitudId').value = solicitudActual;
            document.getElementById('aprobarSolicitante').textContent = solicitante;
        }

        const buttonRechazar = event.target.closest('button[data-bs-target="#rechazarModal"]');
        if (buttonRechazar) {
            solicitudActual = buttonRechazar.getAttribute('data-solicitud-id');
            const solicitante = buttonRechazar.getAttribute('data-solicitante');
            console.log('✓ Botón de rechazo clickeado. ID:', solicitudActual, 'Solicitante:', solicitante);

            if (!solicitudActual || solicitudActual.trim() === '') {
                console.error('✗ ERROR: El atributo data-solicitud-id está vacío en el HTML');
                alert('Error: No se pudo obtener el ID de la solicitud. Revisa la consola.');
                return;
            }

            document.getElementById('rechazarSolicitudId').value = solicitudActual;
            document.getElementById('rechazarSolicitante').textContent = solicitante;
        }
    });

    // Event listeners para los modales - Guardar ID en campo oculto
    aprobarModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        if (!button) {
            console.warn('No relatedTarget en modal de aprobación');
            return;
        }
        const idCapturado = button.getAttribute('data-solicitud-id');
        console.log('✓ Modal de aprobación abierto. ID del botón:', idCapturado);

        // Guardar el ID en el campo oculto del form
        document.getElementById('aprobarSolicitudId').value = idCapturado;

        if (idCapturado) {
            solicitudActual = idCapturado;
        }
        document.getElementById('aprobarSolicitante').textContent = button.getAttribute('data-solicitante');
    });

    rechazarModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        if (!button) {
            console.warn('No relatedTarget en modal de rechazo');
            return;
        }
        const idCapturado = button.getAttribute('data-solicitud-id');
        console.log('✓ Modal de rechazo abierto. ID del botón:', idCapturado);

        // Guardar el ID en el campo oculto del form
        document.getElementById('rechazarSolicitudId').value = idCapturado;

        if (idCapturado) {
            solicitudActual = idCapturado;
        }
        document.getElementById('rechazarSolicitante').textContent = button.getAttribute('data-solicitante');
    });

    aprobarForm.addEventListener('submit', async function (event) {
        event.preventDefault();

        // Obtener el ID del campo oculto
        const fieldElement = document.getElementById('aprobarSolicitudId');
        let solicitudId = fieldElement ? fieldElement.value : '';

        // Limpiar espacios en blanco
        solicitudId = solicitudId.trim();

        console.log('=== APROBAR FORM SUBMIT ===');
        console.log('Valor del ID:', JSON.stringify(solicitudId));

        // Validación: ID debe tener valor
        if (!solicitudId || solicitudId === '') {
            alert('Error: No se pudo obtener el ID de la solicitud. Por favor, intenta nuevamente.');
            console.error('ID vacío. Valor del campo:', fieldElement.value);
            return;
        }

        const observaciones = document.getElementById('observacionesTexto').value.trim();
        const body = new URLSearchParams();
        if (observaciones) {
            body.append('observaciones', observaciones);
        }

        try {
            // Construir URL
            const url = '/solicitudes/' + solicitudId + '/aprobar';
            console.log('URL final:', url);
            await enviarCambioEstado(url, body);
            document.getElementById('estadoToastBody').textContent = 'Solicitud aprobada exitosamente.';
            toast.show();
            bootstrap.Modal.getInstance(aprobarModal).hide();
            setTimeout(() => window.location.reload(), 700);
        } catch (error) {
            console.error('Error en aprobación:', error);
            document.getElementById('estadoToastBody').textContent = 'Error: ' + error.message;
            toast.show();
        }
    });

    rechazarForm.addEventListener('submit', async function (event) {
        event.preventDefault();

        // Obtener el ID del campo oculto
        const fieldElement = document.getElementById('rechazarSolicitudId');
        let solicitudId = fieldElement ? fieldElement.value : '';

        // Limpiar espacios en blanco
        solicitudId = solicitudId.trim();

        console.log('=== RECHAZAR FORM SUBMIT ===');
        console.log('Valor del ID:', JSON.stringify(solicitudId));

        // Validación: ID debe tener valor
        if (!solicitudId || solicitudId === '') {
            alert('Error: No se pudo obtener el ID de la solicitud. Por favor, intenta nuevamente.');
            console.error('ID vacío. Valor del campo:', fieldElement.value);
            return;
        }

        const razon = document.getElementById('razonRechazo').value.trim();
        if (!razon) {
            alert('Debes ingresar una razón para rechazar la solicitud');
            return;
        }

        const body = new URLSearchParams();
        body.append('razon', razon);

        try {
            // Construir URL
            const url = '/solicitudes/' + solicitudId + '/rechazar';
            console.log('URL final:', url);
            await enviarCambioEstado(url, body);
            document.getElementById('estadoToastBody').textContent = 'Solicitud rechazada exitosamente.';
            toast.show();
            bootstrap.Modal.getInstance(rechazarModal).hide();
            setTimeout(() => window.location.reload(), 700);
        } catch (error) {
            console.error('Error en rechazo:', error);
            document.getElementById('estadoToastBody').textContent = 'Error: ' + error.message;
            toast.show();
        }
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
            const errorMsg = await response.text();
            throw new Error(errorMsg || 'No fue posible actualizar el estado');
        }
    }
</script>
</body>
</html>
