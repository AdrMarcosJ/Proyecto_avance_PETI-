<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="negocio.ClsNPeti, negocio.ClsNGrupo" %>
<%@ page import="java.util.Map, java.util.List" %>
<%@page import="java.io.*"%>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener parámetros de la URL
    String modo = request.getParameter("modo");
    String grupoParam = request.getParameter("grupo");
    String rolParam = request.getParameter("rol");
    
    // Obtener información del grupo desde la sesión
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    
    // Determinar si está en modo colaborativo
    boolean modoColaborativo = "colaborativo".equals(modo) && grupoActual != null;
    
    // Obtener información del usuario para mostrar en el dashboard
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        userEmail = "usuario@ejemplo.com";
    }
    
    // Generar iniciales del usuario
    String userInitials = "U";
    if (usuario != null && usuario.length() > 0) {
        userInitials = usuario.substring(0, 1).toUpperCase();
        if (usuario.contains(" ") && usuario.length() > usuario.indexOf(" ") + 1) {
            userInitials += usuario.substring(usuario.indexOf(" ") + 1, usuario.indexOf(" ") + 2).toUpperCase();
        }
    }
    
    // Obtener datos del PETI si está en modo colaborativo
    Map<String, Map<String, String>> datosPeti = null;
    List<Map<String, Object>> historialCambios = null;
    int progreso = 0;
    
    if (modoColaborativo && grupoId != null) {
        ClsNPeti negocioPeti = new ClsNPeti();
        datosPeti = negocioPeti.obtenerTodosDatos(grupoId);
        historialCambios = negocioPeti.obtenerHistorial(grupoId, 5);
        progreso = negocioPeti.obtenerProgreso(grupoId);
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: #f8f9fa;
            height: 100vh;
            overflow: hidden;
        }

        .dashboard-container {
            width: 100vw;
            height: 100vh;
            display: flex;
            overflow: hidden;
        }

        .dashboard-sidebar {
            width: 280px;
            min-width: 280px;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }

        .user-profile {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            padding: 20px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            margin-bottom: 30px;
        }

        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
            backdrop-filter: blur(10px);
        }

        .user-info h3 {
            margin-bottom: 5px;
            font-size: 18px;
            font-weight: 600;
        }

        .user-info p {
            font-size: 14px;
            opacity: 0.8;
        }

        .dashboard-nav ul {
            list-style: none;
            padding: 0;
        }

        .dashboard-nav li {
            margin-bottom: 5px;
        }

        .dashboard-nav a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            padding: 12px 15px;
            display: flex;
            align-items: center;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .dashboard-nav a i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }

        .dashboard-nav a:hover,
        .dashboard-nav li.active a {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            transform: translateX(5px);
        }

        .dashboard-content {
            flex: 1;
            background: #f8f9fa;
            overflow-y: auto;
            height: 100vh;
        }

        .dashboard-header {
            background: white;
            padding: 20px 30px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .dashboard-header h1 {
            color: #2c3e50;
            font-size: 28px;
            font-weight: 600;
            margin: 0;
        }

        .dashboard-main {
            padding: 30px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-primary i {
            margin-right: 8px;
        }

        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            display: flex;
            align-items: center;
            transition: all 0.2s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .card-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            margin-right: 20px;
            flex-shrink: 0;
        }

        .card-content {
            flex: 1;
        }

        .card-content h3 {
            font-size: 16px;
            color: #666;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .card-value {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
        }

        .dashboard-section {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
        }

        .dashboard-section h2 {
            margin-bottom: 20px;
            color: #2c3e50;
            font-size: 20px;
            font-weight: 600;
        }

        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .activity-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            margin-right: 15px;
            flex-shrink: 0;
        }

        .activity-content {
            flex: 1;
        }

        .activity-content p {
            margin: 0 0 5px 0;
            color: #555;
            line-height: 1.4;
        }

        .activity-content strong {
            color: #333;
        }

        .activity-content small {
            color: #999;
            font-size: 12px;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
                height: auto;
                min-height: 100vh;
            }
            
            .dashboard-sidebar {
                width: 100%;
                order: 2;
                padding: 15px;
            }
            
            .dashboard-content {
                order: 1;
                height: auto;
            }
            
            .dashboard-main {
                padding: 20px;
            }
            
            .dashboard-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-sidebar">
            <div class="user-profile">
                <div class="user-avatar">
                    <span id="userInitials"><%= userInitials %></span>
                </div>
                <div class="user-info">
                    <h3 id="userName"><%= usuario %></h3>
                    <p id="userEmail"><%= userEmail %></p>
                </div>
            </div>
            <nav class="dashboard-nav">
                <ul>
                    <li class="active"><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                    <li><a href="empresa_colaborativo.jsp"><i class="fas fa-building"></i> Empresa</a></li>
                    <li><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión</a></li>
                    <li><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión</a></li>
                    <li><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores</a></li>
                    <li><a href="analisis_externo_colaborativo.jsp"><i class="fas fa-search"></i> Análisis Externo</a></li>
                    <li><a href="analisis_interno_colaborativo.jsp"><i class="fas fa-chart-bar"></i> Análisis Interno</a></li>
                    <li><a href="pest_colaborativo.jsp"><i class="fas fa-chart-pie"></i> Análisis PEST</a></li>
                    <li><a href="porter_colaborativo.jsp"><i class="fas fa-chess"></i> 5 Fuerzas Porter</a></li>
                    <li><a href="matriz_came_colaborativo.jsp"><i class="fas fa-th"></i> Matriz CAME</a></li>
                    <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                    <li><a href="objetivos_colaborativo.jsp"><i class="fas fa-target"></i> Objetivos</a></li>
                    <li><a href="identificacion_estrategia_colaborativo.jsp"><i class="fas fa-lightbulb"></i> Estrategias</a></li>
                    <li><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-users"></i> Matriz Participación</a></li>
                    <li><a href="resumen-ejecutivo-colaborativo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                </ul>
            </nav>
        </div>
        <div class="dashboard-content">
            <header class="dashboard-header">
                <h1>
                    <% if (modoColaborativo) { %>
                        Dashboard PETI - <%= grupoActual %>
                    <% } else { %>
                        Dashboard PETI - Modo Individual
                    <% } %>
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <span style="color: #666; font-size: 14px;">
                                <i class="fas fa-users"></i> Modo Colaborativo
                                <% if ("admin".equals(rolUsuario)) { %>
                                    <span style="color: #ffc107;">👑 Admin</span>
                                <% } %>
                            </span>
                            <button class="btn-primary" onclick="verHistorial()">
                                <i class="fas fa-history"></i> Historial
                            </button>
                        </div>
                    <% } else { %>
                        <button class="btn-primary" onclick="window.location.href='../menuprincipal.jsp'">
                            <i class="fas fa-users"></i> Unirse a Grupo
                        </button>
                    <% } %>
                </div>
            </header>
            <main class="dashboard-main">
                <% if (modoColaborativo) { %>
                    <!-- Modo Colaborativo -->
                    <div class="dashboard-cards">
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-percentage"></i></div>
                            <div class="card-content">
                                <h3>Progreso PETI</h3>
                                <p class="card-value"><%= progreso %>%</p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-users"></i></div>
                            <div class="card-content">
                                <h3>Miembros Activos</h3>
                                <p class="card-value"><!-- Se cargará dinámicamente --></p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-edit"></i></div>
                            <div class="card-content">
                                <h3>Cambios Hoy</h3>
                                <p class="card-value"><%= historialCambios != null ? historialCambios.size() : 0 %></p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-clock"></i></div>
                            <div class="card-content">
                                <h3>Última Actividad</h3>
                                <p class="card-value" style="font-size: 14px;">
                                    <% if (historialCambios != null && !historialCambios.isEmpty()) { %>
                                        <%= new java.text.SimpleDateFormat("HH:mm").format(historialCambios.get(0).get("fecha_cambio")) %>
                                    <% } else { %>
                                        --:--
                                    <% } %>
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Barra de progreso visual -->
                    <div class="dashboard-section">
                        <h2>Progreso del PETI</h2>
                        <div style="background: #f8f9fa; border-radius: 10px; height: 20px; overflow: hidden; margin-bottom: 20px;">
                            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 100%; width: <%= progreso %>%; transition: width 0.3s ease;"></div>
                        </div>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                            <div style="text-align: center; padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                <strong>Misión & Visión</strong><br>
                                <span style="color: <%= (datosPeti != null && datosPeti.containsKey("mision")) ? "#28a745" : "#dc3545" %>;">
                                    <%= (datosPeti != null && datosPeti.containsKey("mision")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div style="text-align: center; padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                <strong>Análisis FODA</strong><br>
                                <span style="color: <%= (datosPeti != null && (datosPeti.containsKey("analisis_interno") || datosPeti.containsKey("analisis_externo"))) ? "#28a745" : "#dc3545" %>;">
                                    <%= (datosPeti != null && (datosPeti.containsKey("analisis_interno") || datosPeti.containsKey("analisis_externo"))) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div style="text-align: center; padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                <strong>Estrategias</strong><br>
                                <span style="color: <%= (datosPeti != null && datosPeti.containsKey("estrategia")) ? "#28a745" : "#dc3545" %>;">
                                    <%= (datosPeti != null && datosPeti.containsKey("estrategia")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Actividad Reciente del Grupo -->
                    <div class="dashboard-section">
                        <h2>Actividad Reciente del Grupo</h2>
                        <div class="activity-list">
                            <% if (historialCambios != null && !historialCambios.isEmpty()) { %>
                                <% for (Map<String, Object> cambio : historialCambios) { %>
                                    <div class="activity-item">
                                        <div class="activity-icon">
                                            <% 
                                                String accion = (String) cambio.get("accion");
                                                if ("crear".equals(accion)) {
                                            %>
                                                <i class="fas fa-plus"></i>
                                            <% } else if ("modificar".equals(accion)) { %>
                                                <i class="fas fa-edit"></i>
                                            <% } else { %>
                                                <i class="fas fa-trash"></i>
                                            <% } %>
                                        </div>
                                        <div class="activity-content">
                                            <p><strong><%= cambio.get("usuario") %></strong> 
                                               <%= "crear".equals(accion) ? "creó" : ("modificar".equals(accion) ? "modificó" : "eliminó") %>
                                               <strong><%= cambio.get("campo") %></strong> en <strong><%= cambio.get("seccion") %></strong>
                                            </p>
                                            <% if (cambio.get("valor_nuevo") != null) { %>
                                                <p style="color: #666; font-size: 13px; margin-top: 5px;">
                                                    <%= ((String)cambio.get("valor_nuevo")).length() > 100 ? 
                                                        ((String)cambio.get("valor_nuevo")).substring(0, 100) + "..." : 
                                                        cambio.get("valor_nuevo") %>
                                                </p>
                                            <% } %>
                                            <small><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(cambio.get("fecha_cambio")) %></small>
                                        </div>
                                    </div>
                                <% } %>
                            <% } else { %>
                                <div style="text-align: center; padding: 40px; color: #666;">
                                    <i class="fas fa-history" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>
                                    <p>No hay actividad reciente en el grupo</p>
                                    <p style="font-size: 14px;">¡Comienza editando las secciones del PETI!</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } else { %>
                    <!-- Modo Individual -->
                    <div class="dashboard-cards">
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-user"></i></div>
                            <div class="card-content">
                                <h3>Modo</h3>
                                <p class="card-value" style="font-size: 16px;">Individual</p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-file-alt"></i></div>
                            <div class="card-content">
                                <h3>Secciones</h3>
                                <p class="card-value">15</p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-clock"></i></div>
                            <div class="card-content">
                                <h3>Tiempo Estimado</h3>
                                <p class="card-value" style="font-size: 16px;">2-3 horas</p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-info-circle"></i></div>
                            <div class="card-content">
                                <h3>Estado</h3>
                                <p class="card-value" style="font-size: 16px;">Solo lectura</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="dashboard-section">
                        <h2>Información del Modo Individual</h2>
                        <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 20px; margin-bottom: 20px;">
                            <h4 style="color: #856404; margin: 0 0 10px 0;">
                                <i class="fas fa-exclamation-triangle"></i> Limitaciones del Modo Individual
                            </h4>
                            <ul style="color: #856404; margin: 0; padding-left: 20px;">
                                <li>No puedes guardar cambios permanentes</li>
                                <li>No hay colaboración en tiempo real</li>
                                <li>Los datos no se sincronizan</li>
                                <li>Solo puedes explorar las funcionalidades</li>
                            </ul>
                        </div>
                        
                        <div style="background: #d1ecf1; border: 1px solid #bee5eb; border-radius: 8px; padding: 20px;">
                            <h4 style="color: #0c5460; margin: 0 0 10px 0;">
                                <i class="fas fa-lightbulb"></i> ¿Quieres trabajar colaborativamente?
                            </h4>
                            <p style="color: #0c5460; margin: 0 0 15px 0;">
                                Únete a un grupo o crea uno nuevo para trabajar en equipo y guardar el progreso del PETI.
                            </p>
                            <button class="btn-primary" onclick="window.location.href='../menuprincipal.jsp'">
                                <i class="fas fa-users"></i> Ir al Menú Principal
                            </button>
                        </div>
                    </div>
                    
                    <div class="dashboard-section">
                        <h2>Secciones del PETI</h2>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                            <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-left: 4px solid #667eea;">
                                <h4 style="margin: 0 0 10px 0; color: #333;">📊 Análisis Estratégico</h4>
                                <p style="margin: 0; color: #666; font-size: 14px;">FODA, PEST, Porter, Matriz CAME</p>
                            </div>
                            <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-left: 4px solid #28a745;">
                                <h4 style="margin: 0 0 10px 0; color: #333;">🎯 Definición Organizacional</h4>
                                <p style="margin: 0; color: #666; font-size: 14px;">Misión, Visión, Valores, Objetivos</p>
                            </div>
                            <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-left: 4px solid #ffc107;">
                                <h4 style="margin: 0 0 10px 0; color: #333;">⚡ Estrategias de TI</h4>
                                <p style="margin: 0; color: #666; font-size: 14px;">Identificación y Planificación</p>
                            </div>
                            <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-left: 4px solid #17a2b8;">
                                <h4 style="margin: 0 0 10px 0; color: #333;">📄 Documentación</h4>
                                <p style="margin: 0; color: #666; font-size: 14px;">Resumen Ejecutivo y Reportes</p>
                            </div>
                        </div>
                    </div>
                <% } %>
            </main>
        </div>
    </div>
    
    <script>
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }
        
        function verHistorial() {
            // Función para mostrar el historial completo en un modal
            alert('Funcionalidad de historial completo - Por implementar');
        }
        
        // Auto-refresh para modo colaborativo (cada 30 segundos)
        <% if (modoColaborativo) { %>
            let lastUpdate = new Date();
            
            function checkForUpdates() {
                // Verificar si hay actualizaciones del grupo
                fetch('api/checkUpdates.jsp?grupo=<%= grupoId %>&last=' + lastUpdate.getTime())
                    .then(response => response.json())
                    .then(data => {
                        if (data.hasUpdates) {
                            // Mostrar notificación de actualización
                            showUpdateNotification(data.changes);
                            lastUpdate = new Date();
                        }
                    })
                    .catch(error => console.log('Error checking updates:', error));
            }
            
            function showUpdateNotification(changes) {
                const notification = document.createElement('div');
                notification.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: #4CAF50;
                    color: white;
                    padding: 15px 20px;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                    z-index: 1000;
                    max-width: 300px;
                `;
                notification.innerHTML = `
                    <div style="display: flex; align-items: center;">
                        <i class="fas fa-sync-alt" style="margin-right: 10px;"></i>
                        <div>
                            <strong>Actualización disponible</strong><br>
                            <small>${changes} cambio(s) nuevo(s)</small>
                        </div>
                        <button onclick="this.parentElement.parentElement.remove()" style="background: none; border: none; color: white; margin-left: 10px; cursor: pointer;">×</button>
                    </div>
                `;
                document.body.appendChild(notification);
                
                // Auto-remover después de 5 segundos
                setTimeout(() => {
                    if (notification.parentElement) {
                        notification.remove();
                    }
                }, 5000);
            }
            
            // Iniciar verificación automática cada 30 segundos
            setInterval(checkForUpdates, 30000);
        <% } %>
        
        // Función para navegar entre secciones
        function navigateToSection(section) {
            <% if (modoColaborativo) { %>
                window.location.href = section + '.jsp?modo=colaborativo&grupo=<%= grupoActual %>&rol=<%= rolUsuario %>';
            <% } else { %>
                window.location.href = section + '.jsp?modo=individual';
            <% } %>
        }
        
        // Actualizar enlaces de navegación
        document.addEventListener('DOMContentLoaded', function() {
            const navLinks = document.querySelectorAll('.dashboard-nav a[href$=".jsp"]');
            navLinks.forEach(link => {
                const originalHref = link.getAttribute('href');
                <% if (modoColaborativo) { %>
                    link.setAttribute('href', originalHref + '?modo=colaborativo&grupo=<%= grupoActual %>&rol=<%= rolUsuario %>');
                <% } else { %>
                    link.setAttribute('href', originalHref + '?modo=individual');
                <% } %>
            });
        });
    </script>
</body>
</html>