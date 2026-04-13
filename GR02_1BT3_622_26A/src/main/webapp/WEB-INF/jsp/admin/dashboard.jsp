<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #2C3E50;
        }

        body {
            background-color: #f8f9fa;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .sidebar {
            background-color: var(--dark-color);
            min-height: 100vh;
            padding-top: 20px;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 15px 20px;
            border-left: 3px solid transparent;
            transition: all 0.3s;
        }

        .sidebar a:hover, .sidebar a.active {
            background-color: rgba(255,255,255,0.1);
            border-left-color: var(--primary-color);
            color: var(--primary-color);
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 20px;
            border-left: 4px solid;
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .stat-card.disponibles {
            border-left-color: var(--success-color);
        }

        .stat-card.adoptados {
            border-left-color: var(--info-color);
        }

        .stat-card.en-proceso {
            border-left-color: var(--warning-color);
        }

        .stat-card.total {
            border-left-color: var(--primary-color);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--dark-color);
        }

        .stat-label {
            font-size: 0.9rem;
            color: #666;
            text-transform: uppercase;
            margin-top: 10px;
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 30px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 30px;
        }

        table {
            margin: 0;
        }

        thead {
            background-color: #f8f9fa;
            border-top: 2px solid var(--primary-color);
        }

        tbody tr:hover {
            background-color: #f8f9fa;
        }

        .content {
            padding: 30px 20px;
        }

        .page-title {
            color: var(--dark-color);
            margin-bottom: 30px;
            font-weight: bold;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 15px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">
                <i class="fas fa-paw"></i> Sistema de Adopciones
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-user-shield"></i> Panel de Administración
            </span>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar">
                <a href="/admin/dashboard" class="active">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="/mascotas/lista">
                    <i class="fas fa-list"></i> Lista de Mascotas
                </a>
                <a href="/mascotas/registrar">
                    <i class="fas fa-plus-circle"></i> Registrar Mascota
                </a>
                <a href="/admin/reporte/mascotas">
                    <i class="fas fa-chart-bar"></i> Reportes
                </a>
                <hr style="border-color: rgba(255,255,255,0.2);">
                <a href="/">
                    <i class="fas fa-home"></i> Ir al Sitio
                </a>
            </div>

            <!-- Content -->
            <div class="col-md-10 content">
                <h1 class="page-title">
                    <i class="fas fa-tachometer-alt"></i> Dashboard de Administración
                </h1>

                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-3">
                        <div class="stat-card total">
                            <div class="stat-number">${totalMascotas != null ? totalMascotas : 0}</div>
                            <div class="stat-label">
                                <i class="fas fa-paw"></i> Total de Mascotas
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card disponibles">
                            <div class="stat-number">${mascotasDisponiblesCount != null ? mascotasDisponiblesCount : 0}</div>
                            <div class="stat-label">
                                <i class="fas fa-check-circle"></i> Disponibles
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card en-proceso">
                            <div class="stat-number">${mascotasEnProceso != null ? mascotasEnProceso : 0}</div>
                            <div class="stat-label">
                                <i class="fas fa-hourglass-half"></i> En Proceso
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card adoptados">
                            <div class="stat-number">${mascotasAdoptadas != null ? mascotasAdoptadas : 0}</div>
                            <div class="stat-label">
                                <i class="fas fa-home"></i> Adoptadas
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

