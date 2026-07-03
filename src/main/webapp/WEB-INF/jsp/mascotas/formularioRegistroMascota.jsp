<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UC01 - Registrar Mascota - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; --dark-color: #2C3E50; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .sidebar {
            background-color: var(--dark-color);
            min-height: calc(100vh - 56px);
            padding-top: 20px;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 14px 20px;
            border-left: 3px solid transparent;
            transition: all 0.2s ease;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: rgba(255,255,255,0.08);
            border-left-color: var(--primary-color);
        }
        .content { padding: 28px 20px 40px; }
        .form-container { background: white; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px; }
        .page-header { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 30px; }
        @media (max-width: 991px) { .sidebar { min-height: auto; } }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
            <span class="navbar-text text-white">
                <i class="fas fa-user-shield"></i> Panel de Administracion
            </span>
        </div>
    </nav>

    <div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/jsp/admin/_sidebar.jsp">
            <jsp:param name="activo" value="registrar"/>
        </jsp:include>

        <main class="col-lg-10 content">
    <div class="page-header">
            <h1><i class="fas fa-plus-circle"></i> Registrar Nueva Mascota (UC01)</h1>
    </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="form-container">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form method="POST" action="/mascotas/registrar" novalidate enctype="multipart/form-data">
                        <h4 class="mb-4">Información de la Mascota</h4>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nombre" class="form-label">Nombre *</label>
                                <input type="text" class="form-control" id="nombre" name="nombre" required maxlength="100">
                                <small class="text-muted">Nombre de la mascota</small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="tipo" class="form-label">Tipo *</label>
                                <select class="form-select" id="tipo" name="tipo" required>
                                    <option value="">-- Selecciona tipo --</option>
                                    <option value="Perro">Perro</option>
                                    <option value="Gato">Gato</option>
                                    <option value="Conejo">Conejo</option>
                                    <option value="Loro">Loro</option>
                                    <option value="Hamster">Hamster</option>
                                    <option value="Otro">Otro</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="raza" class="form-label">Raza</label>
                                <input type="text" class="form-control" id="raza" name="raza" maxlength="50">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="genero" class="form-label">Género *</label>
                                <select class="form-select" id="genero" name="genero" required>
                                    <option value="">-- Selecciona género --</option>
                                    <option value="Macho">Macho</option>
                                    <option value="Hembra">Hembra</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edad" class="form-label">Edad (años) *</label>
                                <input type="number" class="form-control" id="edad" name="edad" min="0" max="50" step="1" required placeholder="Ej: 2">
                                <small class="text-muted">0 en caso de meses, Máximo 50 años</small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="pesoKg" class="form-label">Peso (kg)</label>
                                <input type="number" class="form-control" id="pesoKg" name="pesoKg" step="0.1" min="0" max="20" placeholder="Ej: 15.5">
                                <small class="text-muted">0 en caso de lb Máximo 20 kg</small>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="color" class="form-label">Color</label>
                            <input type="text" class="form-control" id="color" name="color" maxlength="255">
                        </div>

                        <div class="mb-3">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <textarea class="form-control" id="descripcion" name="descripcion" rows="4" maxlength="500" placeholder="Características, personalidad, etc."></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="estado" class="form-label">Estado *</label>
                                <select class="form-select" id="estado" name="estado" required>
                                    <option value="Disponible">Disponible</option>
                                    <option value="En proceso">En proceso</option>
                                    <option value="Adoptado">Adoptado</option>
                                </select>
                            </div>
                        </div>

                        <hr class="my-4">
                        <h4 class="mb-4"><i class="fas fa-image"></i> Fotografía de la Mascota</h4>

                        <div class="mb-3">
                            <label for="foto" class="form-label">Cargar Fotografía (Opcional)</label>
                            <div class="input-group">
                                <input type="file" class="form-control" id="foto" name="foto" accept="image/*">
                                <span class="input-group-text"><i class="fas fa-image"></i></span>
                            </div>
                            <small class="text-muted d-block mt-2">Formatos permitidos: JPG, PNG, GIF | Tamaño máximo: 5MB</small>
                            <div id="fotoPreview" style="display:none; margin-top: 15px;">
                                <small class="text-muted">Vista previa:</small>
                                <img id="previewImg" src="" alt="Vista previa" style="max-width: 200px; border-radius: 5px;" class="mt-2">
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save"></i> Registrar Mascota
                            </button>
                            <a href="/mascotas/lista" class="btn btn-secondary">Cancelar</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        </main>
    </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validaciones para el formulario de registro de mascota
        const edadInput = document.getElementById('edad');
        const pesoInput = document.getElementById('pesoKg');
        const fotoInput = document.getElementById('foto');
        const previewDiv = document.getElementById('fotoPreview');
        const previewImg = document.getElementById('previewImg');
        const form = document.querySelector('form');

        // Vista previa de foto
        fotoInput.addEventListener('change', function(event) {
            const file = event.target.files[0];

            if (file) {
                // Validar tipo de archivo
                const tiposPermitidos = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
                if (!tiposPermitidos.includes(file.type)) {
                    alert('Solo se permiten imágenes (JPG, PNG, GIF, WebP)');
                    fotoInput.value = '';
                    previewDiv.style.display = 'none';
                    return;
                }

                // Validar tamaño (5MB máximo)
                const maxSize = 5 * 1024 * 1024; // 5MB
                if (file.size > maxSize) {
                    alert('El archivo no debe pesar más de 5MB');
                    fotoInput.value = '';
                    previewDiv.style.display = 'none';
                    return;
                }

                // Mostrar vista previa
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    previewDiv.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                previewDiv.style.display = 'none';
            }
        });

        // Validar edad en tiempo real
        edadInput.addEventListener('input', function() {
            let valor = parseInt(this.value);

            // Limitar a valores válidos automáticamente
            if (valor < 0) {
                this.value = 0;
            } else if (valor > 50) {
                this.value = 50;
            }
        });

        // Validar peso en tiempo real
        pesoInput.addEventListener('input', function() {
            let valor = parseFloat(this.value);

            // Limitar a valores válidos automáticamente
            if (valor < 0) {
                this.value = 0;
            } else if (valor > 20) {
                this.value = 20;
            }
        });

        // Validación al enviar formulario
        form.addEventListener('submit', function(e) {
            const edad = edadInput.value;
            const peso = pesoInput.value;
            const nombre = document.getElementById('nombre').value.trim();
            const foto = fotoInput.files[0];

            // Validar que el nombre no esté vacío
            if (!nombre) {
                e.preventDefault();
                alert('El nombre de la mascota es requerido');
                document.getElementById('nombre').focus();
                return false;
            }

            // Validar edad
            if (edad === '' || edad < 0 || edad > 50) {
                e.preventDefault();
                alert('La edad debe estar entre 0 y 50 años');
                edadInput.focus();
                return false;
            }

            // Validar peso si se proporciona
            if (peso !== '' && (peso < 0 || peso > 20)) {
                e.preventDefault();
                alert('El peso debe estar entre 0 y 20 kg');
                pesoInput.focus();
                return false;
            }

            // Validar foto si se proporciona
            if (foto) {
                const tiposPermitidos = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
                if (!tiposPermitidos.includes(foto.type)) {
                    e.preventDefault();
                    alert('Solo se permiten imágenes (JPG, PNG, GIF, WebP)');
                    return false;
                }

                const maxSize = 5 * 1024 * 1024;
                if (foto.size > maxSize) {
                    e.preventDefault();
                    alert('El archivo no debe pesar más de 5MB');
                    return false;
                }
            }

            return true;
        });

        // Mostrar estilos de validación
        edadInput.addEventListener('blur', function() {
            if (this.value === '' || this.value < 0 || this.value > 50) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });

        pesoInput.addEventListener('blur', function() {
            if (this.value !== '' && (this.value < 0 || this.value > 20)) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });
    </script>
</body>
</html>

