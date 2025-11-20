<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, entidad.ClsEPeti"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.*"%>

<%!
    // MÉTODO AUXILIAR DECLARADO AL INICIO
    String checkear(Map<String, String> valoresMap, String campo, String valor) {
        String valorActual = valoresMap.getOrDefault(campo, "0");
        return valorActual.equals(valor) ? "checked" : "";
    }
%>

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
    
    // Verificar modo colaborativo
    boolean modoColaborativo = grupoActual != null && grupoId != null;
    
    // Map para almacenar todos los valores
    Map<String, String> valoresPorter = new java.util.HashMap<>();
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            // Array con todos los nombres de campos del formulario
            String[] campos = {
                "rivalidad_crecimiento", "rivalidad_competidores", "rivalidad_capacidad",
                "rivalidad_rentabilidad", "rivalidad_diferenciacion", "rivalidad_barreras",
                "barreras_economia", "barreras_capital", "barreras_tecnologia",
                "barreras_reglamentos", "barreras_tramites", "barreras_reaccion",
                "clientes_numero", "clientes_integracion", "clientes_rentabilidad",
                "clientes_coste", "sustitutivos_disponibilidad", "proveedores_numero",
                "proveedores_coste", "oportunidad_1", "oportunidad_2", "amenaza_1", "amenaza_2"
            };
            
            // Guardar cada campo
            for (String campo : campos) {
                String valor = request.getParameter(campo);
                if (valor != null && !valor.trim().isEmpty()) {
                    ClsEPeti dato = new ClsEPeti(grupoId, "porter_analisis", campo, valor, usuarioId);
                    exito = exito && negocioPeti.guardarDato(dato);
                    valoresPorter.put(campo, valor);
                }
            }
            
            if (exito) {
                mensaje = "Análisis de Porter guardado exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar el análisis de Porter";
                tipoMensaje = "error";
            }
        } catch (Exception e) {
            mensaje = "Error interno: " + e.getMessage();
            tipoMensaje = "error";
            e.printStackTrace();
        }
    }
    
    // Cargar datos existentes
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            valoresPorter = negocioPeti.obtenerDatosSeccion(grupoId, "porter_analisis");
        } catch (Exception e) {
            // Error silencioso
        }
    }
    
    // *** CORRECCIÓN: SOLO 17 CAMPOS PARA EL CÁLCULO ***
     int total = 0;
    String[] camposNumericos = {
        "rivalidad_crecimiento", "rivalidad_competidores", "rivalidad_capacidad",
        "rivalidad_rentabilidad", "rivalidad_diferenciacion", "rivalidad_barreras",
        "barreras_economia", "barreras_capital", "barreras_tecnologia",
        "barreras_reglamentos", "barreras_tramites", "barreras_reaccion",
        "clientes_numero", "clientes_integracion", "clientes_rentabilidad",
        "clientes_coste", "sustitutivos_disponibilidad"
    };
    
    for (String campo : camposNumericos) {
        try {
            String valor = valoresPorter.getOrDefault(campo, "0");
            total += Integer.parseInt(valor);
        } catch (Exception e) {
            // Ignorar errores de conversión
        }
    }
    
    // Determinar la conclusión
    String conclusion = "";
    if (total >= 68) {
        conclusion = "Situación excelente para la empresa - Entorno muy favorable";
    } else if (total >= 51) {
        conclusion = "Situación favorable para la empresa";
    } else if (total >= 34) {
        conclusion = "Situación moderada - Requiere atención en algunas áreas";
    } else if (total >= 17) {
        conclusion = "Situación desafiante - Se requieren mejoras significativas";
    } else {
        conclusion = "Situación crítica - Entorno muy hostil";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Análisis de Porter - Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #f7fafc;
        min-height: 100vh;
    }

    .dashboard-container {
        display: flex;
        min-height: 100vh;
    }

    .dashboard-sidebar {
        width: 280px;
        background: #1a365d;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        display: flex;
        flex-direction: column;
        position: fixed;
        height: 100vh;
        overflow-y: auto;
    }

    .sidebar-header {
        padding: 20px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    .company-logo {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 20px;
    }

    .company-logo i {
        font-size: 32px;
        color: #3182ce;
    }

    .company-logo h2 {
        color: white;
        font-size: 20px;
    }

    .user-profile {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .user-avatar {
        width: 45px;
        height: 45px;
        border-radius: 50%;
        background: #3182ce;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: bold;
        font-size: 18px;
    }

    .user-info h3 {
        font-size: 14px;
        color: white;
        margin-bottom: 2px;
    }

    .user-info p {
        font-size: 12px;
        color: rgba(255,255,255,0.7);
    }

    .dashboard-nav {
        flex: 1;
        overflow-y: auto;
        padding: 20px 0;
    }

    .nav-section {
        margin-bottom: 25px;
    }

    .nav-section-title {
        padding: 0 20px;
        font-size: 11px;
        font-weight: 600;
        color: rgba(255,255,255,0.5);
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 8px;
    }

    .nav-section ul {
        list-style: none;
    }

    .nav-section li {
        margin-bottom: 2px;
    }

    .nav-section a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 20px;
        color: rgba(255,255,255,0.8);
        text-decoration: none;
        transition: all 0.3s;
        font-size: 14px;
    }

    .nav-section a:hover {
        background: rgba(255,255,255,0.1);
        color: white;
    }

    .nav-section li.active a {
        background: #3182ce;
        color: white;
        border-left: 3px solid white;
        font-weight: 600;
    }

    .nav-section a i {
        width: 20px;
        text-align: center;
    }

    .dashboard-content {
        flex: 1;
        margin-left: 280px;
        padding: 30px;
        overflow-y: auto;
    }

    .container {
        max-width: 1400px;
        margin: 0 auto;
    }

    .header {
        background: white;
        padding: 30px;
        border-radius: 15px;
        margin-bottom: 30px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .header h1 {
        color: #1a365d;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .header h1 i {
        color: #3182ce;
    }

    .header p {
        color: #666;
        font-size: 16px;
    }

    .content {
        background: white;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .alert {
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .alert-error {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .info-box {
        background: #e3f2fd;
        border-left: 4px solid #3182ce;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 25px;
    }

    .info-box p {
        color: #1565c0;
        line-height: 1.6;
    }

    .porter-table {
        width: 100%;
        border-collapse: collapse;
        margin: 25px 0;
        font-size: 14px;
    }

    .porter-table th,
    .porter-table td {
        padding: 12px;
        text-align: center;
        border: 1px solid #ddd;
    }

    .porter-table thead th {
        background: #1a365d;
        color: white;
        font-weight: 600;
    }

    .porter-table .category-header {
        background: #f8f9fa;
        font-weight: bold;
        color: #333;
        text-align: left;
        padding-left: 20px;
    }

    .porter-table .subcategory-header {
        background: #e9ecef;
        font-weight: 600;
        color: #495057;
        text-align: left;
        padding-left: 30px;
    }

    .porter-table .gray-row {
        background: #d3d3d3;
        font-weight: 600;
        color: #333;
        text-align: left;
        padding-left: 30px;
    }

    .porter-table .factor-cell {
        text-align: left;
        padding-left: 40px;
        color: #666;
    }

    .porter-table .hostil {
        background: #ffebee;
        color: #c62828;
        font-weight: 600;
    }

    .porter-table .favorable {
        background: #e8f5e9;
        color: #2e7d32;
        font-weight: 600;
    }

    .porter-table input[type="radio"] {
        cursor: pointer;
        transform: scale(1.2);
    }

    .conclusion-box {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #e3f2fd;
        padding: 25px;
        border-radius: 10px;
        margin: 25px 0;
        border: 2px solid #3182ce;
    }

    .conclusion-text {
        flex: 1;
        font-size: 16px;
        color: #333;
    }

    .conclusion-text strong {
        color: #1a365d;
    }

    .total-box {
        text-align: center;
        background: white;
        padding: 20px 30px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .total-label {
        display: block;
        font-size: 12px;
        color: #666;
        margin-bottom: 8px;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .total-value {
        font-size: 36px;
        font-weight: bold;
        color: #3182ce;
    }

    .form-control {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
        transition: border-color 0.3s;
    }

    .form-control:focus {
        outline: none;
        border-color: #3182ce;
    }

    .button-group {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 30px;
    }

    .btn-save,
    .btn-back {
        padding: 12px 30px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
        transition: all 0.3s;
    }

    .btn-save {
        background: #1a365d;
        color: white;
    }

    .btn-save:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(26, 54, 93, 0.4);
        background: #2d4a7c;
    }

    .btn-back {
        background: #6c757d;
        color: white;
    }

    .btn-back:hover {
        background: #5a6268;
        transform: translateY(-2px);
    }

    @media (max-width: 768px) {
        .dashboard-sidebar {
            width: 100%;
            position: relative;
            height: auto;
        }

        .dashboard-content {
            margin-left: 0;
        }

        .porter-table {
            font-size: 12px;
        }

        .porter-table th,
        .porter-table td {
            padding: 8px 4px;
        }

        .conclusion-box {
            flex-direction: column;
            gap: 20px;
        }
    }
</style>
</head>
<body>
   <div class="dashboard-sidebar">
    <div class="sidebar-header">
        <div class="company-logo">
            <i class="fas fa-building"></i>
            <h2>PETI System</h2>
        </div>
        <div class="user-profile">
            <div class="user-avatar">
                <span id="userInitials"><%= userInitials %></span>
            </div>
            <div class="user-info">
                <h3 id="userName"><%= usuario %></h3>
                <p id="userEmail"><%= userEmail %></p>
            </div>
        </div>
    </div>
    <nav class="dashboard-nav">
    <div class="nav-section">
        <div class="nav-section-title">Principal</div>
        <ul>
            <li><a href="dashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a></li>
        </ul>
    </div>
    
    <div class="nav-section">
        <div class="nav-section-title">Planificación Estratégica</div>
        <ul>
            <li><a href="empresa_colaborativo.jsp"><i class="fas fa-building"></i> Información Empresarial</a></li>
            <li><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
            <li><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
            <li><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
            <li><a href="objetivos_colaborativo.jsp"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
        </ul>
    </div>

    <div class="nav-section">
        <div class="nav-section-title">Análisis Estratégico</div>
        <ul>
            <li><a href="analisis_externo_colaborativo.jsp"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
            <li><a href="analisis_interno_colaborativo.jsp"><i class="fas fa-chart-bar"></i> Análisis Organizacional</a></li>
            <%-- El Análisis de Porter se movió a Herramientas de Gestión para consistencia --%>
        </ul>
    </div>

    <div class="nav-section">
        <div class="nav-section-title">Herramientas de Gestión</div>
        <ul>
            <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
            <li><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-users"></i> Matriz de Participación</a></li>
            <li><a href="autodiagnostico_BCG.jsp"><i class="fas fa-users"></i> autodiagnostico_BCG</a></li>
            <li><a href="matriz_porter.jsp"><i class="fas fa-industry"></i> Matriz de Porter</a></li>
            
            <li class="active"><a href="analisis_porter_colaborativo.jsp"><i class="fas fa-industry"></i> Análisis de Porter</a></li>
            
            <%-- Enlaces faltantes agregados --%>
            <li><a href="ANÁLISIS EXTERNO MACROENTORNO_PEST.jsp"><i class="fas fa-industry"></i> Análisis PEST</a></li>
            <li><a href="IDENTIFICACIÓN DE ESTRATEGIAS.jsp"><i class="fas fa-industry"></i> Estrategias</a></li>
            <li><a href="MATRIZ CAME.jsp"><i class="fas fa-industry"></i> Matriz CAME</a></li>
            
            <li><a href="resumen-ejecutivo-colaborativo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
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
            <div class="container">
                <div class="header">
                    <h1><i class="fas fa-industry"></i> ANÁLISIS DE PORTER - PERFIL COMPETITIVO</h1>
                    <p>Evalúe cada una de las 5 fuerzas de Porter para determinar el perfil competitivo de su empresa</p>
                </div>

                <div class="content">
                    <% if (!mensaje.isEmpty()) { %>
                        <div class="alert alert-<%= tipoMensaje %>">
                            <i class="fas fa-<%= tipoMensaje.equals("success") ? "check-circle" : "exclamation-circle" %>"></i>
                            <%= mensaje %>
                        </div>
                    <% } %>

                    <% if (!modoColaborativo) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-triangle"></i>
                            Debe unirse a un grupo para utilizar esta funcionalidad colaborativa.
                        </div>
                        <div class="button-group">
                            <a href="dashboard.jsp" class="btn-back">
                                <i class="fas fa-arrow-left"></i> Volver al Dashboard
                            </a>
                        </div>
                    <% } else { %>
                        <div class="info-box">
                            <p><strong><i class="fas fa-info-circle"></i> Instrucciones:</strong> 
                            Seleccione el nivel que mejor describa la situación de su empresa para cada fuerza. 
                            Los valores van desde 1 (Nada) hasta 5 (Muy Alto). El total se calculará automáticamente.</p>
                        </div>

                        <form method="POST" action="analisis_porter_colaborativo.jsp" id="porterForm">
                            <table class="porter-table">
                                <thead>
                                    <tr>
                                        <th style="width: 35%;">PERFIL COMPETITIVO</th>
                                        <th class="hostil">Hostil</th>
                                        <th>Nada</th>
                                        <th>Poco</th>
                                        <th>Medio</th>
                                        <th>Alto</th>
                                        <th>Muy Alto</th>
                                        <th class="favorable">Favorable</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="category-header" colspan="8">Rivalidad empresas del sector</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Crecimiento</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Ritmo de crecimiento del sector</td>
                                        <td class="hostil">Lento</td>
                                        <td><input type="radio" name="rivalidad_crecimiento" value="1" <%= checkear(valoresPorter, "rivalidad_crecimiento", "1") %>></td>
                                        <td><input type="radio" name="rivalidad_crecimiento" value="2" <%= checkear(valoresPorter, "rivalidad_crecimiento", "2") %>></td>
                                        <td><input type="radio" name="rivalidad_crecimiento" value="3" <%= checkear(valoresPorter, "rivalidad_crecimiento", "3") %>></td>
                                        <td><input type="radio" name="rivalidad_crecimiento" value="4" <%= checkear(valoresPorter, "rivalidad_crecimiento", "4") %>></td>
                                        <td><input type="radio" name="rivalidad_crecimiento" value="5" <%= checkear(valoresPorter, "rivalidad_crecimiento", "5") %>></td>
                                        <td class="favorable">Rápido</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Naturaleza de los competidores</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Número de competidores</td>
                                        <td class="hostil">Muchos</td>
                                        <td><input type="radio" name="rivalidad_competidores" value="1" <%= checkear(valoresPorter, "rivalidad_competidores", "1") %>></td>
                                        <td><input type="radio" name="rivalidad_competidores" value="2" <%= checkear(valoresPorter, "rivalidad_competidores", "2") %>></td>
                                        <td><input type="radio" name="rivalidad_competidores" value="3" <%= checkear(valoresPorter, "rivalidad_competidores", "3") %>></td>
                                        <td><input type="radio" name="rivalidad_competidores" value="4" <%= checkear(valoresPorter, "rivalidad_competidores", "4") %>></td>
                                        <td><input type="radio" name="rivalidad_competidores" value="5" <%= checkear(valoresPorter, "rivalidad_competidores", "5") %>></td>
                                        <td class="favorable">Pocos</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Costos y capacidad productiva</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Exceso de capacidad productiva</td>
                                        <td class="hostil">Sí</td>
                                        <td><input type="radio" name="rivalidad_capacidad" value="1" <%= checkear(valoresPorter, "rivalidad_capacidad", "1") %>></td>
                                        <td><input type="radio" name="rivalidad_capacidad" value="2" <%= checkear(valoresPorter, "rivalidad_capacidad", "2") %>></td>
                                        <td><input type="radio" name="rivalidad_capacidad" value="3" <%= checkear(valoresPorter, "rivalidad_capacidad", "3") %>></td>
                                        <td><input type="radio" name="rivalidad_capacidad" value="4" <%= checkear(valoresPorter, "rivalidad_capacidad", "4") %>></td>
                                        <td><input type="radio" name="rivalidad_capacidad" value="5" <%= checkear(valoresPorter, "rivalidad_capacidad", "5") %>></td>
                                        <td class="favorable">No</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Rentabilidad</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Rentabilidad media del sector</td>
                                        <td class="hostil">Baja</td>
                                        <td><input type="radio" name="rivalidad_rentabilidad" value="1" <%= checkear(valoresPorter, "rivalidad_rentabilidad", "1") %>></td>
                                        <td><input type="radio" name="rivalidad_rentabilidad" value="2" <%= checkear(valoresPorter, "rivalidad_rentabilidad", "2") %>></td>
                                        <td><input type="radio" name="rivalidad_rentabilidad" value="3" <%= checkear(valoresPorter, "rivalidad_rentabilidad", "3") %>></td>
                                        <td><input type="radio" name="rivalidad_rentabilidad" value="4" <%= checkear(valoresPorter, "rivalidad_rentabilidad", "4") %>></td>
                                        <td><input type="radio" name="rivalidad_rentabilidad" value="5" <%= checkear(valoresPorter, "rivalidad_rentabilidad", "5") %>></td>
                                        <td class="favorable">Alta</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Diferenciación del producto</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Nivel de diferenciación</td>
                                        <td class="hostil">Escasa</td>
                                        <td><input type="radio" name="rivalidad_diferenciacion" value="1" <%= checkear(valoresPorter, "rivalidad_diferenciacion", "1") %>></td>
                                        <td><input type="radio" name="rivalidad_diferenciacion" value="2" <%= checkear(valoresPorter, "rivalidad_diferenciacion", "2") %>></td>
                                        <td><input type="radio" name="rivalidad_diferenciacion" value="3" <%= checkear(valoresPorter, "rivalidad_diferenciacion", "3") %>></td>
                                        <td><input type="radio" name="rivalidad_diferenciacion" value="4" <%= checkear(valoresPorter, "rivalidad_diferenciacion", "4") %>></td>
                                        <td><input type="radio" name="rivalidad_diferenciacion" value="5" <%= checkear(valoresPorter, "rivalidad_diferenciacion", "5") %>></td>
                                        <td class="favorable">Elevada</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Barreras de salida</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Dificultad para salir del sector</td>
                                        <td class="hostil">Bajas</td>
                                        <td><input type="radio" name="rivalidad_barreras" value="1" <%= checkear(valoresPorter, "rivalidad_barreras", "1") %>></td>
                                        <td><input type="radio" name="rivalidad_barreras" value="2" <%= checkear(valoresPorter, "rivalidad_barreras", "2") %>></td>
                                        <td><input type="radio" name="rivalidad_barreras" value="3" <%= checkear(valoresPorter, "rivalidad_barreras", "3") %>></td>
                                        <td><input type="radio" name="rivalidad_barreras" value="4" <%= checkear(valoresPorter, "rivalidad_barreras", "4") %>></td>
                                        <td><input type="radio" name="rivalidad_barreras" value="5" <%= checkear(valoresPorter, "rivalidad_barreras", "5") %>></td>
                                        <td class="favorable">Altas</td>
                                    </tr>

                                    <tr>
                                        <td class="category-header" colspan="8">Barreras de Entrada</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Economías de escala</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Importancia de las economías de escala</td>
                                        <td class="hostil">No</td>
                                        <td><input type="radio" name="barreras_economia" value="1" <%= checkear(valoresPorter, "barreras_economia", "1") %>></td>
                                        <td><input type="radio" name="barreras_economia" value="2" <%= checkear(valoresPorter, "barreras_economia", "2") %>></td>
                                        <td><input type="radio" name="barreras_economia" value="3" <%= checkear(valoresPorter, "barreras_economia", "3") %>></td>
                                        <td><input type="radio" name="barreras_economia" value="4" <%= checkear(valoresPorter, "barreras_economia", "4") %>></td>
                                        <td><input type="radio" name="barreras_economia" value="5" <%= checkear(valoresPorter, "barreras_economia", "5") %>></td>
                                        <td class="favorable">Sí</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Necesidad de capital</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Inversión inicial requerida</td>
                                        <td class="hostil">Bajas</td>
                                        <td><input type="radio" name="barreras_capital" value="1" <%= checkear(valoresPorter, "barreras_capital", "1") %>></td>
                                        <td><input type="radio" name="barreras_capital" value="2" <%= checkear(valoresPorter, "barreras_capital", "2") %>></td>
                                        <td><input type="radio" name="barreras_capital" value="3" <%= checkear(valoresPorter, "barreras_capital", "3") %>></td>
                                        <td><input type="radio" name="barreras_capital" value="4" <%= checkear(valoresPorter, "barreras_capital", "4") %>></td>
                                        <td><input type="radio" name="barreras_capital" value="5" <%= checkear(valoresPorter, "barreras_capital", "5") %>></td>
                                        <td class="favorable">Altas</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Acceso a la tecnología</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Dificultad de acceso tecnológico</td>
                                        <td class="hostil">Fácil</td>
                                        <td><input type="radio" name="barreras_tecnologia" value="1" <%= checkear(valoresPorter, "barreras_tecnologia", "1") %>></td>
                                        <td><input type="radio" name="barreras_tecnologia" value="2" <%= checkear(valoresPorter, "barreras_tecnologia", "2") %>></td>
                                        <td><input type="radio" name="barreras_tecnologia" value="3" <%= checkear(valoresPorter, "barreras_tecnologia", "3") %>></td>
                                        <td><input type="radio" name="barreras_tecnologia" value="4" <%= checkear(valoresPorter, "barreras_tecnologia", "4") %>></td>
                                        <td><input type="radio" name="barreras_tecnologia" value="5" <%= checkear(valoresPorter, "barreras_tecnologia", "5") %>></td>
                                        <td class="favorable">Difícil</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Reglamentos o leyes limitativas</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Existencia de regulaciones restrictivas</td>
                                        <td class="hostil">No</td>
                                        <td><input type="radio" name="barreras_reglamentos" value="1" <%= checkear(valoresPorter, "barreras_reglamentos", "1") %>></td>
                                        <td><input type="radio" name="barreras_reglamentos" value="2" <%= checkear(valoresPorter, "barreras_reglamentos", "2") %>></td>
                                        <td><input type="radio" name="barreras_reglamentos" value="3" <%= checkear(valoresPorter, "barreras_reglamentos", "3") %>></td>
                                        <td><input type="radio" name="barreras_reglamentos" value="4" <%= checkear(valoresPorter, "barreras_reglamentos", "4") %>></td>
                                        <td><input type="radio" name="barreras_reglamentos" value="5" <%= checkear(valoresPorter, "barreras_reglamentos", "5") %>></td>
                                        <td class="favorable">Sí</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Trámites burocráticos</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Complejidad de trámites de entrada</td>
                                        <td class="hostil">No</td>
                                        <td><input type="radio" name="barreras_tramites" value="1" <%= checkear(valoresPorter, "barreras_tramites", "1") %>></td>
                                        <td><input type="radio" name="barreras_tramites" value="2" <%= checkear(valoresPorter, "barreras_tramites", "2") %>></td>
                                        <td><input type="radio" name="barreras_tramites" value="3" <%= checkear(valoresPorter, "barreras_tramites", "3") %>></td>
                                        <td><input type="radio" name="barreras_tramites" value="4" <%= checkear(valoresPorter, "barreras_tramites", "4") %>></td>
                                        <td><input type="radio" name="barreras_tramites" value="5" <%= checkear(valoresPorter, "barreras_tramites", "5") %>></td>
                                        <td class="favorable">Sí</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Reacción esperada de competidores</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Respuesta de empresas establecidas</td>
                                        <td class="hostil">Escasa</td>
                                        <td><input type="radio" name="barreras_reaccion" value="1" <%= checkear(valoresPorter, "barreras_reaccion", "1") %>></td>
                                        <td><input type="radio" name="barreras_reaccion" value="2" <%= checkear(valoresPorter, "barreras_reaccion", "2") %>></td>
                                        <td><input type="radio" name="barreras_reaccion" value="3" <%= checkear(valoresPorter, "barreras_reaccion", "3") %>></td>
                                        <td><input type="radio" name="barreras_reaccion" value="4" <%= checkear(valoresPorter, "barreras_reaccion", "4") %>></td>
                                        <td><input type="radio" name="barreras_reaccion" value="5" <%= checkear(valoresPorter, "barreras_reaccion", "5") %>></td>
                                        <td class="favorable">Enérgica</td>
                                    </tr>

                                    <tr>
                                        <td class="category-header" colspan="8">Poder de los Clientes</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Número de clientes</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Concentración de clientes</td>
                                        <td class="hostil">Pocos</td>
                                        <td><input type="radio" name="clientes_numero" value="1" <%= checkear(valoresPorter, "clientes_numero", "1") %>></td>
                                        <td><input type="radio" name="clientes_numero" value="2" <%= checkear(valoresPorter, "clientes_numero", "2") %>></td>
                                        <td><input type="radio" name="clientes_numero" value="3" <%= checkear(valoresPorter, "clientes_numero", "3") %>></td>
                                        <td><input type="radio" name="clientes_numero" value="4" <%= checkear(valoresPorter, "clientes_numero", "4") %>></td>
                                        <td><input type="radio" name="clientes_numero" value="5" <%= checkear(valoresPorter, "clientes_numero", "5") %>></td>
                                        <td class="favorable">Muchos</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Posibilidad de integración ascendente</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Amenaza de integración vertical</td>
                                        <td class="hostil">Grande</td>
                                        <td><input type="radio" name="clientes_integracion" value="1" <%= checkear(valoresPorter, "clientes_integracion", "1") %>></td>
                                        <td><input type="radio" name="clientes_integracion" value="2" <%= checkear(valoresPorter, "clientes_integracion", "2") %>></td>
                                        <td><input type="radio" name="clientes_integracion" value="3" <%= checkear(valoresPorter, "clientes_integracion", "3") %>></td>
                                        <td><input type="radio" name="clientes_integracion" value="4" <%= checkear(valoresPorter, "clientes_integracion", "4") %>></td>
                                        <td><input type="radio" name="clientes_integracion" value="5" <%= checkear(valoresPorter, "clientes_integracion", "5") %>></td>
                                        <td class="favorable">Pequeña</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Rentabilidad de los clientes</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Márgenes de los clientes</td>
                                        <td class="hostil">Baja</td>
                                        <td><input type="radio" name="clientes_rentabilidad" value="1" <%= checkear(valoresPorter, "clientes_rentabilidad", "1") %>></td>
                                        <td><input type="radio" name="clientes_rentabilidad" value="2" <%= checkear(valoresPorter, "clientes_rentabilidad", "2") %>></td>
                                        <td><input type="radio" name="clientes_rentabilidad" value="3" <%= checkear(valoresPorter, "clientes_rentabilidad", "3") %>></td>
                                        <td><input type="radio" name="clientes_rentabilidad" value="4" <%= checkear(valoresPorter, "clientes_rentabilidad", "4") %>></td>
                                        <td><input type="radio" name="clientes_rentabilidad" value="5" <%= checkear(valoresPorter, "clientes_rentabilidad", "5") %>></td>
                                        <td class="favorable">Alta</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Coste de cambio de proveedor</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Switching costs para el cliente</td>
                                        <td class="hostil">Bajo</td>
                                        <td><input type="radio" name="clientes_coste" value="1" <%= checkear(valoresPorter, "clientes_coste", "1") %>></td>
                                        <td><input type="radio" name="clientes_coste" value="2" <%= checkear(valoresPorter, "clientes_coste", "2") %>></td>
                                        <td><input type="radio" name="clientes_coste" value="3" <%= checkear(valoresPorter, "clientes_coste", "3") %>></td>
                                        <td><input type="radio" name="clientes_coste" value="4" <%= checkear(valoresPorter, "clientes_coste", "4") %>></td>
                                        <td><input type="radio" name="clientes_coste" value="5" <%= checkear(valoresPorter, "clientes_coste", "5") %>></td>
                                        <td class="favorable">Alto</td>
                                    </tr>

                                    <tr>
                                        <td class="category-header" colspan="8">Productos sustitutivos</td>
                                    </tr>
                                    <tr>
                                        <td class="gray-row" colspan="8">- Disponibilidad de Productos Sustitutivos</td>
                                    </tr>
                                    <tr>
                                        <td class="factor-cell">Amenaza de productos sustitutos</td>
                                        <td class="hostil">Grande</td>
                                        <td><input type="radio" name="sustitutivos_disponibilidad" value="1" <%= checkear(valoresPorter, "sustitutivos_disponibilidad", "1") %>></td>
                                        <td><input type="radio" name="sustitutivos_disponibilidad" value="2" <%= checkear(valoresPorter, "sustitutivos_disponibilidad", "2") %>></td>
                                        <td><input type="radio" name="sustitutivos_disponibilidad" value="3" <%= checkear(valoresPorter, "sustitutivos_disponibilidad", "3") %>></td>
                                        <td><input type="radio" name="sustitutivos_disponibilidad" value="4" <%= checkear(valoresPorter, "sustitutivos_disponibilidad", "4") %>></td>
                                        <td><input type="radio" name="sustitutivos_disponibilidad" value="5" <%= checkear(valoresPorter, "sustitutivos_disponibilidad", "5") %>></td>
                                        <td class="favorable">Pequeña</td>
                                    </tr>

                                  
                                </tbody>
                            </table>

                            <div class="conclusion-box">
                                <div class="conclusion-text">
                                    <strong>CONCLUSIÓN:</strong> 
                                    <span id="conclusionText"><%= conclusion %></span>
                                </div>
                                <div class="total-box">
                                    <span class="total-label">Total (máx. 85 puntos)</span>
                                    <div class="total-value" id="totalValue"><%= total %></div>
                                </div>
                            </div>

                            <div style="margin-top: 30px; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                <p style="margin-bottom: 20px; color: #666; font-style: italic;">
                                    Una vez analizado el entorno próximo de su empresa, es decir análisis externo de su microentorno, 
                                    identifique las oportunidades y amenazas más relevantes que desee que se reflejen en el análisis 
                                    FODA de su Plan Estratégico de TI
                                </p>
                                
                                <h3 style="background: #fed7aa; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
                                    OPORTUNIDADES
                                </h3>
                                <div style="margin-bottom: 20px;">
                                    <div style="margin-bottom: 10px;">
                                        <label style="font-weight: 600; display: block; margin-bottom: 5px;">O1:</label>
                                        <input type="text" name="oportunidad_1" value="<%= valoresPorter.getOrDefault("oportunidad_1", "") %>" class="form-control">
                                    </div>
                                    <div style="margin-bottom: 10px;">
                                        <label style="font-weight: 600; display: block; margin-bottom: 5px;">O2:</label>
                                        <input type="text" name="oportunidad_2" value="<%= valoresPorter.getOrDefault("oportunidad_2", "") %>" class="form-control">
                                    </div>
                                </div>

                                <h3 style="background: #bee3f8; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
                                    AMENAZAS
                                </h3>
                                <div style="margin-bottom: 20px;">
                                    <div style="margin-bottom: 10px;">
                                        <label style="font-weight: 600; display: block; margin-bottom: 5px;">A1:</label>
                                        <input type="text" name="amenaza_1" value="<%= valoresPorter.getOrDefault("amenaza_1", "") %>" class="form-control">
                                    </div>
                                    <div style="margin-bottom: 10px;">
                                        <label style="font-weight: 600; display: block; margin-bottom: 5px;">A2:</label>
                                        <input type="text" name="amenaza_2" value="<%= valoresPorter.getOrDefault("amenaza_2", "") %>" class="form-control">
                                    </div>
                                </div>
                            </div>

                            <div class="button-group">
                                <button type="submit" class="btn-save">
                                    <i class="fas fa-save"></i> Guardar Análisis
                                </button>
                                <a href="dashboard.jsp" class="btn-back">
                                    <i class="fas fa-arrow-left"></i> Volver al Dashboard
                                </a>
                            </div>
                        </form>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <script>
    function logout() {
        if (confirm('¿Está seguro que desea cerrar sesión?')) {
            window.location.href = 'logout.jsp';
        }
    }

    // *** SOLO 17 CAMPOS PARA EL CÁLCULO ***
    var camposNumericos = [
        "rivalidad_crecimiento", "rivalidad_competidores", "rivalidad_capacidad",
        "rivalidad_rentabilidad", "rivalidad_diferenciacion", "rivalidad_barreras",
        "barreras_economia", "barreras_capital", "barreras_tecnologia",
        "barreras_reglamentos", "barreras_tramites", "barreras_reaccion",
        "clientes_numero", "clientes_integracion", "clientes_rentabilidad",
        "clientes_coste", "sustitutivos_disponibilidad"
    ];

    // Función para calcular el total
    function calcularTotal() {
        var total = 0;
        var camposEncontrados = 0;
        
        for (var i = 0; i < camposNumericos.length; i++) {
            var campo = camposNumericos[i];
            var radioSeleccionado = document.querySelector('input[name="' + campo + '"]:checked');
            
            if (radioSeleccionado && radioSeleccionado.value) {
                var valor = parseInt(radioSeleccionado.value);
                if (!isNaN(valor)) {
                    total = total + valor;
                    camposEncontrados++;
                }
            }
        }
        
        // Actualizar el valor del total
        var totalElement = document.getElementById('totalValue');
        if (totalElement) {
            totalElement.textContent = total;
        }
        
        // Actualizar conclusión según el total
        var conclusionText = document.getElementById('conclusionText');
        if (conclusionText) {
            if (total >= 68) {
                conclusionText.textContent = 'Situación excelente para la empresa - Entorno muy favorable';
            } else if (total >= 51) {
                conclusionText.textContent = 'Situación favorable para la empresa';
            } else if (total >= 34) {
                conclusionText.textContent = 'Situación moderada - Requiere atención en algunas áreas';
            } else if (total >= 17) {
                conclusionText.textContent = 'Situación desafiante - Se requieren mejoras significativas';
            } else {
                conclusionText.textContent = 'Situación crítica - Entorno muy hostil';
            }
        }
        
        return total;
    }

    // Cuando la página carga completamente
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', inicializar);
    } else {
        inicializar();
    }
    
    function inicializar() {
        // Calcular total inicial
        calcularTotal();
        
        // Agregar listeners a TODOS los radio buttons (incluyendo proveedores)
        var todosLosRadios = document.querySelectorAll('input[type="radio"]');
        
        for (var i = 0; i < todosLosRadios.length; i++) {
            // Usar 'click' en lugar de 'change' para mejor respuesta
            todosLosRadios[i].addEventListener('click', function() {
                // Pequeño delay para asegurar que el valor se actualiza
                setTimeout(calcularTotal, 10);
            });
            
            // También mantener 'change' por si acaso
            todosLosRadios[i].addEventListener('change', function() {
                calcularTotal();
            });
        }
    }
</script>

</body>
</html>
