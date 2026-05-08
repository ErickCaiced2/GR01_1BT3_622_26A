<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Administrador | Paws & Home</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ee7752 0%, #e73c7e 50%, #23a6d5 100%);
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

        .badge {
            display: inline-block;
            background: #e74c3c;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 10px;
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
            border-color: #e74c3c;
            box-shadow: 0 0 5px rgba(231, 76, 60, 0.3);
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

        .warning {
            color: #f39c12;
            font-size: 14px;
            padding: 12px;
            background: #fef5e7;
            border: 1px solid #f39c12;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #ee7752 0%, #e73c7e 100%);
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

        .links a {
            color: #e74c3c;
            text-decoration: none;
            margin: 0 5px;
        }

        .links a:hover {
            text-decoration: underline;
        }

        .divider {
            color: #999;
            margin: 0 5px;
        }

        .help-text {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        .security-info {
            background: #ecf0f1;
            border-left: 4px solid #3498db;
            padding: 12px;
            border-radius: 4px;
            margin-top: 20px;
            font-size: 12px;
            color: #555;
        }

        .security-info strong {
            color: #2c3e50;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="logo">
        <h1>🐾 Paws & Home</h1>
        <p>Panel de Administración</p>
        <span class="badge">🔒 Acceso Restringido</span>
    </div>

    <c:if test="${not empty error}">
        <div class="error">⚠️ ${error}</div>
    </c:if>

    <c:if test="${not empty mensaje}">
        <div class="warning">ℹ️ ${mensaje}</div>
    </c:if>

    <form method="POST" action="/login/admin/procesar">
        <div class="form-group">
            <label for="email">Email (Administrador)</label>
            <input
                    type="email"
                    id="email"
                    name="email"
                    required
                    placeholder="admin@pawsandhome.com"
                    autofocus
            >
            <p class="help-text">Cuenta con permisos administrativos</p>
        </div>

        <div class="form-group">
            <label for="password">Contraseña</label>
            <input
                    type="password"
                    id="password"
                    name="password"
                    required
                    placeholder="Tu contraseña segura"
            >
            <p class="help-text">Mínimo 6 caracteres</p>
        </div>

        <button type="submit">🔓 Acceder a Panel Admin</button>
    </form>

    <div class="security-info">
        <strong>🔐 Seguridad:</strong> Esta es un área restringida. Se registran todos los accesos.
    </div>

    <div class="links">
        <p><a href="/acceso">← Volver</a></p>
    </div>
</div>
</body>
</html>

