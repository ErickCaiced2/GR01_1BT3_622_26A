<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso - Paws & Home</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            width: 100%;
        }

        .hero {
            text-align: center;
            color: white;
            margin-bottom: 50px;
        }

        .hero h1 {
            font-size: 48px;
            margin-bottom: 10px;
        }

        .hero p {
            font-size: 18px;
            opacity: 0.9;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .card {
            background: white;
            border-radius: 10px;
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
        }

        .card.admin::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #e74c3c, #c0392b);
        }

        .card.solicitante::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #27ae60, #229954);
        }

        .card h2 {
            font-size: 28px;
            color: #333;
            margin-bottom: 15px;
        }

        .card .icon {
            font-size: 60px;
            margin-bottom: 20px;
        }

        .card p {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
            font-size: 14px;
        }

        .card ul {
            text-align: left;
            display: inline-block;
            margin-bottom: 30px;
            font-size: 14px;
            color: #555;
        }

        .card ul li {
            margin: 8px 0;
            padding-left: 20px;
            position: relative;
        }

        .card ul li::before {
            content: '✓';
            position: absolute;
            left: 0;
            color: #27ae60;
            font-weight: bold;
        }

        .card.admin ul li::before {
            color: #e74c3c;
        }

        .btn {
            display: inline-block;
            padding: 12px 30px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-solicitante {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
        }

        .btn-solicitante:hover {
            box-shadow: 0 5px 15px rgba(39, 174, 96, 0.3);
        }

        .btn-admin {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-admin:hover {
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }

        .footer {
            text-align: center;
            color: white;
            margin-top: 50px;
            font-size: 14px;
        }

        .footer a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .hero h1 {
                font-size: 36px;
            }

            .hero p {
                font-size: 16px;
            }

            .card {
                padding: 30px 20px;
            }

            .card h2 {
                font-size: 22px;
            }

            .card .icon {
                font-size: 48px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="hero">
        <h1>🐾 Paws & Home</h1>
        <p>Sistema Integral de Adopción de Mascotas</p>
    </div>

    <div class="cards">
        <!-- Card Solicitante -->
        <div class="card solicitante">
            <div class="icon">👤</div>
            <h2>Soy Solicitante</h2>
            <p>Acceso para personas que desean adoptar mascotas y hacer seguimiento de su solicitud.</p>
            <ul>
                <li>Buscar mascotas disponibles</li>
                <li>Crear solicitud de adopción</li>
                <li>Seguimiento de estado</li>
                <li>Compartir experiencias</li>
            </ul>
            <a href="/login" class="btn btn-solicitante">Ingresar como Solicitante</a>
        </div>

        <!-- Card Admin -->
        <div class="card admin">
            <div class="icon">🔐</div>
            <h2>Soy Administrador</h2>
            <p>Acceso exclusivo para personal del refugio autorizado a gestionar el sistema.</p>
            <ul>
                <li>Gestionar mascotas</li>
                <li>Revisar solicitudes</li>
                <li>Generar reportes</li>
                <li>Administrar usuarios</li>
            </ul>
            <a href="/login/admin" class="btn btn-admin">Acceder a Panel Admin</a>
        </div>
    </div>

    <div class="footer">
        <p>¿Necesitas ayuda? <a href="/">Contacta con nosotros</a></p>
        <p style="margin-top: 10px; opacity: 0.7;">© 2026 Paws & Home. Todos los derechos reservados.</p>
    </div>
</div>
</body>
</html>

