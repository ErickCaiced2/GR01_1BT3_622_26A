<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Mascota - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #FF6B6B; --secondary-color: #4ECDC4; }
        .navbar { background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); }
        .form-container { background: white; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-paw"></i> Sistema de Adopciones</a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="form-container">
                    <h2 class="mb-4">Editar Mascota: ${mascota.nombre}</h2>

                    <form method="POST" action="/mascotas/actualizar/${mascota.id}" enctype="multipart/form-data">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nombre" class="form-label">Nombre *</label>
                                <input type="text" class="form-control" id="nombre" name="nombre" value="${mascota.nombre}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="tipo" class="form-label">Tipo *</label>
                                <select class="form-select" id="tipo" name="tipo" required>
                                    <option value="Perro" ${mascota.tipo == 'Perro' ? 'selected' : ''}>Perro</option>
                                    <option value="Gato" ${mascota.tipo == 'Gato' ? 'selected' : ''}>Gato</option>
                                    <option value="Conejo" ${mascota.tipo == 'Conejo' ? 'selected' : ''}>Conejo</option>
                                    <option value="Loro" ${mascota.tipo == 'Loro' ? 'selected' : ''}>Loro</option>
                                    <option value="Hamster" ${mascota.tipo == 'Hamster' ? 'selected' : ''}>Hamster</option>
                                    <option value="Otro" ${mascota.tipo == 'Otro' ? 'selected' : ''}>Otro</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="raza" class="form-label">Raza</label>
                                <input type="text" class="form-control" id="raza" name="raza" value="${mascota.raza}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="genero" class="form-label">Género *</label>
                                <select class="form-select" id="genero" name="genero" required>
                                    <option value="Macho" ${mascota.genero == 'Macho' ? 'selected' : ''}>Macho</option>
                                    <option value="Hembra" ${mascota.genero == 'Hembra' ? 'selected' : ''}>Hembra</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edad" class="form-label">Edad (años) *</label>
                                <input type="number" class="form-control" id="edad" name="edad" value="${mascota.edad}" min="0" max="50" step="1" required>
                                <small class="text-muted">Mínimo 0, Máximo 50 años</small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="pesoKg" class="form-label">Peso (kg)</label>
                                <input type="number" class="form-control" id="pesoKg" name="pesoKg" value="${mascota.pesoKg}" step="0.1" min="0" max="20">
                                <small class="text-muted">Mínimo 0, Máximo 20 kg</small>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="color" class="form-label">Color</label>
                            <input type="text" class="form-control" id="color" name="color" value="${mascota.color}">
                        </div>

                        <div class="mb-3">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <textarea class="form-control" id="descripcion" name="descripcion" rows="4" maxlength="500">${mascota.descripcion}</textarea>
                        </div>

                        <div class="mb-3">
                            <label for="estado" class="form-label">Estado *</label>
                            <select class="form-select" id="estado" name="estado" required>
                                <option value="Disponible" ${mascota.estado == 'Disponible' ? 'selected' : ''}>Disponible</option>
                                <option value="En proceso" ${mascota.estado == 'En proceso' ? 'selected' : ''}>En proceso</option>
                                <option value="Adoptado" ${mascota.estado == 'Adoptado' ? 'selected' : ''}>Adoptado</option>
                            </select>
                        </div>

                        <hr class="my-4">
                        <h4 class="mb-4"><i class="fas fa-image"></i> Fotografía de la Mascota</h4>

                        <div class="mb-3">
                            <label for="foto" class="form-label">Cargar/Actualizar Fotografía (Opcional)</label>
                            <div class="input-group">
                                <input type="file" class="form-control" id="foto" name="foto" accept="image/*">
                                <span class="input-group-text"><i class="fas fa-image"></i></span>
                            </div>
                            <small class="text-muted d-block mt-2">Formatos permitidos: JPG, PNG, GIF | Tamaño máximo: 5MB</small>
                            <div id="fotoPreview" style="display:none; margin-top: 15px;">
                                <small class="text-muted">Vista previa del archivo:</small>
                                <img id="previewImg" src="" alt="Vista previa" style="max-width: 200px; border-radius: 5px;" class="mt-2">
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                            <a href="/mascotas/detalle/${mascota.id}" class="btn btn-secondary">Cancelar</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validaciones para el formulario de edición de mascota
        const fotoInput = document.getElementById('foto');
        const previewDiv = document.getElementById('fotoPreview');
        const previewImg = document.getElementById('previewImg');
        const pesoInput = document.getElementById('pesoKg');

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

        // Validar peso en tiempo real
        pesoInput.addEventListener('input', function() {
            let valor = parseFloat(this.value);

            if (valor < 0) {
                this.value = 0;
            } else if (valor > 20) {
                this.value = 20;
            }
        });

        // Validación al enviar formulario
        document.querySelector('form').addEventListener('submit', function(e) {
            const foto = fotoInput.files[0];
            const peso = pesoInput.value;

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
        pesoInput.addEventListener('blur', function() {
            if (this.value !== '' && (this.value < 0 || this.value > 20)) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });
    </script>

