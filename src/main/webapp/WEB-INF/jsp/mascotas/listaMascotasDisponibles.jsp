<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mascotas Disponibles - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .card { border: none; box-shadow: 0 2px 8px rgba(0,0,0,0.1); transition: transform 0.3s; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 5px 20px rgba(0,0,0,0.15); }

        /* 🔵 FILTROS DE COMPATIBILIDAD */
        .filter-section {
            background: linear-gradient(135deg, rgba(255, 107, 107, 0.1) 0%, rgba(78, 205, 196, 0.1) 100%);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            border: 2px solid var(--secondary-color);
        }

        .filter-label {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 8px;
            font-size: 0.9rem;
        }

        .filter-input {
            border: 1px solid var(--secondary-color);
            border-radius: 8px;
            padding: 8px 12px;
        }

        .filter-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 5px rgba(255, 107, 107, 0.3);
        }

        .btn-filter {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            color: white;
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn-filter:hover {
            transform: scale(1.05);
            color: white;
        }

        .btn-clear {
            border: 1px solid var(--secondary-color);
            background: white;
            color: var(--secondary-color);
            border-radius: 8px;
            padding: 8px 16px;
            cursor: pointer;
        }

        .loading {
            display: none;
            text-align: center;
            margin: 20px 0;
        }

        .badge-tipo {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 20px;
            background-color: var(--secondary-color);
            color: white;
            font-size: 0.85rem;
            margin-top: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/navbar.jsp" />

    <div class="container my-5">
        <h2><i class="fas fa-heart"></i> Mascotas Disponibles para Adopción</h2>
        <p>Total disponibles: <strong id="totalCount">${totalMascotas}</strong></p>

        <!-- 🔵 BARRA DE FILTROS -->
        <div class="filter-section">
            <h5 class="mb-3"><i class="fas fa-filter"></i> Filtrar por Preferencias</h5>
            <div class="row g-3">
                <!-- Tipo de mascota -->
                <div class="col-md-3">
                    <label class="filter-label"><i class="fas fa-tag"></i> Tipo</label>
                    <select id="filtroTipo" class="filter-input form-select">
                        <option value="">Todos los tipos</option>
                        <option value="Perro">🐕 Perro</option>
                        <option value="Gato">🐈 Gato</option>
                        <option value="Conejo">🐰 Conejo</option>
                        <option value="Pajaro">🐦 Pájaro</option>
                        <option value="Reptil">🦎 Reptil</option>
                        <option value="Otro">➕ Otro</option>
                    </select>
                </div>

                <!-- Rango de edad -->
                <div class="col-md-3">
                    <label class="filter-label"><i class="fas fa-birthday-cake"></i> Edad (años)</label>
                    <div class="d-flex gap-2">
                        <input type="number" id="filtroEdadMin" class="filter-input" placeholder="Mín" min="0" max="50" value="">
                        <span class="align-self-center">-</span>
                        <input type="number" id="filtroEdadMax" class="filter-input" placeholder="Máx" min="0" max="50" value="">
                    </div>
                </div>

                <!-- Tamaño (basado en peso) -->
                <div class="col-md-3">
                    <label class="filter-label"><i class="fas fa-ruler"></i> Tamaño</label>
                    <select id="filtroTamano" class="filter-input form-select">
                        <option value="">Cualquier tamaño</option>
                        <option value="pequeño">🐭 Pequeño (&lt; 5kg)</option>
                        <option value="mediano">🐕 Mediano (5-20kg)</option>
                        <option value="grande">🦁 Grande (&gt; 20kg)</option>
                    </select>
                </div>

                <!-- Botones -->
                <div class="col-md-3 d-flex gap-2 align-items-end">
                    <button onclick="filtrarMascotas()" class="btn-filter w-100">
                        <i class="fas fa-search"></i> Buscar
                    </button>
                    <button onclick="limpiarFiltros()" class="btn-clear">
                        <i class="fas fa-redo"></i> Limpiar
                    </button>
                </div>
            </div>
        </div>

        <div class="loading" id="loading">
            <div class="spinner-border" style="color: var(--primary-color);" role="status">
                <span class="visually-hidden">Buscando...</span>
            </div>
            <p class="mt-2">Buscando mascotas...</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Contenedor de resultados -->
        <div id="resultados">
            <c:if test="${not empty mascotas}">
                <div class="row g-4">
                    <c:forEach var="mascota" items="${mascotas}">
                        <div class="col-md-6 col-lg-4 mascota-card">
                            <div class="card">
                                <div style="height: 250px; background-color: #e0e0e0; display: flex; align-items: center; justify-content: center;">
                                    <i class="fas fa-image" style="font-size: 3rem; color: #999;"></i>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title">${mascota.nombre}</h5>
                                    <p class="card-text">
                                        <small>
                                            <i class="fas fa-tag"></i> ${mascota.tipo}
                                            <c:if test="${not empty mascota.raza}"> - ${mascota.raza}</c:if>
                                        </small>
                                    </p>
                                    <p class="card-text">
                                        <small>
                                            <i class="fas fa-birthday-cake"></i> ${mascota.edad} años
                                            <c:if test="${not empty mascota.pesoKg}"> | <i class="fas fa-weight"></i> ${mascota.pesoKg}kg</c:if>
                                        </small>
                                    </p>
                                    <p class="card-text">
                                        <small>
                                            <i class="fas fa-mars"></i> ${mascota.genero}
                                        </small>
                                    </p>
                                    <div class="d-grid gap-2">
                                        <a href="/mascotas/detalle/${mascota.id}" class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i> Ver Detalle
                                        </a>
                                        <a href="/solicitudes/formulario?mascotaId=${mascota.id}" class="btn btn-success btn-sm">
                                            <i class="fas fa-heart"></i> Solicitar Adopción
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty mascotas}">
                <div class="alert alert-info text-center" style="padding: 60px 20px;">
                    <i class="fas fa-heart-broken" style="font-size: 3rem;"></i>
                    <h2>No hay mascotas disponibles en este momento</h2>
                    <p>Vuelve más tarde para encontrar tu mascota ideal</p>
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        /**
         * 🔵 SISTEMA DE FILTROS - Búsqueda sin recargar página
         */

        function filtrarMascotas() {
            const tipo = document.getElementById('filtroTipo').value;
            const edadMin = document.getElementById('filtroEdadMin').value;
            const edadMax = document.getElementById('filtroEdadMax').value;
            const tamano = document.getElementById('filtroTamano').value;

            // Mostrar spinner
            document.getElementById('loading').style.display = 'block';

            // Construir parámetros
            let params = new URLSearchParams();
            if (tipo) params.append('tipo', tipo);
            if (edadMin) params.append('edadMin', edadMin);
            if (edadMax) params.append('edadMax', edadMax);
            if (tamano) params.append('tamano', tamano);

            // Hacer fetch
            fetch(`/mascotas/filtrar?${params.toString()}`)
                .then(response => response.json())
                .then(data => {
                    // Ocultar spinner
                    document.getElementById('loading').style.display = 'none';

                    // Actualizar total
                    document.getElementById('totalCount').textContent = data.length;

                    // Generar HTML
                    let html = '';
                    if (data.length === 0) {
                        html = `
                            <div class="alert alert-info text-center" style="padding: 60px 20px;">
                                <i class="fas fa-search" style="font-size: 3rem;"></i>
                                <h2>No encontramos mascotas que coincidan</h2>
                                <p>Intenta con otros filtros</p>
                            </div>
                        `;
                    } else {
                        html = '<div class="row g-4">';
                        data.forEach(mascota => {
                            html += `
                                <div class="col-md-6 col-lg-4 mascota-card">
                                    <div class="card">
                                        <div style="height: 250px; background-color: #e0e0e0; display: flex; align-items: center; justify-content: center;">
                                            <i class="fas fa-image" style="font-size: 3rem; color: #999;"></i>
                                        </div>
                                        <div class="card-body">
                                            <h5 class="card-title">${mascota.nombre}</h5>
                                            <p class="card-text">
                                                <small>
                                                    <i class="fas fa-tag"></i> ${mascota.tipo}
                                                    ${mascota.raza ? ' - ' + mascota.raza : ''}
                                                </small>
                                            </p>
                                            <p class="card-text">
                                                <small>
                                                    <i class="fas fa-birthday-cake"></i> ${mascota.edad} años
                                                    ${mascota.pesoKg ? ' | <i class="fas fa-weight"></i> ' + mascota.pesoKg + 'kg' : ''}
                                                </small>
                                            </p>
                                            <p class="card-text">
                                                <small>
                                                    <i class="fas fa-mars"></i> ${mascota.genero}
                                                </small>
                                            </p>
                                            <div class="d-grid gap-2">
                                                <a href="/mascotas/detalle/${mascota.id}" class="btn btn-info btn-sm">
                                                    <i class="fas fa-eye"></i> Ver Detalle
                                                </a>
                                                <a href="/solicitudes/formulario?mascotaId=${mascota.id}" class="btn btn-success btn-sm">
                                                    <i class="fas fa-heart"></i> Solicitar Adopción
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        });
                        html += '</div>';
                    }

                    // Actualizar DOM
                    document.getElementById('resultados').innerHTML = html;
                })
                .catch(error => {
                    document.getElementById('loading').style.display = 'none';
                    console.error('Error:', error);
                    document.getElementById('resultados').innerHTML = `
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> Error al filtrar mascotas
                        </div>
                    `;
                });
        }

        function limpiarFiltros() {
            document.getElementById('filtroTipo').value = '';
            document.getElementById('filtroEdadMin').value = '';
            document.getElementById('filtroEdadMax').value = '';
            document.getElementById('filtroTamano').value = '';

            // Recargar página original o llamar a endpoint sin filtros
            location.href = '/mascotas/disponibles';
        }

        // Permitir buscar con Enter
        document.addEventListener('keypress', function(event) {
            if (event.key === 'Enter') {
                filtrarMascotas();
            }
        });
    </script>
</body>
</html>

