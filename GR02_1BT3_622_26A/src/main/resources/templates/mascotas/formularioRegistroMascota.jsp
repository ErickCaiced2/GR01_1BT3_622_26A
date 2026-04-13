<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Mascota - Sistema de Adopciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #FF6B6B;
            --secondary-color: #4ECDC4;
        }
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .form-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
            max-width: 600px;
            margin: 30px auto;
        }
        .form-title {
            color: var(--primary-color);
            margin-bottom: 30px;
            font-weight: bold;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            padding: 10px 15px;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 107, 107, 0.25);
        }
        .btn-submit {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 5px;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .error-text {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
        }
        .required {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1 class="form-title">
            <i class="fas fa-plus-circle"></i> Registrar Nueva Mascota
        </h1>

        <c:if test="${error != null}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error:</strong> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form:form modelAttribute="mascota" method="POST" action="/mascotas/registrar" class="needs-validation">
            <!-- Nombre -->
            <div class="form-group">
                <form:label path="nombre" class="form-label">
                    Nombre <span class="required">*</span>
                </form:label>
                <form:input path="nombre" type="text" class="form-control" placeholder="Ej: Buddy" required="true"/>
                <form:errors path="nombre" cssClass="error-text"/>
            </div>

            <!-- Tipo de Mascota -->
            <div class="form-group">
                <form:label path="tipo" class="form-label">
                    Tipo de Mascota <span class="required">*</span>
                </form:label>
                <form:select path="tipo" class="form-control" required="true">
                    <form:option value="">-- Seleccionar --</form:option>
                    <form:option value="Perro">Perro</form:option>
                    <form:option value="Gato">Gato</form:option>
                    <form:option value="Conejo">Conejo</form:option>
                    <form:option value="Pajaro">Pájaro</form:option>
                    <form:option value="Hamster">Hámster</form:option>
                    <form:option value="Otro">Otro</form:option>
                </form:select>
                <form:errors path="tipo" cssClass="error-text"/>
            </div>

            <!-- Raza -->
            <div class="form-group">
                <form:label path="raza" class="form-label">Raza</form:label>
                <form:input path="raza" type="text" class="form-control" placeholder="Ej: Golden Retriever"/>
                <form:errors path="raza" cssClass="error-text"/>
            </div>

            <!-- Edad -->
            <div class="form-group">
                <form:label path="edad" class="form-label">
                    Edad (años) <span class="required">*</span>
                </form:label>
                <form:input path="edad" type="number" class="form-control" min="0" max="50" required="true"/>
                <form:errors path="edad" cssClass="error-text"/>
            </div>

            <!-- Género -->
            <div class="form-group">
                <form:label path="genero" class="form-label">
                    Género <span class="required">*</span>
                </form:label>
                <form:select path="genero" class="form-control" required="true">
                    <form:option value="">-- Seleccionar --</form:option>
                    <form:option value="Macho">Macho</form:option>
                    <form:option value="Hembra">Hembra</form:option>
                </form:select>
                <form:errors path="genero" cssClass="error-text"/>
            </div>

            <!-- Color -->
            <div class="form-group">
                <form:label path="color" class="form-label">Color</form:label>
                <form:input path="color" type="text" class="form-control" placeholder="Ej: Blanco y Negro"/>
                <form:errors path="color" cssClass="error-text"/>
            </div>

            <!-- Peso -->
            <div class="form-group">
                <form:label path="pesoKg" class="form-label">Peso (kg)</form:label>
                <form:input path="pesoKg" type="number" class="form-control" step="0.1" placeholder="Ej: 25.5"/>
                <form:errors path="pesoKg" cssClass="error-text"/>
            </div>

            <!-- Descripción -->
            <div class="form-group">
                <form:label path="descripcion" class="form-label">Descripción</form:label>
                <form:textarea path="descripcion" class="form-control" rows="4"
                               placeholder="Describe el comportamiento, características especiales, etc."/>
                <form:errors path="descripcion" cssClass="error-text"/>
            </div>

            <!-- Estado -->
            <div class="form-group">
                <form:label path="estado" class="form-label">Estado</form:label>
                <form:select path="estado" class="form-control">
                    <form:option value="Disponible">Disponible</form:option>
                    <form:option value="En proceso">En proceso</form:option>
                    <form:option value="Adoptado">Adoptado</form:option>
                </form:select>
                <form:errors path="estado" cssClass="error-text"/>
            </div>

            <!-- Botones -->
            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="/mascotas/lista" class="btn btn-secondary btn-lg">Cancelar</a>
                <button type="submit" class="btn btn-submit btn-lg">
                    <i class="fas fa-save"></i> Registrar Mascota
                </button>
            </div>
        </form:form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

