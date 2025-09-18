<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Verificar si hay una sesión activa
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuario") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Obtener información del usuario
    String nombreUsuario = (String) userSession.getAttribute("usuario");
    String emailUsuario = (String) userSession.getAttribute("email");
    
    // Generar iniciales del usuario
    String iniciales = "";
    if (nombreUsuario != null && !nombreUsuario.isEmpty()) {
        String[] nombres = nombreUsuario.split(" ");
        for (String nombre : nombres) {
            if (!nombre.isEmpty()) {
                iniciales += nombre.charAt(0);
            }
        }
        iniciales = iniciales.toUpperCase();
        if (iniciales.length() > 2) {
            iniciales = iniciales.substring(0, 2);
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resumen Ejecutivo - Plan Estratégico</title>
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

        /* Estilos adicionales para el formulario */
        .breadcrumb-container {
            display: flex;
            align-items: center;
        }

        .breadcrumb {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            align-items: center;
        }

        .breadcrumb li {
            display: flex;
            align-items: center;
        }

        .breadcrumb li:not(:last-child)::after {
            content: '/';
            margin: 0 10px;
            color: #999;
        }

        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
            display: flex;
            align-items: center;
            transition: color 0.3s ease;
        }

        .breadcrumb a:hover {
            color: #764ba2;
        }

        .breadcrumb a i {
            margin-right: 5px;
        }

        .section-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .section-status.pending {
            background: #fff3cd;
            color: #856404;
        }

        .section-status i {
            margin-right: 5px;
        }

        .plan-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        .plan-section h1 {
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .plan-section h1 i {
            margin-right: 12px;
            color: #667eea;
        }

        .section-description {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .progress-bar-container {
            margin-bottom: 30px;
        }

        .progress {
            height: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transition: width 0.3s ease;
        }

        .progress-text {
            text-align: center;
            margin-top: 8px;
            font-size: 14px;
            color: #666;
        }

        .plan-form {
            display: flex;
            flex-direction: column;
        }

        .form-section {
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 1px solid #eee;
        }

        .form-section:last-of-type {
            border-bottom: none;
        }

        .form-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 20px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .required {
            color: #dc3545;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            background: white;
            resize: vertical;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
        }

        .subsection {
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .subsection h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 18px;
            font-weight: 600;
        }

        .tips-container {
            background: linear-gradient(135deg, #e8f2ff 0%, #f0f8ff 100%);
            border: 1px solid #cce7ff;
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
        }

        .tips-container h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .tips-container h3 i {
            margin-right: 10px;
            color: #667eea;
        }

        .tips-container ul {
            margin: 0;
            padding-left: 20px;
        }

        .tips-container li {
            color: #555;
            margin-bottom: 8px;
            line-height: 1.5;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            padding-top: 30px;
            border-top: 1px solid #eee;
            justify-content: flex-start;
            flex-wrap: wrap;
        }

        .navigation-buttons {
            display: flex;
            gap: 15px;
            margin-left: auto;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            border: none;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .btn i {
            margin-right: 8px;
        }

        .save-button {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .save-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .reset-button {
            background: #6c757d;
            color: white;
        }

        .reset-button:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        .prev-button {
            background: #6c757d;
            color: white;
        }

        .prev-button:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        .next-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .next-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .plan-nav-container {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }

        .plan-nav-container h3 {
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 15px;
            font-size: 16px;
            font-weight: 600;
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

            .form-actions {
                flex-direction: column;
            }

            .navigation-buttons {
                margin-left: 0;
                flex-direction: column;
            }

            .plan-section {
                padding: 20px;
            }

            .dashboard-header {
                padding: 15px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .breadcrumb-container {
                width: 100%;
            }

            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar de navegación -->
        <div class="dashboard-sidebar">
            <div class="user-profile">
                <div class="user-avatar">
                    <span id="userInitials"><%= iniciales %></span>
                </div>
                <div class="user-info">
                    <h3 id="userName"><%= nombreUsuario %></h3>
                    <p id="userEmail"><%= emailUsuario %></p>
                </div>
            </div>
            
            <!-- Navegación principal -->
            <nav class="dashboard-nav">
                <ul>
                    <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                    <li><a href="empresa.jsp"><i class="fas fa-building"></i> Empresa</a></li>
                    <li><a href="mision.jsp"><i class="fas fa-bullseye"></i> Misión</a></li>
                    <li><a href="vision.jsp"><i class="fas fa-eye"></i> Visión</a></li>
                    <li><a href="valores.jsp"><i class="fas fa-heart"></i> Valores</a></li>
                    <li><a href="objetivos.jsp"><i class="fas fa-target"></i> Objetivos</a></li>
                    <li><a href="analisis-interno.jsp"><i class="fas fa-chart-bar"></i> Análisis Interno</a></li>
                    <li><a href="analisis-externo.jsp"><i class="fas fa-search"></i> Análisis Externo</a></li>
                    <li><a href="pest.jsp"><i class="fas fa-list"></i> Análisis PEST</a></li>
                    <li><a href="porter.jsp"><i class="fas fa-shield-alt"></i> Porter</a></li>
                    <li><a href="cadena-valor.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                    <li><a href="matriz-participacion.jsp"><i class="fas fa-users"></i> Matriz Participación</a></li>
                    <li><a href="matriz-came.jsp"><i class="fas fa-th"></i> Matriz CAME</a></li>
                    <li class="active"><a href="resumen-ejecutivo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    <li><a href="#" id="logoutBtn"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                </ul>
            </nav>
            
            <!-- Navegación del plan estratégico -->
            <div class="plan-nav-container">
                <h3>Plan Estratégico</h3>
                <!-- El menú se generará con JavaScript -->
            </div>
        </div>
        
        <!-- Contenido principal -->
        <div class="dashboard-content">
            <!-- Encabezado -->
            <header class="dashboard-header">
                <div class="breadcrumb-container">
                    <ul class="breadcrumb">
                        <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                        <li><a href="empresa.jsp">Información de la Empresa</a></li>
                        <li><a href="matriz-came.jsp">Matriz CAME</a></li>
                        <li>Resumen Ejecutivo</li>
                    </ul>
                </div>
                <div class="header-actions">
                    <span class="section-status pending"><i class="fas fa-clock"></i> Pendiente</span>
                    <button class="btn btn-primary" id="exportPdfBtn"><i class="fas fa-file-pdf"></i> Exportar a PDF</button>
                </div>
            </header>
            
            <!-- Contenido de la sección -->
            <main class="dashboard-main">
                <div class="plan-section">
                    <h1><i class="fas fa-file-alt"></i> Resumen Ejecutivo del Plan Estratégico</h1>
                    <p class="section-description">
                        Este documento presenta el resumen ejecutivo del plan estratégico, integrando todos los análisis realizados y las estrategias definidas. Sirve como documento final que sintetiza los aspectos clave del plan estratégico para facilitar su comunicación y seguimiento.
                    </p>
                    
                    <!-- Barra de progreso -->
                    <div class="progress-bar-container">
                        <div class="progress">
                            <div class="progress-bar" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <div class="progress-text">0% Completado</div>
                    </div>
                    
                    <!-- Formulario -->
                    <form class="plan-form">
                        <div class="form-section">
                            <h2>Información General de la Empresa</h2>
                            
                            <div class="form-group">
                                <label for="nombreEmpresa">Nombre de la empresa <span class="required">*</span></label>
                                <input type="text" id="nombreEmpresa" name="nombreEmpresa" class="form-control" required>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="sectorEmpresa">Sector <span class="required">*</span></label>
                                    <input type="text" id="sectorEmpresa" name="sectorEmpresa" class="form-control" required>
                                </div>
                                
                                <div class="form-group col-md-6">
                                    <label for="tamanoEmpresa">Tamaño <span class="required">*</span></label>
                                    <select id="tamanoEmpresa" name="tamanoEmpresa" class="form-control" required>
                                        <option value="">Seleccionar...</option>
                                        <option value="micro">Microempresa (< 10 empleados)</option>
                                        <option value="pequena">Pequeña empresa (10-49 empleados)</option>
                                        <option value="mediana">Mediana empresa (50-249 empleados)</option>
                                        <option value="grande">Gran empresa (≥ 250 empleados)</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="fechaElaboracion">Fecha de elaboración del plan <span class="required">*</span></label>
                                <input type="date" id="fechaElaboracion" name="fechaElaboracion" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="periodoVigencia">Periodo de vigencia del plan <span class="required">*</span></label>
                                <input type="text" id="periodoVigencia" name="periodoVigencia" class="form-control" placeholder="Ej: 2023-2025" required>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Dirección Estratégica</h2>
                            
                            <div class="form-group">
                                <label for="misionResumen">Misión <span class="required">*</span></label>
                                <textarea id="misionResumen" name="misionResumen" class="form-control" rows="3" required></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label for="visionResumen">Visión <span class="required">*</span></label>
                                <textarea id="visionResumen" name="visionResumen" class="form-control" rows="3" required></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label for="valoresResumen">Valores corporativos <span class="required">*</span></label>
                                <textarea id="valoresResumen" name="valoresResumen" class="form-control" rows="3" required></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label for="objetivosResumen">Objetivos estratégicos <span class="required">*</span></label>
                                <textarea id="objetivosResumen" name="objetivosResumen" class="form-control" rows="4" required></textarea>
                                <small class="form-text">Enumere los principales objetivos estratégicos definidos para el periodo.</small>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Resumen del Análisis Estratégico</h2>
                            
                            <div class="subsection">
                                <h3>Análisis FODA</h3>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="fortalezasResumen">Principales fortalezas <span class="required">*</span></label>
                                        <textarea id="fortalezasResumen" name="fortalezasResumen" class="form-control" rows="3" required></textarea>
                                    </div>
                                    
                                    <div class="form-group col-md-6">
                                        <label for="debilidadesResumen">Principales debilidades <span class="required">*</span></label>
                                        <textarea id="debilidadesResumen" name="debilidadesResumen" class="form-control" rows="3" required></textarea>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="oportunidadesResumen">Principales oportunidades <span class="required">*</span></label>
                                        <textarea id="oportunidadesResumen" name="oportunidadesResumen" class="form-control" rows="3" required></textarea>
                                    </div>
                                    
                                    <div class="form-group col-md-6">
                                        <label for="amenazasResumen">Principales amenazas <span class="required">*</span></label>
                                        <textarea id="amenazasResumen" name="amenazasResumen" class="form-control" rows="3" required></textarea>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="subsection">
                                <h3>Análisis del Entorno</h3>
                                
                                <div class="form-group">
                                    <label for="pestResumen">Principales hallazgos del análisis PEST <span class="required">*</span></label>
                                    <textarea id="pestResumen" name="pestResumen" class="form-control" rows="4" required></textarea>
                                    <small class="form-text">Resuma los factores más relevantes del entorno político, económico, social y tecnológico.</small>
                                </div>
                                
                                <div class="form-group">
                                    <label for="porterResumen">Principales hallazgos del análisis de las 5 Fuerzas de Porter <span class="required">*</span></label>
                                    <textarea id="porterResumen" name="porterResumen" class="form-control" rows="4" required></textarea>
                                    <small class="form-text">Resuma las conclusiones más importantes sobre la estructura competitiva del sector.</small>
                                </div>
                            </div>
                            
                            <div class="subsection">
                                <h3>Análisis Interno</h3>
                                
                                <div class="form-group">
                                    <label for="cadenaValorResumen">Principales hallazgos del análisis de la Cadena de Valor <span class="required">*</span></label>
                                    <textarea id="cadenaValorResumen" name="cadenaValorResumen" class="form-control" rows="4" required></textarea>
                                    <small class="form-text">Resuma las actividades que generan mayor valor y las áreas de mejora identificadas.</small>
                                </div>
                            </div>
                            
                            <div class="subsection">
                                <h3>Análisis de Stakeholders</h3>
                                
                                <div class="form-group">
                                    <label for="stakeholdersResumen">Principales stakeholders y estrategias de gestión <span class="required">*</span></label>
                                    <textarea id="stakeholdersResumen" name="stakeholdersResumen" class="form-control" rows="4" required></textarea>
                                    <small class="form-text">Identifique los stakeholders clave y las estrategias para su gestión.</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Estrategias Definidas</h2>
                            
                            <div class="form-group">
                                <label for="estrategiasReorientacionResumen">Estrategias de reorientación (DO) <span class="required">*</span></label>
                                <textarea id="estrategiasReorientacionResumen" name="estrategiasReorientacionResumen" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Resuma las principales estrategias para corregir debilidades aprovechando oportunidades.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="estrategiasSupervivenciaResumen">Estrategias de supervivencia (DA) <span class="required">*</span></label>
                                <textarea id="estrategiasSupervivenciaResumen" name="estrategiasSupervivenciaResumen" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Resuma las principales estrategias para afrontar amenazas y corregir debilidades.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="estrategiasDefensivasResumen">Estrategias defensivas (FA) <span class="required">*</span></label>
                                <textarea id="estrategiasDefensivasResumen" name="estrategiasDefensivasResumen" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Resuma las principales estrategias para mantener fortalezas y afrontar amenazas.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="estrategiasOfensivasResumen">Estrategias ofensivas (FO) <span class="required">*</span></label>
                                <textarea id="estrategiasOfensivasResumen" name="estrategiasOfensivasResumen" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Resuma las principales estrategias para explotar oportunidades aprovechando fortalezas.</small>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Plan de Implementación</h2>
                            
                            <div class="form-group">
                                <label for="estrategiasPrioritarias">Estrategias prioritarias <span class="required">*</span></label>
                                <textarea id="estrategiasPrioritarias" name="estrategiasPrioritarias" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Identifique las estrategias que se implementarán con mayor prioridad y explique por qué.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="cronogramaImplementacion">Cronograma general de implementación <span class="required">*</span></label>
                                <textarea id="cronogramaImplementacion" name="cronogramaImplementacion" class="form-control" rows="4" required></textarea>
                                <small class="form-text">Describa las principales fases y plazos para la implementación del plan estratégico.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="recursosNecesarios">Recursos necesarios <span class="required">*</span></label>
                                <textarea id="recursosNecesarios" name="recursosNecesarios" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Resuma los principales recursos humanos, financieros, tecnológicos y materiales necesarios.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="responsablesImplementacion">Responsables de la implementación <span class="required">*</span></label>
                                <textarea id="responsablesImplementacion" name="responsablesImplementacion" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Identifique los principales responsables de la implementación del plan estratégico.</small>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Seguimiento y Evaluación</h2>
                            
                            <div class="form-group">
                                <label for="indicadoresDesempeno">Indicadores clave de desempeño (KPIs) <span class="required">*</span></label>
                                <textarea id="indicadoresDesempeno" name="indicadoresDesempeno" class="form-control" rows="4" required></textarea>
                                <small class="form-text">Defina los principales indicadores que se utilizarán para medir el éxito del plan estratégico.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="mecanismosSeguimiento">Mecanismos de seguimiento <span class="required">*</span></label>
                                <textarea id="mecanismosSeguimiento" name="mecanismosSeguimiento" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Describa cómo se realizará el seguimiento de la implementación del plan estratégico.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="frecuenciaEvaluacion">Frecuencia de evaluación <span class="required">*</span></label>
                                <select id="frecuenciaEvaluacion" name="frecuenciaEvaluacion" class="form-control" required>
                                    <option value="">Seleccionar...</option>
                                    <option value="mensual">Mensual</option>
                                    <option value="trimestral">Trimestral</option>
                                    <option value="semestral">Semestral</option>
                                    <option value="anual">Anual</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Conclusiones</h2>
                            
                            <div class="form-group">
                                <label for="conclusionesFinales">Conclusiones finales <span class="required">*</span></label>
                                <textarea id="conclusionesFinales" name="conclusionesFinales" class="form-control" rows="5" required></textarea>
                                <small class="form-text">Presente las conclusiones finales del plan estratégico, destacando su importancia para el futuro de la empresa.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="recomendacionesFinales">Recomendaciones finales <span class="required">*</span></label>
                                <textarea id="recomendacionesFinales" name="recomendacionesFinales" class="form-control" rows="5" required></textarea>
                                <small class="form-text">Presente recomendaciones adicionales para asegurar el éxito en la implementación del plan estratégico.</small>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="button" class="btn save-button"><i class="fas fa-save"></i> Guardar</button>
                            <button type="button" class="btn reset-button"><i class="fas fa-undo"></i> Restablecer</button>
                            <div class="navigation-buttons">
                                <a href="matriz-came.jsp" class="btn prev-button"><i class="fas fa-arrow-left"></i> Anterior: Matriz CAME</a>
                                <button type="button" class="btn btn-success" id="completePlanBtn"><i class="fas fa-check-circle"></i> Finalizar Plan Estratégico</button>
                            </div>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
    
    <script src="js/auth.js"></script>
    <script src="js/storage.js"></script>
    <script src="js/navigation.js"></script>
    <script src="js/forms.js"></script>
    <script src="js/progress.js"></script>
    
    <!-- Script específico para el resumen ejecutivo -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Cargar datos de las secciones anteriores
            function cargarDatosAnteriores() {
                // Aquí se implementaría la lógica para cargar datos de las secciones anteriores
                // Por ejemplo, cargar la misión, visión, valores, etc. desde el almacenamiento
                
                // Ejemplo de carga de datos (simulado)
                const datosEmpresa = JSON.parse(localStorage.getItem('datosEmpresa')) || {};
                const mision = JSON.parse(localStorage.getItem('mision')) || {};
                const vision = JSON.parse(localStorage.getItem('vision')) || {};
                const valores = JSON.parse(localStorage.getItem('valores')) || {};
                const objetivos = JSON.parse(localStorage.getItem('objetivos')) || {};
                
                // Rellenar campos con datos existentes
                if (datosEmpresa.nombre) document.getElementById('nombreEmpresa').value = datosEmpresa.nombre;
                if (datosEmpresa.sector) document.getElementById('sectorEmpresa').value = datosEmpresa.sector;
                if (datosEmpresa.tamano) document.getElementById('tamanoEmpresa').value = datosEmpresa.tamano;
                
                if (mision.declaracion) document.getElementById('misionResumen').value = mision.declaracion;
                if (vision.declaracion) document.getElementById('visionResumen').value = vision.declaracion;
                
                // Establecer la fecha actual como fecha de elaboración si no existe
                if (!document.getElementById('fechaElaboracion').value) {
                    const hoy = new Date().toISOString().split('T')[0];
                    document.getElementById('fechaElaboracion').value = hoy;
                }
            }
            
            // Exportar a PDF
            document.getElementById('exportPdfBtn').addEventListener('click', function() {
                alert('Funcionalidad de exportación a PDF en desarrollo.');
                // Aquí se implementaría la lógica para exportar el resumen ejecutivo a PDF
            });
            
            // Finalizar plan estratégico
            document.getElementById('completePlanBtn').addEventListener('click', function() {
                // Validar que todos los campos requeridos estén completos
                const form = document.querySelector('.plan-form');
                if (form.checkValidity()) {
                    // Guardar datos
                    guardarResumenEjecutivo();
                    
                    // Mostrar mensaje de éxito
                    alert('¡Felicidades! Ha completado su Plan Estratégico con éxito.');
                    
                    // Redirigir al dashboard
                    window.location.href = 'dashboard.jsp';
                } else {
                    // Mostrar validaciones del formulario
                    form.reportValidity();
                }
            });
            
            // Función para guardar el resumen ejecutivo
            function guardarResumenEjecutivo() {
                const resumenEjecutivo = {
                    nombreEmpresa: document.getElementById('nombreEmpresa').value,
                    sectorEmpresa: document.getElementById('sectorEmpresa').value,
                    tamanoEmpresa: document.getElementById('tamanoEmpresa').value,
                    fechaElaboracion: document.getElementById('fechaElaboracion').value,
                    periodoVigencia: document.getElementById('periodoVigencia').value,
                    mision: document.getElementById('misionResumen').value,
                    vision: document.getElementById('visionResumen').value,
                    valores: document.getElementById('valoresResumen').value,
                    objetivos: document.getElementById('objetivosResumen').value,
                    fortalezas: document.getElementById('fortalezasResumen').value,
                    debilidades: document.getElementById('debilidadesResumen').value,
                    oportunidades: document.getElementById('oportunidadesResumen').value,
                    amenazas: document.getElementById('amenazasResumen').value,
                    pest: document.getElementById('pestResumen').value,
                    porter: document.getElementById('porterResumen').value,
                    cadenaValor: document.getElementById('cadenaValorResumen').value,
                    stakeholders: document.getElementById('stakeholdersResumen').value,
                    estrategiasReorientacion: document.getElementById('estrategiasReorientacionResumen').value,
                    estrategiasSupervivencia: document.getElementById('estrategiasSupervivenciaResumen').value,
                    estrategiasDefensivas: document.getElementById('estrategiasDefensivasResumen').value,
                    estrategiasOfensivas: document.getElementById('estrategiasOfensivasResumen').value,
                    estrategiasPrioritarias: document.getElementById('estrategiasPrioritarias').value,
                    cronogramaImplementacion: document.getElementById('cronogramaImplementacion').value,
                    recursosNecesarios: document.getElementById('recursosNecesarios').value,
                    responsablesImplementacion: document.getElementById('responsablesImplementacion').value,
                    indicadoresDesempeno: document.getElementById('indicadoresDesempeno').value,
                    mecanismosSeguimiento: document.getElementById('mecanismosSeguimiento').value,
                    frecuenciaEvaluacion: document.getElementById('frecuenciaEvaluacion').value,
                    conclusionesFinales: document.getElementById('conclusionesFinales').value,
                    recomendacionesFinales: document.getElementById('recomendacionesFinales').value,
                    fechaCreacion: new Date().toISOString(),
                    completado: true
                };
                
                // Guardar en localStorage
                localStorage.setItem('resumenEjecutivo', JSON.stringify(resumenEjecutivo));
                
                // Actualizar estado del plan estratégico
                const estadoPlan = JSON.parse(localStorage.getItem('estadoPlan')) || {};
                estadoPlan.resumenEjecutivo = true;
                estadoPlan.completado = true;
                localStorage.setItem('estadoPlan', JSON.stringify(estadoPlan));
            }
            
            // Inicializar
            cargarDatosAnteriores();
        });
    </script>
</body>
</html>