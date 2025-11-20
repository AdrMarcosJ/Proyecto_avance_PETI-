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
    
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            
            // Guardar respuestas de las 25 preguntas
            for (int i = 1; i <= 25; i++) {
                String respuesta = request.getParameter("pregunta" + i);
                if (respuesta != null && !respuesta.trim().isEmpty()) {
                    ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "pregunta" + i, respuesta, usuarioId);
                    negocioPeti.guardarDato(dato);
                }
            }
            
            // Guardar evaluaciones de impacto
            String impactoSociales = request.getParameter("impacto_sociales");
            String impactoPoliticos = request.getParameter("impacto_politicos");
            String impactoEconomicos = request.getParameter("impacto_economicos");
            String impactoTecnologicos = request.getParameter("impacto_tecnologicos");
            String impactoMedioAmbiental = request.getParameter("impacto_medioambiental");
            
            if (impactoSociales != null) {
                ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "impacto_sociales", impactoSociales, usuarioId);
                negocioPeti.guardarDato(dato);
            }
            if (impactoPoliticos != null) {
                ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "impacto_politicos", impactoPoliticos, usuarioId);
                negocioPeti.guardarDato(dato);
            }
            if (impactoEconomicos != null) {
                ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "impacto_economicos", impactoEconomicos, usuarioId);
                negocioPeti.guardarDato(dato);
            }
            if (impactoTecnologicos != null) {
                ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "impacto_tecnologicos", impactoTecnologicos, usuarioId);
                negocioPeti.guardarDato(dato);
            }
            if (impactoMedioAmbiental != null) {
                ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "impacto_medioambiental", impactoMedioAmbiental, usuarioId);
                negocioPeti.guardarDato(dato);
            }
            
            // Guardar oportunidades y amenazas
            String oportunidad3 = request.getParameter("oportunidad3");
            String oportunidad4 = request.getParameter("oportunidad4");
            String amenaza3 = request.getParameter("amenaza3");
            String amenaza4 = request.getParameter("amenaza4");
            
            if (oportunidad3 != null && !oportunidad3.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "oportunidad3", oportunidad3, usuarioId);
                negocioPeti.guardarDato(dato);
            }
            if (oportunidad4 != null && !oportunidad4.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "oportunidad4", oportunidad4, usuarioId);
                negocioPeti.guardarDato(dato);
            }
            if (amenaza3 != null && !amenaza3.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "amenaza3", amenaza3, usuarioId);
                negocioPeti.guardarDato(dato);
            }
            if (amenaza4 != null && !amenaza4.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "pest_analisis", "amenaza4", amenaza4, usuarioId);
                negocioPeti.guardarDato(dato);
            }
            
            mensaje = "Análisis PEST guardado exitosamente";
            tipoMensaje = "success";
            
        } catch (Exception e) {
            mensaje = "Error al guardar: " + e.getMessage();
            tipoMensaje = "error";
            e.printStackTrace();
        }
    }
    
    // Cargar datos existentes
    Map<String, String> datosGuardados = null;
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            datosGuardados = negocioPeti.obtenerDatosSeccion(grupoId, "pest_analisis");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<%!
    // Función helper para obtener valor guardado
    String obtenerValor(Map<String, String> datos, String campo, String valorDefault) {
        if (datos != null && datos.containsKey(campo)) {
            return datos.get(campo);
        }
        return valorDefault;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Análisis PEST - Macroentorno</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="dashboard.css">
    <style>
        :root {
            --primary-color: #1a365d;
            --secondary-color: #2d3748;
            --accent-color: #3182ce;
            --success-color: #38a169;
            --warning-color: #d69e2e;
            --danger-color: #e53e3e;
            --light-bg: #f7fafc;
            --card-bg: #ffffff;
            --text-primary: #2d3748;
            --text-secondary: #4a5568;
            --border-color: #e2e8f0;
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

        /* Sidebar styles from dashboard */
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

        /* Content area */
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

        .header-actions {
            display: flex;
            gap: 12px;
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

        .btn-success {
            background: var(--success-color);
            color: white;
            font-size: 16px;
            padding: 12px 32px;
        }

        .btn-success:hover {
            background: #2f855a;
            transform: translateY(-1px);
        }

        /* Main content */
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

        .alert-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        .alert-warning {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
        }

        /* PEST Header */
        .pest-header {
            background: linear-gradient(135deg, var(--accent-color), #2c5282);
            color: white;
            padding: 32px;
            border-radius: 12px;
            margin-bottom: 32px;
            text-align: center;
        }

        .pest-header h2 {
            font-size: 32px;
            margin-bottom: 12px;
        }

        .pest-header p {
            font-size: 16px;
            opacity: 0.9;
        }

        /* Chart Container */
        .chart-container {
            background: white;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 32px;
        }

        .chart-container h3 {
            margin-bottom: 24px;
            color: var(--text-primary);
            font-size: 20px;
        }

        #pestChart {
            max-height: 400px;
        }

        /* Questions Table */
        .questions-section {
            background: white;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 32px;
        }

        .questions-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .questions-table thead {
            background: var(--accent-color);
            color: white;
        }

        .questions-table th {
            padding: 16px;
            text-align: center;
            font-weight: 600;
            font-size: 14px;
        }

        .questions-table tbody tr {
            border-bottom: 1px solid var(--border-color);
        }

        .questions-table tbody tr:hover {
            background: #f8f9fa;
        }

        .questions-table td {
            padding: 16px;
            vertical-align: middle;
        }

        .questions-table td:first-child {
            background: #e0f2fe;
            font-weight: 500;
            width: 50%;
        }

        .questions-table td.sociales {
            background: #dcfce7;
        }

        .questions-table td.politicos {
            background: #fef3c7;
        }

        .questions-table td.economicos {
            background: #fed7aa;
        }

        .questions-table td.tecnologicos {
            background: #dbeafe;
        }

        .questions-table td.medioambiental {
            background: #d1fae5;
        }

        .questions-table input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .questions-table td:not(:first-child) {
            text-align: center;
            width: 10%;
        }

        /* Impact Section */
        .impact-section {
            background: white;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 32px;
        }

        .impact-section h3 {
            margin-bottom: 20px;
            color: var(--text-primary);
        }

        .impact-grid {
            display: grid;
            gap: 16px;
        }

        .impact-item {
            padding: 16px;
            border-radius: 8px;
            border-left: 4px solid;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .impact-item.sociales { border-left-color: #22c55e; }
        .impact-item.politicos { border-left-color: #eab308; }
        .impact-item.economicos { border-left-color: #f97316; }
        .impact-item.tecnologicos { border-left-color: #3b82f6; }
        .impact-item.medioambiental { border-left-color: #10b981; }

        .impact-item input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }

        .impact-item label {
            font-weight: 500;
            cursor: pointer;
            flex: 1;
        }

        /* FODA Section */
        .foda-section {
            background: white;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 32px;
        }

        .foda-section h3 {
            margin-bottom: 20px;
            color: var(--text-primary);
        }

        .foda-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-top: 20px;
        }

        .foda-box {
            padding: 20px;
            border-radius: 8px;
            border: 2px solid;
        }

        .foda-box.oportunidades {
            border-color: #22c55e;
            background: #f0fdf4;
        }

        .foda-box.amenazas {
            border-color: #ef4444;
            background: #fef2f2;
        }

        .foda-box h4 {
            margin-bottom: 16px;
            text-align: center;
            font-size: 18px;
        }

        .foda-box textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            margin-bottom: 12px;
            resize: vertical;
            min-height: 80px;
        }

        /* Save Section */
        .save-section {
            background: linear-gradient(135deg, #10b981, #059669);
            padding: 32px;
            border-radius: 12px;
            text-align: center;
            color: white;
        }

        .save-section h3 {
            font-size: 24px;
            margin-bottom: 12px;
        }

        .save-section p {
            margin-bottom: 24px;
            opacity: 0.9;
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

            .foda-grid {
                grid-template-columns: 1fr;
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
                        <%= usuario != null && usuario.length() > 0 ? usuario.substring(0, 1).toUpperCase() : "U" %>
                    </div>
                    <div class="user-info">
                        <h3><%= usuario %></h3>
                        <p><%= modoColaborativo ? grupoActual : "Individual" %></p>
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
            
            <li class="active"><a href="ANÁLISIS EXTERNO MACROENTORNO_PEST.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-globe"></i> Análisis PEST</a></li>
            
            <%-- Enlaces faltantes agregados --%>
            <li><a href="IDENTIFICACIÓN DE ESTRATEGIAS.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-industry"></i> Estrategias</a></li>
            <li><a href="MATRIZ CAME.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-industry"></i> Matriz CAME</a></li>
            
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
                    <i class="fas fa-globe"></i>
                    9. ANÁLISIS EXTERNO MACROENTORNO: PEST
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i> <%= grupoActual %>
                        </span>
                    <% } %>
                </h1>
                <div class="header-actions">
                    <a href="dashboard.jsp" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Dashboard
                    </a>
                </div>
            </header>

            <main class="dashboard-main">
                <% if (!mensaje.isEmpty()) { %>
                    <div class="alert alert-<%= tipoMensaje %>">
                        <i class="fas fa-<%= "success".equals(tipoMensaje) ? "check-circle" : "exclamation-triangle" %>"></i>
                        <%= mensaje %>
                    </div>
                <% } %>

                <% if (!modoColaborativo) { %>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Modo Individual:</strong> Únete a un grupo para guardar tu análisis PEST.
                    </div>
                <% } %>

                <!-- PEST Header -->
                <div class="pest-header">
                    <h2>ANÁLISIS EXTERNO MACROENTORNO: PEST</h2>
                    <p><strong>PEST</strong> es un acrónimo y las letras representan el macro entorno de la empresa</p>
                    <p style="margin-top: 12px; font-size: 14px;">
                        <strong>Políticos:</strong> legislación, regulaciones | 
                        <strong>Económicos:</strong> tasas, inflación | 
                        <strong>Sociales:</strong> demografía, estilos de vida | 
                        <strong>Tecnológicos:</strong> innovación, automatización
                    </p>
                </div>

                <!-- Chart Section -->
                <div class="chart-container">
                    <h3><i class="fas fa-chart-bar"></i> Nivel de Impacto de Factores Generales Externos</h3>
                    <canvas id="pestChart"></canvas>
                </div>

                <form method="post" id="pestForm">
                    <!-- Questions Section -->
                    <div class="questions-section">
                        <h3><i class="fas fa-clipboard-list"></i> AUTODIAGNÓSTICO ENTORNO GLOBAL P.E.S.T.</h3>
                        <p style="margin-bottom: 20px; color: #666;">
                            Marque con una <strong>X</strong> para valorar su empresa en función de cada una de las afirmaciones:
                            <strong>0</strong>= En total desacuerdo, <strong>1</strong>= No está de acuerdo, 
                            <strong>2</strong>= Está de acuerdo, <strong>3</strong>= Está bastante de acuerdo, 
                            <strong>4</strong>= En total acuerdo
                        </p>

                        <table class="questions-table">
                            <thead>
                                <tr>
                                    <th>AUTODIAGNÓSTICO ENTORNO GLOBAL P.E.S.T.</th>
                                    <th>En total<br>desacuerdo<br>0</th>
                                    <th>No está de<br>acuerdo<br>1</th>
                                    <th>Está de<br>acuerdo<br>2</th>
                                    <th>Está bastante de<br>acuerdo<br>3</th>
                                    <th>En total<br>acuerdo<br>4</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Preguntas 1-5: Factores Sociales y Demográficos -->
                                <tr>
                                    <td class="sociales">1. Los cambios en la composición étnica de los consumidores de nuestro mercado.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta1" value="<%= i %>" 
                                            data-categoria="sociales" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta1", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="sociales">2. El envejecimiento de la población tiene un importante impacto en la demanda.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta2" value="<%= i %>" 
                                            data-categoria="sociales" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta2", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="sociales">3. Los nuevos estilos de vida y tendencias originan cambios en la oferta de nuestro sector.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta3" value="<%= i %>" 
                                            data-categoria="sociales" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta3", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="sociales">4. El envejecimiento de la población tiene un importante impacto en la oferta del sector donde operamos.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta4" value="<%= i %>" 
                                            data-categoria="sociales" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta4", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="sociales">5. Las variaciones en el nivel de riqueza de la población impactan considerablemente en la demanda de los productos/servicios del sector donde operamos.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta5" value="<%= i %>" 
                                            data-categoria="sociales" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta5", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>

                                <!-- Preguntas 6-10: Factores Políticos -->
                                <tr>
                                    <td class="politicos">6. La legislación fiscal afecta muy considerablemente a la economía de las empresas del sector donde operamos.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta6" value="<%= i %>" 
                                            data-categoria="politicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta6", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="politicos">7. La legislación laboral afecta muy considerablemente a la operativa del sector donde actuamos.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta7" value="<%= i %>" 
                                            data-categoria="politicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta7", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="politicos">8. Las subvenciones otorgadas por las Administraciones Públicas son claves en el desarrollo competitivo del mercado donde operamos.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta8" value="<%= i %>" 
                                            data-categoria="politicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta8", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="politicos">9. El impacto que tiene la legislación de protección al consumidor, en la manera de producir bienes y/o servicios es muy importante.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta9" value="<%= i %>" 
                                            data-categoria="politicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta9", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="politicos">10. La normativa autonómica tiene un impacto considerable en el funcionamiento del sector donde actuamos.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta10" value="<%= i %>" 
                                            data-categoria="politicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta10", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>

                                <!-- Preguntas 11-15: Factores Económicos -->
                                <tr>
                                    <td class="economicos">11. Las expectativas de crecimiento económico generales afectan crucialmente al mercado donde operamos.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta11" value="<%= i %>" 
                                            data-categoria="economicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta11", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="economicos">12. La política de tipos de interés es fundamental en el desarrollo financiero del sector donde trabaja nuestra empresa.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta12" value="<%= i %>" 
                                            data-categoria="economicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta12", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="economicos">13. La globalización permite a nuestra industria gozar de importantes oportunidades en nuevos mercados.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta13" value="<%= i %>" 
                                            data-categoria="economicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta13", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="economicos">14. La situación del empleo es fundamental para el desarrollo económico de nuestra empresa y nuestro sector.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta14" value="<%= i %>" 
                                            data-categoria="economicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta14", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="economicos">15. Las expectativas del ciclo económico de nuestro sector impactan en la situación económica de sus empresas.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta15" value="<%= i %>" 
                                            data-categoria="economicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta15", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>

                                <!-- Preguntas 16-20: Factores Tecnológicos -->
                                <tr>
                                    <td class="tecnologicos">16. Las Administraciones Públicas están incentivando el esfuerzo tecnológico de las empresas de nuestro sector.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta16" value="<%= i %>" 
                                            data-categoria="tecnologicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta16", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="tecnologicos">17. Internet, el comercio electrónico, el wireless y otras NTIC están impactando en la demanda de nuestros productos/servicios y en los de la competencia.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta17" value="<%= i %>" 
                                            data-categoria="tecnologicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta17", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="tecnologicos">18. El empleo de NTIC's es generalizado en el sector donde trabajamos.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta18" value="<%= i %>" 
                                            data-categoria="tecnologicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta18", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="tecnologicos">19. En nuestro sector, es de gran importancia ser pionero o referente en el empleo de aplicaciones tecnológicas.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta19" value="<%= i %>" 
                                            data-categoria="tecnologicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta19", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="tecnologicos">20. En el sector donde operamos, para ser competitivos, es condición "sine qua non" innovar constantemente.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta20" value="<%= i %>" 
                                            data-categoria="tecnologicos" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta20", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>

                                <!-- Preguntas 21-25: Factores Medio Ambientales -->
                                <tr>
                                    <td class="medioambiental">21. La legislación medioambiental afecta al desarrollo de nuestro sector.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta21" value="<%= i %>" 
                                            data-categoria="medioambiental" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta21", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="medioambiental">22. Los clientes de nuestro mercado exigen que se seamos socialmente responsables, en el plano medioambiental.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta22" value="<%= i %>" 
                                            data-categoria="medioambiental" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta22", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="medioambiental">23. En nuestro sector, las políticas medioambientales son una fuente de ventajas competitivas.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta23" value="<%= i %>" 
                                            data-categoria="medioambiental" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta23", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="medioambiental">24. La creciente preocupación social por el medio ambiente impacta notablemente en la demanda de productos/servicios ofertados en nuestro mercado.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta24" value="<%= i %>" 
                                            data-categoria="medioambiental" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta24", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                                <tr>
                                    <td class="medioambiental">25. El factor ecológico es una fuente de diferenciación clara en el sector donde opera nuestra empresa.</td>
                                    <% for (int i = 0; i <= 4; i++) { %>
                                        <td><input type="radio" name="pregunta25" value="<%= i %>" 
                                            data-categoria="medioambiental" data-puntos="<%= i * 5 %>"
                                            <%= obtenerValor(datosGuardados, "pregunta25", "").equals(String.valueOf(i)) ? "checked" : "" %>
                                            <%= modoColaborativo ? "" : "disabled" %>></td>
                                    <% } %>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Impact Evaluation Section -->
                    <div class="impact-section">
                        <h3><i class="fas fa-exclamation-circle"></i> Evaluación de Impacto Notable</h3>
                        <p style="margin-bottom: 20px; color: #666;">
                            Marque los factores que tienen un impacto notable en el funcionamiento de la empresa:
                        </p>
                        <div class="impact-grid">
                            <%
                                String impactoSocialesChecked = "SI".equals(obtenerValor(datosGuardados, "impacto_sociales", "")) ? "checked" : "";
                                String impactoPoliticosChecked = "SI".equals(obtenerValor(datosGuardados, "impacto_politicos", "")) ? "checked" : "";
                                String impactoEconomicosChecked = "SI".equals(obtenerValor(datosGuardados, "impacto_economicos", "")) ? "checked" : "";
                                String impactoTecnologicosChecked = "SI".equals(obtenerValor(datosGuardados, "impacto_tecnologicos", "")) ? "checked" : "";
                                String impactoMedioambientalChecked = "SI".equals(obtenerValor(datosGuardados, "impacto_medioambiental", "")) ? "checked" : "";
                            %>
                            <div class="impact-item sociales">
                                <input type="checkbox" id="impacto_sociales" name="impacto_sociales" value="SI" 
                                    <%= impactoSocialesChecked %> <%= modoColaborativo ? "" : "disabled" %>>
                                <label for="impacto_sociales">HAY UN NOTABLE IMPACTO DE FACTORES SOCIALES Y DEMOGRÁFICOS EN EL FUNCIONAMIENTO DE LA EMPRESA</label>
                            </div>
                            <div class="impact-item politicos">
                                <input type="checkbox" id="impacto_politicos" name="impacto_politicos" value="SI" 
                                    <%= impactoPoliticosChecked %> <%= modoColaborativo ? "" : "disabled" %>>
                                <label for="impacto_politicos">HAY UN NOTABLE IMPACTO DE FACTORES POLÍTICOS EN EL FUNCIONAMIENTO DE LA EMPRESA</label>
                            </div>
                            <div class="impact-item economicos">
                                <input type="checkbox" id="impacto_economicos" name="impacto_economicos" value="SI" 
                                    <%= impactoEconomicosChecked %> <%= modoColaborativo ? "" : "disabled" %>>
                                <label for="impacto_economicos">HAY UN NOTABLE IMPACTO DE FACTORES ECONÓMICOS EN EL FUNCIONAMIENTO DE LA EMPRESA</label>
                            </div>
                            <div class="impact-item tecnologicos">
                                <input type="checkbox" id="impacto_tecnologicos" name="impacto_tecnologicos" value="SI" 
                                    <%= impactoTecnologicosChecked %> <%= modoColaborativo ? "" : "disabled" %>>
                                <label for="impacto_tecnologicos">HAY UN NOTABLE IMPACTO DE FACTORES TECNOLÓGICOS EN EL FUNCIONAMIENTO DE LA EMPRESA</label>
                            </div>
                            <div class="impact-item medioambiental">
                                <input type="checkbox" id="impacto_medioambiental" name="impacto_medioambiental" value="SI" 
                                    <%= impactoMedioambientalChecked %> <%= modoColaborativo ? "" : "disabled" %>>
                                <label for="impacto_medioambiental">HAY UN NOTABLE IMPACTO DEL FACTOR MEDIO AMBIENTAL EN EL FUNCIONAMIENTO DE LA EMPRESA</label>
                            </div>
                        </div>
                    </div>

                    <!-- FODA Section -->
                    <div class="foda-section">
                        <h3><i class="fas fa-clipboard-check"></i> Oportunidades y Amenazas del Análisis PEST</h3>
                        <p style="margin-bottom: 20px; color: #666;">
                            A partir de la conclusión obtenida en el diagnóstico en cada uno de los factores, determine las oportunidades y amenazas más relevantes que desee que se reflejen en el análisis FODA de su Plan Estratégico
                        </p>
                        <div class="foda-grid">
                            <div class="foda-box oportunidades">
                                <h4>OPORTUNIDADES</h4>
                                <label>O3:</label>
                                <textarea name="oportunidad3" placeholder="Describa una oportunidad identificada..." <%= modoColaborativo ? "" : "readonly" %>><%= obtenerValor(datosGuardados, "oportunidad3", "") %></textarea>
                                <label>O4:</label>
                                <textarea name="oportunidad4" placeholder="Describa otra oportunidad identificada..." <%= modoColaborativo ? "" : "readonly" %>><%= obtenerValor(datosGuardados, "oportunidad4", "") %></textarea>
                            </div>
                            <div class="foda-box amenazas">
                                <h4>AMENAZAS</h4>
                                <label>A3:</label>
                                <textarea name="amenaza3" placeholder="Describa una amenaza identificada..." <%= modoColaborativo ? "" : "readonly" %>><%= obtenerValor(datosGuardados, "amenaza3", "") %></textarea>
                                <label>A4:</label>
                                <textarea name="amenaza4" placeholder="Describa otra amenaza identificada..." <%= modoColaborativo ? "" : "readonly" %>><%= obtenerValor(datosGuardados, "amenaza4", "") %></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Save Button -->
                    <% if (modoColaborativo) { %>
                        <div class="save-section">
                            <h3><i class="fas fa-save"></i> Guardar Análisis PEST Completo</h3>
                            <p>Toda la información será guardada y compartida con tu equipo de trabajo</p>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save"></i> Guardar Todo el Análisis
                            </button>
                        </div>
                    <% } %>
                </form>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script>
        // Datos para el gráfico
        let chartData = {
            sociales: 0,
            politicos: 0,
            economicos: 0,
            tecnologicos: 0,
            medioambiental: 0
        };

        // Calcular puntos iniciales desde datos guardados
        function calcularPuntosIniciales() {
            document.querySelectorAll('input[type="radio"]:checked').forEach(radio => {
                const categoria = radio.getAttribute('data-categoria');
                const puntos = parseInt(radio.getAttribute('data-puntos'));
                chartData[categoria] += puntos;
            });
            actualizarGrafico();
        }

        // Actualizar gráfico cuando cambian las respuestas
        document.querySelectorAll('input[type="radio"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const categoria = this.getAttribute('data-categoria');
                const puntos = parseInt(this.getAttribute('data-puntos'));
                const name = this.getAttribute('name');
                const currentValue = this.value;
                
                // Recalcular desde cero para esta categoría
                chartData[categoria] = 0;
                
                // Sumar todos los valores marcados de esta categoría
                document.querySelectorAll('input[data-categoria="' + categoria + '"]:checked').forEach(function(radio) {
                    chartData[categoria] += parseInt(radio.getAttribute('data-puntos'));
                });
                
                // Actualizar checkbox de impacto automáticamente
                actualizarCheckboxImpacto(categoria, chartData[categoria]);
                
                actualizarGrafico();
            });
        });

        // Función para actualizar checkbox de impacto según puntuación
        function actualizarCheckboxImpacto(categoria, puntos) {
            const umbral = 10; // Si tiene 10 o más puntos (2 respuestas o más con valor >= 2)
            let checkboxId = '';
            
            switch(categoria) {
                case 'sociales':
                    checkboxId = 'impacto_sociales';
                    break;
                case 'politicos':
                    checkboxId = 'impacto_politicos';
                    break;
                case 'economicos':
                    checkboxId = 'impacto_economicos';
                    break;
                case 'tecnologicos':
                    checkboxId = 'impacto_tecnologicos';
                    break;
                case 'medioambiental':
                    checkboxId = 'impacto_medioambiental';
                    break;
            }
            
            const checkbox = document.getElementById(checkboxId);
            if (checkbox && !checkbox.disabled) {
                checkbox.checked = (puntos >= umbral);
            }
        }

        // Crear el gráfico
        const ctx = document.getElementById('pestChart');
        const pestChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [
                    'FACTORES SOCIALES Y DEMOGRÁFICOS',
                    'FACTORES MEDIO AMBIENTALES',
                    'FACTORES POLÍTICOS',
                    'FACTORES ECONÓMICOS',
                    'FACTORES TECNOLÓGICOS'
                ],
                datasets: [{
                    label: 'Nivel de Impacto',
                    data: [0, 0, 0, 0, 0],
                    backgroundColor: [
                        '#22c55e',
                        '#10b981',
                        '#eab308',
                        '#f97316',
                        '#3b82f6'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        ticks: {
                            stepSize: 20,
                            font: {
                                size: 12
                            }
                        },
                        title: {
                            display: true,
                            text: 'Nivel de impacto de factores generales externos',
                            font: {
                                size: 14,
                                weight: 'bold'
                            }
                        }
                    },
                    x: {
                        ticks: {
                            font: {
                                size: 11
                            }
                        },
                        title: {
                            display: true,
                            text: 'Tipología de factores generales externos',
                            font: {
                                size: 14,
                                weight: 'bold'
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Impacto: ' + context.parsed.y + ' puntos';
                            }
                        }
                    }
                }
            }
        });

        function actualizarGrafico() {
            pestChart.data.datasets[0].data = [
                chartData.sociales,
                chartData.medioambiental,
                chartData.politicos,
                chartData.economicos,
                chartData.tecnologicos
            ];
            pestChart.update();
        }

        // Calcular puntos iniciales al cargar la página
        calcularPuntosIniciales();
        
        // Actualizar checkboxes iniciales basados en datos guardados
        Object.keys(chartData).forEach(categoria => {
            actualizarCheckboxImpacto(categoria, chartData[categoria]);
        });

        // Validar formulario antes de enviar
        document.getElementById('pestForm').addEventListener('submit', function(e) {
            let todasRespondidas = true;
            let preguntasSinResponder = [];
            
            for (let i = 1; i <= 25; i++) {
                const respondida = document.querySelector('input[name="pregunta' + i + '"]:checked');
                if (!respondida) {
                    todasRespondidas = false;
                    preguntasSinResponder.push(i);
                }
            }
            
            if (!todasRespondidas) {
                e.preventDefault();
                alert('Por favor, responda todas las 25 preguntas antes de guardar.\n\nPreguntas sin responder: ' + preguntasSinResponder.join(', '));
                return false;
            }
            
            // Confirmar antes de guardar
            return confirm('¿Está seguro de guardar el análisis PEST completo?\n\nSe guardará:\n- 25 respuestas\n- Evaluaciones de impacto\n- Oportunidades y amenazas');
        });
    </script>
</body>
</html>