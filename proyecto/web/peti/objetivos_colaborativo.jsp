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
    
    // Variables para los datos
    String objetivoGeneral = "";
    String objetivo1 = "";
    String objetivo2 = "";
    String objetivo3 = "";
    String objetivo4 = "";
    String indicadores = "";
    String metas = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevoObjetivoGeneral = request.getParameter("objetivo_general");
        String nuevosIndicadores = request.getParameter("indicadores");
        String nuevasMetas = request.getParameter("metas");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            // Guardar objetivo general
            if (nuevoObjetivoGeneral != null && !nuevoObjetivoGeneral.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "objetivos", "objetivo_general", nuevoObjetivoGeneral.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            // Guardar objetivos específicos dinámicamente
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                if (paramName.startsWith("objetivo") && !paramName.equals("objetivo_general")) {
                    String valor = request.getParameter(paramName);
                    if (valor != null && !valor.trim().isEmpty()) {
                        ClsEPeti dato = new ClsEPeti(grupoId, "objetivos", paramName, valor.trim(), usuarioId);
                        exito = exito && negocioPeti.guardarDato(dato);
                    }
                }
            }
            
            // Guardar indicadores y metas
            if (nuevosIndicadores != null && !nuevosIndicadores.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "objetivos", "indicadores", nuevosIndicadores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevasMetas != null && !nuevasMetas.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "objetivos", "metas", nuevasMetas.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Objetivos estratégicos guardados exitosamente";
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
    Map<String, String> todosLosObjetivos = new java.util.HashMap<>();
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            Map<String, String> datosObjetivos = negocioPeti.obtenerDatosSeccion(grupoId, "objetivos");
            
            objetivoGeneral = datosObjetivos.getOrDefault("objetivo_general", "");
            objetivo1 = datosObjetivos.getOrDefault("objetivo1", "");
            objetivo2 = datosObjetivos.getOrDefault("objetivo2", "");
            objetivo3 = datosObjetivos.getOrDefault("objetivo3", "");
            objetivo4 = datosObjetivos.getOrDefault("objetivo4", "");
            indicadores = datosObjetivos.getOrDefault("indicadores", "");
            metas = datosObjetivos.getOrDefault("metas", "");
            
            // Obtener todos los objetivos específicos adicionales
            todosLosObjetivos.putAll(datosObjetivos);
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
    <title>Objetivos Estratégicos - PETI Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            z-index: -1;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header h1 {
            color: #2c3e50;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: 700;
        }

        .objectives-logo {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            padding: 12px 16px;
            border-radius: 12px;
            font-weight: bold;
            font-size: 18px;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .grupo-info {
            font-size: 16px;
            color: #7f8c8d;
            font-weight: 500;
        }

        .nav-buttons {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(52, 152, 219, 0.4);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.9);
            color: #2c3e50;
            border: 1px solid rgba(52, 152, 219, 0.2);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 1);
            transform: translateY(-1px);
        }

        .content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 35px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .alert {
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            backdrop-filter: blur(20px);
        }

        .alert-success {
            background: rgba(39, 174, 96, 0.9);
            color: white;
            border: 1px solid rgba(39, 174, 96, 0.3);
        }

        .alert-error {
            background: rgba(231, 76, 60, 0.9);
            color: white;
            border: 1px solid rgba(231, 76, 60, 0.3);
        }

        .modo-info {
            background: rgba(52, 152, 219, 0.1);
            border: 1px solid rgba(52, 152, 219, 0.2);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
            color: #2c3e50;
        }

        .objetivo-principal {
            background: rgba(52, 152, 219, 0.1);
            border: 2px solid rgba(52, 152, 219, 0.3);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        .objetivo-principal:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(52, 152, 219, 0.2);
        }

        .objetivo-principal h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .objetivos-especificos {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .objetivo-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border: 2px solid rgba(52, 152, 219, 0.2);
            border-radius: 15px;
            padding: 25px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .objetivo-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #3498db 0%, #2980b9 100%);
        }

        .objetivo-card:hover {
            transform: translateY(-5px);
            border-color: rgba(52, 152, 219, 0.4);
            box-shadow: 0 15px 40px rgba(52, 152, 219, 0.15);
        }

        .objetivo-card h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
        }
        .card-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            color: #2c3e50;
            font-weight: 600;
            font-size: 16px;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid rgba(52, 152, 219, 0.2);
            border-radius: 12px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
            line-height: 1.6;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background: rgba(255, 255, 255, 1);
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #bdc3c7;
        }

        .btn-save {
            background: linear-gradient(135deg, #27ae60 0%, #16a085 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
            box-shadow: 0 4px 15px rgba(39, 174, 96, 0.3);
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(39, 174, 96, 0.4);
        }

        .preview-section {
            background: rgba(248, 249, 250, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px;
            margin-top: 25px;
            border: 1px solid rgba(52, 152, 219, 0.1);
        }

        .preview-section h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .objetivo-preview {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 15px;
            border-left: 4px solid #3498db;
            transition: all 0.3s ease;
        }

        .objetivo-preview:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.1);
        }

        .objetivo-preview h4 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .objetivo-preview p {
            color: #5a6c7d;
            line-height: 1.6;
        }

        .tips-box {
            background: rgba(39, 174, 96, 0.1);
            border: 1px solid rgba(39, 174, 96, 0.2);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .tips-box h4 {
            color: #27ae60;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 18px;
        }

        .tips-box ul {
            list-style: none;
            padding: 0;
        }

        .tips-box li {
            color: #2c3e50;
            margin-bottom: 8px;
            padding-left: 20px;
            position: relative;
        }

        .tips-box li::before {
            content: '✓';
            position: absolute;
            left: 0;
            color: #27ae60;
            font-weight: bold;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-remove {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            box-shadow: 0 2px 10px rgba(231, 76, 60, 0.3);
        }

        .btn-remove:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.4);
        }

        .objetivo-card {
            position: relative;
        }

        .objetivo-card.removing {
            animation: fadeOut 0.3s ease;
        }

        @keyframes fadeOut {
            from { opacity: 1; transform: translateY(0); }
            to { opacity: 0; transform: translateY(-20px); }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .objetivo-card.adding {
            animation: fadeIn 0.3s ease;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .objetivos-especificos {
                grid-template-columns: 1fr;
            }
            
            .nav-buttons {
                flex-wrap: wrap;
                justify-content: center;
            }
        }
        </style>
    </head>

<body>
    <div class="container">
        <div class="header">
            <h1>
                <div class="objectives-logo">OBJ</div>
                Objetivos Estratégicos
            </h1>
            <% if (modoColaborativo) { %>
                <div class="grupo-info">
                    <div><strong>Grupo:</strong> <%= grupoActual %></div>
                    <div><strong>Usuario:</strong> <%= usuario %> (<%= rolUsuario %>)</div>
                </div>
            <% } %>
            <div class="nav-buttons">
                <a href="dashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Dashboard
                </a>
                <a href="../menuprincipal.jsp" class="btn btn-primary">
                    <i class="fas fa-home"></i> Menú Principal
                </a>
            </div>
        </div>
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="../menuprincipal.jsp" class="btn btn-primary">
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
                <div class="alert" style="background: #fff3cd; border: 1px solid #ffeaa7; color: #856404;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Error:</strong> Debes estar en un grupo para acceder a esta página.
                    <a href="../menuprincipal.jsp" style="color: #856404; text-decoration: underline;">Ir al menú principal</a>
                </div>
            <% } else { %>

            <div class="tips-box">
                <h4><i class="fas fa-lightbulb"></i> Guía para definir Objetivos Estratégicos</h4>
                <ul>
                    <li><strong>SMART:</strong> Específicos, Medibles, Alcanzables, Relevantes y con Tiempo definido</li>
                    <li><strong>Alineados:</strong> Deben conectar con la misión y visión de la empresa</li>
                    <li><strong>Realistas:</strong> Ambiciosos pero factibles con los recursos disponibles</li>
                    <li><strong>Medibles:</strong> Incluir indicadores que permitan evaluar el progreso</li>
                </ul>
            </div>

            <form method="post" action="" onsubmit="return sincronizarTodosLosCampos()">
                <!-- Campos hidden para preservar objetivos dinámicos -->
                <div id="hiddenFields">
                    <% 
                    // Generar campos hidden para objetivos adicionales existentes
                    if (modoColaborativo && todosLosObjetivos != null) {
                        for (String key : todosLosObjetivos.keySet()) {
                            if (key.startsWith("objetivo") && !key.equals("objetivo_general") && 
                                !key.equals("objetivo1") && !key.equals("objetivo2") && 
                                !key.equals("objetivo3") && !key.equals("objetivo4")) {
                                String valor = todosLosObjetivos.get(key);
                                if (valor != null && !valor.trim().isEmpty()) {
                    %>
                                    <input type="hidden" name="<%= key %>" value="<%= valor.replace("\"", "&quot;") %>" />
                    <%
                                }
                            }
                        }
                    }
                    %>
                </div>
                
                <!-- Objetivo General -->
                <div class="objetivo-principal">
                    <div class="form-group">
                        <label for="objetivo_general">
                            <i class="fas fa-bullseye"></i> Objetivo General
                        </label>
                        <textarea id="objetivo_general" name="objetivo_general" 
                                  placeholder="Define el objetivo principal que guiará toda la estrategia de la empresa..."
                                  style="min-height: 100px;"><%= objetivoGeneral %></textarea>
                    </div>
                </div>

                <!-- Objetivos Específicos -->
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h3 style="margin: 0; color: #2c3e50;">
                        <i class="fas fa-list-ol"></i> Objetivos Específicos
                    </h3>
                    <button type="button" id="btnAgregarObjetivo" class="btn btn-secondary" style="padding: 8px 16px; font-size: 14px;">
                        <i class="fas fa-plus"></i> Agregar Objetivo
                    </button>
                </div>
                
                <div class="objetivos-especificos" id="objetivosContainer">
                    <div class="objetivo-card">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                            <h3>
                                <div class="card-icon">
                                    <i class="fas fa-flag"></i>
                                </div>
                                Objetivo Específico 1
                            </h3>
                        </div>
                        <div class="form-group">
                            <input type="text" id="objetivo1" name="objetivo1" 
                                   placeholder="Ej: Incrementar las ventas en un 25%"
                                   value="<%= objetivo1 %>"
                                   onkeyup="actualizarPreview()">
                        </div>
                    </div>

                    <div class="objetivo-card">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                            <h3>
                                <div class="card-icon">
                                    <i class="fas fa-flag"></i>
                                </div>
                                Objetivo Específico 2
                            </h3>
                        </div>
                        <div class="form-group">
                            <input type="text" id="objetivo2" name="objetivo2" 
                                   placeholder="Ej: Mejorar la satisfacción del cliente al 90%"
                                   value="<%= objetivo2 %>"
                                   onkeyup="actualizarPreview()">
                        </div>
                    </div>

                    <div class="objetivo-card">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                            <h3>
                                <div class="card-icon">
                                    <i class="fas fa-flag"></i>
                                </div>
                                Objetivo Específico 3
                            </h3>
                        </div>
                        <div class="form-group">
                            <input type="text" id="objetivo3" name="objetivo3" 
                                   placeholder="Ej: Reducir costos operacionales en 15%"
                                   value="<%= objetivo3 %>"
                                   onkeyup="actualizarPreview()">
                        </div>
                    </div>

                    <div class="objetivo-card">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                            <h3>
                                <div class="card-icon">
                                    <i class="fas fa-flag"></i>
                                </div>
                                Objetivo Específico 4
                            </h3>
                        </div>
                        <div class="form-group">
                            <input type="text" id="objetivo4" name="objetivo4" 
                                   placeholder="Ej: Expandir a 3 nuevos mercados"
                                   value="<%= objetivo4 %>"
                                   onkeyup="actualizarPreview()">
                        </div>
                    </div>
                </div>

                <!-- Indicadores y Metas -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px;">
                    <div style="background: #fff3e0; padding: 20px; border-radius: 8px; border-left: 5px solid #ff9800;">
                        <div class="form-group">
                            <label for="indicadores">
                                <i class="fas fa-chart-bar"></i> Indicadores de Medición
                            </label>
                            <textarea id="indicadores" name="indicadores" 
                                      placeholder="Define los KPIs y métricas para medir el progreso..."><%= indicadores %></textarea>
                        </div>
                    </div>

                    <div style="background: #e8f5e8; padding: 20px; border-radius: 8px; border-left: 5px solid #4caf50;">
                        <div class="form-group">
                            <label for="metas">
                                <i class="fas fa-calendar-alt"></i> Metas y Plazos
                            </label>
                            <textarea id="metas" name="metas" 
                                      placeholder="Establece las metas específicas y los plazos para cada objetivo..."><%= metas %></textarea>
                        </div>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">
                        <i class="fas fa-save"></i> Guardar Objetivos Estratégicos
                    </button>
                </div>
            </form>

            <!-- Vista Previa -->
            <div class="preview-section">
                <h3><i class="fas fa-eye"></i> Vista Previa de los Objetivos</h3>
                <div id="previewContainer">
                    <!-- Se llenará dinámicamente -->
                </div>
            </div>

            <div style="background: #e8f5e8; padding: 15px; border-radius: 8px; margin-top: 20px;">
                <p style="color: #2d5a3d; margin: 0;">
                    <i class="fas fa-info-circle"></i> 
                    <strong>Modo Colaborativo:</strong> Los objetivos se guardan automáticamente y son visibles 
                    para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                </p>
            </div>

            <% } %>
        </div>
    </div>

    <script>
        let contadorObjetivos = 4; // Los primeros 4 objetivos ya existen, los nuevos empiezan desde 5

        function actualizarPreview() {
            const previewContainer = document.getElementById('previewContainer');
            previewContainer.innerHTML = '';
            
            // Objetivo General
            const objetivoGeneral = document.getElementById('objetivo_general').value;
            if (objetivoGeneral.trim()) {
                const generalDiv = document.createElement('div');
                generalDiv.className = 'objetivo-preview';
                generalDiv.style.borderLeftColor = '#3498db';
                generalDiv.innerHTML = `
                    <h4><i class="fas fa-bullseye" style="color: #3498db;"></i> Objetivo General</h4>
                    <p style="font-size: 14px; line-height: 1.6; color: #555;">${objetivoGeneral}</p>
                `;
                previewContainer.appendChild(generalDiv);
            }
            
            // Objetivos Específicos (dinámicos)
            const objetivosInputs = document.querySelectorAll('input[name^="objetivo"]');
            objetivosInputs.forEach((input, index) => {
                if (input.value.trim()) {
                    const objetivoDiv = document.createElement('div');
                    objetivoDiv.className = 'objetivo-preview';
                    objetivoDiv.style.borderLeftColor = '#3498db';
                    const numeroObjetivo = input.name.replace('objetivo', '') || (index + 1);
                    objetivoDiv.innerHTML = `
                        <h4><i class="fas fa-flag" style="color: #3498db;"></i> Objetivo Específico ${numeroObjetivo}</h4>
                        <p style="font-size: 14px; line-height: 1.6; color: #555;">${input.value}</p>
                    `;
                    previewContainer.appendChild(objetivoDiv);
                }
            });
            
            // Indicadores
            const indicadores = document.getElementById('indicadores').value;
            if (indicadores.trim()) {
                const indicadoresDiv = document.createElement('div');
                indicadoresDiv.className = 'objetivo-preview';
                indicadoresDiv.style.borderLeftColor = '#ff9800';
                indicadoresDiv.innerHTML = `
                    <h4><i class="fas fa-chart-bar" style="color: #ff9800;"></i> Indicadores de Medición</h4>
                    <p style="font-size: 14px; line-height: 1.6; color: #555;">${indicadores}</p>
                `;
                previewContainer.appendChild(indicadoresDiv);
            }
            
            // Metas
            const metas = document.getElementById('metas').value;
            if (metas.trim()) {
                const metasDiv = document.createElement('div');
                metasDiv.className = 'objetivo-preview';
                metasDiv.style.borderLeftColor = '#4caf50';
                metasDiv.innerHTML = `
                    <h4><i class="fas fa-calendar-alt" style="color: #4caf50;"></i> Metas y Plazos</h4>
                    <p style="font-size: 14px; line-height: 1.6; color: #555;">${metas}</p>
                `;
                previewContainer.appendChild(metasDiv);
            }
            
            if (previewContainer.children.length === 0) {
                previewContainer.innerHTML = '<p style="text-align: center; color: #666; font-style: italic;">No hay objetivos definidos</p>';
            }
        }

        function agregarObjetivo() {
            // Asegurar que contadorObjetivos sea al menos 5
            if (contadorObjetivos < 5) {
                contadorObjetivos = 5;
            } else {
                contadorObjetivos++;
            }
            
            const container = document.getElementById('objetivosContainer');
            
            const nuevoObjetivo = document.createElement('div');
            nuevoObjetivo.className = 'objetivo-card adding';
            nuevoObjetivo.innerHTML = `
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                    <h3>
                        <div class="card-icon">
                            <i class="fas fa-flag"></i>
                        </div>
                        Objetivo Específico ${contadorObjetivos}
                    </h3>
                    <button type="button" class="btn-remove" onclick="eliminarObjetivo(this)">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
                <div class="form-group">
                    <input type="text" name="objetivo${contadorObjetivos}" 
                           placeholder="Define un nuevo objetivo específico..."
                           onkeyup="actualizarPreview(); actualizarCampoHidden(this)">
                </div>
            `;
            
            container.appendChild(nuevoObjetivo);
            
            // Crear campo hidden correspondiente
            crearCampoHidden(`objetivo${contadorObjetivos}`, '');
            
            // Enfocar el nuevo input
            setTimeout(() => {
                const nuevoInput = nuevoObjetivo.querySelector('input');
                nuevoInput.focus();
            }, 100);
        }

        function eliminarObjetivo(btn) {
            const objetivoCard = btn.closest('.objetivo-card');
            const input = objetivoCard.querySelector('input');
            const nombreCampo = input.name;
            
            objetivoCard.classList.add('removing');
            
            setTimeout(() => {
                objetivoCard.remove();
                eliminarCampoHidden(nombreCampo);
                actualizarPreview();
                renumerarObjetivos();
            }, 300);
        }

        function renumerarObjetivos() {
            const objetivos = document.querySelectorAll('#objetivosContainer .objetivo-card');
            let contadorDinamicos = 5; // Empezar desde objetivo5
            
            objetivos.forEach((objetivo, index) => {
                const titulo = objetivo.querySelector('h3');
                const input = objetivo.querySelector('input');
                
                // Solo renumerar objetivos dinámicos (no los primeros 4)
                if (input && !input.name.match(/^objetivo[1-4]$/)) {
                    const numeroVisual = contadorDinamicos;
                    
                    titulo.innerHTML = `
                        <div class="card-icon">
                            <i class="fas fa-flag"></i>
                        </div>
                        Objetivo Específico ${numeroVisual}
                    `;
                    
                    // Actualizar el nombre del campo
                    const nombreAnterior = input.name;
                    const nombreNuevo = `objetivo${numeroVisual}`;
                    
                    input.name = nombreNuevo;
                    
                    // Actualizar campo hidden correspondiente
                    eliminarCampoHidden(nombreAnterior);
                    crearCampoHidden(nombreNuevo, input.value);
                    
                    contadorDinamicos++;
                } else {
                    // Mantener numeración original para los primeros 4
                    const numeroOriginal = index + 1;
                    titulo.innerHTML = `
                        <div class="card-icon">
                            <i class="fas fa-flag"></i>
                        </div>
                        Objetivo Específico ${numeroOriginal}
                    `;
                }
            });
            
            // Actualizar contador global
            contadorObjetivos = contadorDinamicos - 1;
        }

        // Agregar botones de eliminar a los objetivos existentes (excepto los primeros 2)
        function inicializarBotonesEliminar() {
            const objetivos = document.querySelectorAll('#objetivosContainer .objetivo-card');
            objetivos.forEach((objetivo, index) => {
                if (index >= 2) { // Solo a partir del tercer objetivo
                    const header = objetivo.querySelector('div[style*="display: flex"]');
                    if (header && !header.querySelector('.btn-remove')) {
                        const btnEliminar = document.createElement('button');
                        btnEliminar.type = 'button';
                        btnEliminar.className = 'btn-remove';
                        btnEliminar.innerHTML = '<i class="fas fa-trash"></i>';
                        btnEliminar.onclick = function() { eliminarObjetivo(this); };
                        header.appendChild(btnEliminar);
                    }
                }
            });
        }

        // Event Listeners
        document.addEventListener('DOMContentLoaded', function() {
            // Botón agregar objetivo
            document.getElementById('btnAgregarObjetivo').addEventListener('click', agregarObjetivo);
            
            // Cargar objetivos adicionales del servidor
            cargarObjetivosAdicionales();
            
            // Inicializar botones de eliminar
            inicializarBotonesEliminar();
            
            // Listeners para inputs existentes
            const inputs = document.querySelectorAll('input, textarea');
            inputs.forEach(input => {
                input.addEventListener('input', actualizarPreview);
            });
            
            // Vista previa inicial
            actualizarPreview();
        });

        function cargarObjetivosAdicionales() {
            // Función simplificada - cargar desde campos hidden
            const hiddenFields = document.getElementById('hiddenFields');
            const hiddenInputs = hiddenFields.querySelectorAll('input[type="hidden"]');
            
            hiddenInputs.forEach(input => {
                if (input.name.startsWith('objetivo') && input.name !== 'objetivo1' && 
                    input.name !== 'objetivo2' && input.name !== 'objetivo3' && input.name !== 'objetivo4') {
                    const numero = parseInt(input.name.replace('objetivo', ''));
                    if (input.value && input.value.trim() !== '') {
                        agregarObjetivoConDatos(input.name, input.value, numero);
                    }
                }
            });
        }

        function agregarObjetivoConDatos(name, valor, numero) {
            const container = document.getElementById('objetivosContainer');
            
            // Actualizar contador
            contadorObjetivos = Math.max(contadorObjetivos, numero);
            
            const nuevoObjetivo = document.createElement('div');
            nuevoObjetivo.className = 'objetivo-card';
            nuevoObjetivo.innerHTML = `
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                    <h3>
                        <div class="card-icon">
                            <i class="fas fa-flag"></i>
                        </div>
                        Objetivo Específico ${numero}
                    </h3>
                    <button type="button" class="btn-remove" onclick="eliminarObjetivo(this)">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
                <div class="form-group">
                    <input type="text" name="${name}" value="${valor}"
                           placeholder="Define un objetivo específico..."
                           onkeyup="actualizarPreview(); actualizarCampoHidden(this)">
                </div>
            `;
            
            container.appendChild(nuevoObjetivo);
            
            // Crear campo hidden correspondiente
            crearCampoHidden(name, valor);
        }

        // Funciones para manejar campos hidden
        function sincronizarTodosLosCampos() {
            console.log('Sincronizando todos los campos antes de enviar...');
            
            // Obtener todos los inputs de objetivos dinámicos
            const objetivosInputs = document.querySelectorAll('#objetivosContainer input[name^="objetivo"]');
            
            objetivosInputs.forEach(input => {
                const nombre = input.name;
                const valor = input.value;
                
                // Solo sincronizar objetivos dinámicos (no los 4 predeterminados)
                if (nombre !== 'objetivo1' && nombre !== 'objetivo2' && 
                    nombre !== 'objetivo3' && nombre !== 'objetivo4') {
                    
                    console.log(`Sincronizando ${nombre} = ${valor}`);
                    crearCampoHidden(nombre, valor);
                }
            });
            
            // Mostrar en consola todos los campos hidden para debug
            const hiddenFields = document.getElementById('hiddenFields');
            const hiddenInputs = hiddenFields.querySelectorAll('input[type="hidden"]');
            console.log('Campos hidden que se enviarán:');
            hiddenInputs.forEach(hidden => {
                console.log(`${hidden.name} = ${hidden.value}`);
            });
            
            return true; // Permitir el envío del formulario
        }

        function crearCampoHidden(nombre, valor) {
            const hiddenFields = document.getElementById('hiddenFields');
            
            // Verificar si ya existe
            let existingField = hiddenFields.querySelector(`input[name="${nombre}"]`);
            if (!existingField) {
                const hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = nombre;
                hiddenInput.value = valor;
                hiddenFields.appendChild(hiddenInput);
            } else {
                existingField.value = valor;
            }
        }

        function eliminarCampoHidden(nombre) {
            const hiddenFields = document.getElementById('hiddenFields');
            const campo = hiddenFields.querySelector(`input[name="${nombre}"]`);
            if (campo) {
                campo.remove();
            }
        }

        function actualizarCampoHidden(input) {
            const nombre = input.name;
            const valor = input.value;
            crearCampoHidden(nombre, valor);
        }

        // Auto-refresh cada 15 segundos
        setInterval(function() {
            const inputs = document.querySelectorAll('input, textarea');
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
        document.querySelectorAll('input, textarea').forEach(element => {
            element.addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
        });
    </script>
</body>
</html>