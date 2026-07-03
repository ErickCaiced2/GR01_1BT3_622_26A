<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizaciones de Bienestar - Admin</title>
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
            <jsp:param name="activo" value="bienestar"/>
        </jsp:include>

        <main class="col-lg-10 content">
            <h1 class="page-title"><i class="fas fa-heartbeat"></i> Actualizaciones de Bienestar</h1>
            <p class="text-muted mb-4">Seguimiento post-adopción reportado por los adoptantes.</p>

            <div class="panel-section">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="h5 mb-0">Actualizaciones registradas</h2>
                    <span class="badge bg-secondary">${actualizaciones.size()} registro(s)</span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Adopción</th>
                            <th>Adoptante</th>
                            <th>Mascota</th>
                            <th>Estado</th>
                            <th>Comentario</th>
                            <th>Fecha</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty actualizaciones}">
                                <c:forEach var="actualizacion" items="${actualizaciones}">
                                    <tr>
                                        <td>#${actualizacion.id}</td>
                                        <td>#${actualizacion.adopcion.id}</td>
                                        <td>
                                            ${actualizacion.adopcion.solicitante.nombre}
                                            ${actualizacion.adopcion.solicitante.apellido}
                                        </td>
                                        <td>${actualizacion.adopcion.mascota.nombre}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${actualizacion.estadoMascota == 'Con problemas'}">
                                                    <span class="badge bg-danger">${actualizacion.estadoMascota}</span>
                                                </c:when>
                                                <c:when test="${actualizacion.estadoMascota == 'Feliz'}">
                                                    <span class="badge bg-success">${actualizacion.estadoMascota}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">${actualizacion.estadoMascota}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${actualizacion.comentario}</td>
                                        <td>${actualizacion.fechaRegistro}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">
                                        <i class="fas fa-info-circle me-2"></i>
                                        Aún no hay actualizaciones de bienestar registradas.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
