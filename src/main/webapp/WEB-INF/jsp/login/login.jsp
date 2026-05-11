<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | Paws & Home</title>
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
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            max-width: 400px;
            width: 100%;
            padding: 40px;
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .logo p {
            color: #999;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            color: #333;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102, 126, 234, 0.3);
        }

        .error {
            color: #e74c3c;
            font-size: 14px;
            padding: 12px;
            background: #fadbd8;
            border: 1px solid #e74c3c;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .mensaje {
            color: #27ae60;
            font-size: 14px;
            padding: 12px;
            background: #d5f4e6;
            border: 1px solid #27ae60;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .info {
            color: #3498db;
            font-size: 13px;
            padding: 10px;
            background: #d6eaf8;
            border: 1px solid #3498db;
            border-radius: 5px;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        button:hover {
            transform: translateY(-2px);
        }

        button:active {
            transform: translateY(0);
        }

        .links {
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
        }

        .links p {
            margin-bottom: 10px;
        }

        .links a {
            color: #667eea;
            text-decoration: none;
        }

        .links a:hover {
            text-decoration: underline;
        }

        .help-text {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="logo">
        <h1>🐾 Paws & Home</h1>
        <p>Acceso Unificado</p>
    </div>

    <!-- Información de flujo inteligente -->
    <div class="info">
        ✨ Ingresa tus credenciales. Te redirigiremos automáticamente a tu área según tu rol.
    </div>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <c:if test="${not empty mensaje}">
        <div class="mensaje">${mensaje}</div>
    </c:if>

    <!-- Formulario unificado -->
    <form method="POST" action="/login/procesar">
        <div class="form-group">
            <label for="email">Email</label>
            <input
                    type="email"
                    id="email"
                    name="email"
                    required
                    placeholder="tu@email.com"
                    autofocus
            >
            <p class="help-text">Usa el email de tu cuenta registrada</p>
        </div>

        <div class="form-group">
            <label for="password">Contraseña</label>
            <input
                    type="password"
                    id="password"
                    name="password"
                    required
                    placeholder="Tu contraseña"
            >
            <p class="help-text">Mínimo 6 caracteres</p>
        </div>

        <button type="submit">🔓 Iniciar Sesión</button>
    </form>

    <div class="links">
        <p>¿No tienes cuenta? <a href="/usuarios/registro">Regístrate aquí</a></p>
        <p><a href="/">Volver al inicio</a></p>
    </div>
</div>
</body>
</html>

