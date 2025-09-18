<%-- 
    Document   : menuprincipal
    Created on : 15 set. 2025
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Random"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Verificar si el usuario ya tiene un grupo asignado
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario"); // "admin" o "miembro"
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Menú Principal - Proyecto PETI</title>
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
                padding: 2rem;
            }
            
            .header {
                background: white;
                padding: 1rem 2rem;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .user-info h2 {
                color: #333;
                margin-bottom: 0.5rem;
            }
            
            .user-info p {
                color: #666;
                font-size: 0.9rem;
            }
            
            .logout-btn {
                background: #dc3545;
                color: white;
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                cursor: pointer;
                text-decoration: none;
                font-size: 0.9rem;
            }
            
            .logout-btn:hover {
                background: #c82333;
            }
            
            .main-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 2rem;
                max-width: 1200px;
                margin: 0 auto;
            }
            
            .card {
                background: white;
                padding: 2rem;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            }
            
            .card h3 {
                color: #333;
                margin-bottom: 1rem;
                font-size: 1.5rem;
            }
            
            .card p {
                color: #666;
                margin-bottom: 1.5rem;
                line-height: 1.6;
            }
            
            .form-group {
                margin-bottom: 1rem;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                color: #333;
                font-weight: 500;
            }
            
            .form-group input, .form-group select {
                width: 100%;
                padding: 0.75rem;
                border: 2px solid #e1e5e9;
                border-radius: 8px;
                font-size: 1rem;
            }
            
            .form-group input:focus, .form-group select:focus {
                outline: none;
                border-color: #667eea;
            }
            
            .btn {
                width: 100%;
                padding: 0.75rem;
                border: none;
                border-radius: 8px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.2s ease;
            }
            
            .btn:hover {
                transform: translateY(-2px);
            }
            
            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            
            .btn-success {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
            }
            
            .btn-info {
                background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
                color: white;
            }
            
            .btn-secondary {
                background: #6c757d;
                color: white;
            }
            
            .btn-secondary:hover {
                background: #5a6268;
            }
            
            .action-buttons {
                display: flex;
                gap: 1rem;
                margin-top: 1rem;
            }
            
            .action-buttons .btn {
                flex: 1;
                width: auto;
            }
            
            .codigo-display {
                background: #f8f9fa;
                border: 2px dashed #667eea;
                padding: 1rem;
                border-radius: 8px;
                text-align: center;
                margin: 1rem 0;
            }
            
            .codigo-display .codigo {
                font-size: 2rem;
                font-weight: bold;
                color: #667eea;
                letter-spacing: 0.2rem;
            }
            
            .grupo-info {
                background: #e3f2fd;
                border-left: 4px solid #2196f3;
                padding: 1rem;
                border-radius: 0 8px 8px 0;
                margin-bottom: 1rem;
            }
            
            .grupo-info h4 {
                color: #1976d2;
                margin-bottom: 0.5rem;
            }
            
            .grupo-info p {
                color: #424242;
                margin: 0;
            }
            
            .miembros-list {
                background: #f5f5f5;
                padding: 1rem;
                border-radius: 8px;
                margin-top: 1rem;
            }
            
            .miembro-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0.5rem 0;
                border-bottom: 1px solid #ddd;
            }
            
            .miembro-item:last-child {
                border-bottom: none;
            }
            
            .admin-badge {
                background: #ffc107;
                color: #212529;
                padding: 0.2rem 0.5rem;
                border-radius: 4px;
                font-size: 0.8rem;
                font-weight: bold;
            }
            
            .alert {
                padding: 1rem;
                border-radius: 8px;
                margin-bottom: 1rem;
                font-size: 0.9rem;
            }
            
            .alert-error {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
            }
            
            .alert-success {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <div class="user-info">
                <h2>Bienvenido, <%= usuario %></h2>
                <p>
                    <% if (grupoActual != null) { %>
                        Grupo actual: <strong><%= grupoActual %></strong> 
                        (<%= "admin".equals(rolUsuario) ? "Administrador" : "Miembro" %>)
                    <% } else { %>
                        Sin grupo asignado
                    <% } %>
                </p>
            </div>
            <a href="logout.jsp" class="logout-btn">Cerrar Sesión</a>
        </div>
        
        <%
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            String grupo = request.getParameter("grupo");
            String codigo = request.getParameter("codigo");
            
            if (error != null) {
                String mensajeError = "";
                switch (error) {
                    case "ya_tiene_grupo":
                        mensajeError = "Ya perteneces a un grupo. No puedes crear o unirte a otro.";
                        break;
                    case "campos_vacios":
                        mensajeError = "Por favor, completa todos los campos requeridos.";
                        break;
                    case "limite_invalido":
                        mensajeError = "El límite de usuarios debe estar entre 2 y 100.";
                        break;
                    case "nombre_grupo_existe":
                        mensajeError = "Ya existe un grupo con ese nombre. Elige otro nombre.";
                        break;
                    case "codigo_vacio":
                        mensajeError = "Debes ingresar un código de grupo.";
                        break;
                    case "codigo_no_encontrado":
                        mensajeError = "El código ingresado no corresponde a ningún grupo existente.";
                        break;
                    case "grupo_lleno":
                        mensajeError = "El grupo ha alcanzado su límite máximo de usuarios.";
                        break;
                    case "ya_es_miembro":
                        mensajeError = "Ya eres miembro de este grupo.";
                        break;
                    case "sin_permisos":
                        mensajeError = "No tienes permisos para realizar esta acción.";
                        break;
                    case "grupo_no_encontrado":
                        mensajeError = "No se encontró el grupo especificado.";
                        break;
                    case "sin_grupo":
                        mensajeError = "No perteneces a ningún grupo actualmente.";
                        break;
                    case "admin_no_puede_salir":
                        mensajeError = "Como administrador, no puedes salir del grupo mientras tenga otros miembros. Transfiere la administración primero.";
                        break;
                    default:
                        mensajeError = "Ha ocurrido un error. Inténtalo de nuevo.";
                }
        %>
                <div class="alert alert-error">
                    <%= mensajeError %>
                </div>
        <%
            }
            
            if (success != null) {
                String mensajeExito = "";
                switch (success) {
                    case "grupo_creado":
                        mensajeExito = "¡Grupo creado exitosamente! Ahora eres el administrador.";
                        break;
                    case "unido_grupo":
                        mensajeExito = "¡Te has unido al grupo \"" + (grupo != null ? grupo : "desconocido") + "\" exitosamente!";
                        break;
                    case "codigo_generado":
                        mensajeExito = "¡Nuevo código generado exitosamente!" + (codigo != null ? " Código: " + codigo : "");
                        break;
                    case "salir_grupo":
                        mensajeExito = "Has salido del grupo exitosamente.";
                        break;
                    default:
                        mensajeExito = "Operación realizada con éxito.";
                }
        %>
                <div class="alert alert-success">
                    <%= mensajeExito %>
                </div>
        <%
            }
        %>
        
        <div class="main-container">
            <% if (grupoActual == null) { %>
                <!-- Usuario sin grupo - Puede crear o unirse -->
                <div class="card">
                    <h3>🚀 Crear Nuevo Grupo</h3>
                    <p>Crea tu propio grupo y conviértete en el administrador. Podrás generar códigos para que otros usuarios se unan.</p>
                    
                    <form action="crearGrupo.jsp" method="post">
                        <div class="form-group">
                            <label for="nombreGrupo">Nombre del Grupo:</label>
                            <input type="text" id="nombreGrupo" name="nombreGrupo" required placeholder="Ej: Equipo de Desarrollo">
                        </div>
                        
                        <div class="form-group">
                            <label for="limiteUsuarios">Límite de Usuarios:</label>
                            <select id="limiteUsuarios" name="limiteUsuarios" required>
                                <option value="5">5 usuarios</option>
                                <option value="10">10 usuarios</option>
                                <option value="15">15 usuarios</option>
                                <option value="20">20 usuarios</option>
                                <option value="25">25 usuarios</option>
                                <option value="50">50 usuarios</option>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Crear Grupo</button>
                    </form>
                </div>
                
                <div class="card">
                    <h3>🔗 Unirse a Grupo Existente</h3>
                    <p>¿Tienes un código de grupo? Ingrésalo aquí para unirte a un grupo existente.</p>
                    
                    <form action="unirseGrupo.jsp" method="post">
                        <div class="form-group">
                            <label for="codigoUnirse">Código de Grupo:</label>
                            <input type="text" id="codigoUnirse" name="codigoUnirse" required placeholder="Ej: ABC123" style="text-transform: uppercase;">
                        </div>
                        
                        <button type="submit" class="btn btn-success">Unirse al Grupo</button>
                    </form>
                </div>
            <% } else { %>
                <!-- Usuario con grupo asignado -->
                <div class="card">
                    <div class="grupo-info">
                        <h4>📋 Información del Grupo</h4>
                        <p><strong>Nombre:</strong> <%= grupoActual %></p>
                        <p><strong>Tu rol:</strong> <%= "admin".equals(rolUsuario) ? "Administrador" : "Miembro" %></p>
                    </div>
                    
                    <% if ("admin".equals(rolUsuario)) { %>
                        <h3>🎯 Panel de Administración</h3>
                        <p>Como administrador, puedes generar códigos para que nuevos usuarios se unan a tu grupo.</p>
                        
                        <div class="admin-actions">
                            <h4>🔧 Acciones de Administrador</h4>
                            <div class="action-buttons">
                                <a href="generarCodigo.jsp" class="btn btn-secondary">🔄 Generar Nuevo Código</a>
                                <a href="gestionarGrupo.jsp" class="btn btn-info">👥 Gestionar Miembros</a>
                            </div>
                        </div>
                        
                        <% 
                            String codigoActual = (String) session.getAttribute("codigoGrupo");
                            if (codigoActual != null) {
                        %>
                            <div class="codigo-display">
                                <p>Código actual del grupo:</p>
                                <div class="codigo"><%= codigoActual %></div>
                                <p style="font-size: 0.9rem; color: #666; margin-top: 0.5rem;">
                                    Comparte este código con los usuarios que quieras invitar
                                </p>
                            </div>
                        <% } %>
                    <% } else { %>
                        <h3>👥 Miembro del Grupo</h3>
                        <p>Eres miembro de este grupo. Puedes colaborar con otros miembros del equipo.</p>
                    <% } %>
                </div>
                
                <div class="card">
                    <h3>👥 Miembros del Grupo</h3>
                    <p>Lista de usuarios que pertenecen a este grupo.</p>
                    
                    <div class="miembros-list">
                        <!-- Aquí se mostrarían los miembros del grupo desde la base de datos -->
                        <div class="miembro-item">
                            <span><%= usuario %></span>
                            <% if ("admin".equals(rolUsuario)) { %>
                                <span class="admin-badge">ADMIN</span>
                            <% } %>
                        </div>
                        <!-- Más miembros se cargarían dinámicamente -->
                    </div>
                    
                    <% if ("admin".equals(rolUsuario)) { %>
                        <form action="gestionarGrupo.jsp" method="post" style="margin-top: 1rem;">
                            <button type="submit" class="btn btn-info">Gestionar Miembros</button>
                        </form>
                    <% } %>
                </div>
                
                <div class="card">
                    <h3>⚙️ Opciones</h3>
                    <p>Acciones disponibles para tu cuenta.</p>
                    
                    <form action="salirGrupo.jsp" method="post">
                        <button type="submit" class="btn" style="background: #dc3545; color: white;" 
                                onclick="return confirm('¿Estás seguro de que quieres salir del grupo?')">
                            Salir del Grupo
                        </button>
                    </form>
                </div>
            <% } %>
        </div>
    </body>
</html>