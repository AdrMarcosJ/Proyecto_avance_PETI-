<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, entidad.ClsEPeti"%>
<%@page import="java.util.Map, java.util.ArrayList, java.util.List"%>
<%@page import="java.text.SimpleDateFormat, java.util.Date"%>
<%
    // Lógica de sesión y carga de datos... (Mantenida de tu scriptlet original)
    // --- INICIO CÓDIGO JSP ORIGINAL (Mantenido) ---
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    
    boolean modoColaborativo = grupoActual != null && grupoId != null;
    
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        userEmail = "usuario@ejemplo.com";
    }
    
    String userInitials = "U";
    if (usuario != null && usuario.length() > 0) {
        userInitials = usuario.substring(0, 1).toUpperCase();
        if (usuario.contains(" ") && usuario.length() > usuario.indexOf(" ") + 1) {
            userInitials += usuario.substring(usuario.indexOf(" ") + 1, usuario.indexOf(" ") + 2).toUpperCase();
        }
    }
    
    String mensaje = "";
    String tipoMensaje = "";
    
    String nombreEmpresa = "";
    String fechaElaboracion = "";
    String emprendedores = "";
    String mision = "";
    String vision = "";
    List<String> valores = new ArrayList<>();
    String unidadesEstrategicas = "";
    List<String> objetivosGenerales = new ArrayList<>();
    List<String> fortalezas = new ArrayList<>();
    List<String> debilidades = new ArrayList<>();
    List<String> oportunidades = new ArrayList<>();
    List<String> amenazas = new ArrayList<>();
    String estrategiaIdentificada = "";
    
    // Variables para campos manuales del resumen
    String accionesCompetitivas = "";
    String conclusiones = "";
    
    // Procesar guardado de campos manuales
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String accion = request.getParameter("accion");
        
        if ("guardar_resumen".equals(accion)) {
            String accionesData = request.getParameter("acciones_data");
            String conclusionesData = request.getParameter("conclusiones_data");
            
            ClsNPeti negocioPeti = new ClsNPeti();
            boolean exito = true;
            
            try {
                if (accionesData != null && !accionesData.trim().isEmpty()) {
                    ClsEPeti datoAcciones = new ClsEPeti(grupoId, "resumen_ejecutivo", "acciones_competitivas", accionesData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoAcciones);
                }
                if (conclusionesData != null && !conclusionesData.trim().isEmpty()) {
                    ClsEPeti datoConclusiones = new ClsEPeti(grupoId, "resumen_ejecutivo", "conclusiones", conclusionesData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoConclusiones);
                }
                
                if (exito) {
                    mensaje = "Resumen ejecutivo guardado exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar el resumen";
                    tipoMensaje = "error";
                }
            } catch (Exception e) {
                mensaje = "Error interno: " + e.getMessage();
                tipoMensaje = "error";
            }
        }
    }
    
    // Cargar datos desde la base de datos
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            
            // 1. Datos de la empresa
            Map<String, String> datosEmpresa = negocioPeti.obtenerDatosSeccion(grupoId, "empresa");
            if (datosEmpresa.containsKey("nombre_empresa")) {
                nombreEmpresa = datosEmpresa.get("nombre_empresa");
            }
            if (datosEmpresa.containsKey("emprendedores")) {
                emprendedores = datosEmpresa.get("emprendedores");
            }
            if (datosEmpresa.containsKey("unidades_estrategicas")) {
                unidadesEstrategicas = datosEmpresa.get("unidades_estrategicas");
            }
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            fechaElaboracion = sdf.format(new Date());
            
            // 2. Misión / 3. Visión
            Map<String, String> datosMision = negocioPeti.obtenerDatosSeccion(grupoId, "mision");
            if (datosMision.containsKey("mision_final")) {
                mision = datosMision.get("mision_final");
            }
            
            Map<String, String> datosVision = negocioPeti.obtenerDatosSeccion(grupoId, "vision");
            if (datosVision.containsKey("vision_final")) {
                vision = datosVision.get("vision_final");
            }
            
            // 4. Valores
            Map<String, String> datosValores = negocioPeti.obtenerDatosSeccion(grupoId, "valores");
            for (int i = 1; i <= 10; i++) {
                String key = "valor" + i;
                if (datosValores.containsKey(key)) {
                    String valor = datosValores.get(key);
                    if (valor != null && !valor.trim().isEmpty()) {
                        valores.add(valor);
                    }
                }
            }
            
            // 5. Objetivos
            Map<String, String> datosObjetivos = negocioPeti.obtenerDatosSeccion(grupoId, "objetivos");
            for (int i = 1; i <= 10; i++) {
                String key = "objetivo" + i;
                if (datosObjetivos.containsKey(key)) {
                    String objetivo = datosObjetivos.get(key);
                    if (objetivo != null && !objetivo.trim().isEmpty()) {
                        objetivosGenerales.add(objetivo);
                    }
                }
            }
            
            // 6. FODA - Extraer de múltiples fuentes
            // Fortalezas: Cadena Valor (F1, F2) + BCG (F3, F4)
            Map<String, String> datosCadena = negocioPeti.obtenerDatosSeccion(grupoId, "cadena_valor");
            if (datosCadena.containsKey("fortaleza1")) { fortalezas.add(datosCadena.get("fortaleza1")); }
            if (datosCadena.containsKey("fortaleza2")) { fortalezas.add(datosCadena.get("fortaleza2")); }
            
            Map<String, String> datosBCG = negocioPeti.obtenerDatosSeccion(grupoId, "bcg");
            if (datosBCG.containsKey("fortaleza3")) { fortalezas.add(datosBCG.get("fortaleza3")); }
            if (datosBCG.containsKey("fortaleza4")) { fortalezas.add(datosBCG.get("fortaleza4")); }
            
            // Debilidades: Cadena Valor (D1, D2) + BCG (D3, D4)
            if (datosCadena.containsKey("debilidad1")) { debilidades.add(datosCadena.get("debilidad1")); }
            if (datosCadena.containsKey("debilidad2")) { debilidades.add(datosCadena.get("debilidad2")); }
            if (datosBCG.containsKey("debilidad3")) { debilidades.add(datosBCG.get("debilidad3")); }
            if (datosBCG.containsKey("debilidad4")) { debilidades.add(datosBCG.get("debilidad4")); }
            
            // Oportunidades: PEST (O1, O2) + Porter (O3, O4)
            Map<String, String> datosPest = negocioPeti.obtenerDatosSeccion(grupoId, "pest_analisis");
            if (datosPest.containsKey("oportunidad1")) { oportunidades.add(datosPest.get("oportunidad1")); }
            if (datosPest.containsKey("oportunidad2")) { oportunidades.add(datosPest.get("oportunidad2")); }
            
            Map<String, String> datosPorter = negocioPeti.obtenerDatosSeccion(grupoId, "porter_analisis");
            if (datosPorter.containsKey("oportunidad3")) { oportunidades.add(datosPorter.get("oportunidad3")); }
            if (datosPorter.containsKey("oportunidad4")) { oportunidades.add(datosPorter.get("oportunidad4")); }
            
            // Amenazas: PEST (A1, A2) + Porter (A3, A4)
            if (datosPest.containsKey("amenaza1")) { amenazas.add(datosPest.get("amenaza1")); }
            if (datosPest.containsKey("amenaza2")) { amenazas.add(datosPest.get("amenaza2")); }
            if (datosPorter.containsKey("amenaza3")) { amenazas.add(datosPorter.get("amenaza3")); }
            if (datosPorter.containsKey("amenaza4")) { amenazas.add(datosPorter.get("amenaza4")); }
            
            // 7. Estrategia identificada (de la matriz FODA)
            Map<String, String> datosEstrategia = negocioPeti.obtenerDatosSeccion(grupoId, "identificacion_estrategia");
            if (datosEstrategia.containsKey("estrategia_seleccionada")) {
                estrategiaIdentificada = datosEstrategia.get("estrategia_seleccionada");
            }
            
            // 8. Cargar datos manuales del resumen
            Map<String, String> datosResumen = negocioPeti.obtenerDatosSeccion(grupoId, "resumen_ejecutivo");
            if (datosResumen.containsKey("acciones_competitivas")) {
                accionesCompetitivas = datosResumen.get("acciones_competitivas");
            }
            if (datosResumen.containsKey("conclusiones")) {
                conclusiones = datosResumen.get("conclusiones");
            }
            
        } catch (Exception e) {
            mensaje = "Error al cargar datos: " + e.getMessage();
            tipoMensaje = "error";
        }
    }
    // --- FIN CÓDIGO JSP ORIGINAL (Mantenido) ---
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resumen Ejecutivo - PETI System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a365d;
            --accent-color: #3182ce;
            --success-color: #38a169;
            --light-bg: #f7fafc;
            --card-bg: #ffffff;
            --text-primary: #2d3748;
            --border-color: #e2e8f0;
            --section-header-bg: #3182ce; /* Nuevo color para headers de sección */
            --box-border-color: #a0aec0; /* Nuevo color para bordes de cajas */
        }

        /* [Sección de CSS General y Sidebar - Se mantiene de tu código] */
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
            font-size: 14px;
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
        }

        .btn-success:hover {
            background: #2f855a;
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
        /* FIN CSS GENERAL */

        /* INICIO CSS ESPECÍFICO DEL RESUMEN (MEJORADO) */
        .resumen-container {
            background: var(--card-bg);
            padding: 48px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); /* Sombra más suave */
        }

        .resumen-title {
            text-align: center;
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 40px;
            color: var(--primary-color);
            border-bottom: 4px solid var(--section-header-bg); /* Línea más gruesa y color consistente */
            padding-bottom: 16px;
        }

        .resumen-section {
            margin-bottom: 32px;
            padding-bottom: 20px;
            border-bottom: 1px dashed var(--border-color); /* Separador sutil */
        }

        .resumen-section:last-child {
            border-bottom: none;
        }

        .section-header {
            background: var(--section-header-bg);
            color: white;
            padding: 12px 20px;
            font-weight: 700;
            font-size: 16px;
            margin-bottom: 12px;
            border-radius: 6px; /* Borde más redondeado */
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-header i {
            font-size: 18px;
        }

        .section-label {
            font-weight: 600;
            color: var(--primary-color);
            font-size: 14px;
            margin-right: 8px;
            text-transform: uppercase;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 10px 20px;
            align-items: center;
            margin-bottom: 20px;
            border-left: 4px solid var(--accent-color);
            padding-left: 15px;
        }

        .info-grid .section-value {
            font-size: 14px;
            color: var(--text-primary);
        }

        .content-box {
            border: 1px solid var(--box-border-color);
            padding: 16px;
            min-height: 100px;
            border-radius: 6px;
            background: #fdfdfd;
            font-size: 14px;
            line-height: 1.6;
            white-space: pre-wrap; /* Mantiene saltos de línea y espacios */
        }

        .content-box-editable {
            border: 1px solid var(--box-border-color);
            border-radius: 6px;
            background: white;
        }

        .content-box-editable textarea {
            width: 100%;
            min-height: 150px;
            border: none;
            padding: 16px;
            font-size: 14px;
            font-family: inherit;
            line-height: 1.6;
            resize: vertical;
        }

        .valores-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .valor-item {
            background: #e6fffa; /* Fondo suave */
            color: #2c7a7b; /* Color de texto fuerte */
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            border: 1px solid #b2f5ea;
        }
        
        /* Estilos mejorados para la tabla de Objetivos */
        .objetivos-table {
            width: 100%;
            border-collapse: collapse;
        }
        .objetivos-table th, .objetivos-table td {
            border: 1px solid var(--box-border-color);
            padding: 12px;
            vertical-align: top;
            font-size: 13px;
        }
        .objetivos-table th {
            background: #edf2f7; /* Fondo más neutro */
            font-weight: 700;
            color: var(--text-primary);
        }
        .objetivos-table .mision-cell {
            background: #f7fafc;
            width: 100px;
            text-align: center;
            font-weight: 600;
        }
        .objetivos-table .objetivo-general {
            background: #e9f5ff; /* Color para Objetivos Generales */
            font-weight: 500;
        }
        .objetivos-table .objetivo-especifico-placeholder {
            background: #f0f4f8; /* Color para Objetivos Específicos (vacío) */
        }

        /* Estilos mejorados para la tabla FODA */
        .foda-table {
            width: 100%;
            border-collapse: collapse;
        }
        .foda-table td {
            border: 2px solid var(--box-border-color);
            padding: 0;
            vertical-align: top;
        }
        .foda-header-box {
            background: rgba(0, 0, 0, 0.05);
            color: var(--text-primary);
            padding: 8px 12px;
            font-weight: 700;
            font-size: 14px;
            border-bottom: 1px solid var(--box-border-color);
        }
        .foda-content {
            padding: 12px;
            min-height: 100px;
        }
        .foda-item {
            margin-bottom: 6px;
            font-size: 13px;
            line-height: 1.5;
            color: var(--text-primary);
            display: flex;
            gap: 5px;
        }
        /* FIN CSS ESPECÍFICO DEL RESUMEN */
    </style>
</head>
<body>
    <div class="dashboard-container">
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
                        <li class="active"><a href="resumen-ejecutivo-colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
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
                        <li><a href="MATRIZ CAME.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-th"></i> Matriz CAME</a></li>
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

        <div class="dashboard-content">
            <header class="dashboard-header no-print">
                <h1>
                    <i class="fas fa-file-alt"></i>
                    RESUMEN EJECUTIVO
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i> <%= grupoActual %>
                        </span>
                    <% } %>
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <button onclick="guardarResumen()" class="btn btn-success">
                            <i class="fas fa-save"></i> Guardar
                        </button>
                        <button onclick="imprimirPDF()" class="btn btn-primary">
                            <i class="fas fa-print"></i> Imprimir PDF
                        </button>
                    <% } %>
                    <a href="dashboard.jsp" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Dashboard
                    </a>
                </div>
            </header>

            <main class="dashboard-main">
                <% if (!mensaje.isEmpty()) { %>
                    <div class="alert alert-<%= tipoMensaje %> no-print">
                        <i class="fas fa-<%= "error".equals(tipoMensaje) ? "exclamation-triangle" : "check-circle" %>"></i>
                        <%= mensaje %>
                    </div>
                <% } %>

                <% if (!modoColaborativo) { %>
                    <div class="alert alert-warning no-print">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Modo Individual:</strong> Únete a un grupo para utilizar el Resumen Ejecutivo.
                    </div>
                <% } %>

                <div class="resumen-container">
                    <h1 class="resumen-title">RESUMEN EJECUTIVO DEL PLAN ESTRATÉGICO</h1>
                    
                    <div class="resumen-section">
                        <div class="info-grid">
                            <div class="section-label">Nombre de la empresa / proyecto:</div>
                            <div class="section-value"><%= nombreEmpresa.isEmpty() ? "No definido" : nombreEmpresa %></div>
                            
                            <div class="section-label">Fecha de elaboración:</div>
                            <div class="section-value"><%= fechaElaboracion.isEmpty() ? "No definida" : fechaElaboracion %></div>
                            
                            <div class="section-label">Emprendedores / promotores:</div>
                            <div class="section-value"><%= emprendedores.isEmpty() ? "No definidos" : emprendedores %></div>
                        </div>
                    </div>
                    
                    <div class="resumen-section">
                        <div class="section-header"><i class="fas fa-bullseye"></i> Misión</div>
                        <div class="content-box">
                            <%= mision.isEmpty() ? "Misión no definida en el módulo de Planificación Estratégica." : mision %>
                        </div>
                        
                        <div class="section-header" style="margin-top: 24px;"><i class="fas fa-eye"></i> Visión</div>
                        <div class="content-box">
                            <%= vision.isEmpty() ? "Visión no definida en el módulo de Planificación Estratégica." : vision %>
                        </div>
                    </div>
                    
                    <div class="resumen-section">
                        <div class="section-header"><i class="fas fa-heart"></i> Valores Organizacionales</div>
                        <div class="valores-list">
                            <% if (valores.isEmpty()) { %>
                                <div style="padding: 8px; color: #999;">No hay valores definidos en el módulo correspondiente.</div>
                            <% } else {
                                for (String valor : valores) { %>
                                    <div class="valor-item"><%= valor %></div>
                                <% }
                            } %>
                        </div>

                        <div class="section-header" style="margin-top: 24px;"><i class="fas fa-industry"></i> Unidades Estratégicas de Negocio (UEN)</div>
                        <div class="content-box">
                            <%= unidadesEstrategicas.isEmpty() ? "Unidades Estratégicas no definidas en el módulo de Información Empresarial." : unidadesEstrategicas %>
                        </div>
                    </div>

                    <div class="resumen-section">
                        <div class="section-header"><i class="fas fa-target"></i> Objetivos Estratégicos</div>
                        <table class="objetivos-table">
                            <thead>
                                <tr>
                                    <th style="width: 10%;">MISIÓN</th>
                                    <th style="width: 45%;">OBJETIVOS GENERALES O ESTRATÉGICOS</th>
                                    <th style="width: 45%;">OBJETIVOS ESPECÍFICOS (Pendiente de módulo)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                int maxObjetivos = objetivosGenerales.size();
                                if (maxObjetivos == 0) { %>
                                    <tr>
                                        <td class="mision-cell" rowspan="1">MISIÓN</td>
                                        <td class="objetivo-general" colspan="2">No hay objetivos generales definidos en el módulo de Planificación Estratégica.</td>
                                    </tr>
                                <% } else {
                                    for (int i = 0; i < maxObjetivos; i++) { %>
                                        <tr>
                                            <% if (i == 0) { %>
                                                <td class="mision-cell" rowspan="<%= maxObjetivos %>">Misión</td>
                                            <% } %>
                                            <td class="objetivo-general">
                                                <i class="fas fa-arrow-right" style="margin-right: 5px; color: #3182ce;"></i>
                                                <%= objetivosGenerales.get(i) %>
                                            </td>
                                            <td class="objetivo-especifico-placeholder">
                                                </td>
                                        </tr>
                                    <% }
                                } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="resumen-section">
                        <div class="section-header"><i class="fas fa-chart-line"></i> Análisis FODA (Consolidado de Cadena de Valor, BCG, PEST y Porter)</div>
                        <table class="foda-table">
                            <tr>
                                <td style="background: #fcf6e7;">
                                    <div class="foda-header-box">DEBILIDADES <i class="fas fa-times-circle" style="color: #c53030;"></i></div>
                                    <div class="foda-content">
                                        <% if (debilidades.isEmpty()) { %>
                                            <div style="color: #999;">No hay debilidades identificadas.</div>
                                        <% } else {
                                            for (String debilidad : debilidades) { %>
                                                <div class="foda-item"><i class="fas fa-dot-circle" style="color: #c53030; font-size: 8px;"></i> <%= debilidad %></div>
                                            <% }
                                        } %>
                                    </div>
                                </td>
                                <td style="background: #e6f6f9;">
                                    <div class="foda-header-box">AMENAZAS <i class="fas fa-exclamation-triangle" style="color: #dd6b20;"></i></div>
                                    <div class="foda-content">
                                        <% if (amenazas.isEmpty()) { %>
                                            <div style="color: #999;">No hay amenazas identificadas.</div>
                                        <% } else {
                                            for (String amenaza : amenazas) { %>
                                                <div class="foda-item"><i class="fas fa-dot-circle" style="color: #dd6b20; font-size: 8px;"></i> <%= amenaza %></div>
                                            <% }
                                        } %>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="background: #f3f9f3;">
                                    <div class="foda-header-box">FORTALEZAS <i class="fas fa-check-circle" style="color: #38a169;"></i></div>
                                    <div class="foda-content">
                                        <% if (fortalezas.isEmpty()) { %>
                                            <div style="color: #999;">No hay fortalezas identificadas.</div>
                                        <% } else {
                                            for (String fortaleza : fortalezas) { %>
                                                <div class="foda-item"><i class="fas fa-dot-circle" style="color: #38a169; font-size: 8px;"></i> <%= fortaleza %></div>
                                            <% }
                                        } %>
                                    </div>
                                </td>
                                <td style="background: #f9f3f3;">
                                    <div class="foda-header-box">OPORTUNIDADES <i class="fas fa-lightbulb" style="color: #3182ce;"></i></div>
                                    <div class="foda-content">
                                        <% if (oportunidades.isEmpty()) { %>
                                            <div style="color: #999;">No hay oportunidades identificadas.</div>
                                        <% } else {
                                            for (String oportunidad : oportunidades) { %>
                                                <div class="foda-item"><i class="fas fa-dot-circle" style="color: #3182ce; font-size: 8px;"></i> <%= oportunidad %></div>
                                            <% }
                                        } %>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div class="resumen-section">
                        <div class="section-header"><i class="fas fa-chess"></i> Estrategia Identificada (Resultado de Matriz FODA/CAME)</div>
                        <div style="padding: 8px 0; font-size: 14px; color: #666;">Resultado de la matriz **FODA** / **CAME** - Estrategia Global Seleccionada:</div>
                        <div class="content-box">
                            <%= estrategiaIdentificada.isEmpty() ? "Estrategia no seleccionada en el módulo de Identificación de Estrategias." : estrategiaIdentificada %>
                        </div>
                    </div>

                    <div class="resumen-section">
                        <form id="resumenForm" method="POST" action="resumen-ejecutivo-colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "" %>">
                            <input type="hidden" name="accion" value="guardar_resumen">
                            <div class="section-header"><i class="fas fa-list-ol"></i> Acciones Competitivas (De Matriz CAME)</div>
                            <div style="padding: 8px 0; font-size: 14px; color: #666;">Ingrese las 16 acciones competitivas clave derivadas de la Matriz CAME.</div>
                            <div class="content-box-editable">
                                <textarea name="acciones_data" id="acciones_competitivas" placeholder="1. Acción SO...&#10;2. Acción DO...&#10;3. Acción FA...&#10;4. Acción DA...&#10;... (Máximo 16 acciones sugeridas)"><%= accionesCompetitivas %></textarea>
                            </div>
                        
                            <div class="resumen-section" style="padding-top: 32px; border-bottom: none;">
                                <div class="section-header"><i class="fas fa-clipboard-check"></i> Conclusiones</div>
                                <div style="padding: 8px 0; font-size: 14px; color: #666;">Anote las conclusiones más relevantes del Plan Estratégico.</div>
                                <div class="content-box-editable">
                                    <textarea name="conclusiones_data" id="conclusiones" placeholder="Conclusión 1...&#10;Conclusión 2...&#10;Conclusión 3..."><%= conclusiones %></textarea>
                                </div>
                            </div>
                        </form>
                    </div>

                    <% if (modoColaborativo) { %>
                        <div style="background: #e6f7ff; padding: 15px; border-radius: 8px; margin-top: 20px;" class="no-print">
                            <p style="color: #2c5282; margin: 0;">
                                <i class="fas fa-info-circle"></i> 
                                <strong>Colaboración:</strong> Los datos se cargan automáticamente del plan del grupo <strong><%= grupoActual %></strong>. Los campos de Acciones Competitivas y Conclusiones deben **guardarse** manualmente.
                            </p>
                        </div>
                    <% } %>
                </div>
            </main>
        </div>
    </div>

    <script>
        // Función para guardar resumen ejecutivo
        function guardarResumen() {
            if (!<%= modoColaborativo %>) {
                alert('Función disponible solo en modo colaborativo');
                return;
            }
            // Envía el formulario que contiene los dos campos de textarea
            document.getElementById('resumenForm').submit();
        }

        // Función para imprimir PDF
        function imprimirPDF() {
            window.print();
        }
    </script>
</body>
</html>