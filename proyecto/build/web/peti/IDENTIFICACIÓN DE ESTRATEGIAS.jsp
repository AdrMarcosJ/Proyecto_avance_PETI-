<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, entidad.ClsEPeti"%>
<%@page import="java.util.Map, java.util.List, java.util.ArrayList"%>
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
    
    // Variables para almacenar puntuaciones guardadas
    String puntuacionesFO = "";
    String puntuacionesFA = "";
    String puntuacionesDO = "";
    String puntuacionesDA = "";
    
    // Procesar guardado de puntuaciones
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String accion = request.getParameter("accion");
        
        if ("guardar_puntuaciones".equals(accion)) {
            String foData = request.getParameter("fo_data");
            String faData = request.getParameter("fa_data");
            String doData = request.getParameter("do_data");
            String daData = request.getParameter("da_data");
            
            ClsNPeti negocioPeti = new ClsNPeti();
            boolean exito = true;
            
            try {
                if (foData != null && !foData.trim().isEmpty()) {
                    ClsEPeti datoFO = new ClsEPeti(grupoId, "identificacion_estrategia", "puntuaciones_fo", foData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoFO);
                }
                if (faData != null && !faData.trim().isEmpty()) {
                    ClsEPeti datoFA = new ClsEPeti(grupoId, "identificacion_estrategia", "puntuaciones_fa", faData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoFA);
                }
                if (doData != null && !doData.trim().isEmpty()) {
                    ClsEPeti datoDO = new ClsEPeti(grupoId, "identificacion_estrategia", "puntuaciones_do", doData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoDO);
                }
                if (daData != null && !daData.trim().isEmpty()) {
                    ClsEPeti datoDA = new ClsEPeti(grupoId, "identificacion_estrategia", "puntuaciones_da", daData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoDA);
                }
                
                if (exito) {
                    mensaje = "Puntuaciones guardadas exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar las puntuaciones";
                    tipoMensaje = "error";
                }
            } catch (Exception e) {
                mensaje = "Error interno: " + e.getMessage();
                tipoMensaje = "error";
            }
        }
    }
    
    // Listas para almacenar FODA
    List<String> fortalezas = new ArrayList<>();
    List<String> debilidades = new ArrayList<>();
    List<String> oportunidades = new ArrayList<>();
    List<String> amenazas = new ArrayList<>();
    
    // Cargar datos FODA desde la base de datos
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            
            // Obtener datos de PEST
            Map<String, String> datosPest = negocioPeti.obtenerDatosSeccion(grupoId, "pest_analisis");
            if (datosPest.containsKey("oportunidad3") && !datosPest.get("oportunidad3").trim().isEmpty()) {
                oportunidades.add(datosPest.get("oportunidad3"));
            }
            if (datosPest.containsKey("oportunidad4") && !datosPest.get("oportunidad4").trim().isEmpty()) {
                oportunidades.add(datosPest.get("oportunidad4"));
            }
            if (datosPest.containsKey("amenaza3") && !datosPest.get("amenaza3").trim().isEmpty()) {
                amenazas.add(datosPest.get("amenaza3"));
            }
            if (datosPest.containsKey("amenaza4") && !datosPest.get("amenaza4").trim().isEmpty()) {
                amenazas.add(datosPest.get("amenaza4"));
            }
            
            // Obtener datos de Porter
            Map<String, String> datosPorter = negocioPeti.obtenerDatosSeccion(grupoId, "porter_analisis");
            if (datosPorter.containsKey("oportunidad_1") && !datosPorter.get("oportunidad_1").trim().isEmpty()) {
                oportunidades.add(datosPorter.get("oportunidad_1"));
            }
            if (datosPorter.containsKey("oportunidad_2") && !datosPorter.get("oportunidad_2").trim().isEmpty()) {
                oportunidades.add(datosPorter.get("oportunidad_2"));
            }
            if (datosPorter.containsKey("amenaza_1") && !datosPorter.get("amenaza_1").trim().isEmpty()) {
                amenazas.add(datosPorter.get("amenaza_1"));
            }
            if (datosPorter.containsKey("amenaza_2") && !datosPorter.get("amenaza_2").trim().isEmpty()) {
                amenazas.add(datosPorter.get("amenaza_2"));
            }
            
            // Obtener datos de Cadena de Valor
            Map<String, String> datosCadena = negocioPeti.obtenerDatosSeccion(grupoId, "cadena_valor");
            if (datosCadena.containsKey("fortaleza1") && !datosCadena.get("fortaleza1").trim().isEmpty()) {
                fortalezas.add(datosCadena.get("fortaleza1"));
            }
            if (datosCadena.containsKey("fortaleza2") && !datosCadena.get("fortaleza2").trim().isEmpty()) {
                fortalezas.add(datosCadena.get("fortaleza2"));
            }
            if (datosCadena.containsKey("debilidad1") && !datosCadena.get("debilidad1").trim().isEmpty()) {
                debilidades.add(datosCadena.get("debilidad1"));
            }
            if (datosCadena.containsKey("debilidad2") && !datosCadena.get("debilidad2").trim().isEmpty()) {
                debilidades.add(datosCadena.get("debilidad2"));
            }
            
            // Obtener datos de BCG (si hay fortalezas/debilidades adicionales)
            Map<String, String> datosBCG = negocioPeti.obtenerDatosSeccion(grupoId, "bcg");
            if (datosBCG.containsKey("fortaleza3") && !datosBCG.get("fortaleza3").trim().isEmpty()) {
                fortalezas.add(datosBCG.get("fortaleza3"));
            }
            if (datosBCG.containsKey("fortaleza4") && !datosBCG.get("fortaleza4").trim().isEmpty()) {
                fortalezas.add(datosBCG.get("fortaleza4"));
            }
            if (datosBCG.containsKey("debilidad3") && !datosBCG.get("debilidad3").trim().isEmpty()) {
                debilidades.add(datosBCG.get("debilidad3"));
            }
            if (datosBCG.containsKey("debilidad4") && !datosBCG.get("debilidad4").trim().isEmpty()) {
                debilidades.add(datosBCG.get("debilidad4"));
            }
            
            // Cargar puntuaciones guardadas
            Map<String, String> datosEstrategia = negocioPeti.obtenerDatosSeccion(grupoId, "identificacion_estrategia");
            if (datosEstrategia.containsKey("puntuaciones_fo")) {
                puntuacionesFO = datosEstrategia.get("puntuaciones_fo");
            }
            if (datosEstrategia.containsKey("puntuaciones_fa")) {
                puntuacionesFA = datosEstrategia.get("puntuaciones_fa");
            }
            if (datosEstrategia.containsKey("puntuaciones_do")) {
                puntuacionesDO = datosEstrategia.get("puntuaciones_do");
            }
            if (datosEstrategia.containsKey("puntuaciones_da")) {
                puntuacionesDA = datosEstrategia.get("puntuaciones_da");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            mensaje = "Error al cargar datos FODA: " + e.getMessage();
            tipoMensaje = "error";
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>10. Identificación de Estrategias</title>
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

        /* Sidebar styles */
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

        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        /* Strategy Header */
        .strategy-header {
            background: linear-gradient(135deg, #3182ce, #2c5282);
            color: white;
            padding: 32px;
            border-radius: 12px;
            margin-bottom: 32px;
            text-align: center;
        }

        .strategy-header h2 {
            font-size: 32px;
            margin-bottom: 12px;
        }

        .strategy-header p {
            font-size: 16px;
            opacity: 0.9;
            line-height: 1.6;
        }

        /* DAFO Diagram */
        .dafo-diagram {
            background: white;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 32px;
        }

        .dafo-diagram h3 {
            text-align: center;
            margin-bottom: 32px;
            color: var(--text-primary);
            font-size: 24px;
        }

        .dafo-grid {
            display: grid;
            grid-template-columns: 200px 1fr 1fr;
            grid-template-rows: auto auto auto;
            gap: 2px;
            background: #cbd5e0;
            border: 2px solid #cbd5e0;
        }

        .dafo-cell {
            background: white;
            padding: 20px;
            min-height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .dafo-label {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            font-weight: 700;
            font-size: 16px;
            text-align: center;
        }

        .dafo-header {
            background: #e2e8f0;
            font-weight: 600;
            font-size: 18px;
            text-align: center;
            color: var(--text-primary);
        }

        .dafo-header.oportunidades {
            background: #fed7aa;
            color: #7c2d12;
        }

        .dafo-header.amenazas {
            background: #bfdbfe;
            color: #1e3a8a;
        }

        .estrategia-cell {
            background: #f8f9fa;
            font-size: 14px;
            line-height: 1.6;
        }

        .estrategia-cell.ofensiva {
            background: #ddd6fe;
            border-left: 4px solid #7c3aed;
        }

        .estrategia-cell.defensiva {
            background: #fce7f3;
            border-left: 4px solid #ec4899;
        }

        .estrategia-cell.reorientacion {
            background: #dbeafe;
            border-left: 4px solid #3b82f6;
        }

        .estrategia-cell.supervivencia {
            background: #fee2e2;
            border-left: 4px solid #ef4444;
        }

        .estrategia-title {
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 8px;
            text-transform: uppercase;
            font-size: 12px;
        }

        /* FODA Matrix */
        .foda-matrix {
            background: white;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 32px;
        }

        .foda-matrix h3 {
            margin-bottom: 24px;
            color: var(--text-primary);
            font-size: 20px;
        }

        .foda-grid-simple {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .foda-box {
            padding: 24px;
            border-radius: 12px;
            border: 2px solid;
            min-height: 250px;
        }

        .foda-box h4 {
            text-align: center;
            margin-bottom: 16px;
            font-size: 18px;
            font-weight: 700;
        }

        .foda-box.debilidades {
            background: #fef3c7;
            border-color: #f59e0b;
        }

        .foda-box.debilidades h4 {
            color: #92400e;
        }

        .foda-box.amenazas {
            background: #dbeafe;
            border-color: #3b82f6;
        }

        .foda-box.amenazas h4 {
            color: #1e3a8a;
        }

        .foda-box.fortalezas {
            background: #d1fae5;
            border-color: #10b981;
        }

        .foda-box.fortalezas h4 {
            color: #065f46;
        }

        .foda-box.oportunidades {
            background: #fed7aa;
            border-color: #f97316;
        }

        .foda-box.oportunidades h4 {
            color: #7c2d12;
        }

        .foda-list {
            list-style: none;
            padding: 0;
        }

        .foda-list li {
            padding: 12px;
            margin-bottom: 8px;
            background: white;
            border-radius: 6px;
            border-left: 3px solid;
            font-size: 14px;
            line-height: 1.5;
        }

        .foda-box.debilidades .foda-list li {
            border-left-color: #f59e0b;
        }

        .foda-box.amenazas .foda-list li {
            border-left-color: #3b82f6;
        }

        .foda-box.fortalezas .foda-list li {
            border-left-color: #10b981;
        }

        .foda-box.oportunidades .foda-list li {
            border-left-color: #f97316;
        }

        .empty-message {
            text-align: center;
            color: #9ca3af;
            font-style: italic;
            padding: 20px;
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

            .foda-grid-simple {
                grid-template-columns: 1fr;
            }

            .dafo-grid {
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
            
            <%-- Enlaces de Porter y PEST reubicados y completados --%>
            <li><a href="matriz_porter.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-industry"></i> Matriz de Porter</a></li>
            <li><a href="analisis_porter_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-industry"></i> Análisis de Porter</a></li>
            <li><a href="ANÁLISIS EXTERNO MACROENTORNO_PEST.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-globe"></i> Análisis PEST</a></li>
            
            <li class="active"><a href="IDENTIFICACIÓN DE ESTRATEGIAS.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-chess"></i> Estrategias</a></li>
            
            <%-- Matriz CAME faltante agregada --%>
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
                    <i class="fas fa-chess"></i>
                    10. IDENTIFICACIÓN DE ESTRATEGIAS
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i> <%= grupoActual %>
                        </span>
                    <% } %>
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <button onclick="guardarPuntuaciones()" class="btn btn-primary" style="margin-right: 12px;">
                            <i class="fas fa-save"></i> Guardar Puntuaciones
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
                        <strong>Modo Individual:</strong> Únete a un grupo para visualizar las estrategias.
                    </div>
                <% } %>

                <!-- Strategy Header -->
                <div class="strategy-header">
                    <h2>IDENTIFICACIÓN DE ESTRATEGIAS</h2>
                    <p>Tras el análisis realizado habiéndose identificado las oportunidades, amenazas, fortalezas y debilidades, es momento de identificar la estrategia que debe seguir en su empresa durante el logro de sus objetivos empresariales.</p>
                    <p style="margin-top: 12px;">Se trata de realizar una Matriz Cruzada tal y como se refleja en el siguiente dibujo para identificar la estrategia más conveniente a llevar a cabo.</p>
                </div>

                <!-- Matriz DAFO Diagram -->
                <div class="dafo-diagram">
                    <h3><i class="fas fa-project-diagram"></i> Matriz DAFO</h3>
                    <div class="dafo-grid">
                        <!-- Esquina superior izquierda vacía -->
                        <div class="dafo-cell dafo-label">Matriz DAFO</div>
                        <div class="dafo-cell dafo-header oportunidades">OPORTUNIDADES</div>
                        <div class="dafo-cell dafo-header amenazas">AMENAZAS</div>
                        
                        <!-- Fila de Fortalezas -->
                        <div class="dafo-cell dafo-label" style="background: #d1fae5; color: #065f46;">FORTALEZAS</div>
                        <div class="dafo-cell estrategia-cell ofensiva">
                            <div>
                                <div class="estrategia-title">ESTRATEGIAS OFENSIVAS</div>
                                <p>Maximizar fortalezas para aprovechar oportunidades</p>
                            </div>
                        </div>
                        <div class="dafo-cell estrategia-cell defensiva">
                            <div>
                                <div class="estrategia-title">ESTRATEGIAS DEFENSIVAS</div>
                                <p>Usar fortalezas para minimizar amenazas</p>
                            </div>
                        </div>
                        
                        <!-- Fila de Debilidades -->
                        <div class="dafo-cell dafo-label" style="background: #fef3c7; color: #92400e;">DEBILIDADES</div>
                        <div class="dafo-cell estrategia-cell reorientacion">
                            <div>
                                <div class="estrategia-title">ESTRATEGIAS DE REORIENTACIÓN</div>
                                <p>Superar debilidades aprovechando oportunidades</p>
                            </div>
                        </div>
                        <div class="dafo-cell estrategia-cell supervivencia">
                            <div>
                                <div class="estrategia-title">ESTRATEGIAS DE SUPERVIVENCIA</div>
                                <p>Reducir debilidades y evitar amenazas</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- FODA Matrix with Data -->
                <div class="foda-matrix">
                    <h3><i class="fas fa-clipboard-list"></i> Según ha ido cumplimentando en las fases anteriores, los factores internos y externos de su empresa son los siguientes:</h3>
                    
                    <div class="foda-grid-simple">
                        <!-- Debilidades -->
                        <div class="foda-box debilidades">
                            <h4>DEBILIDADES</h4>
                            <% if (debilidades.isEmpty()) { %>
                                <p class="empty-message">No se han identificado debilidades aún. Complete los análisis anteriores.</p>
                            <% } else { %>
                                <ul class="foda-list">
                                    <% for (String debilidad : debilidades) { %>
                                        <li><%= debilidad %></li>
                                    <% } %>
                                </ul>
                            <% } %>
                        </div>

                        <!-- Amenazas -->
                        <div class="foda-box amenazas">
                            <h4>AMENAZAS</h4>
                            <% if (amenazas.isEmpty()) { %>
                                <p class="empty-message">No se han identificado amenazas aún. Complete los análisis anteriores.</p>
                            <% } else { %>
                                <ul class="foda-list">
                                    <% for (String amenaza : amenazas) { %>
                                        <li><%= amenaza %></li>
                                    <% } %>
                                </ul>
                            <% } %>
                        </div>

                        <!-- Fortalezas -->
                        <div class="foda-box fortalezas">
                            <h4>FORTALEZAS</h4>
                            <% if (fortalezas.isEmpty()) { %>
                                <p class="empty-message">No se han identificado fortalezas aún. Complete los análisis anteriores.</p>
                            <% } else { %>
                                <ul class="foda-list">
                                    <% for (String fortaleza : fortalezas) { %>
                                        <li><%= fortaleza %></li>
                                    <% } %>
                                </ul>
                            <% } %>
                        </div>

                        <!-- Oportunidades -->
                        <div class="foda-box oportunidades">
                            <h4>OPORTUNIDADES</h4>
                            <% if (oportunidades.isEmpty()) { %>
                                <p class="empty-message">No se han identificado oportunidades aún. Complete los análisis anteriores.</p>
                            <% } else { %>
                                <ul class="foda-list">
                                    <% for (String oportunidad : oportunidades) { %>
                                        <li><%= oportunidad %></li>
                                    <% } %>
                                </ul>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Matrices de Puntuación FODA -->
                <div class="scoring-section" style="margin-top: 40px;">
                    <h3 style="text-align: center; color: var(--text-primary); margin-bottom: 30px; font-size: 22px;">
                        <i class="fas fa-calculator"></i> Matrices de Puntuación Estratégica
                    </h3>
                    
                    <p style="text-align: center; color: #666; margin-bottom: 30px; line-height: 1.6;">
                        <strong>Escala de Puntuación:</strong> 0=En total desacuerdo, 1=No está de acuerdo, 2=Está de acuerdo, 3=Bastante de acuerdo, 4=En total acuerdo
                    </p>

                    <!-- Fortalezas × Oportunidades -->
                    <div class="scoring-matrix" style="background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px;">
                        <h4 style="text-align: center; color: #7c3aed; margin-bottom: 8px; font-size: 18px;">
                            FORTALEZAS × OPORTUNIDADES (Estrategias Ofensivas)
                        </h4>
                        <p style="text-align: center; font-size: 13px; color: #666; margin-bottom: 20px; font-style: italic;">
                            Las fortalezas se usan para tomar ventaja en cada una de las oportunidades
                        </p>
                        <div style="overflow-x: auto;">
                            <table class="score-table" style="width: 100%; border-collapse: collapse; background: white;">
                                <thead>
                                    <tr style="background: #fce7f3;">
                                        <th rowspan="2" style="border: 2px solid #d1d5db; padding: 12px; text-align: center; background: #ddd6fe;">FORTALEZAS</th>
                                        <th colspan="<%= oportunidades.size() %>" style="border: 2px solid #d1d5db; padding: 12px; text-align: center; background: #fed7aa; color: #7c2d12;">OPORTUNIDADES</th>
                                    </tr>
                                    <tr style="background: #fed7aa;">
                                        <% for (int i = 0; i < oportunidades.size(); i++) { %>
                                            <th style="border: 2px solid #d1d5db; padding: 8px; text-align: center; font-size: 13px; min-width: 100px;">O<%= i+1 %></th>
                                        <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    int totalFO = 0;
                                    for (int f = 0; f < fortalezas.size(); f++) { 
                                        int rowTotal = 0;
                                    %>
                                        <tr>
                                            <td style="border: 2px solid #d1d5db; padding: 10px; font-weight: 600; background: #d1fae5;">F<%= f+1 %></td>
                                            <% for (int o = 0; o < oportunidades.size(); o++) { %>
                                                <td style="border: 2px solid #d1d5db; padding: 8px; text-align: center;">
                                                    <input type="number" min="0" max="4" value="0" 
                                                           class="score-input fo-score" 
                                                           data-row="<%= f %>" data-col="<%= o %>"
                                                           style="width: 60px; padding: 6px; text-align: center; border: 1px solid #ccc; border-radius: 4px; font-size: 14px;">
                                                </td>
                                            <% } %>
                                        </tr>
                                    <% } %>
                                    <tr style="background: #fef3c7;">
                                        <td style="border: 2px solid #d1d5db; padding: 10px; font-weight: 700; text-align: center;">Total</td>
                                        <% for (int o = 0; o < (oportunidades.size() > 0 ? oportunidades.size() : 1); o++) { %>
                                            <td id="fo-col-total-<%= o %>" style="border: 2px solid #d1d5db; padding: 10px; text-align: center; font-weight: 700;">0</td>
                                        <% } %>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div style="text-align: right; margin-top: 12px; padding: 12px; background: #ddd6fe; border-radius: 6px;">
                            <strong style="font-size: 18px; color: #7c3aed;">TOTAL FO: <span id="total-fo">0</span></strong>
                        </div>
                    </div>

                    <!-- Fortalezas × Amenazas -->
                    <div class="scoring-matrix" style="background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px;">
                        <h4 style="text-align: center; color: #ec4899; margin-bottom: 8px; font-size: 18px;">
                            FORTALEZAS × AMENAZAS (Estrategias Defensivas)
                        </h4>
                        <p style="text-align: center; font-size: 13px; color: #666; margin-bottom: 20px; font-style: italic;">
                            Las fortalezas evaden el efecto negativo de las amenazas
                        </p>
                        <div style="overflow-x: auto;">
                            <table class="score-table" style="width: 100%; border-collapse: collapse; background: white;">
                                <thead>
                                    <tr style="background: #fce7f3;">
                                        <th rowspan="2" style="border: 2px solid #d1d5db; padding: 12px; text-align: center; background: #d1fae5;">FORTALEZAS</th>
                                        <th colspan="<%= amenazas.size() %>" style="border: 2px solid #d1d5db; padding: 12px; text-align: center; background: #dbeafe; color: #1e3a8a;">AMENAZAS</th>
                                    </tr>
                                    <tr style="background: #dbeafe;">
                                        <% for (int i = 0; i < amenazas.size(); i++) { %>
                                            <th style="border: 2px solid #d1d5db; padding: 8px; text-align: center; font-size: 13px; min-width: 100px;">A<%= i+1 %></th>
                                        <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (int f = 0; f < fortalezas.size(); f++) { %>
                                        <tr>
                                            <td style="border: 2px solid #d1d5db; padding: 10px; font-weight: 600; background: #d1fae5;">F<%= f+1 %></td>
                                            <% for (int a = 0; a < amenazas.size(); a++) { %>
                                                <td style="border: 2px solid #d1d5db; padding: 8px; text-align: center;">
                                                    <input type="number" min="0" max="4" value="0" 
                                                           class="score-input fa-score" 
                                                           data-row="<%= f %>" data-col="<%= a %>"
                                                           style="width: 60px; padding: 6px; text-align: center; border: 1px solid #ccc; border-radius: 4px; font-size: 14px;">
                                                </td>
                                            <% } %>
                                        </tr>
                                    <% } %>
                                    <tr style="background: #fef3c7;">
                                        <td style="border: 2px solid #d1d5db; padding: 10px; font-weight: 700; text-align: center;">Total</td>
                                        <% for (int a = 0; a < (amenazas.size() > 0 ? amenazas.size() : 1); a++) { %>
                                            <td id="fa-col-total-<%= a %>" style="border: 2px solid #d1d5db; padding: 10px; text-align: center; font-weight: 700;">0</td>
                                        <% } %>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div style="text-align: right; margin-top: 12px; padding: 12px; background: #fce7f3; border-radius: 6px;">
                            <strong style="font-size: 18px; color: #ec4899;">TOTAL FA: <span id="total-fa">0</span></strong>
                        </div>
                    </div>

                    <!-- Debilidades × Oportunidades -->
                    <div class="scoring-matrix" style="background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px;">
                        <h4 style="text-align: center; color: #3b82f6; margin-bottom: 8px; font-size: 18px;">
                            DEBILIDADES × OPORTUNIDADES (Estrategias de Reorientación)
                        </h4>
                        <p style="text-align: center; font-size: 13px; color: #666; margin-bottom: 20px; font-style: italic;">
                            Superamos las debilidades tomando ventaja de las oportunidades
                        </p>
                        <div style="overflow-x: auto;">
                            <table class="score-table" style="width: 100%; border-collapse: collapse; background: white;">
                                <thead>
                                    <tr style="background: #fef3c7;">
                                        <th rowspan="2" style="border: 2px solid #d1d5db; padding: 12px; text-align: center; background: #fef3c7;">DEBILIDADES</th>
                                        <th colspan="<%= oportunidades.size() %>" style="border: 2px solid #d1d5db; padding: 12px; text-align: center; background: #fed7aa; color: #7c2d12;">OPORTUNIDADES</th>
                                    </tr>
                                    <tr style="background: #fed7aa;">
                                        <% for (int i = 0; i < oportunidades.size(); i++) { %>
                                            <th style="border: 2px solid #d1d5db; padding: 8px; text-align: center; font-size: 13px; min-width: 100px;">O<%= i+1 %></th>
                                        <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (int d = 0; d < debilidades.size(); d++) { %>
                                        <tr>
                                            <td style="border: 2px solid #d1d5db; padding: 10px; font-weight: 600; background: #fef3c7;">D<%= d+1 %></td>
                                            <% for (int o = 0; o < oportunidades.size(); o++) { %>
                                                <td style="border: 2px solid #d1d5db; padding: 8px; text-align: center;">
                                                    <input type="number" min="0" max="4" value="0" 
                                                           class="score-input do-score" 
                                                           data-row="<%= d %>" data-col="<%= o %>"
                                                           style="width: 60px; padding: 6px; text-align: center; border: 1px solid #ccc; border-radius: 4px; font-size: 14px;">
                                                </td>
                                            <% } %>
                                        </tr>
                                    <% } %>
                                    <tr style="background: #fef3c7;">
                                        <td style="border: 2px solid #d1d5db; padding: 10px; font-weight: 700; text-align: center;">Total</td>
                                        <% for (int o = 0; o < (oportunidades.size() > 0 ? oportunidades.size() : 1); o++) { %>
                                            <td id="do-col-total-<%= o %>" style="border: 2px solid #d1d5db; padding: 10px; text-align: center; font-weight: 700;">0</td>
                                        <% } %>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div style="text-align: right; margin-top: 12px; padding: 12px; background: #dbeafe; border-radius: 6px;">
                            <strong style="font-size: 18px; color: #3b82f6;">TOTAL DO: <span id="total-do">0</span></strong>
                        </div>
                    </div>

                    <!-- Debilidades × Amenazas -->
                    <div class="scoring-matrix" style="background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px;">
                        <h4 style="text-align: center; color: #ef4444; margin-bottom: 8px; font-size: 18px;">
                            DEBILIDADES × AMENAZAS (Estrategias de Supervivencia)
                        </h4>
                        <p style="text-align: center; font-size: 13px; color: #666; margin-bottom: 20px; font-style: italic;">
                            Las debilidades intensifican notablemente el efecto negativo de las amenazas
                        </p>
                        <div style="overflow-x: auto;">
                            <table class="score-table" style="width: 100%; border-collapse: collapse; background: white;">
                                <thead>
                                    <tr style="background: #fef3c7;">
                                        <th rowspan="2" style="border: 2px solid #d1d5db; padding: 12px; text-align: center; background: #fef3c7;">DEBILIDADES</th>
                                        <th colspan="<%= amenazas.size() %>" style="border: 2px solid #d1d5db; padding: 12px; text-align: center; background: #dbeafe; color: #1e3a8a;">AMENAZAS</th>
                                    </tr>
                                    <tr style="background: #dbeafe;">
                                        <% for (int i = 0; i < amenazas.size(); i++) { %>
                                            <th style="border: 2px solid #d1d5db; padding: 8px; text-align: center; font-size: 13px; min-width: 100px;">A<%= i+1 %></th>
                                        <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (int d = 0; d < debilidades.size(); d++) { %>
                                        <tr>
                                            <td style="border: 2px solid #d1d5db; padding: 10px; font-weight: 600; background: #fef3c7;">D<%= d+1 %></td>
                                            <% for (int a = 0; a < amenazas.size(); a++) { %>
                                                <td style="border: 2px solid #d1d5db; padding: 8px; text-align: center;">
                                                    <input type="number" min="0" max="4" value="0" 
                                                           class="score-input da-score" 
                                                           data-row="<%= d %>" data-col="<%= a %>"
                                                           style="width: 60px; padding: 6px; text-align: center; border: 1px solid #ccc; border-radius: 4px; font-size: 14px;">
                                                </td>
                                            <% } %>
                                        </tr>
                                    <% } %>
                                    <tr style="background: #fef3c7;">
                                        <td style="border: 2px solid #d1d5db; padding: 10px; font-weight: 700; text-align: center;">Total</td>
                                        <% for (int a = 0; a < (amenazas.size() > 0 ? amenazas.size() : 1); a++) { %>
                                            <td id="da-col-total-<%= a %>" style="border: 2px solid #d1d5db; padding: 10px; text-align: center; font-weight: 700;">0</td>
                                        <% } %>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div style="text-align: right; margin-top: 12px; padding: 12px; background: #fee2e2; border-radius: 6px;">
                            <strong style="font-size: 18px; color: #ef4444;">TOTAL DA: <span id="total-da">0</span></strong>
                        </div>
                    </div>

                    <!-- Síntesis de Resultados -->
                    <div style="background: white; padding: 32px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-top: 40px;">
                        <h3 style="text-align: center; color: var(--text-primary); margin-bottom: 30px; font-size: 24px; font-weight: 700;">
                            <i class="fas fa-chart-bar"></i> SÍNTESIS DE RESULTADOS
                        </h3>
                        <div style="overflow-x: auto;">
                            <table style="width: 100%; border-collapse: collapse; border: 2px solid #3b82f6;">
                                <thead>
                                    <tr style="background: #bfdbfe;">
                                        <th style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 700; color: #1e3a8a;">Relaciones</th>
                                        <th style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 700; color: #1e3a8a;">Tipología de estrategia</th>
                                        <th style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 700; color: #1e3a8a;">Puntuación</th>
                                        <th style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 700; color: #1e3a8a;">Descripción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 600; background: #e0f2fe;">FO</td>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; background: white;">Estrategia Ofensiva</td>
                                        <td id="result-fo" style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 700; font-size: 18px; background: #fef3c7;">0</td>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; background: white;">Deberá adoptar estrategias de crecimiento</td>
                                    </tr>
                                    <tr>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 600; background: #e0f2fe;">AF</td>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; background: white;">Estrategia Defensiva</td>
                                        <td id="result-fa" style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 700; font-size: 18px; background: #fef3c7;">0</td>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; background: white;">La empresa está preparada para enfrentarse a las amenazas</td>
                                    </tr>
                                    <tr>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 600; background: #e0f2fe;">AD</td>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; background: white;">Estrategia de Supervivencia</td>
                                        <td id="result-da" style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 700; font-size: 18px; background: #fef3c7;">0</td>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; background: white;">Se enfrenta a amenazas externas sin las fortalezas necesarias para luchar con la competencia</td>
                                    </tr>
                                    <tr>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 600; background: #e0f2fe;">OD</td>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; background: white;">Estrategia de Reorientación</td>
                                        <td id="result-do" style="border: 2px solid #3b82f6; padding: 14px; text-align: center; font-weight: 700; font-size: 18px; background: #fef3c7;">0</td>
                                        <td style="border: 2px solid #3b82f6; padding: 14px; background: white;">La empresa no puede aprovechar las oportunidades porque carece de preparación adecuada</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <p style="text-align: center; margin-top: 20px; color: #666; font-style: italic; font-size: 14px;">
                            <i class="fas fa-info-circle"></i> La puntuación mayor le indica la estrategia que deberá llevar a cabo.
                        </p>
                    </div>
                </div>

                <script>
                    // Función para calcular totales
                    function calcularTotales() {
                        // Calcular FO (Fortalezas × Oportunidades)
                        let totalFO = 0;
                        const numOportunidades = <%= oportunidades.size() %>;
                        const numFortalezas = <%= fortalezas.size() %>;
                        
                        // Calcular totales por columna FO
                        for (let col = 0; col < numOportunidades; col++) {
                            let colTotal = 0;
                            document.querySelectorAll('.fo-score[data-col="' + col + '"]').forEach(input => {
                                colTotal += parseInt(input.value) || 0;
                            });
                            const colElement = document.getElementById('fo-col-total-' + col);
                            if (colElement) colElement.textContent = colTotal;
                            totalFO += colTotal;
                        }
                        document.getElementById('total-fo').textContent = totalFO;
                        document.getElementById('result-fo').textContent = totalFO;

                        // Calcular FA (Fortalezas × Amenazas)
                        let totalFA = 0;
                        const numAmenazas = <%= amenazas.size() %>;
                        
                        for (let col = 0; col < numAmenazas; col++) {
                            let colTotal = 0;
                            document.querySelectorAll('.fa-score[data-col="' + col + '"]').forEach(input => {
                                colTotal += parseInt(input.value) || 0;
                            });
                            const colElement = document.getElementById('fa-col-total-' + col);
                            if (colElement) colElement.textContent = colTotal;
                            totalFA += colTotal;
                        }
                        document.getElementById('total-fa').textContent = totalFA;
                        document.getElementById('result-fa').textContent = totalFA;

                        // Calcular DO (Debilidades × Oportunidades)
                        let totalDO = 0;
                        
                        for (let col = 0; col < numOportunidades; col++) {
                            let colTotal = 0;
                            document.querySelectorAll('.do-score[data-col="' + col + '"]').forEach(input => {
                                colTotal += parseInt(input.value) || 0;
                            });
                            const colElement = document.getElementById('do-col-total-' + col);
                            if (colElement) colElement.textContent = colTotal;
                            totalDO += colTotal;
                        }
                        document.getElementById('total-do').textContent = totalDO;
                        document.getElementById('result-do').textContent = totalDO;

                        // Calcular DA (Debilidades × Amenazas)
                        let totalDA = 0;
                        
                        for (let col = 0; col < numAmenazas; col++) {
                            let colTotal = 0;
                            document.querySelectorAll('.da-score[data-col="' + col + '"]').forEach(input => {
                                colTotal += parseInt(input.value) || 0;
                            });
                            const colElement = document.getElementById('da-col-total-' + col);
                            if (colElement) colElement.textContent = colTotal;
                            totalDA += colTotal;
                        }
                        document.getElementById('total-da').textContent = totalDA;
                        document.getElementById('result-da').textContent = totalDA;

                        // Resaltar la estrategia con mayor puntuación
                        const estrategias = [
                            { id: 'result-fo', valor: totalFO },
                            { id: 'result-fa', valor: totalFA },
                            { id: 'result-do', valor: totalDO },
                            { id: 'result-da', valor: totalDA }
                        ];
                        
                        const maxValor = Math.max(...estrategias.map(e => e.valor));
                        
                        estrategias.forEach(e => {
                            const elemento = document.getElementById(e.id);
                            if (elemento) {
                                if (e.valor === maxValor && maxValor > 0) {
                                    elemento.style.background = '#86efac';
                                    elemento.style.color = '#065f46';
                                    elemento.style.fontWeight = '900';
                                } else {
                                    elemento.style.background = '#fef3c7';
                                    elemento.style.color = '#000';
                                    elemento.style.fontWeight = '700';
                                }
                            }
                        });
                    }

                    // Función para guardar puntuaciones
                    function guardarPuntuaciones() {
                        if (!<%= modoColaborativo %>) {
                            alert('Función disponible solo en modo colaborativo');
                            return;
                        }

                        // Recopilar puntuaciones FO
                        const foData = {};
                        document.querySelectorAll('.fo-score').forEach(input => {
                            const key = 'fo_' + input.dataset.row + '_' + input.dataset.col;
                            foData[key] = input.value;
                        });

                        // Recopilar puntuaciones FA
                        const faData = {};
                        document.querySelectorAll('.fa-score').forEach(input => {
                            const key = 'fa_' + input.dataset.row + '_' + input.dataset.col;
                            faData[key] = input.value;
                        });

                        // Recopilar puntuaciones DO
                        const doData = {};
                        document.querySelectorAll('.do-score').forEach(input => {
                            const key = 'do_' + input.dataset.row + '_' + input.dataset.col;
                            doData[key] = input.value;
                        });

                        // Recopilar puntuaciones DA
                        const daData = {};
                        document.querySelectorAll('.da-score').forEach(input => {
                            const key = 'da_' + input.dataset.row + '_' + input.dataset.col;
                            daData[key] = input.value;
                        });

                        // Crear formulario y enviar
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.style.display = 'none';

                        const foInput = document.createElement('input');
                        foInput.name = 'fo_data';
                        foInput.value = JSON.stringify(foData);
                        form.appendChild(foInput);

                        const faInput = document.createElement('input');
                        faInput.name = 'fa_data';
                        faInput.value = JSON.stringify(faData);
                        form.appendChild(faInput);

                        const doInput = document.createElement('input');
                        doInput.name = 'do_data';
                        doInput.value = JSON.stringify(doData);
                        form.appendChild(doInput);

                        const daInput = document.createElement('input');
                        daInput.name = 'da_data';
                        daInput.value = JSON.stringify(daData);
                        form.appendChild(daInput);

                        const accionInput = document.createElement('input');
                        accionInput.name = 'accion';
                        accionInput.value = 'guardar_puntuaciones';
                        form.appendChild(accionInput);

                        document.body.appendChild(form);
                        form.submit();
                    }

                    // Función para cargar puntuaciones guardadas
                    function cargarPuntuacionesGuardadas() {
                        <% if (modoColaborativo && !puntuacionesFO.isEmpty()) { %>
                            try {
                                const foData = JSON.parse('<%= puntuacionesFO.replace("'", "\\'") %>');
                                Object.keys(foData).forEach(key => {
                                    const parts = key.split('_');
                                    if (parts.length === 3) {
                                        const input = document.querySelector('.fo-score[data-row="' + parts[1] + '"][data-col="' + parts[2] + '"]');
                                        if (input) input.value = foData[key];
                                    }
                                });
                            } catch (e) {
                                console.log('Error cargando FO:', e);
                            }
                        <% } %>

                        <% if (modoColaborativo && !puntuacionesFA.isEmpty()) { %>
                            try {
                                const faData = JSON.parse('<%= puntuacionesFA.replace("'", "\\'") %>');
                                Object.keys(faData).forEach(key => {
                                    const parts = key.split('_');
                                    if (parts.length === 3) {
                                        const input = document.querySelector('.fa-score[data-row="' + parts[1] + '"][data-col="' + parts[2] + '"]');
                                        if (input) input.value = faData[key];
                                    }
                                });
                            } catch (e) {
                                console.log('Error cargando FA:', e);
                            }
                        <% } %>

                        <% if (modoColaborativo && !puntuacionesDO.isEmpty()) { %>
                            try {
                                const doData = JSON.parse('<%= puntuacionesDO.replace("'", "\\'") %>');
                                Object.keys(doData).forEach(key => {
                                    const parts = key.split('_');
                                    if (parts.length === 3) {
                                        const input = document.querySelector('.do-score[data-row="' + parts[1] + '"][data-col="' + parts[2] + '"]');
                                        if (input) input.value = doData[key];
                                    }
                                });
                            } catch (e) {
                                console.log('Error cargando DO:', e);
                            }
                        <% } %>

                        <% if (modoColaborativo && !puntuacionesDA.isEmpty()) { %>
                            try {
                                const daData = JSON.parse('<%= puntuacionesDA.replace("'", "\\'") %>');
                                Object.keys(daData).forEach(key => {
                                    const parts = key.split('_');
                                    if (parts.length === 3) {
                                        const input = document.querySelector('.da-score[data-row="' + parts[1] + '"][data-col="' + parts[2] + '"]');
                                        if (input) input.value = daData[key];
                                    }
                                });
                            } catch (e) {
                                console.log('Error cargando DA:', e);
                            }
                        <% } %>
                    }

                    // Agregar listeners a todos los inputs de puntuación
                    document.addEventListener('DOMContentLoaded', function() {
                        document.querySelectorAll('.score-input').forEach(input => {
                            input.addEventListener('input', function() {
                                // Validar rango 0-4
                                if (this.value > 4) this.value = 4;
                                if (this.value < 0) this.value = 0;
                                calcularTotales();
                            });
                        });
                        
                        // Cargar puntuaciones guardadas
                        cargarPuntuacionesGuardadas();
                        
                        // Calcular totales iniciales
                        calcularTotales();
                    });
                </script>

                <% if (modoColaborativo) { %>
                    <div style="background: #e8f5e8; padding: 15px; border-radius: 8px; margin-top: 20px;">
                        <p style="color: #2d5a3d; margin: 0;">
                            <i class="fas fa-info-circle"></i> 
                            <strong>Actualización Automática:</strong> Esta matriz se actualiza automáticamente cuando modificas los análisis PEST, Porter, Cadena de Valor o BCG en el grupo <strong><%= grupoActual %></strong>.
                        </p>
                    </div>
                <% } %>
            </main>
        </div>
    </div>
</body>
</html>
