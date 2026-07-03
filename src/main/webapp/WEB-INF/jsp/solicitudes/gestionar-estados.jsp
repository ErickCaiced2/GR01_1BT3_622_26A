<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Token CSRF para peticiones POST -->
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>Gestionar Estados - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
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

        .page-title { color: var(--dark-color); font-weight: 700; margin-bottom: 12px; }
        .page-subtitle { color: #6c757d; margin-bottom: 22px; }
        .panel-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 18px;
            margin-top: 18px;
        }
        .action-group { display: flex; gap: 8px; flex-wrap: wrap; }
        .toast-container { z-index: 1080; }
        .modal-header.approve { background: #eaf7ef; }
        .modal-header.reject { background: #fdeeee; }

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
            <jsp:param name="activo" value="gestionar"/>
        </jsp:include>

        <main class="col-lg-10 content">
            <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                <div>
                    <h1 class="page-title"><i class="fas fa-tasks"></i> Gestionar estados de solicitudes</h1>
                    <p class="page-subtitle">Filtra por estado, fecha o solicitante y actualiza sin salir de la pantalla.</p>
                </div>
                <a href="/admin/dashboard" class="btn btn-dark">
                    <i class="fas fa-arrow-left"></i> Volver al dashboard
                </a>
            </div>

    <section class="panel-section">
        <form method="get" action="/admin/solicitudes/gestionar" class="row g-3 align-items-end">
            <div class="col-md-4">
                <label for="estado" class="form-label">Estado</label>
                <select id="estado" name="estado" class="form-select">
                    <c:forEach var="opcion" items="${estadosDisponibles}">
                        <option value="${opcion}" <c:if test="${opcion == estadoSeleccionado}">selected</c:if>>${opcion}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <label for="fecha" class="form-label">Fecha</label>
                <input type="date" id="fecha" name="fecha" class="form-control" value="${fechaSeleccionada}">
            </div>
            <div class="col-md-3">
                <label for="solicitante" class="form-label">Solicitante</label>
                <input type="text" id="solicitante" name="solicitante" class="form-control" value="${solicitanteSeleccionado}" placeholder="Nombre o correo">
            </div>
            <div class="col-md-2 d-grid gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-filter"></i> Filtrar
                </button>
            </div>
        </form>
    </section>

    <section class="panel-section">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
            <div>
                <h2 class="h5 mb-1">Resultados</h2>
                <p class="text-muted mb-0">Estado seleccionado: <strong>${estadoSeleccionado}</strong></p>
            </div>
            <span class="badge bg-dark">${solicitudes != null ? solicitudes.size() : 0} registros</span>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Solicitante</th>
                    <th>Mascota</th>
                    <th>Fecha</th>
                    <th>Estado</th>
                    <th class="text-end">Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty solicitudes}">
                        <c:forEach var="solicitud" items="${solicitudes}">
                            <tr>
                                <td>#${solicitud.id}</td>
                                <td>
                                    <div class="fw-semibold">${solicitud.solicitante.nombre}</div>
                                    <small class="text-muted">${solicitud.solicitante.email}</small>
                                </td>
                                <td>${solicitud.mascota.nombre}</td>
                                <td>${solicitud.fechaSolicitud}</td>
                                <td><span class="badge bg-secondary">${solicitud.estado}</span></td>
                                <td class="text-end">
                                    <div class="action-group justify-content-end">
                                        <a href="/admin/documentos?solicitanteId=${solicitud.solicitante.id}"
                                           class="btn btn-outline-secondary btn-sm">
                                            <i class="fas fa-file-alt"></i> Documentos
                                        </a>
                                        <c:if test="${solicitud.estado == 'Aprobada'}">
                                            <a href="/solicitudes/${solicitud.id}/contrato/descargar"
                                               class="btn btn-outline-success btn-sm"
                                               target="_blank">
                                                <i class="fas fa-file-pdf"></i> Contrato
                                            </a>
                                        </c:if>
                                        <c:if test="${solicitud.estado != 'En revisión'}">
                                            <button type="button"
                                                    class="btn btn-primary btn-sm"
                                                    data-solicitud-id="${solicitud.id}"
                                                    data-solicitante="${solicitud.solicitante.nombre}"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#revisionModal">
                                                <i class="fas fa-sync-alt"></i> A Revisión
                                            </button>
                                        </c:if>
                                        <c:if test="${solicitud.estado == 'En revisión'}">
                                            <button type="button"
                                                    class="btn btn-info btn-sm"
                                                    data-solicitud-id="${solicitud.id}"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#detalleModal">
                                                <i class="fas fa-eye"></i> Ver Detalles
                                            </button>
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
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">
                                No hay solicitudes para los filtros seleccionados.
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
            <div class="toast-body" id="estadoToastBody">Estado actualizado correctamente.</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
        </div>
    </div>
</div>

<div class="modal fade" id="revisionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="background: #e3f2fd;">
                <h5 class="modal-title"><i class="fas fa-sync-alt text-primary"></i> Enviar a Revisión</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <form id="revisionForm">
                <!-- Campo oculto para guardar el ID de la solicitud -->
                <input type="hidden" id="revisionSolicitudId" value="">
                <div class="modal-body">
                    <p class="mb-3">Enviarás a revisión la solicitud de <strong id="revisionSolicitante"></strong>.</p>
                    <div class="mb-3">
                        <label for="observacionesRevision" class="form-label">Observaciones (opcional)</label>
                        <textarea class="form-control" id="observacionesRevision" rows="3" placeholder="Agrega observaciones sobre la revisión"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Enviar a revisión</button>
                </div>
            </form>
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
            <form id="aprobarForm">
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
            <form id="rechazarForm">
                <!-- Campo oculto para guardar el ID de la solicitud -->
                <input type="hidden" id="rechazarSolicitudId" value="">
                <div class="modal-body">
                    <p class="mb-3">Rechazaras la solicitud de <strong id="rechazarSolicitante"></strong>.</p>
                    <div class="mb-3">
                        <label for="razonRechazo" class="form-label">Razon del rechazo</label>
                        <textarea class="form-control" id="razonRechazo" rows="4" required placeholder="Explica la razon del rechazo"></textarea>
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

<!-- Modal para Ver Detalles de la Solicitud -->
<div class="modal fade" id="detalleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header" style="background: #e3f5ff;">
                <h5 class="modal-title"><i class="fas fa-file-alt text-info"></i> Detalle de Solicitud</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body" id="detalleModalBody" style="max-height: 70vh; overflow-y: auto;">
                <div class="text-center">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Cargando...</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const revisionModal = document.getElementById('revisionModal');
    const aprobarModal = document.getElementById('aprobarModal');
    const rechazarModal = document.getElementById('rechazarModal');
    const revisionForm = document.getElementById('revisionForm');
    const aprobarForm = document.getElementById('aprobarForm');
    const rechazarForm = document.getElementById('rechazarForm');
    const toast = new bootstrap.Toast(document.getElementById('estadoToast'));
    let solicitudActual = null;

    // Obtener token CSRF del meta tag
    function getCsrfToken() {
        const token = document.querySelector('meta[name="_csrf"]');
        return token ? token.getAttribute('content') : '';
    }

    // Obtener header CSRF del meta tag
    function getCsrfHeader() {
        const header = document.querySelector('meta[name="_csrf_header"]');
        return header ? header.getAttribute('content') : 'X-CSRF-TOKEN';
    }

    // DEBUG: Verificar qué botones existen en la página
    console.log('Total de botones con data-solicitud-id:', document.querySelectorAll('[data-solicitud-id]').length);
    document.querySelectorAll('[data-solicitud-id]').forEach((btn, i) => {
        console.log(`Botón ${i}: ID="${btn.getAttribute('data-solicitud-id')}", Solicitante="${btn.getAttribute('data-solicitante')}"`)
    });

    // Usar event delegation para capturar clicks en botones (funciona incluso si se cargan dinámicamente)
    document.addEventListener('click', function(event) {
        // IMPORTANTE: Ignorar clicks en botones dentro de modales (para no resetear solicitudActual)
        if (event.target.closest('.modal')) {
            console.log('Click en modal ignorado - no resetear solicitudActual');
            return;
        }

        const clickedElement = event.target;
        console.log('Click detectado en:', clickedElement.tagName, clickedElement.className);

        const button = event.target.closest('button[data-bs-target="#revisionModal"]');
        if (button) {
            solicitudActual = button.getAttribute('data-solicitud-id');
            const solicitante = button.getAttribute('data-solicitante');
            console.log('✓ Botón de revisión clickeado. ID:', solicitudActual, 'Solicitante:', solicitante);

            if (!solicitudActual || solicitudActual.trim() === '') {
                console.error('✗ ERROR: El atributo data-solicitud-id está vacío en el HTML');
                console.log('HTML del botón:', button.outerHTML);
                alert('Error: No se pudo obtener el ID de la solicitud. Revisa la consola.');
                return;
            }

            document.getElementById('revisionSolicitante').textContent = solicitante;
        }

        const buttonAprobar = event.target.closest('button[data-bs-target="#aprobarModal"]');
        if (buttonAprobar) {
            solicitudActual = buttonAprobar.getAttribute('data-solicitud-id');
            const solicitante = buttonAprobar.getAttribute('data-solicitante');
            console.log('✓ Botón de aprobación clickeado. ID:', solicitudActual, 'Solicitante:', solicitante);

            if (!solicitudActual || solicitudActual.trim() === '') {
                console.error('✗ ERROR: El atributo data-solicitud-id está vacío en el HTML');
                console.log('HTML del botón:', buttonAprobar.outerHTML);
                alert('Error: No se pudo obtener el ID de la solicitud. Revisa la consola.');
                return;
            }

            document.getElementById('aprobarSolicitante').textContent = solicitante;
        }

        const buttonRechazar = event.target.closest('button[data-bs-target="#rechazarModal"]');
        if (buttonRechazar) {
            solicitudActual = buttonRechazar.getAttribute('data-solicitud-id');
            const solicitante = buttonRechazar.getAttribute('data-solicitante');
            console.log('✓ Botón de rechazo clickeado. ID:', solicitudActual, 'Solicitante:', solicitante);

            if (!solicitudActual || solicitudActual.trim() === '') {
                console.error('✗ ERROR: El atributo data-solicitud-id está vacío en el HTML');
                console.log('HTML del botón:', buttonRechazar.outerHTML);
                alert('Error: No se pudo obtener el ID de la solicitud. Revisa la consola.');
                return;
            }

            document.getElementById('rechazarSolicitante').textContent = solicitante;
        }
    });

    // Event listeners para los modales - Guardar ID en campo oculto
    revisionModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        if (!button) {
            console.warn('No relatedTarget en modal de revisión');
            return;
        }
        const idCapturado = button.getAttribute('data-solicitud-id');
        console.log('✓ Modal de revisión abierto. ID del botón:', idCapturado);

        // Guardar el ID en el campo oculto del form
        document.getElementById('revisionSolicitudId').value = idCapturado;

        if (idCapturado) {
            solicitudActual = idCapturado;
        }
        document.getElementById('revisionSolicitante').textContent = button.getAttribute('data-solicitante');
    });

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

    // Event listener para el modal de detalles
    const detalleModal = document.getElementById('detalleModal');
    detalleModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        if (!button) {
            console.warn('No relatedTarget en modal de detalles');
            return;
        }
        const idCapturado = button.getAttribute('data-solicitud-id');
        console.log('✓ Modal de detalles abierto. ID del botón:', idCapturado);

        if (!idCapturado || idCapturado.trim() === '') {
            console.error('✗ ERROR: El atributo data-solicitud-id está vacío');
            console.log('HTML del botón:', button.outerHTML);
            return;
        }

        // Llamar a la función para cargar los detalles
        cargarDetalleSolicitud(idCapturado);
    });

    revisionForm.addEventListener('submit', async function (event) {
        event.preventDefault();

        // Obtener el ID del campo oculto (releer directamente del DOM)
        const fieldElement = document.getElementById('revisionSolicitudId');
        let solicitudId = fieldElement ? fieldElement.value : '';

        // Limpiar espacios en blanco
        solicitudId = solicitudId.trim();

        console.log('=== REVISION FORM SUBMIT ===');
        console.log('Campo element existe?:', !!fieldElement);
        console.log('Valor crudo del campo:', JSON.stringify(fieldElement.value));
        console.log('Valor limpio:', JSON.stringify(solicitudId));
        console.log('Largo:', solicitudId.length);
        console.log('Es número?:', !isNaN(solicitudId));

        // Validación: ID debe tener valor
        if (!solicitudId || solicitudId === '') {
            alert('Error: No se pudo obtener el ID de la solicitud. Por favor, intenta nuevamente.');
            console.error('ID vacío. Valor del campo:', fieldElement.value);
            return;
        }

        const observaciones = document.getElementById('observacionesRevision').value.trim();
        const body = new URLSearchParams();
        if (observaciones) {
            body.append('observaciones', observaciones);
        }

        try {
            // Construir URL sin template strings
            const url = '/solicitudes/' + solicitudId + '/enviar-a-revision';
            console.log('URL final:', url);
            await enviarCambioEstado(url, body);
            document.getElementById('estadoToastBody').textContent = 'Solicitud enviada a revisión exitosamente.';
            toast.show();
            bootstrap.Modal.getInstance(revisionModal).hide();
            setTimeout(() => window.location.reload(), 700);
        } catch (error) {
            console.error('Error en revisión:', error);
            document.getElementById('estadoToastBody').textContent = 'Error: ' + error.message;
            toast.show();
        }
    });

    aprobarForm.addEventListener('submit', async function (event) {
        event.preventDefault();

        // Obtener el ID del campo oculto (releer directamente del DOM)
        const fieldElement = document.getElementById('aprobarSolicitudId');
        let solicitudId = fieldElement ? fieldElement.value : '';

        // Limpiar espacios en blanco
        solicitudId = solicitudId.trim();

        console.log('=== APROBAR FORM SUBMIT ===');
        console.log('Campo element existe?:', !!fieldElement);
        console.log('Valor crudo del campo:', JSON.stringify(fieldElement.value));
        console.log('Valor limpio:', JSON.stringify(solicitudId));

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
            // Construir URL sin template strings
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

        // Obtener el ID del campo oculto (releer directamente del DOM)
        const fieldElement = document.getElementById('rechazarSolicitudId');
        let solicitudId = fieldElement ? fieldElement.value : '';

        // Limpiar espacios en blanco
        solicitudId = solicitudId.trim();

        console.log('=== RECHAZAR FORM SUBMIT ===');
        console.log('Campo element existe?:', !!fieldElement);
        console.log('Valor crudo del campo:', JSON.stringify(fieldElement.value));
        console.log('Valor limpio:', JSON.stringify(solicitudId));

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
            // Construir URL sin template strings
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

    // Función para cargar detalle de la solicitud
    async function cargarDetalleSolicitud(solicitudId) {
        console.log('🔍 cargarDetalleSolicitud() llamada con solicitudId:', solicitudId, 'tipo:', typeof solicitudId);
        const modalBody = document.getElementById('detalleModalBody');

        try {
            const url = '/solicitudes/' + solicitudId + '/api/detalle';
            console.log('📡 Haciendo fetch a:', url);
            const response = await fetch(url);
            if (!response.ok) throw new Error('No se pudo cargar el detalle');

            const solicitud = await response.json();

            // Renderizar el HTML del detalle
            let html = `
                <div class="mb-4">
                    <h6 class="text-primary mb-3"><i class="fas fa-user"></i> Información del Solicitante</h6>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Nombre Completo</small>
                            <p class="fw-bold">${solicitud.solicitante.nombre} ${solicitud.solicitante.apellido}</p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Email</small>
                            <p class="fw-bold">${solicitud.solicitante.email}</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Teléfono</small>
                            <p class="fw-bold">${solicitud.solicitante.telefono}</p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Documento</small>
                            <p class="fw-bold">${solicitud.solicitante.tipoDocumento}: ${solicitud.solicitante.documentoIdentidad}</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Dirección</small>
                            <p class="fw-bold">${solicitud.solicitante.direccion}</p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Ciudad</small>
                            <p class="fw-bold">${solicitud.solicitante.ciudad}</p>
                        </div>
                    </div>
                </div>

                <hr>

                <div class="mb-4">
                    <h6 class="text-info mb-3"><i class="fas fa-paw"></i> Mascota Solicitada</h6>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Nombre</small>
                            <p class="fw-bold">${solicitud.mascota.nombre}</p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Tipo</small>
                            <p class="fw-bold">${solicitud.mascota.tipo}</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Raza</small>
                            <p class="fw-bold">${solicitud.mascota.raza || 'N/A'}</p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Edad</small>
                            <p class="fw-bold">${solicitud.mascota.edad} años</p>
                        </div>
                    </div>
                </div>

                <hr>

                <div class="mb-4">
                    <h6 class="text-secondary mb-3"><i class="fas fa-clipboard-list"></i> Detalles de la Solicitud</h6>
                    <div class="mb-2">
                        <small class="text-muted">Motivo de Adopción</small>
                        <p class="fw-bold">${solicitud.motivo}</p>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Mascotas que posee</small>
                            <p class="fw-bold">${solicitud.numeroMascotas}</p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Tipo de Vivienda</small>
                            <p class="fw-bold">${solicitud.tipoVivienda}</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">¿Tiene Jardín?</small>
                            <p class="fw-bold">
                                ${solicitud.tieneJardin ? '<i class="fas fa-check-circle text-success"></i> Sí' : '<i class="fas fa-times-circle text-danger"></i> No'}
                            </p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <small class="text-muted">Fecha de Solicitud</small>
                            <p class="fw-bold">${solicitud.fechaSolicitud}</p>
                        </div>
                    </div>
                </div>
            `;

            modalBody.innerHTML = html;
        } catch (error) {
            console.error('Error cargando detalle:', error);
            modalBody.innerHTML = `<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> Error al cargar los detalles. Intenta nuevamente.</div>`;
        }
    }

    async function enviarCambioEstado(url, body) {
        const csrfToken = getCsrfToken();
        const csrfHeader = getCsrfHeader();
        const headers = {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        };

        // Agregar token CSRF si existe
        if (csrfToken) {
            headers[csrfHeader] = csrfToken;
        }

        const response = await fetch(url, {
            method: 'POST',
            headers: headers,
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
