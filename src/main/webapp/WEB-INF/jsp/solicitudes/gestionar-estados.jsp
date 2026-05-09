<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestionar Estados - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8f9fa; }
        .page-wrap { padding: 28px 20px 40px; }
        .page-title { color: #2C3E50; font-weight: 700; margin-bottom: 12px; }
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
    </style>
</head>
<body>
<div class="container-fluid page-wrap">
    <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-2">
                    <li class="breadcrumb-item"><a href="/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Gestionar estados</li>
                </ol>
            </nav>
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
                                No hay solicitudes para los filtros seleccionados.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </section>
</div>

<div class="toast-container position-fixed top-0 end-0 p-3">
    <div id="estadoToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body" id="estadoToastBody">Estado actualizado correctamente.</div>
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
            <form id="aprobarForm">
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
