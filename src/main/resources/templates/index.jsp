<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Adopciones - Inicio</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --dark-color: #2C3E50;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .hero {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 100px 20px;
            text-align: center;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .hero-content {
            max-width: 700px;
        }

        .hero h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .hero p {
            font-size: 1.3rem;
            margin-bottom: 30px;
            opacity: 0.95;
        }

        .hero-icon {
            font-size: 5rem;
            margin-bottom: 30px;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        .btn-hero {
            padding: 12px 40px;
            font-size: 1.1rem;
            margin: 10px;
        }

        .features {
            padding: 80px 20px;
            background-color: #f8f9fa;
        }

        .feature-card {
            text-align: center;
            padding: 40px 20px;
            border-radius: 10px;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            margin: 20px 0;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .feature-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .feature-title {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--dark-color);
            margin-bottom: 15px;
        }

        .feature-text {
            color: #666;
            line-height: 1.6;
        }

        .stats {
            padding: 60px 20px;
            background: linear-gradient(135deg, var(--dark-color) 0%, #34495e 100%);
            color: white;
        }

        .stat-item {
            text-align: center;
            padding: 20px;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            color: var(--secondary-color);
        }

        .stat-label {
            font-size: 1.1rem;
            margin-top: 10px;
        }

        .cta-section {
            padding: 80px 20px;
            text-align: center;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
        }

        .cta-title {
            font-size: 2.5rem;
            margin-bottom: 30px;
            font-weight: bold;
        }

        footer {
            background-color: var(--dark-color);
            color: white;
            padding: 40px 20px;
            text-align: center;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
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
                        <a class="nav-link active" href="/">Inicio</a>
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
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <div class="hero-icon">
                <i class="fas fa-heart"></i>
            </div>
            <h1>Encuentra tu Mascota Ideal</h1>
            <p>Conectamos personas amorosas con mascotas que necesitan un hogar. Cada adopción es un segundo comienzo.</p>
            <div>
                <a href="/mascotas/disponibles" class="btn btn-light btn-hero">
                    <i class="fas fa-search"></i> Ver Disponibles
                </a>
                <a href="/mascotas/registrar" class="btn btn-outline-light btn-hero">
                    <i class="fas fa-plus"></i> Registrar Mascota
                </a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <h2 style="text-align: center; font-size: 2.5rem; margin-bottom: 60px; color: var(--dark-color);">
                ¿Por Qué Elegirnos?
            </h2>
            <div class="row">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-database"></i>
                        </div>
                        <div class="feature-title">Base de Datos Completa</div>
                        <div class="feature-text">
                            Tenemos un registro detallado de todas las mascotas disponibles para adopción con información completa de cada una.
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="feature-title">Proceso Seguro</div>
                        <div class="feature-text">
                            Contamos con un sistema de verificación garantizando que cada mascota vaya a un hogar seguro y responsable.
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-heart"></i>
                        </div>
                        <div class="feature-title">Amor y Cuidado</div>
                        <div class="feature-text">
                            Todas nuestras mascotas reciben amor, atención veterinaria y cuidados necesarios para su bienestar.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats">
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">150+</div>
                        <div class="stat-label">Mascotas Registradas</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">500+</div>
                        <div class="stat-label">Adopciones Exitosas</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">1000+</div>
                        <div class="stat-label">Familias Felices</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">24/7</div>
                        <div class="stat-label">Soporte Disponible</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <h2 class="cta-title">¿Listo para Cambiar una Vida?</h2>
            <p style="font-size: 1.2rem; margin-bottom: 30px;">
                Explora nuestro catálogo de mascotas maravillosas que están esperando un hogar amoroso.
            </p>
            <a href="/mascotas/disponibles" class="btn btn-light btn-lg">
                <i class="fas fa-arrow-right"></i> Comenzar Ahora
            </a>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row mb-4">
                <div class="col-md-4">
                    <h5>Sistema de Adopciones</h5>
                    <p>Conectando mascotas con hogares que las aman.</p>
                </div>
                <div class="col-md-4">
                    <h5>Enlaces Rápidos</h5>
                    <ul style="list-style: none; padding: 0;">
                        <li><a href="/mascotas/lista" style="color: white; text-decoration: none;">Todas las Mascotas</a></li>
                        <li><a href="/mascotas/disponibles" style="color: white; text-decoration: none;">Disponibles</a></li>
                        <li><a href="/mascotas/registrar" style="color: white; text-decoration: none;">Registrar Mascota</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Contacto</h5>
                    <p>
                        <i class="fas fa-phone"></i> +1 (555) 123-4567<br>
                        <i class="fas fa-envelope"></i> info@adopciones.com<br>
                        <i class="fas fa-map-marker-alt"></i> Calle Principal 123
                    </p>
                </div>
            </div>
            <hr style="border-color: rgba(255,255,255,0.3);">
            <p>&copy; 2026 Sistema de Adopciones - Todos los derechos reservados</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

