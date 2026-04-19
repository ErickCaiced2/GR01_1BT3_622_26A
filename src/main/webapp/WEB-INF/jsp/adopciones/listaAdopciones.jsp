<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        table { border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
        </div>
    </nav>

    <div class="container my-5">
        <h2>${titulo != null ? titulo : 'Lista de Adopciones'}</h2>

        <c:if test="${not empty adopciones}">
            <div class="table-responsive">
                <table class="table table-hover table-striped">
                    <thead style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); color: white;">
                        <tr>
                            <th>ID</th>
                            <th>Usuario</th>
                            <th>Mascota</th>
                            <th>Estado</th>
                            <th>Fecha</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="adopcion" items="${adopciones}">
                            <tr>
                                <td>#${adopcion.id}</td>
                                <td>${adopcion.usuario.nombre}</td>
                                <td>${adopcion.mascota.nombre}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${adopcion.estado == 'Completada'}">
                                            <span class="badge bg-success">Completada</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-info">En Proceso</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${adopcion.fechaAdopcion}</td>
                                <td>
                                    <a href="/adopciones/${adopcion.id}" class="btn btn-sm btn-info text-white">
                                        <i class="fas fa-eye"></i> Ver
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <c:if test="${empty adopciones}">
            <div class="alert alert-info">
                <i class="fas fa-inbox"></i> No hay adopciones registradas
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

