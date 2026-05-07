<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Adopciones 🐾 - Conecta con tu Mascota Ideal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #FF6B6B 0%, #FF8E8E 50%, #4ECDC4 100%);
            --secondary-gradient: linear-gradient(135deg, #4ECDC4 0%, #44A08D 100%);
            --dark-gradient: linear-gradient(135deg, #2C3E50 0%, #34495e 100%);
            --accent-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --dark-color: #2C3E50;
            --light-color: #F8F9FA;
            --text-dark: #1a1a1a;
        }

        * {
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: var(--light-color);
            color: var(--text-dark);
            overflow-x: hidden;
        }

        /* NAVBAR MEJORADO */
        .navbar {
            background: var(--primary-gradient);
            box-shadow: 0 4px 15px rgba(255, 107, 107, 0.2);
            padding: 1rem 0;
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            padding: 0.5rem 0;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 800;
            letter-spacing: -1px;
            transition: transform 0.3s ease;
        }

        .navbar-brand:hover {
            transform: scale(1.05);
        }

        .nav-link {
            font-weight: 600;
            margin: 0 10px;
            position: relative;
            transition: all 0.3s ease;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 3px;
            background: white;
            transition: width 0.3s ease;
        }

        .nav-link:hover::after {
            width: 100%;
        }

        /* HERO SECTION MODERNA */
        .hero {
            background: var(--primary-gradient);
            color: white;
            padding: 100px 20px;
            text-align: center;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 120"><path d="M0,50 Q300,0 600,50 T1200,50 L1200,120 L0,120 Z" fill="rgba(255,255,255,0.1)"></path></svg>') repeat-x;
            animation: wave 15s linear infinite;
            opacity: 0.3;
        }

        @keyframes wave {
            0% { transform: translateX(0); }
            100% { transform: translateX(1200px); }
        }

        .hero-content {
            max-width: 800px;
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.8s ease;
        }

        .hero-icon {
            font-size: 6rem;
            margin-bottom: 30px;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-30px); }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero h1 {
            font-size: 4rem;
            margin-bottom: 20px;
            font-weight: 800;
            text-shadow: 3px 3px 6px rgba(0,0,0,0.15);
            letter-spacing: -2px;
        }

        .hero p {
            font-size: 1.4rem;
            margin-bottom: 40px;
            opacity: 0.98;
            font-weight: 300;
            line-height: 1.8;
        }

        .btn-hero {
            padding: 15px 45px;
            font-size: 1rem;
            margin: 10px;
            border-radius: 50px;
            font-weight: 700;
            border: 2px solid white;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-hero:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        /* FEATURES MEJORADO */
        .features {
            padding: 100px 20px;
            background-color: white;
        }

        .section-title {
            font-size: 2.8rem;
            font-weight: 800;
            margin-bottom: 70px;
            color: var(--dark-color);
            position: relative;
            display: inline-block;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--primary-gradient);
            border-radius: 2px;
        }

        .feature-card {
            text-align: center;
            padding: 50px 30px;
            border-radius: 15px;
            background: white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            margin: 20px 0;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .feature-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 15px 40px rgba(255, 107, 107, 0.2);
            border-color: var(--accent-color);
        }

        .feature-icon {
            font-size: 3.5rem;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 25px;
            transition: transform 0.3s ease;
        }

        .feature-card:hover .feature-icon {
            transform: scale(1.2) rotate(10deg);
        }

        .feature-title {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 15px;
        }

        .feature-text {
            color: #666;
            line-height: 1.8;
            font-weight: 400;
        }

        /* STATS SECTION CON ANIMACIÓN */
        .stats {
            padding: 80px 20px;
            background: var(--dark-gradient);
            color: white;
            position: relative;
            overflow: hidden;
        }

        .stat-item {
            text-align: center;
            padding: 30px;
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            transform: scale(1.1);
        }

        .stat-number {
            font-size: 3.5rem;
            font-weight: 800;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 1.1rem;
            margin-top: 10px;
            opacity: 0.9;
            font-weight: 500;
        }

        /* CTA SECTION */
        .cta-section {
            padding: 100px 20px;
            text-align: center;
            background: var(--secondary-gradient);
            color: white;
            position: relative;
            overflow: hidden;
        }

        .cta-title {
            font-size: 2.8rem;
            margin-bottom: 30px;
            font-weight: 800;
        }

        .cta-description {
            font-size: 1.2rem;
            margin-bottom: 40px;
            opacity: 0.95;
            font-weight: 300;
        }

        /* TESTIMONIOS SECCIÓN */
        .testimonials {
            padding: 100px 20px;
            background-color: white;
        }

        .testimonial-card {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            margin: 20px 0;
            transition: all 0.3s ease;
            border-left: 4px solid var(--accent-color);
        }

        .testimonial-card:hover {
            transform: translateX(10px);
            box-shadow: 0 12px 30px rgba(255, 107, 107, 0.15);
        }

        .testimonial-text {
            font-style: italic;
            color: #555;
            margin-bottom: 20px;
            line-height: 1.8;
        }

        .testimonial-author {
            font-weight: 700;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .testimonial-stars {
            color: #FFD700;
            margin-bottom: 10px;
        }

        /* FOOTER MEJORADO */
        footer {
            background: var(--dark-color);
            color: white;
            padding: 50px 20px;
            text-align: center;
        }

        .footer-section h5 {
            font-weight: 700;
            margin-bottom: 20px;
            color: var(--secondary-color);
        }

        .footer-section ul li {
            margin: 8px 0;
        }

        .footer-section a {
            color: #ddd;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .footer-section a:hover {
            color: var(--secondary-color);
            transform: translateX(5px);
            display: inline-block;
        }

        .social-links {
            margin: 20px 0;
        }

        .social-links a {
            display: inline-block;
            width: 40px;
            height: 40px;
            background: var(--accent-color);
            border-radius: 50%;
            line-height: 40px;
            margin: 0 10px;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            transform: translateY(-5px);
            background: var(--secondary-color);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .hero h1 { font-size: 2.5rem; }
            .hero p { font-size: 1.1rem; }
            .section-title { font-size: 2rem; }
            .cta-title { font-size: 2rem; }
        }

        /* SCROLL INDICATOR */
        .scroll-indicator {
            position: absolute;
            bottom: 40px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 2rem;
            animation: bounce 2s infinite;
            z-index: 1;
        }
    </style>
</head>
<body>
    <!-- Navbar Mejorado -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top" id="navbar">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="fas fa-paw"></i> <strong>Adopciones</strong>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link active" href="/">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="/mascotas/lista">Todas</a></li>
                    <li class="nav-item"><a class="nav-link" href="/mascotas/disponibles">Disponibles</a></li>
                    <li class="nav-item"><a class="nav-link" href="/mascotas/registrar">Registrar</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section Mejorado -->
    <section class="hero">
        <div class="hero-content">
            <div class="hero-icon"><i class="fas fa-heart"></i></div>
            <h1>Encuentra tu Mascota Ideal 🐾</h1>
            <p>Conectamos personas amorosas con mascotas que necesitan un hogar. Cada adopción es una segunda oportunidad.</p>
            <div>
                <a href="/mascotas/disponibles" class="btn btn-light btn-hero">
                    <i class="fas fa-search"></i> Explorar Mascotas
                </a>
                <a href="/mascotas/registrar" class="btn btn-outline-light btn-hero">
                    <i class="fas fa-plus"></i> Registrar Mascota
                </a>
            </div>
        </div>
        <div class="scroll-indicator"><i class="fas fa-chevron-down"></i></div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="container text-center">
            <h2 class="section-title">¿Por Qué Elegirnos?</h2>
            <div class="row mt-5">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-database"></i></div>
                        <div class="feature-title">Base de Datos Completa</div>
                        <div class="feature-text">
                            Registro detallado de todas las mascotas con información verificada sobre salud, edad y personalidad.
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-shield-alt"></i></div>
                        <div class="feature-title">Proceso Seguro y Verificado</div>
                        <div class="feature-text">
                            Sistema de verificación garantizando que cada mascota vaya a un hogar seguro y responsable.
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-heart"></i></div>
                        <div class="feature-title">Cuidado y Amor</div>
                        <div class="feature-text">
                            Todas nuestras mascotas reciben amor, atención veterinaria y cuidados necesarios para su bienestar total.
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
                        <div class="stat-number" data-count="150">0</div>
                        <div class="stat-label">🐕 Mascotas Registradas</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number" data-count="500">0</div>
                        <div class="stat-label">✨ Adopciones Exitosas</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number" data-count="1000">0</div>
                        <div class="stat-label">👨‍👩‍👧‍👦 Familias Felices</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">24/7</div>
                        <div class="stat-label">📞 Soporte Disponible</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonios Section -->
    <section class="testimonials">
        <div class="container">
            <h2 class="section-title text-center mb-5">Historias de Éxito</h2>
            <div class="row">
                <div class="col-md-4">
                    <div class="testimonial-card">
                        <div class="testimonial-stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <p class="testimonial-text">"¡Luna cambió nuestras vidas! Fue el mejor proceso de adopción que pudimos haber tenido."</p>
                        <div class="testimonial-author">
                            <i class="fas fa-user-circle"></i> María García
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="testimonial-card">
                        <div class="testimonial-stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <p class="testimonial-text">"El equipo es profesional y realmente se preocupa por el bienestar de los animales. ¡Muy recomendado!"</p>
                        <div class="testimonial-author">
                            <i class="fas fa-user-circle"></i> Carlos López
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="testimonial-card">
                        <div class="testimonial-stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <p class="testimonial-text">"Adoptar a Max fue la decisión más acertada. ¡Gracias por facilitar este proceso!"</p>
                        <div class="testimonial-author">
                            <i class="fas fa-user-circle"></i> Jennifer Rodríguez
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <h2 class="cta-title">¿Listo para Cambiar una Vida? 💙</h2>
            <p class="cta-description">
                Explora nuestro catálogo de mascotas maravillosas que están esperando un hogar amoroso.
            </p>
            <a href="/mascotas/disponibles" class="btn btn-light btn-lg" style="padding: 15px 50px; font-weight: 700;">
                <i class="fas fa-arrow-right"></i> Comenzar Ahora
            </a>
        </div>
    </section>

    <!-- Footer Mejorado -->
    <footer>
        <div class="container">
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="footer-section">
                        <h5>🐾 Sistema de Adopciones</h5>
                        <p>Conectando mascotas con hogares que las aman desde 2024.</p>
                        <div class="social-links">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-whatsapp"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="footer-section">
                        <h5>Enlaces Rápidos</h5>
                        <ul style="list-style: none; padding: 0;">
                            <li><a href="/mascotas/lista"><i class="fas fa-paw"></i> Todas las Mascotas</a></li>
                            <li><a href="/mascotas/disponibles"><i class="fas fa-check-circle"></i> Disponibles</a></li>
                            <li><a href="/mascotas/registrar"><i class="fas fa-plus"></i> Registrar Mascota</a></li>
                            <li><a href="/"><i class="fas fa-question-circle"></i> Preguntas Frecuentes</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="footer-section">
                        <h5>📞 Contacto</h5>
                        <p>
                            <i class="fas fa-phone"></i> +1 (555) 123-4567<br>
                            <i class="fas fa-envelope"></i> info@adopciones.com<br>
                            <i class="fas fa-map-marker-alt"></i> Calle Principal 123<br>
                            <i class="fas fa-clock"></i> Lun-Vie: 9:00 - 18:00
                        </p>
                    </div>
                </div>
            </div>
            <hr style="border-color: rgba(255,255,255,0.3);">
            <p style="margin: 0; opacity: 0.8;">&copy; 2026 Sistema de Adopciones - Todos los derechos reservados 🐾</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Counter animation
        function animateCounter() {
            const counters = document.querySelectorAll('[data-count]');
            counters.forEach(counter => {
                const target = parseInt(counter.getAttribute('data-count'));
                const increment = target / 50;
                let current = 0;

                const updateCounter = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        counter.textContent = target + '+';
                        clearInterval(updateCounter);
                    } else {
                        counter.textContent = Math.floor(current);
                    }
                }, 40);
            });
        }

        // Trigger counter when stats section comes into view
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    animateCounter();
                    observer.unobserve(entry.target);
                }
            });
        });

        const statsSection = document.querySelector('.stats');
        if (statsSection) observer.observe(statsSection);

        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth' });
                }
            });
        });
    </script>
</body>
</html>

