<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Navbar Compartida -->
<nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #FF6B6B 0%, #4ECDC4 100%); box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
    <div class="container">
        <a class="navbar-brand" href="/">
            <i class="fas fa-paw"></i> Sistema de Adopciones
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/">Inicio</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/mascotas/lista">Mascotas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/mascotas/disponibles">Disponibles</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/mascotas/registrar">Registrar Mascota</a>
                </li>
                <!-- Menú de Solicitante -->
                <c:if test="${not empty sessionScope.solicitanteId}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="solicitanteDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> Mi Perfil
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="solicitanteDropdown">
                            <li><a class="dropdown-item" href="/solicitantes/perfil"><i class="fas fa-user-circle"></i> Ver Perfil</a></li>
                            <li><a class="dropdown-item" href="/solicitantes/documentos"><i class="fas fa-file-upload"></i> Documentación</a></li>
                            <li><a class="dropdown-item" href="/solicitudes/mis-solicitudes"><i class="fas fa-list"></i> Mis Solicitudes</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                        </ul>
                    </li>
                </c:if>
                <c:if test="${empty sessionScope.solicitanteId}">
                    <li class="nav-item">
                        <a class="nav-link" href="/login"><i class="fas fa-sign-in-alt"></i> Iniciar Sesión</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

