<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, entidad.ClsEPeti"%>
<%@page import="java.util.Map"%>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener información del grupo desde la sesión
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    
    // Verificar modo colaborativo
    boolean modoColaborativo = grupoActual != null && grupoId != null;
    
    // Obtener información del usuario
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
    
    String mensaje = "";
    String tipoMensaje = "";
    
    // Variables para almacenar las acciones CAME
    String accionesCorregir = "";
    String accionesAfrontar = "";
    String accionesMantener = "";
    String accionesExplotar = "";
    
    // Procesar guardado
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String accion = request.getParameter("accion");
        
        if ("guardar_came".equals(accion)) {
            String corregirData = request.getParameter("corregir_data");
            String afrontarData = request.getParameter("afrontar_data");
            String mantenerData = request.getParameter("mantener_data");
            String explotarData = request.getParameter("explotar_data");
            
            ClsNPeti negocioPeti = new ClsNPeti();
            boolean exito = true;
            
            try {
                if (corregirData != null && !corregirData.trim().isEmpty()) {
                    ClsEPeti datoC = new ClsEPeti(grupoId, "matriz_came", "acciones_corregir", corregirData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoC);
                }
                if (afrontarData != null && !afrontarData.trim().isEmpty()) {
                    ClsEPeti datoA = new ClsEPeti(grupoId, "matriz_came", "acciones_afrontar", afrontarData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoA);
                }
                if (mantenerData != null && !mantenerData.trim().isEmpty()) {
                    ClsEPeti datoM = new ClsEPeti(grupoId, "matriz_came", "acciones_mantener", mantenerData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoM);
                }
                if (explotarData != null && !explotarData.trim().isEmpty()) {
                    ClsEPeti datoE = new ClsEPeti(grupoId, "matriz_came", "acciones_explotar", explotarData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoE);
                }
                
                if (exito) {
                    mensaje = "Acciones CAME guardadas exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar las acciones";
                    tipoMensaje = "error";
                }
            } catch (Exception e) {
                mensaje = "Error interno: " + e.getMessage();
                tipoMensaje = "error";
            }
        }
    }
    
    // Cargar datos existentes
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            Map<String, String> datosCame = negocioPeti.obtenerDatosSeccion(grupoId, "matriz_came");
            
            if (datosCame.containsKey("acciones_corregir")) {
                accionesCorregir = datosCame.get("acciones_corregir");
            }
            if (datosCame.containsKey("acciones_afrontar")) {
                accionesAfrontar = datosCame.get("acciones_afrontar");
            }
            if (datosCame.containsKey("acciones_mantener")) {
                accionesMantener = datosCame.get("acciones_mantener");
            }
            if (datosCame.containsKey("acciones_explotar")) {
                accionesExplotar = datosCame.get("acciones_explotar");
            }
        } catch (Exception e) {
            mensaje = "Error al cargar datos: " + e.getMessage();
            tipoMensaje = "error";
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>11. Matriz CAME - PETI System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="dashboard.css">
    <style>
        :root {
            --primary-color: #1a365d;
            --accent-color: #3182ce;
            --success-color: #38a169;
            --warning-color: #d69e2e;
            --danger-color: #e53e3e;
            --light-bg: #f7fafc;
            --card-bg: #ffffff;
            --text-primary: #2d3748;
            --border-color: #e2e8f0;
            --came-corregir: #1e88a8;
            --came-afrontar: #1e88a8;
            --came-mantener: #1e88a8;
            --came-explotar: #1e88a8;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        body {
            background: var(--light-bg);
            min-height: 100vh;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .dashboard-sidebar {
            width: 280px;
            min-width: 280px;
            background: var(--primary-color);
            color: white;
            padding: 0;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            height: 100vh;
            overflow-y: auto;
            position: sticky;
            top: 0;
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
        }

        .company-logo {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
        }

        .company-logo i {
            font-size: 28px;
            margin-right: 12px;
            color: var(--accent-color);
        }

        .company-logo h2 {
            font-size: 20px;
            font-weight: 700;
        }

        .user-profile {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            margin-top: 8px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: var(--accent-color);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            font-weight: 600;
            margin-right: 12px;
        }

        .user-info h3 {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 2px;
        }

        .user-info p {
            font-size: 12px;
            opacity: 0.7;
        }

        .dashboard-nav {
            flex: 1;
            padding: 20px 0;
        }

        .nav-section {
            margin-bottom: 24px;
        }

        .nav-section-title {
            padding: 0 20px 8px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: rgba(255, 255, 255, 0.6);
        }

        .dashboard-nav ul {
            list-style: none;
            padding: 0;
        }

        .dashboard-nav li {
            margin-bottom: 2px;
        }

        .dashboard-nav a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            transition: all 0.2s ease;
            font-size: 14px;
            font-weight: 500;
        }

        .dashboard-nav a i {
            margin-right: 12px;
            width: 18px;
            text-align: center;
        }

        .dashboard-nav a:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .dashboard-nav li.active a {
            background: var(--accent-color);
            color: white;
        }

        .dashboard-content {
            flex: 1;
            overflow-y: auto;
        }

        .dashboard-header {
            background: var(--card-bg);
            padding: 20px 32px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .dashboard-header h1 {
            color: var(--text-primary);
            font-size: 24px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            background: rgba(49, 130, 206, 0.1);
            color: var(--accent-color);
            border-radius: 6px;
            font-size: 13px;
            font-weight: 500;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary {
            background: var(--accent-color);
            color: white;
        }

        .btn-primary:hover {
            background: #2c5282;
            transform: translateY(-1px);
        }

        .dashboard-main {
            padding: 32px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .alert {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        .alert-warning {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
        }

        .alert-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        .came-header {
            background: linear-gradient(135deg, #1e88a8, #16677f);
            color: white;
            padding: 32px;
            border-radius: 12px;
            margin-bottom: 32px;
            text-align: center;
        }

        .came-header h2 {
            font-size: 32px;
            margin-bottom: 12px;
        }

        .came-header p {
            font-size: 16px;
            opacity: 0.95;
            line-height: 1.6;
            margin-bottom: 8px;
        }

        .came-header .subtitle {
            font-style: italic;
            font-size: 15px;
            opacity: 0.9;
        }

        .came-matrix {
            background: white;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .came-section {
            margin-bottom: 40px;
        }

        .came-section:last-child {
            margin-bottom: 0;
        }

        .came-section-header {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            background: var(--came-corregir);
            color: white;
            border-radius: 8px 8px 0 0;
            font-weight: 700;
            font-size: 18px;
        }

        .came-section-header .letter {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: 900;
            margin-right: 16px;
        }

        .came-actions {
            border: 2px solid var(--came-corregir);
            border-top: none;
            border-radius: 0 0 8px 8px;
        }

        .came-action-row {
            display: flex;
            border-bottom: 2px solid var(--border-color);
        }

        .came-action-row:last-child {
            border-bottom: none;
        }

        .came-action-number {
            width: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f7fafc;
            border-right: 2px solid var(--border-color);
            font-weight: 700;
            font-size: 16px;
            color: var(--text-primary);
        }

        .came-action-input {
            flex: 1;
            padding: 0;
        }

        .came-action-input textarea {
            width: 100%;
            border: none;
            padding: 16px 20px;
            font-size: 14px;
            font-family: inherit;
            line-height: 1.6;
            resize: vertical;
            min-height: 60px;
        }

        .came-action-input textarea:focus {
            outline: none;
            background: #f7fafc;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }

            .dashboard-sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .dashboard-main {
                padding: 16px;
            }

            .came-header h2 {
                font-size: 24px;
            }

            .came-section-header {
                font-size: 16px;
            }

            .came-action-number {
                width: 50px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="company-logo">
                    <i class="fas fa-building"></i>
                    <h2>PETI System</h2>
                </div>
                <div class="user-profile">
                    <div class="user-avatar">
                        <%= userInitials %>
                    </div>
                    <div class="user-info">
                        <h3><%= usuario %></h3>
                        <p><%= userEmail %></p>
                        <% if (modoColaborativo) { %>
                            <p style="margin-top: 4px; font-size: 11px; color: #86efac;">
                                <i class="fas fa-users"></i> <%= grupoActual %>
                            </p>
                        <% } %>
                    </div>
                </div>
            </div>
            <nav class="dashboard-nav">
    <div class="nav-section">
        <div class="nav-section-title">Principal</div>
        <ul>
            <li><a href="dashboard.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-chart-line"></i> Dashboard</a></li>
        </ul>
    </div>
    
    <div class="nav-section">
        <div class="nav-section-title">Planificación Estratégica</div>
        <ul>
            <li><a href="empresa_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-building"></i> Información Empresarial</a></li>
            <li><a href="mision_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
            <li><a href="vision_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
            <li><a href="valores_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
            <li><a href="objetivos_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
        </ul>
    </div>

    <div class="nav-section">
        <div class="nav-section-title">Análisis Estratégico</div>
        <ul>
            <li><a href="analisis_externo_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
            <li><a href="analisis_interno_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-chart-bar"></i> Análisis Organizacional</a></li>
        </ul>
    </div>

    <div class="nav-section">
        <div class="nav-section-title">Herramientas de Gestión</div>
        <ul>
            <li><a href="cadena_valor_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-link"></i> Cadena de Valor</a></li>
            <li><a href="matriz_participacion_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-users"></i> Matriz de Participación</a></li>
            <li><a href="autodiagnostico_BCG.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-chart-pie"></i> Autodiagnóstico BCG</a></li>
            
            <li><a href="matriz_porter.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-industry"></i> Matriz de Porter</a></li>
            <li><a href="analisis_porter_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-industry"></i> Análisis de Porter</a></li>
            <li><a href="ANÁLISIS EXTERNO MACROENTORNO_PEST.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-globe"></i> Análisis PEST</a></li>
            <li><a href="IDENTIFICACIÓN DE ESTRATEGIAS.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-chess"></i> Estrategias</a></li>
            
            <li class="active"><a href="MATRIZ CAME.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-th"></i> Matriz CAME</a></li>
            
            <li><a href="resumen-ejecutivo-colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
        </ul>
    </div>
    
    <div class="nav-section">
        <div class="nav-section-title">Sistema</div>
        <ul>
            <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
        </ul>
    </div>
</nav>
        </div>

        <!-- Main Content -->
        <div class="dashboard-content">
            <header class="dashboard-header">
                <h1>
                    <i class="fas fa-th"></i>
                    11. MATRIZ CAME
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i> <%= grupoActual %>
                        </span>
                    <% } %>
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <button onclick="guardarCame()" class="btn btn-primary" style="margin-right: 12px;">
                            <i class="fas fa-save"></i> Guardar
                        </button>
                    <% } %>
                    <a href="dashboard.jsp" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Dashboard
                    </a>
                </div>
            </header>

            <main class="dashboard-main">
                <% if (!mensaje.isEmpty()) { %>
                    <div class="alert alert-<%= tipoMensaje %>">
                        <i class="fas fa-<%= "error".equals(tipoMensaje) ? "exclamation-triangle" : "check-circle" %>"></i>
                        <%= mensaje %>
                    </div>
                <% } %>

                <% if (!modoColaborativo) { %>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Modo Individual:</strong> Únete a un grupo para utilizar la Matriz CAME.
                    </div>
                <% } %>

                <!-- CAME Header -->
                <div class="came-header">
                    <h2>11. MATRIZ CAME</h2>
                    <p>A continuación y para finalizar de elaborar un Plan Estratégico, además de tener identificada la estrategia es necesario determinar acciones que permitan corregir las debilidades, afrontar las amenazas, mantener las fortalezas y explotar las oportunidades.</p>
                    <p class="subtitle">Reflexione y anote acciones a llevar a cabo teniendo en cuenta que estas acciones deben favorecer la ejecución exitosa de la estrategia general identificada.</p>
                </div>

                <!-- Matriz CAME -->
                <div class="came-matrix">
                    <!-- CORREGIR las debilidades -->
                    <div class="came-section">
                        <div class="came-section-header" style="background: var(--came-corregir);">
                            <div class="letter">C</div>
                            <div>Corregir las debilidades</div>
                        </div>
                        <div class="came-actions" style="border-color: var(--came-corregir);">
                            <% for (int i = 1; i <= 4; i++) { %>
                                <div class="came-action-row">
                                    <div class="came-action-number"><%= i %></div>
                                    <div class="came-action-input">
                                        <textarea id="corregir_<%= i %>" placeholder="Acción <%= i %> para corregir debilidades..."></textarea>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- AFRONTAR las amenazas -->
                    <div class="came-section">
                        <div class="came-section-header" style="background: var(--came-afrontar);">
                            <div class="letter">A</div>
                            <div>Afrontar las amenazas</div>
                        </div>
                        <div class="came-actions" style="border-color: var(--came-afrontar);">
                            <% for (int i = 5; i <= 8; i++) { %>
                                <div class="came-action-row">
                                    <div class="came-action-number"><%= i %></div>
                                    <div class="came-action-input">
                                        <textarea id="afrontar_<%= i %>" placeholder="Acción <%= i %> para afrontar amenazas..."></textarea>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- MANTENER las fortalezas -->
                    <div class="came-section">
                        <div class="came-section-header" style="background: var(--came-mantener);">
                            <div class="letter">M</div>
                            <div>Mantener las fortalezas</div>
                        </div>
                        <div class="came-actions" style="border-color: var(--came-mantener);">
                            <% for (int i = 9; i <= 12; i++) { %>
                                <div class="came-action-row">
                                    <div class="came-action-number"><%= i %></div>
                                    <div class="came-action-input">
                                        <textarea id="mantener_<%= i %>" placeholder="Acción <%= i %> para mantener fortalezas..."></textarea>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- EXPLOTAR las oportunidades -->
                    <div class="came-section">
                        <div class="came-section-header" style="background: var(--came-explotar);">
                            <div class="letter">E</div>
                            <div>Explotar las oportunidades</div>
                        </div>
                        <div class="came-actions" style="border-color: var(--came-explotar);">
                            <% for (int i = 13; i <= 16; i++) { %>
                                <div class="came-action-row">
                                    <div class="came-action-number"><%= i %></div>
                                    <div class="came-action-input">
                                        <textarea id="explotar_<%= i %>" placeholder="Acción <%= i %> para explotar oportunidades..."></textarea>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <% if (modoColaborativo) { %>
                    <div style="background: #e8f5e8; padding: 15px; border-radius: 8px; margin-top: 20px;">
                        <p style="color: #2d5a3d; margin: 0;">
                            <i class="fas fa-info-circle"></i> 
                            <strong>Colaboración:</strong> Las acciones se guardan automáticamente para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                        </p>
                    </div>
                <% } %>
            </main>
        </div>
    </div>

    <script>
        // Función para guardar acciones CAME
        function guardarCame() {
            if (!<%= modoColaborativo %>) {
                alert('Función disponible solo en modo colaborativo');
                return;
            }

            // Recopilar acciones de Corregir (C)
            const corregirData = {};
            for (let i = 1; i <= 4; i++) {
                const textarea = document.getElementById('corregir_' + i);
                if (textarea) {
                    corregirData['accion_' + i] = textarea.value;
                }
            }

            // Recopilar acciones de Afrontar (A)
            const afrontarData = {};
            for (let i = 5; i <= 8; i++) {
                const textarea = document.getElementById('afrontar_' + i);
                if (textarea) {
                    afrontarData['accion_' + i] = textarea.value;
                }
            }

            // Recopilar acciones de Mantener (M)
            const mantenerData = {};
            for (let i = 9; i <= 12; i++) {
                const textarea = document.getElementById('mantener_' + i);
                if (textarea) {
                    mantenerData['accion_' + i] = textarea.value;
                }
            }

            // Recopilar acciones de Explotar (E)
            const explotarData = {};
            for (let i = 13; i <= 16; i++) {
                const textarea = document.getElementById('explotar_' + i);
                if (textarea) {
                    explotarData['accion_' + i] = textarea.value;
                }
            }

            // Crear formulario y enviar
            const form = document.createElement('form');
            form.method = 'POST';
            form.style.display = 'none';

            const corregirInput = document.createElement('input');
            corregirInput.name = 'corregir_data';
            corregirInput.value = JSON.stringify(corregirData);
            form.appendChild(corregirInput);

            const afrontarInput = document.createElement('input');
            afrontarInput.name = 'afrontar_data';
            afrontarInput.value = JSON.stringify(afrontarData);
            form.appendChild(afrontarInput);

            const mantenerInput = document.createElement('input');
            mantenerInput.name = 'mantener_data';
            mantenerInput.value = JSON.stringify(mantenerData);
            form.appendChild(mantenerInput);

            const explotarInput = document.createElement('input');
            explotarInput.name = 'explotar_data';
            explotarInput.value = JSON.stringify(explotarData);
            form.appendChild(explotarInput);

            const accionInput = document.createElement('input');
            accionInput.name = 'accion';
            accionInput.value = 'guardar_came';
            form.appendChild(accionInput);

            document.body.appendChild(form);
            form.submit();
        }

        // Función para cargar datos guardados
        function cargarDatosGuardados() {
            <% if (modoColaborativo && !accionesCorregir.isEmpty()) { %>
                try {
                    const corregirData = JSON.parse('<%= accionesCorregir.replace("'", "\\'").replace("\n", "\\n").replace("\r", "") %>');
                    Object.keys(corregirData).forEach(key => {
                        const parts = key.split('_');
                        if (parts.length === 2) {
                            const textarea = document.getElementById('corregir_' + parts[1]);
                            if (textarea) textarea.value = corregirData[key];
                        }
                    });
                } catch (e) {
                    console.log('Error cargando Corregir:', e);
                }
            <% } %>

            <% if (modoColaborativo && !accionesAfrontar.isEmpty()) { %>
                try {
                    const afrontarData = JSON.parse('<%= accionesAfrontar.replace("'", "\\'").replace("\n", "\\n").replace("\r", "") %>');
                    Object.keys(afrontarData).forEach(key => {
                        const parts = key.split('_');
                        if (parts.length === 2) {
                            const textarea = document.getElementById('afrontar_' + parts[1]);
                            if (textarea) textarea.value = afrontarData[key];
                        }
                    });
                } catch (e) {
                    console.log('Error cargando Afrontar:', e);
                }
            <% } %>

            <% if (modoColaborativo && !accionesMantener.isEmpty()) { %>
                try {
                    const mantenerData = JSON.parse('<%= accionesMantener.replace("'", "\\'").replace("\n", "\\n").replace("\r", "") %>');
                    Object.keys(mantenerData).forEach(key => {
                        const parts = key.split('_');
                        if (parts.length === 2) {
                            const textarea = document.getElementById('mantener_' + parts[1]);
                            if (textarea) textarea.value = mantenerData[key];
                        }
                    });
                } catch (e) {
                    console.log('Error cargando Mantener:', e);
                }
            <% } %>

            <% if (modoColaborativo && !accionesExplotar.isEmpty()) { %>
                try {
                    const explotarData = JSON.parse('<%= accionesExplotar.replace("'", "\\'").replace("\n", "\\n").replace("\r", "") %>');
                    Object.keys(explotarData).forEach(key => {
                        const parts = key.split('_');
                        if (parts.length === 2) {
                            const textarea = document.getElementById('explotar_' + parts[1]);
                            if (textarea) textarea.value = explotarData[key];
                        }
                    });
                } catch (e) {
                    console.log('Error cargando Explotar:', e);
                }
            <% } %>
        }

        // Cargar datos al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            cargarDatosGuardados();
        });
    </script>
</body>
</html>
