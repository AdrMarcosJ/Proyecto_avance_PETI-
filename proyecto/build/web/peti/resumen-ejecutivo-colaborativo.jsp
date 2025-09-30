<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, entidad.ClsEPeti"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.*"%>

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
    
    // Variables para el resumen ejecutivo
    String introduccion = "";
    String analisisSituacion = "";
    String estrategiasClaves = "";
    String objetivosGenerales = "";
    String planImplementacion = "";
    String recursosRequeridos = "";
    String cronograma = "";
    String indicadoresExito = "";
    String riesgosDesafios = "";
    String conclusionesRecomendaciones = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevaIntroduccion = request.getParameter("introduccion");
        String nuevoAnalisis = request.getParameter("analisis");
        String nuevasEstrategias = request.getParameter("estrategias");
        String nuevosObjetivos = request.getParameter("objetivos");
        String nuevoPlan = request.getParameter("plan");
        String nuevosRecursos = request.getParameter("recursos");
        String nuevoCronograma = request.getParameter("cronograma");
        String nuevosIndicadores = request.getParameter("indicadores");
        String nuevosRiesgos = request.getParameter("riesgos");
        String nuevasConclusiones = request.getParameter("conclusiones");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevaIntroduccion != null && !nuevaIntroduccion.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "introduccion", nuevaIntroduccion.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoAnalisis != null && !nuevoAnalisis.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "analisis", nuevoAnalisis.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevasEstrategias != null && !nuevasEstrategias.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "estrategias", nuevasEstrategias.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosObjetivos != null && !nuevosObjetivos.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "objetivos", nuevosObjetivos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoPlan != null && !nuevoPlan.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "plan", nuevoPlan.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosRecursos != null && !nuevosRecursos.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "recursos", nuevosRecursos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoCronograma != null && !nuevoCronograma.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "cronograma", nuevoCronograma.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosIndicadores != null && !nuevosIndicadores.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "indicadores", nuevosIndicadores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosRiesgos != null && !nuevosRiesgos.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "riesgos", nuevosRiesgos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevasConclusiones != null && !nuevasConclusiones.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "resumen_ejecutivo", "conclusiones", nuevasConclusiones.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Resumen Ejecutivo guardado exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar algunos datos";
                tipoMensaje = "error";
            }
        } catch (Exception e) {
            mensaje = "Error interno: " + e.getMessage();
            tipoMensaje = "error";
        }
    }
    
    // Cargar datos existentes
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            Map<String, String> datosResumen = negocioPeti.obtenerDatosSeccion(grupoId, "resumen_ejecutivo");
            
            introduccion = datosResumen.getOrDefault("introduccion", "");
            analisisSituacion = datosResumen.getOrDefault("analisis", "");
            estrategiasClaves = datosResumen.getOrDefault("estrategias", "");
            objetivosGenerales = datosResumen.getOrDefault("objetivos", "");
            planImplementacion = datosResumen.getOrDefault("plan", "");
            recursosRequeridos = datosResumen.getOrDefault("recursos", "");
            cronograma = datosResumen.getOrDefault("cronograma", "");
            indicadoresExito = datosResumen.getOrDefault("indicadores", "");
            riesgosDesafios = datosResumen.getOrDefault("riesgos", "");
            conclusionesRecomendaciones = datosResumen.getOrDefault("conclusiones", "");
        } catch (Exception e) {
            //System.err.println("Error al cargar datos: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resumen Ejecutivo - PETI Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #667eea 100%);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 40% 40%, rgba(120, 119, 198, 0.2) 0%, transparent 50%);
            pointer-events: none;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 20px;
            position: relative;
            z-index: 1;
        }

        .header {
            background: linear-gradient(145deg, rgba(255, 255, 255, 0.25), rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 35px 40px;
            border-radius: 25px;
            margin-bottom: 40px;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.15),
                inset 0 1px 0 rgba(255, 255, 255, 0.4);
            position: relative;
            overflow: hidden;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 25px;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
            border-radius: 25px 25px 0 0;
        }

        .header h1 {
            color: white;
            font-size: 2.8rem;
            font-weight: 700;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            display: flex;
            align-items: center;
            gap: 20px;
            letter-spacing: -0.5px;
        }

        .header h1 i {
            color: #f093fb;
            filter: drop-shadow(0 2px 10px rgba(240, 147, 251, 0.5));
        }

        .header p {
            color: rgba(255, 255, 255, 0.95);
            font-size: 1.2rem;
            font-weight: 500;
            margin-top: 12px;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        .header p strong {
            color: #f093fb;
            font-weight: 700;
        }

        .nav-buttons {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 16px 28px;
            border: none;
            border-radius: 15px;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            position: relative;
            overflow: hidden;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.6s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #667eea 0%, #2a5298 100%);
            color: white;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.25);
        }

        .btn:active {
            transform: translateY(-1px) scale(0.98);
        }

        .content {
            background: linear-gradient(145deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0.05));
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 25px;
            padding: 40px;
            box-shadow: 
                0 25px 70px rgba(0, 0, 0, 0.15),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
            margin-bottom: 30px;
        }

        .alert {
            padding: 20px 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            font-weight: 600;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: slideInDown 0.5s ease;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 172, 132, 0.9), rgba(29, 209, 161, 0.8));
            color: white;
            box-shadow: 0 10px 30px rgba(16, 172, 132, 0.3);
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(231, 76, 60, 0.9), rgba(192, 57, 43, 0.8));
            color: white;
            box-shadow: 0 10px 30px rgba(231, 76, 60, 0.3);
        }

        .executive-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .summary-section {
            background: linear-gradient(145deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            padding: 35px;
            border-radius: 20px;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }

        .summary-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            border-radius: 20px 20px 0 0;
        }

        .summary-section:hover {
            transform: translateY(-5px);
            box-shadow: 
                0 20px 50px rgba(0, 0, 0, 0.2),
                inset 0 1px 0 rgba(255, 255, 255, 0.4);
            border-color: rgba(255, 255, 255, 0.4);
        }

        .section-title {
            color: white;
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
        }

        .section-title i {
            font-size: 1.8rem;
            filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.3));
        }

        .section-subtitle {
            color: rgba(255, 255, 255, 0.85);
            font-size: 0.95rem;
            margin-bottom: 15px;
            font-style: italic;
        }

        /* Colores específicos para cada sección */
        .introduccion-section::before { background: linear-gradient(90deg, #3498db, #2980b9); }
        .introduccion-section .section-title i { color: #3498db; }

        .analisis-section::before { background: linear-gradient(90deg, #27ae60, #2ecc71); }
        .analisis-section .section-title i { color: #27ae60; }

        .estrategias-section::before { background: linear-gradient(90deg, #9b59b6, #8e44ad); }
        .estrategias-section .section-title i { color: #9b59b6; }

        .objetivos-section::before { background: linear-gradient(90deg, #e74c3c, #c0392b); }
        .objetivos-section .section-title i { color: #e74c3c; }

        .plan-section::before { background: linear-gradient(90deg, #f39c12, #e67e22); }
        .plan-section .section-title i { color: #f39c12; }

        .recursos-section::before { background: linear-gradient(90deg, #1abc9c, #16a085); }
        .recursos-section .section-title i { color: #1abc9c; }

        .cronograma-section::before { background: linear-gradient(90deg, #34495e, #2c3e50); }
        .cronograma-section .section-title i { color: #34495e; }

        .indicadores-section::before { background: linear-gradient(90deg, #e91e63, #ad1457); }
        .indicadores-section .section-title i { color: #e91e63; }

        .riesgos-section::before { background: linear-gradient(90deg, #ff5722, #d84315); }
        .riesgos-section .section-title i { color: #ff5722; }

        .conclusiones-section::before { background: linear-gradient(90deg, #607d8b, #455a64); }
        .conclusiones-section .section-title i { color: #607d8b; }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            color: rgba(255, 255, 255, 0.95);
            font-weight: 600;
            font-size: 1rem;
        }

        .form-group textarea {
            width: 100%;
            padding: 20px;
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            color: white;
            font-size: 16px;
            min-height: 140px;
            resize: vertical;
            transition: all 0.3s ease;
            font-family: inherit;
            line-height: 1.6;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: rgba(240, 147, 251, 0.8);
            box-shadow: 
                0 0 0 3px rgba(240, 147, 251, 0.2),
                0 8px 25px rgba(0, 0, 0, 0.15);
            background: rgba(255, 255, 255, 0.15);
        }

        .form-group textarea::placeholder {
            color: rgba(255, 255, 255, 0.6);
            font-style: italic;
        }

        .section-examples {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.7);
            margin-top: 8px;
            padding: 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            font-style: italic;
            line-height: 1.4;
        }

        .tips-box {
            background: linear-gradient(145deg, rgba(76, 175, 80, 0.2), rgba(76, 175, 80, 0.1));
            border: 2px solid rgba(76, 175, 80, 0.4);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            backdrop-filter: blur(15px);
        }

        .tips-box h4 {
            color: #4caf50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.3rem;
        }

        .tips-box p {
            color: rgba(255, 255, 255, 0.9);
            line-height: 1.6;
        }

        .preview-section {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            padding: 25px;
            margin-top: 30px;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .preview-section h3 {
            color: white;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .document-preview {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            font-family: 'Times New Roman', serif;
            line-height: 1.8;
            color: #333;
        }

        .document-title {
            text-align: center;
            color: #1e3c72;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 30px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .document-section {
            margin-bottom: 25px;
        }

        .document-section h4 {
            color: #1e3c72;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 12px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 8px;
        }

        .document-section p {
            color: #555;
            font-size: 1rem;
            text-align: justify;
        }

        .page-break {
            margin: 30px 0;
            border-top: 2px dashed #ddd;
            padding-top: 20px;
        }

        @keyframes slideInDown {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 20px 15px;
            }
            
            .header {
                padding: 25px 20px;
                flex-direction: column;
                text-align: center;
            }
            
            .header h1 {
                font-size: 2.2rem;
            }
            
            .nav-buttons {
                width: 100%;
                justify-content: center;
            }
            
            .executive-summary {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .content {
                padding: 25px 20px;
            }

            .document-preview {
                padding: 25px;
            }
        }

        @media (max-width: 480px) {
            .header h1 {
                font-size: 1.8rem;
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
            
            .btn {
                padding: 14px 20px;
                font-size: 0.9rem;
                width: 100%;
                justify-content: center;
            }
            
            .nav-buttons {
                flex-direction: column;
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <i class="fas fa-file-alt"></i> Resumen Ejecutivo del PETI
                </h1>
                <p>Grupo: <strong><%= grupoActual %></strong>
                <% if ("admin".equals(rolUsuario)) { %>
                    <span style="color: #f093fb;">👑 Admin</span>
                <% } %>
                </p>
            </div>
            <div class="nav-buttons">
                <a href="dashboard.jsp" class="btn btn-primary">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="../menuprincipal.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Menú Principal
                </a>
            </div>
        </div>

        <div class="content">
            <% if (!mensaje.isEmpty()) { %>
                <div class="alert alert-<%= tipoMensaje %>">
                    <i class="fas fa-<%= "success".equals(tipoMensaje) ? "check-circle" : "exclamation-triangle" %>"></i>
                    <%= mensaje %>
                </div>
            <% } %>

            <% if (!modoColaborativo) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Error:</strong> Debes estar en un grupo para acceder a esta página.
                </div>
            <% } else { %>

            <div class="tips-box">
                <h4><i class="fas fa-lightbulb"></i> ¿Qué es el Resumen Ejecutivo?</h4>
                <p style="margin-bottom: 15px;">
                    El Resumen Ejecutivo es una síntesis concisa del Plan Estratégico de Tecnologías de Información (PETI) 
                    que presenta los elementos más importantes de manera clara y ejecutiva para la toma de decisiones.
                </p>
                <div style="font-size: 0.95rem;">
                    <strong>Objetivo:</strong> Proporcionar una visión panorámica del PETI que permita a directivos y stakeholders 
                    comprender rápidamente las estrategias, objetivos, recursos y cronograma del plan.
                </div>
            </div>

            <form method="post" action="">
                <div class="executive-summary">
                    <!-- 1. Introducción -->
                    <div class="summary-section introduccion-section">
                        <h3 class="section-title">
                            <i class="fas fa-flag"></i>
                            1. Introducción
                        </h3>
                        <div class="form-group">
                            <textarea id="introduccion" name="introduccion" 
                                      placeholder="Describe el contexto organizacional, la necesidad del PETI, su propósito estratégico, justificación del plan, alcance y período de vigencia..."
                                      ><%= introduccion %></textarea>
                        </div>
                    </div>

                    <!-- 2. Análisis de Situación -->
                    <div class="summary-section analisis-section">
                        <h3 class="section-title">
                            <i class="fas fa-search"></i>
                            2. Análisis de Situación
                        </h3>
                        <div class="form-group">
                            <textarea id="analisis" name="analisis" 
                                      placeholder="Resume el diagnóstico interno y externo: análisis DOFA, factores PEST clave, fuerzas de Porter, situación tecnológica actual..."
                                      ><%= analisisSituacion %></textarea>
                        </div>
                    </div>

                    <!-- 3. Estrategias Clave -->
                    <div class="summary-section estrategias-section">
                        <h3 class="section-title">
                            <i class="fas fa-chess"></i>
                            3. Estrategias Clave
                        </h3>
                        <div class="section-subtitle">Estrategias definidas para el PETI</div>
                        <div class="form-group">
                            <label for="estrategias">Estrategias Principales:</label>
                            <textarea id="estrategias" name="estrategias" 
                                      placeholder="Resume las estrategias competitivas, de crecimiento, funcionales y corporativas definidas..."
                                      ><%= estrategiasClaves %></textarea>
                            <div class="section-examples">
                                Incluye: Estrategia competitiva, estrategias de crecimiento, estrategias funcionales, ventaja competitiva
                            </div>
                        </div>
                    </div>

                    <!-- 4. Objetivos Generales -->
                    <div class="summary-section objetivos-section">
                        <h3 class="section-title">
                            <i class="fas fa-bullseye"></i>
                            4. Objetivos Generales
                        </h3>
                        <div class="section-subtitle">Objetivos estratégicos del PETI</div>
                        <div class="form-group">
                            <label for="objetivos">Objetivos Estratégicos:</label>
                            <textarea id="objetivos" name="objetivos" 
                                      ivos" 
                                      placeholder="Resume el objetivo general y los objetivos específicos más importantes del PETI..."
                                      ><%= objetivosGenerales %></textarea>
                            <div class="section-examples">
                                Incluye: Objetivo general, objetivos específicos principales, metas cuantificables, indicadores clave
                            </div>
                        </div>
                    </div>

                    <!-- 5. Plan de Implementación -->
                    <div class="summary-section plan-section">
                        <h3 class="section-title">
                            <i class="fas fa-tasks"></i>
                            5. Plan de Implementación
                        </h3>
                        <div class="section-subtitle">Estrategia de ejecución del PETI</div>
                        <div class="form-group">
                            <label for="plan">Plan de Implementación:</label>
                            <textarea id="plan" name="plan" 
                                      placeholder="Describe el enfoque de implementación, fases principales, metodología a seguir..."
                                      ><%= planImplementacion %></textarea>
                            <div class="section-examples">
                                Incluye: Fases de implementación, metodología, estructura de gestión, matriz de responsabilidades
                            </div>
                        </div>
                    </div>

                    <!-- 6. Recursos Requeridos -->
                    <div class="summary-section recursos-section">
                        <h3 class="section-title">
                            <i class="fas fa-coins"></i>
                            6. Recursos Requeridos
                        </h3>
                        <div class="section-subtitle">Inversión y recursos necesarios</div>
                        <div class="form-group">
                            <label for="recursos">Recursos y Presupuesto:</label>
                            <textarea id="recursos" name="recursos" 
                                      placeholder="Describe los recursos humanos, tecnológicos y financieros requeridos..."
                                      ><%= recursosRequeridos %></textarea>
                            <div class="section-examples">
                                Incluye: Presupuesto estimado, recursos humanos, tecnología requerida, infraestructura necesaria
                            </div>
                        </div>
                    </div>

                    <!-- 7. Cronograma -->
                    <div class="summary-section cronograma-section">
                        <h3 class="section-title">
                            <i class="fas fa-calendar-alt"></i>
                            7. Cronograma
                        </h3>
                        <div class="section-subtitle">Tiempos y fechas clave</div>
                        <div class="form-group">
                            <label for="cronograma">Cronograma General:</label>
                            <textarea id="cronograma" name="cronograma" 
                                      placeholder="Define el cronograma general, hitos principales y fechas clave del PETI..."
                                      ><%= cronograma %></textarea>
                            <div class="section-examples">
                                Incluye: Duración total, fases temporales, hitos clave, fechas de inicio y fin, puntos de control
                            </div>
                        </div>
                    </div>

                    <!-- 8. Indicadores de Éxito -->
                    <div class="summary-section indicadores-section">
                        <h3 class="section-title">
                            <i class="fas fa-chart-line"></i>
                            8. Indicadores de Éxito
                        </h3>
                        <div class="section-subtitle">Métricas y KPIs del PETI</div>
                        <div class="form-group">
                            <label for="indicadores">Indicadores y Métricas:</label>
                            <textarea id="indicadores" name="indicadores" 
                                      placeholder="Define los indicadores clave de desempeño (KPIs) para medir el éxito del PETI..."
                                      ><%= indicadoresExito %></textarea>
                            <div class="section-examples">
                                Incluye: KPIs principales, métricas de seguimiento, metas cuantificables, frecuencia de medición
                            </div>
                        </div>
                    </div>

                    <!-- 9. Riesgos y Desafíos -->
                    <div class="summary-section riesgos-section">
                        <h3 class="section-title">
                            <i class="fas fa-exclamation-triangle"></i>
                            9. Riesgos y Desafíos
                        </h3>
                        <div class="section-subtitle">Identificación y mitigación de riesgos</div>
                        <div class="form-group">
                            <label for="riesgos">Principales Riesgos y Desafíos:</label>
                            <textarea id="riesgos" name="riesgos" 
                                      placeholder="Identifica los principales riesgos y desafíos, junto con estrategias de mitigación..."
                                      ><%= riesgosDesafios %></textarea>
                            <div class="section-examples">
                                Incluye: Riesgos técnicos, financieros, organizacionales, planes de contingencia, estrategias de mitigación
                            </div>
                        </div>
                    </div>

                    <!-- 10. Conclusiones y Recomendaciones -->
                    <div class="summary-section conclusiones-section">
                        <h3 class="section-title">
                            <i class="fas fa-check-circle"></i>
                            10. Conclusiones
                        </h3>
                        <div class="section-subtitle">Reflexiones finales y recomendaciones</div>
                        <div class="form-group">
                            <label for="conclusiones">Conclusiones y Recomendaciones:</label>
                            <textarea id="conclusiones" name="conclusiones" 
                                      placeholder="Resume las principales conclusiones del PETI y proporciona recomendaciones finales..."
                                      ><%= conclusionesRecomendaciones %></textarea>
                            <div class="section-examples">
                                Incluye: Conclusiones principales, recomendaciones clave, beneficios esperados, próximos pasos
                            </div>
                        </div>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn btn-primary" style="padding: 18px 40px; font-size: 1.1rem;">
                        <i class="fas fa-save"></i> Guardar Resumen Ejecutivo
                    </button>
                </div>
            </form>

            <!-- Vista Previa del Documento -->
            <div class="preview-section">
                <h3><i class="fas fa-file-alt"></i> Vista Previa del Documento Ejecutivo</h3>
                <div class="document-preview" id="documentPreview">
                    <div class="document-title">RESUMEN EJECUTIVO<br>PLAN ESTRATÉGICO DE TECNOLOGÍAS DE INFORMACIÓN</div>
                    
                    <div class="document-section">
                        <h4>1. INTRODUCCIÓN</h4>
                        <p id="preview-introduccion">Contenido no definido</p>
                    </div>
                    
                    <div class="document-section">
                        <h4>2. ANÁLISIS DE SITUACIÓN</h4>
                        <p id="preview-analisis">Contenido no definido</p>
                    </div>
                    
                    <div class="document-section">
                        <h4>3. ESTRATEGIAS CLAVE</h4>
                        <p id="preview-estrategias">Contenido no definido</p>
                    </div>
                    
                    <div class="document-section">
                        <h4>4. OBJETIVOS GENERALES</h4>
                        <p id="preview-objetivos">Contenido no definido</p>
                    </div>
                    
                    <div class="page-break"></div>
                    
                    <div class="document-section">
                        <h4>5. PLAN DE IMPLEMENTACIÓN</h4>
                        <p id="preview-plan">Contenido no definido</p>
                    </div>
                    
                    <div class="document-section">
                        <h4>6. RECURSOS REQUERIDOS</h4>
                        <p id="preview-recursos">Contenido no definido</p>
                    </div>
                    
                    <div class="document-section">
                        <h4>7. CRONOGRAMA</h4>
                        <p id="preview-cronograma">Contenido no definido</p>
                    </div>
                    
                    <div class="document-section">
                        <h4>8. INDICADORES DE ÉXITO</h4>
                        <p id="preview-indicadores">Contenido no definido</p>
                    </div>
                    
                    <div class="document-section">
                        <h4>9. RIESGOS Y DESAFÍOS</h4>
                        <p id="preview-riesgos">Contenido no definido</p>
                    </div>
                    
                    <div class="document-section">
                        <h4>10. CONCLUSIONES Y RECOMENDACIONES</h4>
                        <p id="preview-conclusiones">Contenido no definido</p>
                    </div>
                </div>
            </div>

            <div style="background: linear-gradient(145deg, rgba(76, 175, 80, 0.2), rgba(76, 175, 80, 0.1)); padding: 20px; border-radius: 12px; margin-top: 25px; border: 1px solid rgba(76, 175, 80, 0.3);">
                <p style="color: rgba(255, 255, 255, 0.95); margin: 0; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-info-circle"></i> 
                    <strong>Modo Colaborativo:</strong> El Resumen Ejecutivo se guarda automáticamente y es visible 
                    para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                </p>
            </div>

            <% } %>
        </div>
    </div>

    <script>
        function actualizarPreview() {
            const secciones = [
                'introduccion', 'analisis', 'estrategias', 'objetivos', 'plan', 
                'recursos', 'cronograma', 'indicadores', 'riesgos', 'conclusiones'
            ];
            
            secciones.forEach(seccion => {
                const elemento = document.getElementById(seccion);
                const preview = document.getElementById(`preview-${seccion}`);
                
                if (elemento && preview) {
                    const texto = elemento.value.trim();
                    preview.textContent = texto || 'Contenido no definido';
                }
            });
        }

        // Agregar listeners
        document.addEventListener('DOMContentLoaded', function() {
            const campos = ['introduccion', 'analisis', 'estrategias', 'objetivos', 'plan', 'recursos', 'cronograma', 'indicadores', 'riesgos', 'conclusiones'];
            campos.forEach(id => {
                const elemento = document.getElementById(id);
                if (elemento) {
                    elemento.addEventListener('input', actualizarPreview);
                }
            });
            
            // Actualizar preview inicial
            actualizarPreview();
        });

        // Auto-refresh cada 15 segundos
        setInterval(function() {
            const inputs = document.querySelectorAll('textarea');
            let hayChanged = false;
            inputs.forEach(input => {
                if (input.dataset.changed === 'true') {
                    hayChanged = true;
                }
            });
            
            if (!hayChanged) {
                location.reload();
            }
        }, 15000);

        // Marcar como cambiado
        document.querySelectorAll('textarea').forEach(element => {
            element.addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
        });
    </script>
</body>
</html> 