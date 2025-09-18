<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Obtener información del usuario
    String nombreCompleto = (String) session.getAttribute("nombreCompleto");
    String email = (String) session.getAttribute("email");
    String rol = (String) session.getAttribute("rol");
    
    // Generar iniciales del usuario
    String iniciales = "";
    if (nombreCompleto != null && !nombreCompleto.isEmpty()) {
        String[] nombres = nombreCompleto.split(" ");
        for (String nombre : nombres) {
            if (!nombre.isEmpty()) {
                iniciales += nombre.charAt(0);
            }
        }
        iniciales = iniciales.toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadena de Valor - PETI</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 280px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }

        .sidebar-header {
            padding: 2rem 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            text-align: center;
        }

        .sidebar-header h2 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .user-profile {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
            margin-right: 1rem;
        }

        .user-info h4 {
            margin-bottom: 0.25rem;
            font-size: 1rem;
        }

        .user-info span {
            font-size: 0.85rem;
            opacity: 0.8;
        }

        .nav-menu {
            padding: 1rem 0;
        }

        .nav-item {
            margin: 0.25rem 1rem;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .nav-link:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }

        .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
            font-weight: 500;
        }

        .nav-link i {
            margin-right: 0.75rem;
            width: 20px;
            text-align: center;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            background-color: #f8fafc;
        }

        .top-bar {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            color: #64748b;
            font-size: 0.9rem;
        }

        .breadcrumb a {
            color: #3b82f6;
            text-decoration: none;
            margin-right: 0.5rem;
        }

        .breadcrumb i {
            margin: 0 0.5rem;
            font-size: 0.8rem;
        }

        .section-status {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-pending {
            background-color: #fef3c7;
            color: #d97706;
        }

        .content-area {
            padding: 2rem;
        }

        .page-header {
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .page-description {
            color: #64748b;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .progress-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .progress-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .progress-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #374151;
        }

        .progress-percentage {
            font-size: 1.1rem;
            font-weight: 600;
            color: #3b82f6;
        }

        .progress-bar {
            width: 100%;
            height: 8px;
            background-color: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #3b82f6, #1d4ed8);
            border-radius: 4px;
            transition: width 0.3s ease;
            width: 70%;
        }

        .form-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .form-section {
            padding: 2rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .form-section:last-child {
            border-bottom: none;
        }

        .form-section h2 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .form-section h2 i {
            margin-right: 0.75rem;
            color: #3b82f6;
        }

        .section-intro {
            color: #64748b;
            margin-bottom: 1.5rem;
            font-size: 1rem;
            line-height: 1.6;
        }

        .subsection {
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: #f8fafc;
            border-radius: 8px;
            border-left: 4px solid #3b82f6;
        }

        .subsection h3 {
            font-size: 1.2rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.5rem;
        }

        .subsection-intro {
            color: #64748b;
            margin-bottom: 1rem;
            font-size: 0.95rem;
            font-style: italic;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #374151;
        }

        .required {
            color: #ef4444;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: white;
        }

        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .form-text {
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }

        .form-actions {
            padding: 2rem;
            background: #f8fafc;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .save-button {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .save-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }

        .reset-button {
            background: #6b7280;
            color: white;
        }

        .reset-button:hover {
            background: #4b5563;
            transform: translateY(-2px);
        }

        .navigation-buttons {
            display: flex;
            gap: 1rem;
        }

        .prev-button {
            background: #f3f4f6;
            color: #374151;
            border: 2px solid #d1d5db;
        }

        .prev-button:hover {
            background: #e5e7eb;
            border-color: #9ca3af;
        }

        .next-button {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
        }

        .next-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }

            .top-bar {
                padding: 1rem;
            }

            .content-area {
                padding: 1rem;
            }

            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .navigation-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2><i class="fas fa-chart-line"></i> PETI</h2>
                <p>Plan Estratégico de TI</p>
            </div>
            
            <div class="user-profile">
                <div class="user-avatar">
                    <%= iniciales %>
                </div>
                <div class="user-info">
                    <h4><%= nombreCompleto != null ? nombreCompleto : usuario %></h4>
                    <span><%= rol != null ? rol : "Usuario" %></span>
                </div>
            </div>

            <nav class="nav-menu">
                <div class="nav-item">
                    <a href="dashboard.jsp" class="nav-link">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="empresa.jsp" class="nav-link">
                        <i class="fas fa-building"></i>
                        <span>Información de la Empresa</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="mision.jsp" class="nav-link">
                        <i class="fas fa-bullseye"></i>
                        <span>Misión y Visión</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="analisis-interno.jsp" class="nav-link">
                        <i class="fas fa-search-plus"></i>
                        <span>Análisis Interno</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="analisis-externo.jsp" class="nav-link">
                        <i class="fas fa-globe"></i>
                        <span>Análisis Externo</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="foda.jsp" class="nav-link">
                        <i class="fas fa-th-large"></i>
                        <span>Matriz FODA</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="porter.jsp" class="nav-link">
                        <i class="fas fa-shield-alt"></i>
                        <span>5 Fuerzas de Porter</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="cadena-valor.jsp" class="nav-link active">
                        <i class="fas fa-link"></i>
                        <span>Cadena de Valor</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="matriz-participacion.jsp" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Matriz de Participación</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="matriz-came.jsp" class="nav-link">
                        <i class="fas fa-chess-board"></i>
                        <span>Matriz CAME</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="objetivos.jsp" class="nav-link">
                        <i class="fas fa-flag"></i>
                        <span>Objetivos Estratégicos</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="resumen-ejecutivo.jsp" class="nav-link">
                        <i class="fas fa-file-alt"></i>
                        <span>Resumen Ejecutivo</span>
                    </a>
                </div>
            </nav>
        </aside>

        <div class="main-content">
            <header class="top-bar">
                <div class="breadcrumb">
                    <a href="dashboard.jsp">Dashboard</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Cadena de Valor</span>
                </div>
                <div class="section-status">
                    <span class="status-badge status-pending">
                        <i class="fas fa-clock"></i> En progreso
                    </span>
                </div>
            </header>

            <main class="content-area">
                <div class="page-header">
                    <h1 class="page-title">Análisis de la Cadena de Valor</h1>
                    <p class="page-description">
                        La cadena de valor es una herramienta de análisis estratégico que ayuda a determinar la ventaja competitiva de la empresa. 
                        Identifica las actividades que generan valor y aquellas que pueden optimizarse para mejorar la posición competitiva.
                    </p>
                </div>

                <div class="progress-section">
                    <div class="progress-header">
                        <span class="progress-title">Progreso del Análisis</span>
                        <span class="progress-percentage">70%</span>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill"></div>
                    </div>
                </div>

                <div class="form-container">
                    <form id="cadenaValorForm">
                        <div class="form-section">
                            <h2><i class="fas fa-arrow-right"></i> Actividades Primarias</h2>
                            <p class="section-intro">Las actividades primarias están directamente relacionadas con la creación física del producto, su venta y transferencia al comprador, así como la asistencia posterior a la venta.</p>
                            
                            <!-- Logística interna -->
                            <div class="subsection">
                                <h3>1. Logística interna</h3>
                                <p class="subsection-intro">Actividades relacionadas con la recepción, almacenamiento y distribución de insumos del producto.</p>
                                
                                <div class="form-group">
                                    <label for="descripcionLogisticaInterna">Descripción actual <span class="required">*</span></label>
                                    <textarea id="descripcionLogisticaInterna" name="descripcionLogisticaInterna" class="form-control" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fortalezasLogisticaInterna">Fortalezas identificadas</label>
                                    <textarea id="fortalezasLogisticaInterna" name="fortalezasLogisticaInterna" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="debilidadesLogisticaInterna">Debilidades identificadas</label>
                                    <textarea id="debilidadesLogisticaInterna" name="debilidadesLogisticaInterna" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="valorDiferencialLogisticaInterna">¿Genera valor diferencial? <span class="required">*</span></label>
                                    <select id="valorDiferencialLogisticaInterna" name="valorDiferencialLogisticaInterna" class="form-control" required>
                                        <option value="">Seleccionar...</option>
                                        <option value="si-alto">Sí, alto valor diferencial</option>
                                        <option value="si-medio">Sí, valor diferencial medio</option>
                                        <option value="si-bajo">Sí, bajo valor diferencial</option>
                                        <option value="no">No genera valor diferencial</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="mejorasLogisticaInterna">Mejoras potenciales</label>
                                    <textarea id="mejorasLogisticaInterna" name="mejorasLogisticaInterna" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                            
                            <!-- Operaciones -->
                            <div class="subsection">
                                <h3>2. Operaciones</h3>
                                <p class="subsection-intro">Actividades relacionadas con la transformación de insumos en el producto final.</p>
                                
                                <div class="form-group">
                                    <label for="descripcionOperaciones">Descripción actual <span class="required">*</span></label>
                                    <textarea id="descripcionOperaciones" name="descripcionOperaciones" class="form-control" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fortalezasOperaciones">Fortalezas identificadas</label>
                                    <textarea id="fortalezasOperaciones" name="fortalezasOperaciones" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="debilidadesOperaciones">Debilidades identificadas</label>
                                    <textarea id="debilidadesOperaciones" name="debilidadesOperaciones" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="valorDiferencialOperaciones">¿Genera valor diferencial? <span class="required">*</span></label>
                                    <select id="valorDiferencialOperaciones" name="valorDiferencialOperaciones" class="form-control" required>
                                        <option value="">Seleccionar...</option>
                                        <option value="si-alto">Sí, alto valor diferencial</option>
                                        <option value="si-medio">Sí, valor diferencial medio</option>
                                        <option value="si-bajo">Sí, bajo valor diferencial</option>
                                        <option value="no">No genera valor diferencial</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="mejorasOperaciones">Mejoras potenciales</label>
                                    <textarea id="mejorasOperaciones" name="mejorasOperaciones" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                            
                            <!-- Logística externa -->
                            <div class="subsection">
                                <h3>3. Logística externa</h3>
                                <p class="subsection-intro">Actividades relacionadas con el almacenamiento y distribución del producto a los compradores.</p>
                                
                                <div class="form-group">
                                    <label for="descripcionLogisticaExterna">Descripción actual <span class="required">*</span></label>
                                    <textarea id="descripcionLogisticaExterna" name="descripcionLogisticaExterna" class="form-control" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fortalezasLogisticaExterna">Fortalezas identificadas</label>
                                    <textarea id="fortalezasLogisticaExterna" name="fortalezasLogisticaExterna" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="debilidadesLogisticaExterna">Debilidades identificadas</label>
                                    <textarea id="debilidadesLogisticaExterna" name="debilidadesLogisticaExterna" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="valorDiferencialLogisticaExterna">¿Genera valor diferencial? <span class="required">*</span></label>
                                    <select id="valorDiferencialLogisticaExterna" name="valorDiferencialLogisticaExterna" class="form-control" required>
                                        <option value="">Seleccionar...</option>
                                        <option value="si-alto">Sí, alto valor diferencial</option>
                                        <option value="si-medio">Sí, valor diferencial medio</option>
                                        <option value="si-bajo">Sí, bajo valor diferencial</option>
                                        <option value="no">No genera valor diferencial</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="mejorasLogisticaExterna">Mejoras potenciales</label>
                                    <textarea id="mejorasLogisticaExterna" name="mejorasLogisticaExterna" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                            
                            <!-- Marketing y ventas -->
                            <div class="subsection">
                                <h3>4. Marketing y ventas</h3>
                                <p class="subsection-intro">Actividades relacionadas con proporcionar un medio por el cual los compradores puedan adquirir el producto e inducirlos a hacerlo.</p>
                                
                                <div class="form-group">
                                    <label for="descripcionMarketing">Descripción actual <span class="required">*</span></label>
                                    <textarea id="descripcionMarketing" name="descripcionMarketing" class="form-control" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fortalezasMarketing">Fortalezas identificadas</label>
                                    <textarea id="fortalezasMarketing" name="fortalezasMarketing" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="debilidadesMarketing">Debilidades identificadas</label>
                                    <textarea id="debilidadesMarketing" name="debilidadesMarketing" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="valorDiferencialMarketing">¿Genera valor diferencial? <span class="required">*</span></label>
                                    <select id="valorDiferencialMarketing" name="valorDiferencialMarketing" class="form-control" required>
                                        <option value="">Seleccionar...</option>
                                        <option value="si-alto">Sí, alto valor diferencial</option>
                                        <option value="si-medio">Sí, valor diferencial medio</option>
                                        <option value="si-bajo">Sí, bajo valor diferencial</option>
                                        <option value="no">No genera valor diferencial</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="mejorasMarketing">Mejoras potenciales</label>
                                    <textarea id="mejorasMarketing" name="mejorasMarketing" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                            
                            <!-- Servicio post-venta -->
                            <div class="subsection">
                                <h3>5. Servicio post-venta</h3>
                                <p class="subsection-intro">Actividades relacionadas con la prestación de servicios para mantener o realzar el valor del producto después de la venta.</p>
                                
                                <div class="form-group">
                                    <label for="descripcionServicio">Descripción actual <span class="required">*</span></label>
                                    <textarea id="descripcionServicio" name="descripcionServicio" class="form-control" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fortalezasServicio">Fortalezas identificadas</label>
                                    <textarea id="fortalezasServicio" name="fortalezasServicio" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="debilidadesServicio">Debilidades identificadas</label>
                                    <textarea id="debilidadesServicio" name="debilidadesServicio" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="valorDiferencialServicio">¿Genera valor diferencial? <span class="required">*</span></label>
                                    <select id="valorDiferencialServicio" name="valorDiferencialServicio" class="form-control" required>
                                        <option value="">Seleccionar...</option>
                                        <option value="si-alto">Sí, alto valor diferencial</option>
                                        <option value="si-medio">Sí, valor diferencial medio</option>
                                        <option value="si-bajo">Sí, bajo valor diferencial</option>
                                        <option value="no">No genera valor diferencial</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="mejorasServicio">Mejoras potenciales</label>
                                    <textarea id="mejorasServicio" name="mejorasServicio" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Actividades de Apoyo</h2>
                            <p class="section-intro">Las actividades de apoyo sustentan a las actividades primarias y se apoyan entre sí, proporcionando insumos comprados, tecnología, recursos humanos y varias funciones de toda la empresa.</p>
                            
                            <!-- Infraestructura de la empresa -->
                            <div class="subsection">
                                <h3>1. Infraestructura de la empresa</h3>
                                <p class="subsection-intro">Actividades que prestan apoyo a toda la cadena de valor, como planificación, finanzas, contabilidad, asuntos legales, etc.</p>
                                
                                <div class="form-group">
                                    <label for="descripcionInfraestructura">Descripción actual <span class="required">*</span></label>
                                    <textarea id="descripcionInfraestructura" name="descripcionInfraestructura" class="form-control" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fortalezasInfraestructura">Fortalezas identificadas</label>
                                    <textarea id="fortalezasInfraestructura" name="fortalezasInfraestructura" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="debilidadesInfraestructura">Debilidades identificadas</label>
                                    <textarea id="debilidadesInfraestructura" name="debilidadesInfraestructura" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="mejorasInfraestructura">Mejoras potenciales</label>
                                    <textarea id="mejorasInfraestructura" name="mejorasInfraestructura" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                            
                            <!-- Gestión de recursos humanos -->
                            <div class="subsection">
                                <h3>2. Gestión de recursos humanos</h3>
                                <p class="subsection-intro">Actividades relacionadas con la búsqueda, contratación, formación y desarrollo del personal.</p>
                                
                                <div class="form-group">
                                    <label for="descripcionRRHH">Descripción actual <span class="required">*</span></label>
                                    <textarea id="descripcionRRHH" name="descripcionRRHH" class="form-control" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fortalezasRRHH">Fortalezas identificadas</label>
                                    <textarea id="fortalezasRRHH" name="fortalezasRRHH" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="debilidadesRRHH">Debilidades identificadas</label>
                                    <textarea id="debilidadesRRHH" name="debilidadesRRHH" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="mejorasRRHH">Mejoras potenciales</label>
                                    <textarea id="mejorasRRHH" name="mejorasRRHH" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                            
                            <!-- Desarrollo tecnológico -->
                            <div class="subsection">
                                <h3>3. Desarrollo tecnológico</h3>
                                <p class="subsection-intro">Actividades relacionadas con el diseño del producto, así como con la mejora de los procesos de producción y servicio.</p>
                                
                                <div class="form-group">
                                    <label for="descripcionTecnologia">Descripción actual <span class="required">*</span></label>
                                    <textarea id="descripcionTecnologia" name="descripcionTecnologia" class="form-control" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fortalezasTecnologia">Fortalezas identificadas</label>
                                    <textarea id="fortalezasTecnologia" name="fortalezasTecnologia" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="debilidadesTecnologia">Debilidades identificadas</label>
                                    <textarea id="debilidadesTecnologia" name="debilidadesTecnologia" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="mejorasTecnologia">Mejoras potenciales</label>
                                    <textarea id="mejorasTecnologia" name="mejorasTecnologia" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                            
                            <!-- Aprovisionamiento -->
                            <div class="subsection">
                                <h3>4. Aprovisionamiento</h3>
                                <p class="subsection-intro">Actividades relacionadas con la compra de insumos utilizados en la cadena de valor de la empresa.</p>
                                
                                <div class="form-group">
                                    <label for="descripcionAprovisionamiento">Descripción actual <span class="required">*</span></label>
                                    <textarea id="descripcionAprovisionamiento" name="descripcionAprovisionamiento" class="form-control" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fortalezasAprovisionamiento">Fortalezas identificadas</label>
                                    <textarea id="fortalezasAprovisionamiento" name="fortalezasAprovisionamiento" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="debilidadesAprovisionamiento">Debilidades identificadas</label>
                                    <textarea id="debilidadesAprovisionamiento" name="debilidadesAprovisionamiento" class="form-control" rows="2"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="mejorasAprovisionamiento">Mejoras potenciales</label>
                                    <textarea id="mejorasAprovisionamiento" name="mejorasAprovisionamiento" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Conclusiones del Análisis de la Cadena de Valor</h2>
                            
                            <div class="form-group">
                                <label for="actividadesClaveValor">Actividades clave que generan mayor valor <span class="required">*</span></label>
                                <textarea id="actividadesClaveValor" name="actividadesClaveValor" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Identifique las actividades que generan mayor valor para la empresa y sus clientes.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="actividadesMejorar">Actividades a mejorar prioritariamente <span class="required">*</span></label>
                                <textarea id="actividadesMejorar" name="actividadesMejorar" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Identifique las actividades que requieren mejoras urgentes para aumentar el valor generado.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="ventajasCompetitivas">Ventajas competitivas identificadas <span class="required">*</span></label>
                                <textarea id="ventajasCompetitivas" name="ventajasCompetitivas" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Describa las ventajas competitivas que se derivan del análisis de la cadena de valor.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="estrategiasRecomendadas">Estrategias recomendadas <span class="required">*</span></label>
                                <textarea id="estrategiasRecomendadas" name="estrategiasRecomendadas" class="form-control" rows="4" required></textarea>
                                <small class="form-text">Basado en el análisis, ¿qué estrategias recomienda para mejorar la cadena de valor de la empresa?</small>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="button" class="btn save-button"><i class="fas fa-save"></i> Guardar</button>
                            <button type="button" class="btn reset-button"><i class="fas fa-undo"></i> Restablecer</button>
                            <div class="navigation-buttons">
                                <a href="porter.jsp" class="btn prev-button"><i class="fas fa-arrow-left"></i> Anterior: 5 Fuerzas de Porter</a>
                                <a href="matriz-participacion.jsp" class="btn next-button"><i class="fas fa-arrow-right"></i> Siguiente: Matriz de Participación</a>
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
</body>
</html>