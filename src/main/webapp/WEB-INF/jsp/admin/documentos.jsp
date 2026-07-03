<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Revisar Documentos - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --dark-color: #2C3E50;
            --panel-bg: #f8f9fa;
        }

        body { background: var(--panel-bg); }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
            background-color: rgba(255,255,255,0.08);
            border-left-color: var(--primary-color);
        }

        .content { padding: 28px 20px 40px; }

        .page-title {
            color: var(--dark-color);
            font-weight: 700;
            margin-bottom: 6px;
        }

        .panel-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 24px;
            margin-top: 24px;
        }

        .badge-Pendiente   { background-color: #ffc107; color: #000; }
        .badge-Verificado  { background-color: #198754; color: #fff; }
        .badge-Rechazado   { background-color: #dc3545; color: #fff; }

        .toast-container { z-index: 1080; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
        <span class="navbar-text text-white">
            <i class="fas fa-user-shield"></i> Panel de Administracion
        </span>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/jsp/admin/_sidebar.jsp">
            <jsp:param name="activo" value="documentos"/>
        </jsp:include>

        <main class="col-lg-10 content">
            <h1 class="page-title"><i class="fas fa-file-alt"></i> Revisar Documentos</h1>
            <p class="text-muted mb-4">Consulta y decide sobre los documentos cargados por un solicitante.</p>

            <!-- Formulario búsqueda por solicitanteId -->
            <form method="get" action="/admin/documentos" class="row g-3 align-items-end mb-2">
                <div class="col-auto">
                    <label for="solicitanteId" class="form-label fw-semibold">ID del Solicitante</label>
                    <input
                        type="number"
                        id="solicitanteId"
                        name="solicitanteId"
                        class="form-control"
                        placeholder="Ej: 1"
                        value="${solicitanteId != null ? solicitanteId : ''}"
                        min="1"
                        required
                    >
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-dark">
                        <i class="fas fa-search"></i> Buscar
                    </button>
                </div>
            </form>

            <!-- Tabla de documentos -->
            <c:if test="${solicitanteId != null}">
                <div class="panel-section">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="h5 mb-0">
                            Documentos del solicitante #${solicitanteId}
                        </h2>
                        <span class="badge bg-secondary">${documentos.size()} documento(s)</span>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Tipo de Documento</th>
                                <th>Nombre de Archivo</th>
                                <th>Estado</th>
                                <th class="text-end">Acciones</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty documentos}">
                                    <c:forEach var="doc" items="${documentos}">
                                        <tr>
                                            <td>#${doc.id}</td>
                                            <td>${doc.tipoDocumento}</td>
                                            <td>
                                                <i class="fas fa-file text-muted me-1"></i>
                                                ${doc.nombreArchivo}
                                            </td>
                                            <td>
                                                <span class="badge badge-${doc.estadoVerificacion}">
                                                    ${doc.estadoVerificacion}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-flex gap-2 justify-content-end">
                                                    <button
                                                        class="btn btn-success btn-sm"
                                                        onclick="verificarDoc(${doc.id}, 'Verificado')"
                                                    >
                                                        <i class="fas fa-check"></i> Verificar
                                                    </button>
                                                    <button
                                                        class="btn btn-danger btn-sm"
                                                        onclick="verificarDoc(${doc.id}, 'Rechazado')"
                                                    >
                                                        <i class="fas fa-times"></i> Rechazar
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                            <i class="fas fa-folder-open me-2"></i>
                                            Este solicitante no tiene documentos cargados.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </main>
    </div>
</div>

<!-- Toast notificación -->
<div class="toast-container position-fixed top-0 end-0 p-3">
    <div id="docToast" class="toast align-items-center border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body" id="docToastBody"></div>
            <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const toastEl = document.getElementById('docToast');
    const toastBody = document.getElementById('docToastBody');
    const toast = new bootstrap.Toast(toastEl);

    async function verificarDoc(documentoId, estado) {
        try {
            const url = '/api/documentos/' + documentoId + '/verificar?estado=' + encodeURIComponent(estado);
            const response = await fetch(url);
            const data = await response.json();

            if (response.ok) {
                toastEl.classList.remove('text-bg-danger');
                toastEl.classList.add('text-bg-success');
                toastBody.textContent = data.mensaje + ' — estado: ' + estado;
                toast.show();
                setTimeout(() => window.location.reload(), 900);
            } else {
                toastEl.classList.remove('text-bg-success');
                toastEl.classList.add('text-bg-danger');
                toastBody.textContent = 'Error: ' + (data.error || 'No se pudo actualizar el documento');
                toast.show();
            }
        } catch (err) {
            toastEl.classList.remove('text-bg-success');
            toastEl.classList.add('text-bg-danger');
            toastBody.textContent = 'Error de conexión: ' + err.message;
            toast.show();
        }
    }
</script>
</body>
</html>
