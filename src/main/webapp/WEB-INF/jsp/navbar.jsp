<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Navbar Mejorada Profesional para Solicitantes -->
<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #FF6B6B 0%, #FF8E8E 50%, #4ECDC4 100%);
        --secondary-gradient: linear-gradient(135deg, #4ECDC4 0%, #44A08D 100%);
        --accent-color: #FF6B6B;
        --secondary-color: #4ECDC4;
        --dark-color: #2C3E50;
        --text-dark: #1a1a1a;
    }

    .navbar-adopciones {
        background: var(--primary-gradient);
        box-shadow: 0 4px 15px rgba(255, 107, 107, 0.2);
        padding: 1rem 0;
        transition: all 0.3s ease;
    }

    .navbar-adopciones.scrolled {
        padding: 0.5rem 0;
        box-shadow: 0 8px 25px rgba(0,0,0,0.15);
    }

    .navbar-adopciones .navbar-brand {
        font-size: 1.5rem;
        font-weight: 800;
        letter-spacing: -1px;
        transition: transform 0.3s ease;
    }

    .navbar-adopciones .navbar-brand:hover {
        transform: scale(1.05);
    }

    .navbar-adopciones .nav-link {
        font-weight: 600;
        margin: 0 10px;
        position: relative;
        transition: all 0.3s ease;
    }

    .navbar-adopciones .nav-link::after {
        content: '';
        position: absolute;
        bottom: -5px;
        left: 0;
        width: 0;
        height: 3px;
        background: white;
        transition: width 0.3s ease;
    }

    .navbar-adopciones .nav-link:hover::after {
        width: 100%;
    }

    /* User badge mejorado */
    .user-badge {
        display: flex;
        align-items: center;
        background: rgba(255,255,255,0.2);
        padding: 0.5rem 1rem;
        border-radius: 20px;
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .user-badge:hover {
        background: rgba(255,255,255,0.3);
    }

    .user-badge .user-avatar {
        width: 32px;
        height: 32px;
        background: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 0.75rem;
        color: #FF6B6B;
        font-weight: 700;
    }

    /* Dropdown mejorado */
    .dropdown-menu {
        background: rgba(255, 255, 255, 0.98);
        backdrop-filter: blur(10px);
        border: none;
        box-shadow: 0 8px 32px rgba(0,0,0,0.15);
        border-radius: 12px;
        padding: 0.5rem 0;
    }

    .dropdown-item {
        color: var(--dark-color);
        padding: 0.75rem 1.5rem;
        transition: all 0.2s ease;
        border-left: 3px solid transparent;
    }

    .dropdown-item:hover {
        background-color: #f0f9ff;
        border-left-color: #FF6B6B;
        padding-left: 1.8rem;
        color: #FF6B6B;
    }

    .dropdown-item i {
        margin-right: 0.75rem;
        width: 18px;
        text-align: center;
    }

    .dropdown-divider {
        margin: 0.5rem 0;
        opacity: 0.2;
    }

    /* Responsive */
    @media (max-width: 991px) {
        .navbar-adopciones .nav-link {
            padding: 0.75rem 0;
        }

        .navbar-adopciones .nav-link::after {
            display: none;
        }

        .user-badge {
            margin-top: 1rem;
            justify-content: center;
        }
    }
</style>

<nav class="navbar navbar-expand-lg navbar-dark navbar-adopciones sticky-top" id="navbar">
    <div class="container">
        <a class="navbar-brand" href="/">
            <i class="fas fa-paw"></i> <strong>Adopciones</strong>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="/mascotas/disponibles"><i class="fas fa-heart"></i> Mascotas Disponibles</a></li>
                <c:if test="${not empty sessionScope.solicitanteId}">
                    <li class="nav-item"><a class="nav-link" href="/solicitudes/mis-solicitudes"><i class="fas fa-file-alt"></i> Mis Solicitudes</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle user-badge" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <div class="user-avatar"><i class="fas fa-user"></i></div>
                            <span class="d-none d-md-inline">${sessionScope.nombre}</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="/solicitantes/perfil"><i class="fas fa-user-circle"></i> Mi Perfil</a></li>
                            <li><a class="dropdown-item" href="/solicitantes/documentos"><i class="fas fa-file-upload"></i> Documentación</a></li>
                            <li><a class="dropdown-item" href="/solicitudes/mis-solicitudes"><i class="fas fa-file-contract"></i> Mis Solicitudes</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/logout" style="color: #FF6B6B;"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                        </ul>
                    </li>
                </c:if>
                <c:if test="${empty sessionScope.solicitanteId}">
                    <li class="nav-item"><a class="nav-link btn btn-light text-primary" href="/login" style="margin: 5px; font-weight: 700;"><i class="fas fa-sign-in-alt"></i> Iniciar Sesión</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<script>
    window.addEventListener('scroll', () => {
        const navbar = document.getElementById('navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
</script>

