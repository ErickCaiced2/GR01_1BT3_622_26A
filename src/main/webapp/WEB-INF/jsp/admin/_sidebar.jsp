<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
  Sidebar de navegación del panel de administración.
  Incluir con <jsp:include page="/WEB-INF/jsp/admin/_sidebar.jsp"><jsp:param name="activo" value="..."/></jsp:include>
  Valores válidos de "activo": dashboard, gestionar, documentos, bienestar, estadisticas, mascotas, registrar, reportes
--%>
<aside class="col-lg-2 sidebar">
    <a href="/admin/dashboard" class="${param.activo == 'dashboard' ? 'active' : ''}">
        <i class="fas fa-tachometer-alt"></i> Dashboard
    </a>
    <a href="/admin/solicitudes/gestionar" class="${param.activo == 'gestionar' ? 'active' : ''}">
        <i class="fas fa-tasks"></i> Gestionar estados
    </a>
    <a href="/admin/documentos" class="${param.activo == 'documentos' ? 'active' : ''}">
        <i class="fas fa-file-alt"></i> Documentos
    </a>
    <a href="/admin/bienestar" class="${param.activo == 'bienestar' ? 'active' : ''}">
        <i class="fas fa-heartbeat"></i> Bienestar
    </a>
    <a href="/admin/estadisticas" class="${param.activo == 'estadisticas' ? 'active' : ''}">
        <i class="fas fa-chart-pie"></i> Estadísticas
    </a>
    <a href="/mascotas/lista" class="${param.activo == 'mascotas' ? 'active' : ''}">
        <i class="fas fa-list"></i> Lista de Mascotas
    </a>
    <a href="/mascotas/registrar" class="${param.activo == 'registrar' ? 'active' : ''}">
        <i class="fas fa-plus-circle"></i> Registrar Mascota
    </a>
    <a href="/admin/reporte/mascotas" class="${param.activo == 'reportes' ? 'active' : ''}">
        <i class="fas fa-chart-bar"></i> Reportes
    </a>
    <hr style="border-color: rgba(255,255,255,0.2);">
    <a href="/acceso">
        <i class="fas fa-home"></i> Ir al sitio
    </a>
</aside>