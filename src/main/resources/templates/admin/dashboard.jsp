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
                            <div class="stat-number">${totalMascotas}</div>
                            <div class="stat-label">
                                <i class="fas fa-paw"></i> Total de Mascotas
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card disponibles">
                            <div class="stat-number">${mascotasDisponiblesCount}</div>
                            <div class="stat-label">
                                <i class="fas fa-check-circle"></i> Disponibles
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card en-proceso">
                            <div class="stat-number">${mascotasEnProceso}</div>
                            <div class="stat-label">
                                <i class="fas fa-hourglass-half"></i> En Proceso
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card adoptados">
                            <div class="stat-number">${mascotasAdoptadas}</div>
                            <div class="stat-label">
                                <i class="fas fa-home"></i> Adoptadas
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="chart-container">
                            <h5 style="margin-bottom: 20px;">Distribución por Estado</h5>
                            <canvas id="chartEstados"></canvas>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="chart-container">
                            <h5 style="margin-bottom: 20px;">Distribución por Tipo</h5>
                            <canvas id="chartTipos"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Recent Mascotas Table -->
                <div class="table-container">
                    <h5 style="margin-bottom: 20px;">
                        <i class="fas fa-list"></i> Mascotas Registradas Recientemente
                    </h5>
                    <table class="table table-hover table-striped">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Tipo</th>
                                <th>Raza</th>
                                <th>Edad</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="mascota" items="${mascotas}" begin="0" end="9">
                                <tr>
                                    <td><strong>${mascota.nombre}</strong></td>
                                    <td>${mascota.tipo}</td>
                                    <td>${mascota.raza}</td>
                                    <td>${mascota.edad} años</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${mascota.estado == 'Disponible'}">
                                                <span class="badge bg-success">Disponible</span>
                                            </c:when>
                                            <c:when test="${mascota.estado == 'Adoptado'}">
                                                <span class="badge bg-info">Adoptado</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning">En Proceso</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="/mascotas/detalle/${mascota.id}" class="btn btn-sm btn-info text-white">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="/mascotas/editar/${mascota.id}" class="btn btn-sm btn-warning">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Gráfico de Estados
        const ctxEstados = document.getElementById('chartEstados').getContext('2d');
        new Chart(ctxEstados, {
            type: 'doughnut',
            data: {
                labels: ['Disponible', 'En Proceso', 'Adoptado'],
                datasets: [{
                    data: [${mascotasDisponiblesCount}, ${mascotasEnProceso}, ${mascotasAdoptadas}],
                    backgroundColor: [
                        '#28a745',
                        '#ffc107',
                        '#17a2b8'
                    ],
                    borderColor: '#fff',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                    }
                }
            }
        });

        // Gráfico de Tipos
        const ctxTipos = document.getElementById('chartTipos').getContext('2d');
        const tipos = {};
        <c:forEach var="mascota" items="${mascotas}">
            tipos['${mascota.tipo}'] = (tipos['${mascota.tipo}'] || 0) + 1;
        </c:forEach>

        new Chart(ctxTipos, {
            type: 'bar',
            data: {
                labels: Object.keys(tipos),
                datasets: [{
                    label: 'Cantidad',
                    data: Object.values(tipos),
                    backgroundColor: '#FF6B6B',
                    borderColor: '#FF6B6B',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                indexAxis: 'y',
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>

