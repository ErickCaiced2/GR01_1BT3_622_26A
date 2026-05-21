<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Usuario</title>
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
                    <h2 class="mb-4">Crear Cuenta de Usuario</h2>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form method="POST" action="/usuarios/crear">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nombre" class="form-label">Nombre *</label>
                                <input type="text" class="form-control" id="nombre" name="nombre"
                                       pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+"
                                       placeholder="Solo letras"
                                       title="El nombre solo debe contener letras"
                                       required>
                                <small class="text-muted">Solo letras permitidas</small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="apellido" class="form-label">Apellido *</label>
                                <input type="text" class="form-control" id="apellido" name="apellido"
                                       pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+"
                                       placeholder="Solo letras"
                                       title="El apellido solo debe contener letras"
                                       required>
                                <small class="text-muted">Solo letras permitidas</small>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Email *</label>
                                <input type="email" class="form-control" id="email" name="email"
                                       placeholder="ejemplo@correo.com"
                                       title="Ingresa un email válido"
                                       required>
                                <small class="text-muted">Formato: usuario@dominio.com</small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="telefono" class="form-label">Teléfono *</label>
                                <input type="tel" class="form-control" id="telefono" name="telefono"
                                       pattern="[0-9]+"
                                       maxlength="10"
                                       placeholder="Ej: 3001234567"
                                       title="El teléfono solo debe contener números (máximo 10 dígitos)"
                                       required>
                                <small class="text-muted">Solo números, máximo 10 dígitos</small>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="direccion" class="form-label">Dirección *</label>
                            <input type="text" class="form-control" id="direccion" name="direccion"
                                   placeholder="Calle, número y complementos"
                                   maxlength="100"
                                   required>
                            <small class="text-muted">Máximo 100 caracteres</small>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="ciudad" class="form-label">Ciudad *</label>
                                <input type="text" class="form-control" id="ciudad" name="ciudad"
                                       pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+"
                                       placeholder="Solo letras"
                                       title="La ciudad solo debe contener letras"
                                       required>
                                <small class="text-muted">Solo letras permitidas</small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="documentoIdentidad" class="form-label">Documento de Identidad *</label>
                                <input type="text" class="form-control" id="documentoIdentidad" name="documentoIdentidad"
                                       pattern="[0-9]+"
                                       placeholder="Ej: 1234567890"
                                       title="El documento solo debe contener números"
                                       required>
                                <small class="text-muted">Solo números permitidos</small>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="tipoDocumento" class="form-label">Tipo de Documento *</label>
                                <select class="form-select" id="tipoDocumento" name="tipoDocumento" required>
                                    <option value="">-- Selecciona tipo --</option>
                                    <option value="CC">Cédula de Ciudadanía</option>
                                    <option value="TI">Tarjeta de Identidad</option>
                                    <option value="Pasaporte">Pasaporte</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="fechaNacimiento" class="form-label">Fecha de Nacimiento *</label>
                                <input type="date" class="form-control" id="fechaNacimiento" name="fechaNacimiento" required>
                            </div>
                        </div>

                        <hr class="my-4">
                        <h5 class="mb-3">Credenciales de Acceso</h5>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label">Contraseña *</label>
                                <input type="password" class="form-control" id="password" name="password" required minlength="6" placeholder="Mínimo 6 caracteres">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="confirmPassword" class="form-label">Confirmar Contraseña *</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="6" placeholder="Repite tu contraseña">
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-user-plus"></i> Registrarse
                            </button>
                            <a href="/" class="btn btn-secondary">Cancelar</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Obtener referencias a los campos
        const nombreInput = document.getElementById('nombre');
        const apellidoInput = document.getElementById('apellido');
        const ciudadInput = document.getElementById('ciudad');
        const telefonoInput = document.getElementById('telefono');
        const documentoInput = document.getElementById('documentoIdentidad');
        const direccionInput = document.getElementById('direccion');
        const form = document.querySelector('form');

         // Función para permitir solo letras y espacios
         function permitirSoloLetras(event) {
             event.target.value = event.target.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '');
         }

        // Función para permitir solo números
        function permitirSoloNumeros(event) {
            event.target.value = event.target.value.replace(/[^0-9]/g, '');
        }

        // Event listeners para validación en tiempo real
        nombreInput.addEventListener('input', permitirSoloLetras);
        apellidoInput.addEventListener('input', permitirSoloLetras);
        ciudadInput.addEventListener('input', permitirSoloLetras);
        telefonoInput.addEventListener('input', permitirSoloNumeros);
        documentoInput.addEventListener('input', permitirSoloNumeros);

        // Validar que las contraseñas coincidan y otros campos
        form.addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const nombre = nombreInput.value.trim();
            const apellido = apellidoInput.value.trim();
            const telefono = telefonoInput.value.trim();
            const documento = documentoInput.value.trim();

            // Validar que no estén vacíos
            if (!nombre) {
                e.preventDefault();
                alert('El nombre es requerido');
                nombreInput.focus();
                return false;
            }

            if (!apellido) {
                e.preventDefault();
                alert('El apellido es requerido');
                apellidoInput.focus();
                return false;
            }

            if (telefono.length < 7) {
                e.preventDefault();
                alert('El teléfono debe tener al menos 7 dígitos');
                telefonoInput.focus();
                return false;
            }

            if (!documento || documento.length < 8) {
                e.preventDefault();
                alert('El documento debe tener al menos 8 dígitos');
                documentoInput.focus();
                return false;
            }

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Las contraseñas no coinciden');
                document.getElementById('confirmPassword').focus();
                return false;
            }

            if (password.length < 6) {
                e.preventDefault();
                alert('La contraseña debe tener al menos 6 caracteres');
                document.getElementById('password').focus();
                return false;
            }

            return true;
        });

        // Eventos para validación en tiempo real
        nombreInput.addEventListener('blur', function() {
            if (this.value.trim() === '') {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });

        apellidoInput.addEventListener('blur', function() {
            if (this.value.trim() === '') {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });

        telefonoInput.addEventListener('blur', function() {
            if (this.value.length < 7) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });

        documentoInput.addEventListener('blur', function() {
            if (this.value.length < 8) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });
    </script>

