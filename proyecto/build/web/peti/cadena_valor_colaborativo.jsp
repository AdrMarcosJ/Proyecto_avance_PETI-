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
    
    // Variables para la cadena de valor
    String logisticaInterna = "";
    String operaciones = "";
    String logisticaExterna = "";
    String marketingVentas = "";
    String serviciosPostventa = "";
    String infraestructura = "";
    String recursosHumanos = "";
    String tecnologia = "";
    String compras = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevaLogisticaInterna = request.getParameter("logistica_interna");
        String nuevasOperaciones = request.getParameter("operaciones");
        String nuevaLogisticaExterna = request.getParameter("logistica_externa");
        String nuevoMarketing = request.getParameter("marketing");
        String nuevosServicios = request.getParameter("servicios");
        String nuevaInfraestructura = request.getParameter("infraestructura");
        String nuevosRecursos = request.getParameter("recursos_humanos");
        String nuevaTecnologia = request.getParameter("tecnologia");
        String nuevasCompras = request.getParameter("compras");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevaLogisticaInterna != null && !nuevaLogisticaInterna.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "logistica_interna", nuevaLogisticaInterna.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevasOperaciones != null && !nuevasOperaciones.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "operaciones", nuevasOperaciones.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevaLogisticaExterna != null && !nuevaLogisticaExterna.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "logistica_externa", nuevaLogisticaExterna.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoMarketing != null && !nuevoMarketing.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "marketing", nuevoMarketing.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosServicios != null && !nuevosServicios.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "servicios", nuevosServicios.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevaInfraestructura != null && !nuevaInfraestructura.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "infraestructura", nuevaInfraestructura.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosRecursos != null && !nuevosRecursos.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "recursos_humanos", nuevosRecursos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevaTecnologia != null && !nuevaTecnologia.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "tecnologia", nuevaTecnologia.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevasCompras != null && !nuevasCompras.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "compras", nuevasCompras.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Cadena de Valor guardada exitosamente";
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
            Map<String, String> datosCadena = negocioPeti.obtenerDatosSeccion(grupoId, "cadena_valor");
            
            logisticaInterna = datosCadena.getOrDefault("logistica_interna", "");
            operaciones = datosCadena.getOrDefault("operaciones", "");
            logisticaExterna = datosCadena.getOrDefault("logistica_externa", "");
            marketingVentas = datosCadena.getOrDefault("marketing", "");
            serviciosPostventa = datosCadena.getOrDefault("servicios", "");
            infraestructura = datosCadena.getOrDefault("infraestructura", "");
            recursosHumanos = datosCadena.getOrDefault("recursos_humanos", "");
            tecnologia = datosCadena.getOrDefault("tecnologia", "");
            compras = datosCadena.getOrDefault("compras", "");
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
    <title>Cadena de Valor - PETI Colaborativo</title>
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
            animation: backgroundShift 20s ease-in-out infinite;
        }

        @keyframes backgroundShift {
            0%, 100% { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
            25% { background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%); }
            50% { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 50%, #667eea 100%); }
            75% { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 50%, #667eea 100%); }
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
            animation: gridFloat 15s ease-in-out infinite;
        }

        @keyframes gridFloat {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-10px) rotate(1deg); }
        }

        .container {
            max-width: 1600px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 30px;
            border-radius: 25px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
            animation: headerGlow 3s ease-in-out infinite alternate;
        }

        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: conic-gradient(from 0deg, rgba(22, 160, 133, 0.1), rgba(39, 174, 96, 0.1), rgba(52, 152, 219, 0.1), rgba(155, 89, 182, 0.1), rgba(22, 160, 133, 0.1));
            animation: rotate 20s linear infinite;
            z-index: -1;
        }

        @keyframes headerGlow {
            0% { box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1); }
            100% { box-shadow: 0 25px 50px rgba(22, 160, 133, 0.2); }
        }

        @keyframes rotate {
            100% { transform: rotate(360deg); }
        }

        .header h1 {
            color: #2c3e50;
            font-size: 32px;
            display: flex;
            align-items: center;
            gap: 20px;
            font-weight: 800;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .chain-logo {
            background: linear-gradient(135deg, #16a085 0%, #27ae60 100%);
            color: white;
            padding: 16px 20px;
            border-radius: 16px;
            font-weight: bold;
            font-size: 20px;
            box-shadow: 0 8px 25px rgba(22, 160, 133, 0.4);
            position: relative;
            overflow: hidden;
        }

        .chain-logo::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
            animation: logoShine 3s ease-in-out infinite;
        }

        @keyframes logoShine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            50% { transform: translateX(100%) translateY(100%) rotate(45deg); }
            100% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
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

        .progress-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .progress-title {
            font-size: 18px;
            color: #2c3e50;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .progress-stats {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: #7f8c8d;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .progress-bar-container {
            background: rgba(0, 0, 0, 0.1);
            height: 8px;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #16a085 0%, #27ae60 100%);
            border-radius: 4px;
            transition: width 0.3s ease;
            position: relative;
        }

        .progress-bar::after {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { left: -100%; }
            100% { left: 100%; }
        }

        .cadena-valor-container {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
            margin-bottom: 25px;
        }

        .actividades-apoyo {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .actividades-primarias {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 20px;
        }

        .actividad-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
            position: relative;
            overflow: hidden;
            animation: cardFloat 6s ease-in-out infinite;
        }

        @keyframes cardFloat {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-8px); }
        }

        .actividad-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }

        .actividad-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #16a085 0%, #27ae60 100%);
            animation: gradientShift 4s ease-in-out infinite;
        }

        @keyframes gradientShift {
            0%, 100% { background: linear-gradient(90deg, #16a085 0%, #27ae60 100%); }
            50% { background: linear-gradient(90deg, #27ae60 0%, #2ecc71 100%); }
        }

        .actividad-apoyo .actividad-card::before {
            background: linear-gradient(90deg, #e74c3c 0%, #c0392b 100%);
            animation: gradientShiftRed 4s ease-in-out infinite;
        }

        @keyframes gradientShiftRed {
            0%, 100% { background: linear-gradient(90deg, #e74c3c 0%, #c0392b 100%); }
            50% { background: linear-gradient(90deg, #c0392b 0%, #e67e22 100%); }
        }

        .actividad-card::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: conic-gradient(from 0deg, transparent, rgba(255,255,255,0.1), transparent);
            animation: cardRotate 8s linear infinite;
            z-index: -1;
        }

        @keyframes cardRotate {
            100% { transform: rotate(360deg); }
        }

        .actividad-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
        }

        .actividad-icon {
            width: 50px;
            height: 50px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: white;
            background: linear-gradient(135deg, #16a085 0%, #27ae60 100%);
            box-shadow: 0 8px 25px rgba(22, 160, 133, 0.4);
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .actividad-icon::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
            animation: iconShine 2s ease-in-out infinite;
        }

        @keyframes iconShine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            50% { transform: translateX(100%) translateY(100%) rotate(45deg); }
            100% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
        }

        .actividad-card:hover .actividad-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 12px 30px rgba(22, 160, 133, 0.5);
        }

        .actividad-apoyo .actividad-icon {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            box-shadow: 0 8px 25px rgba(231, 76, 60, 0.4);
        }

        .actividad-apoyo .actividad-card:hover .actividad-icon {
            box-shadow: 0 12px 30px rgba(231, 76, 60, 0.5);
        }

        .actividad-title {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
            flex: 1;
        }

        .char-counter {
            font-size: 12px;
            color: #95a5a6;
            background: rgba(149, 165, 166, 0.1);
            padding: 4px 8px;
            border-radius: 6px;
        }

        .input-group {
            position: relative;
        }

        .form-textarea {
            width: 100%;
            min-height: 140px;
            padding: 20px;
            border: 3px solid rgba(52, 152, 219, 0.2);
            border-radius: 15px;
            font-size: 15px;
            font-family: inherit;
            resize: vertical;
            transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            line-height: 1.6;
            color: #2c3e50;
        }

        .form-textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.15), 0 8px 25px rgba(52, 152, 219, 0.1);
            background: rgba(255, 255, 255, 1);
            transform: translateY(-2px);
        }

        .form-textarea::placeholder {
            color: #bdc3c7;
            font-style: italic;
        }

        .form-textarea:hover {
            border-color: rgba(52, 152, 219, 0.4);
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.1);
        }

        .section-divider {
            text-align: center;
            margin: 40px 0;
            position: relative;
        }

        .section-divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, rgba(52, 152, 219, 0.3), rgba(155, 89, 182, 0.3), rgba(52, 152, 219, 0.3), transparent);
            animation: lineGlow 3s ease-in-out infinite alternate;
        }

        @keyframes lineGlow {
            0% { opacity: 0.6; }
            100% { opacity: 1; }
        }

        .section-label {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 16px 32px;
            border-radius: 30px;
            font-weight: 700;
            color: #2c3e50;
            border: 3px solid rgba(52, 152, 219, 0.2);
            display: inline-block;
            position: relative;
            z-index: 1;
            font-size: 18px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .section-label:hover {
            transform: scale(1.05);
            border-color: rgba(52, 152, 219, 0.4);
            box-shadow: 0 12px 30px rgba(52, 152, 219, 0.2);
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-save {
            background: linear-gradient(135deg, #27ae60 0%, #16a085 100%);
            color: white;
            padding: 18px 40px;
            border: none;
            border-radius: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 18px;
            box-shadow: 0 8px 25px rgba(39, 174, 96, 0.4);
            position: relative;
            overflow: hidden;
        }

        .btn-save::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }

        .btn-save:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 15px 40px rgba(39, 174, 96, 0.5);
        }

        .btn-save:hover::before {
            left: 100%;
        }

        .btn-save:active {
            transform: translateY(-1px) scale(1.02);
        }

        .mensaje {
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            backdrop-filter: blur(20px);
        }

        .mensaje.success {
            background: rgba(39, 174, 96, 0.9);
            color: white;
            border: 1px solid rgba(39, 174, 96, 0.3);
        }

        .mensaje.error {
            background: rgba(231, 76, 60, 0.9);
            color: white;
            border: 1px solid rgba(231, 76, 60, 0.3);
        }

        .modo-info {
            background: rgba(52, 152, 219, 0.1);
            border: 1px solid rgba(52, 152, 219, 0.2);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .colaboradores-online {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            color: #7f8c8d;
        }

        .colaborador-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 12px;
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
            
            .actividades-apoyo,
            .actividades-primarias {
                grid-template-columns: 1fr;
            }
            
            .nav-buttons {
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .progress-stats {
                flex-direction: column;
                gap: 10px;
            }
        }

        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .auto-save-indicator {
            position: fixed;
            top: 20px;
            right: 20px;
            background: rgba(39, 174, 96, 0.9);
            color: white;
            padding: 10px 15px;
            border-radius: 8px;
            font-size: 14px;
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 1000;
        }

        .auto-save-indicator.show {
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="auto-save-indicator" id="autoSaveIndicator">
        <i class="fas fa-check"></i> Guardado automáticamente
    </div>

    <div class="container">
        <div class="header">
            <h1>
                <div class="chain-logo">CV</div>
                Cadena de Valor
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

        <% if (!mensaje.isEmpty()) { %>
            <div class="mensaje <%= tipoMensaje %>">
                <% if ("success".equals(tipoMensaje)) { %>
                    <i class="fas fa-check-circle"></i>
                <% } else { %>
                    <i class="fas fa-exclamation-triangle"></i>
                <% } %>
                <%= mensaje %>
            </div>
        <% } %>

        <% if (modoColaborativo) { %>
            <div class="progress-section">
                <div class="progress-header">
                    <h3 class="progress-title">
                        <i class="fas fa-chart-line"></i>
                        Progreso de Análisis
                    </h3>
                    <div class="progress-stats">
                        <div class="stat-item">
                            <i class="fas fa-users"></i>
                            <span id="colaboradoresCount">1 colaborador</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-clock"></i>
                            <span id="lastUpdate">Actualizado ahora</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-percentage"></i>
                            <span id="completionPercent">0% completado</span>
                        </div>
                    </div>
                </div>
                <div class="progress-bar-container">
                    <div class="progress-bar" id="overallProgress" style="width: 0%"></div>
                </div>
            </div>
        <% } else { %>
            <div class="modo-info">
                <i class="fas fa-info-circle"></i>
                <strong>Modo Individual:</strong> Únete a un grupo para colaborar en tiempo real con otros usuarios.
            </div>
        <% } %>

        <form method="post" id="cadenaForm">
            <div class="cadena-valor-container">
                <div class="section-divider">
                    <div class="section-label">
                        <i class="fas fa-cogs"></i>
                        Actividades de Apoyo
                    </div>
                </div>
                
                <div class="actividades-apoyo">
                    <div class="actividad-card">
                        <div class="actividad-header">
                            <div class="actividad-icon">
                                <i class="fas fa-building"></i>
                            </div>
                            <h3 class="actividad-title">Infraestructura</h3>
                            <span class="char-counter" id="infraestructura-counter">0/500</span>
                        </div>
                        <div class="input-group">
                            <textarea 
                                name="infraestructura" 
                                class="form-textarea" 
                                placeholder="Describe la infraestructura organizacional, sistemas de planificación, finanzas, contabilidad, aspectos legales, gestión de calidad..."
                                maxlength="500"
                                data-counter="infraestructura-counter"><%= infraestructura %></textarea>
                        </div>
                    </div>

                    <div class="actividad-card">
                        <div class="actividad-header">
                            <div class="actividad-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <h3 class="actividad-title">Recursos Humanos</h3>
                            <span class="char-counter" id="recursos-counter">0/500</span>
                        </div>
                        <div class="input-group">
                            <textarea 
                                name="recursos_humanos" 
                                class="form-textarea" 
                                placeholder="Describe las actividades de gestión de recursos humanos: reclutamiento, capacitación, desarrollo, compensación..."
                                maxlength="500"
                                data-counter="recursos-counter"><%= recursosHumanos %></textarea>
                        </div>
                    </div>

                    <div class="actividad-card">
                        <div class="actividad-header">
                            <div class="actividad-icon">
                                <i class="fas fa-microchip"></i>
                            </div>
                            <h3 class="actividad-title">Tecnología</h3>
                            <span class="char-counter" id="tecnologia-counter">0/500</span>
                        </div>
                        <div class="input-group">
                            <textarea 
                                name="tecnologia" 
                                class="form-textarea" 
                                placeholder="Describe el desarrollo tecnológico, investigación y desarrollo, automatización, sistemas de información..."
                                maxlength="500"
                                data-counter="tecnologia-counter"><%= tecnologia %></textarea>
                        </div>
                    </div>

                    <div class="actividad-card">
                        <div class="actividad-header">
                            <div class="actividad-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <h3 class="actividad-title">Compras</h3>
                            <span class="char-counter" id="compras-counter">0/500</span>
                        </div>
                        <div class="input-group">
                            <textarea 
                                name="compras" 
                                class="form-textarea" 
                                placeholder="Describe las actividades de adquisición de materias primas, suministros, servicios, equipos, edificios..."
                                maxlength="500"
                                data-counter="compras-counter"><%= compras %></textarea>
                        </div>
                    </div>
                </div>

                <div class="section-divider">
                    <div class="section-label">
                        <i class="fas fa-arrow-right"></i>
                        Actividades Primarias
                    </div>
                </div>

                <div class="actividades-primarias">
                    <div class="actividad-card">
                        <div class="actividad-header">
                            <div class="actividad-icon">
                                <i class="fas fa-truck-loading"></i>
                            </div>
                            <h3 class="actividad-title">Logística Interna</h3>
                            <span class="char-counter" id="logistica-interna-counter">0/500</span>
                        </div>
                        <div class="input-group">
                            <textarea 
                                name="logistica_interna" 
                                class="form-textarea" 
                                placeholder="Describe las actividades de recepción, almacenamiento, control de inventarios, programación de vehículos, devoluciones..."
                                maxlength="500"
                                data-counter="logistica-interna-counter"><%= logisticaInterna %></textarea>
                        </div>
                    </div>

                    <div class="actividad-card">
                        <div class="actividad-header">
                            <div class="actividad-icon">
                                <i class="fas fa-cogs"></i>
                            </div>
                            <h3 class="actividad-title">Operaciones</h3>
                            <span class="char-counter" id="operaciones-counter">0/500</span>
                        </div>
                        <div class="input-group">
                            <textarea 
                                name="operaciones" 
                                class="form-textarea" 
                                placeholder="Describe las actividades de transformación de insumos en productos finales: maquinado, empaque, ensamble, mantenimiento de equipos, pruebas..."
                                maxlength="500"
                                data-counter="operaciones-counter"><%= operaciones %></textarea>
                        </div>
                    </div>

                    <div class="actividad-card">
                        <div class="actividad-header">
                            <div class="actividad-icon">
                                <i class="fas fa-shipping-fast"></i>
                            </div>
                            <h3 class="actividad-title">Logística Externa</h3>
                            <span class="char-counter" id="logistica-externa-counter">0/500</span>
                        </div>
                        <div class="input-group">
                            <textarea 
                                name="logistica_externa" 
                                class="form-textarea" 
                                placeholder="Describe las actividades de recopilación, almacenamiento y distribución física del producto a los compradores..."
                                maxlength="500"
                                data-counter="logistica-externa-counter"><%= logisticaExterna %></textarea>
                        </div>
                    </div>

                    <div class="actividad-card">
                        <div class="actividad-header">
                            <div class="actividad-icon">
                                <i class="fas fa-bullhorn"></i>
                            </div>
                            <h3 class="actividad-title">Marketing y Ventas</h3>
                            <span class="char-counter" id="marketing-counter">0/500</span>
                        </div>
                        <div class="input-group">
                            <textarea 
                                name="marketing" 
                                class="form-textarea" 
                                placeholder="Describe las actividades para proporcionar medios por los cuales los compradores pueden comprar el producto: publicidad, promoción, fuerza de ventas, cotizaciones, selección de canales..."
                                maxlength="500"
                                data-counter="marketing-counter"><%= marketingVentas %></textarea>
                        </div>
                    </div>

                    <div class="actividad-card">
                        <div class="actividad-header">
                            <div class="actividad-icon">
                                <i class="fas fa-headset"></i>
                            </div>
                            <h3 class="actividad-title">Servicios Post-venta</h3>
                            <span class="char-counter" id="servicios-counter">0/500</span>
                        </div>
                        <div class="input-group">
                            <textarea 
                                name="servicios" 
                                class="form-textarea" 
                                placeholder="Describe las actividades para mantener o realzar el valor del producto: instalación, reparación, capacitación, repuestos, ajustes..."
                                maxlength="500"
                                data-counter="servicios-counter"><%= serviciosPostventa %></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <% if (modoColaborativo) { %>
                <div class="action-buttons">
                    <button type="submit" class="btn-save">
                        <i class="fas fa-save"></i>
                        Guardar Cadena de Valor
                    </button>
                </div>
            <% } %>
        </form>
    </div>

    <script>
        // Actualizar contadores de caracteres
        function updateCharCounter(textarea, counterId) {
            const counter = document.getElementById(counterId);
            const currentLength = textarea.value.length;
            const maxLength = parseInt(textarea.getAttribute('maxlength'));
            counter.textContent = `${currentLength}/${maxLength}`;
            
            if (currentLength > maxLength * 0.9) {
                counter.style.color = '#e74c3c';
            } else if (currentLength > maxLength * 0.7) {
                counter.style.color = '#f39c12';
            } else {
                counter.style.color = '#95a5a6';
            }
        }

        // Inicializar contadores y eventos
        document.addEventListener('DOMContentLoaded', function() {
            const textareas = document.querySelectorAll('.form-textarea');
            
            textareas.forEach(textarea => {
                const counterId = textarea.getAttribute('data-counter');
                if (counterId) {
                    updateCharCounter(textarea, counterId);
                    
                    textarea.addEventListener('input', function() {
                        updateCharCounter(this, counterId);
                        updateProgress();
                        <% if (modoColaborativo) { %>
                            scheduleAutoSave();
                        <% } %>
                    });
                }
            });

            updateProgress();
        });

        // Calcular progreso
        function updateProgress() {
            const textareas = document.querySelectorAll('.form-textarea');
            let totalFields = textareas.length;
            let completedFields = 0;
            let totalChars = 0;

            textareas.forEach(textarea => {
                const value = textarea.value.trim();
                if (value.length > 0) {
                    completedFields++;
                }
                totalChars += value.length;
            });

            const percentage = Math.round((completedFields / totalFields) * 100);
            
            const progressBar = document.getElementById('overallProgress');
            const percentageSpan = document.getElementById('completionPercent');
            
            if (progressBar) {
                progressBar.style.width = percentage + '%';
            }
            
            if (percentageSpan) {
                percentageSpan.textContent = `${percentage}% completado`;
            }

            return {
                percentage: percentage,
                completedFields: completedFields,
                totalFields: totalFields,
                totalChars: totalChars
            };
        }

        <% if (modoColaborativo) { %>
        // Auto-guardado
        let autoSaveTimeout;
        let lastSavedContent = '';

        function scheduleAutoSave() {
            clearTimeout(autoSaveTimeout);
            autoSaveTimeout = setTimeout(autoSave, 3000); // 3 segundos después de la última modificación
        }

        function autoSave() {
            const form = document.getElementById('cadenaForm');
            const formData = new FormData(form);
            const currentContent = JSON.stringify(Object.fromEntries(formData));
            
            if (currentContent !== lastSavedContent) {
                // Simular guardado automático (aquí podrías hacer una petición AJAX)
                showAutoSaveIndicator();
                lastSavedContent = currentContent;
                updateLastUpdateTime();
            }
        }

        function showAutoSaveIndicator() {
            const indicator = document.getElementById('autoSaveIndicator');
            indicator.classList.add('show');
            setTimeout(() => {
                indicator.classList.remove('show');
            }, 2000);
        }

        function updateLastUpdateTime() {
            const lastUpdateSpan = document.getElementById('lastUpdate');
            if (lastUpdateSpan) {
                lastUpdateSpan.textContent = 'Actualizado ahora';
            }
        }

        // Simular colaboradores online (esto se conectaría con el sistema real)
        function updateCollaborators() {
            // Esta función se conectaría con el sistema de colaboración real
            const collaboratorsSpan = document.getElementById('colaboradoresCount');
            if (collaboratorsSpan) {
                collaboratorsSpan.textContent = '1 colaborador';
            }
        }

        // Actualizar cada minuto
        setInterval(updateCollaborators, 60000);
        <% } %>

        // Prevenir pérdida de datos
        window.addEventListener('beforeunload', function(e) {
            const textareas = document.querySelectorAll('.form-textarea');
            let hasUnsavedContent = false;
            
            textareas.forEach(textarea => {
                if (textarea.value.trim().length > 0) {
                    hasUnsavedContent = true;
                }
            });
            
            if (hasUnsavedContent) {
                e.preventDefault();
                e.returnValue = '';
            }
        });

        // Manejar envío del formulario
        document.getElementById('cadenaForm').addEventListener('submit', function(e) {
            const button = this.querySelector('.btn-save');
            if (button) {
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Guardando...';
                button.disabled = true;
            }
        });
    </script>
</body>
</html>
    <style>
        
        border-radius{: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .content {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
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

        .value-chain-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 30px;
        }

        .support-activities {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }

        .primary-activities {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 15px;
        }

        .activity-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-top: 4px solid;
            transition: all 0.3s ease;
            position: relative;
        }

        .activity-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }

        .activity-card h3 {
            margin-bottom: 15px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            text-align: center;
            justify-content: center;
        }

        .activity-subtitle {
            font-size: 12px;
            color: #666;
            text-align: center;
            margin-bottom: 15px;
            font-style: italic;
        }

        /* Actividades de Soporte */
        .infraestructura-card {
            border-top-color: #9c27b0;
            background: linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%);
        }

        .recursos-card {
            border-top-color: #ff5722;
            background: linear-gradient(135deg, #fff3e0 0%, #ffccbc 100%);
        }

        .tecnologia-card {
            border-top-color: #2196f3;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
        }

        .compras-card {
            border-top-color: #ff9800;
            background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 100%);
        }

        /* Actividades Primarias */
        .logistica-interna-card {
            border-top-color: #4caf50;
            background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
        }

        .operaciones-card {
            border-top-color: #f44336;
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
        }

        .logistica-externa-card {
            border-top-color: #607d8b;
            background: linear-gradient(135deg, #eceff1 0%, #cfd8dc 100%);
        }

        .marketing-card {
            border-top-color: #e91e63;
            background: linear-gradient(135deg, #fce4ec 0%, #f8bbd9 100%);
        }

        .servicios-card {
            border-top-color: #00bcd4;
            background: linear-gradient(135deg, #e0f2f1 0%, #b2dfdb 100%);
        }

        .section-title {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            text-align: center;
            font-weight: 600;
            font-size: 18px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 13px;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 6px;
            font-size: 13px;
            min-height: 120px;
            resize: vertical;
            background: rgba(255, 255, 255, 0.9);
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background: white;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .tips-box {
            background: #e8f5e8;
            border: 1px solid #4caf50;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .tips-box h4 {
            color: #2e7d32;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 18px;
        }

        .tips-content {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-top: 15px;
        }

        .tip-section {
            background: rgba(255, 255, 255, 0.7);
            padding: 15px;
            border-radius: 6px;
            border-left: 3px solid #4caf50;
        }

        .tip-section h5 {
            color: #2e7d32;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .tip-section ul {
            color: #2e7d32;
            margin-left: 15px;
            font-size: 13px;
        }

        .tip-section li {
            margin-bottom: 5px;
        }

        .preview-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .preview-section h3 {
            color: #333;
            margin-bottom: 15px;
        }

        .preview-chain {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .preview-row {
            display: grid;
            gap: 10px;
        }

        .preview-support {
            grid-template-columns: repeat(4, 1fr);
        }

        .preview-primary {
            grid-template-columns: repeat(5, 1fr);
        }

        .preview-item {
            background: white;
            padding: 12px;
            border-radius: 6px;
            border-top: 3px solid;
            font-size: 13px;
        }

        .activity-examples {
            font-size: 11px;
            color: #666;
            margin-top: 8px;
            padding: 6px;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 4px;
            font-style: italic;
        }

        @media (max-width: 1024px) {
            .support-activities,
            .primary-activities {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .preview-support,
            .preview-primary {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .support-activities,
            .primary-activities,
            .preview-support,
            .preview-primary {
                grid-template-columns: 1fr;
            }
            
            .tips-content {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <i class="fas fa-link"></i> Cadena de Valor de Porter
                    <small style="font-size: 14px; color: #666;">- Grupo: <%= grupoActual %> 
                    <% if ("admin".equals(rolUsuario)) { %>
                        <span style="color: #ffc107;">👑</span>
                    <% } %>
                    </small>
                </h1>
            </div>
            <div style="display: flex; gap: 10px;">
                <a href="dashboard.jsp" class="btn" style="background: #6c757d; color: white;">
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
                <h4><i class="fas fa-lightbulb"></i> ¿Qué es la Cadena de Valor?</h4>
                <p style="color: #2e7d32; margin-bottom: 15px;">
                    La Cadena de Valor de Porter identifica las actividades que crean valor en una organización, 
                    dividiéndolas en actividades primarias y de soporte.
                </p>
                <div class="tips-content">
                    <div class="tip-section">
                        <h5><i class="fas fa-cogs"></i> Actividades Primarias</h5>
                        <ul>
                            <li><strong>Logística Interna:</strong> Recepción y almacenamiento</li>
                            <li><strong>Operaciones:</strong> Transformación de materias primas</li>
                            <li><strong>Logística Externa:</strong> Distribución de productos</li>
                            <li><strong>Marketing:</strong> Promoción y ventas</li>
                            <li><strong>Servicios:</strong> Postventa y soporte</li>
                        </ul>
                    </div>
                    <div class="tip-section">
                        <h5><i class="fas fa-building"></i> Actividades de Soporte</h5>
                        <ul>
                            <li><strong>Infraestructura:</strong> Gestión, finanzas, legal</li>
                            <li><strong>Recursos Humanos:</strong> Selección, capacitación</li>
                            <li><strong>Tecnología:</strong> I+D, sistemas de información</li>
                            <li><strong>Compras:</strong> Adquisición de materiales</li>
                        </ul>
                    </div>
                </div>
            </div>

            <form method="post" action="">
                <div class="value-chain-container">
                    <!-- Actividades de Soporte -->
                    <div class="section-title">
                        <i class="fas fa-building"></i> Actividades de Soporte
                    </div>
                    <div class="support-activities">
                        <!-- Infraestructura -->
                        <div class="activity-card infraestructura-card">
                            <h3>
                                <i class="fas fa-building" style="color: #9c27b0;"></i>
                                Infraestructura
                            </h3>
                            <div class="activity-subtitle">Gestión general de la empresa</div>
                            <div class="form-group">
                                <label for="infraestructura">Infraestructura de la Empresa:</label>
                                <textarea id="infraestructura" name="infraestructura" 
                                          placeholder="Describe la gestión general, finanzas, legal, calidad, relaciones públicas..."
                                          ><%= infraestructura %></textarea>
                                <div class="activity-examples">
                                    Ejemplos: Estructura organizacional, sistemas de gestión, finanzas, legal, planificación estratégica
                                </div>
                            </div>
                        </div>

                        <!-- Recursos Humanos -->
                        <div class="activity-card recursos-card">
                            <h3>
                                <i class="fas fa-users" style="color: #ff5722;"></i>
                                Recursos Humanos
                            </h3>
                            <div class="activity-subtitle">Gestión del talento humano</div>
                            <div class="form-group">
                                <label for="recursos_humanos">Gestión de Recursos Humanos:</label>
                                <textarea id="recursos_humanos" name="recursos_humanos" 
                                          placeholder="Describe reclutamiento, selección, capacitación, desarrollo, compensación..."
                                          ><%= recursosHumanos %></textarea>
                                <div class="activity-examples">
                                    Ejemplos: Reclutamiento, capacitación, evaluación, compensación, desarrollo profesional
                                </div>
                            </div>
                        </div>

                        <!-- Desarrollo Tecnológico -->
                        <div class="activity-card tecnologia-card">
                            <h3>
                                <i class="fas fa-laptop-code" style="color: #2196f3;"></i>
                                Tecnología
                            </h3>
                            <div class="activity-subtitle">I+D y desarrollo tecnológico</div>
                            <div class="form-group">
                                <label for="tecnologia">Desarrollo Tecnológico:</label>
                                <textarea id="tecnologia" name="tecnologia" 
                                          placeholder="Describe I+D, innovación, sistemas de información, automatización..."
                                          ><%= tecnologia %></textarea>
                                <div class="activity-examples">
                                    Ejemplos: I+D, sistemas de información, automatización, innovación tecnológica, patentes
                                </div>
                            </div>
                        </div>

                        <!-- Compras -->
                        <div class="activity-card compras-card">
                            <h3>
                                <i class="fas fa-shopping-cart" style="color: #ff9800;"></i>
                                Compras
                            </h3>
                            <div class="activity-subtitle">Adquisición de insumos</div>
                            <div class="form-group">
                                <label for="compras">Actividades de Compras:</label>
                                <textarea id="compras" name="compras" 
                                          placeholder="Describe adquisición de materias primas, equipos, servicios, negociación..."
                                          ><%= compras %></textarea>
                                <div class="activity-examples">
                                    Ejemplos: Selección de proveedores, negociación, adquisición de materiales, control de calidad de insumos
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Actividades Primarias -->
                    <div class="section-title">
                        <i class="fas fa-cogs"></i> Actividades Primarias
                    </div>
                    <div class="primary-activities">
                        <!-- Logística Interna -->
                        <div class="activity-card logistica-interna-card">
                            <h3>
                                <i class="fas fa-warehouse" style="color: #4caf50;"></i>
                                Logística Interna
                            </h3>
                            <div class="activity-subtitle">Recepción y almacenamiento</div>
                            <div class="form-group">
                                <label for="logistica_interna">Logística Interna:</label>
                                <textarea id="logistica_interna" name="logistica_interna" 
                                          placeholder="Describe recepción, almacenamiento, control de inventarios, manejo de materiales..."
                                          ><%= logisticaInterna %></textarea>
                                <div class="activity-examples">
                                    Ejemplos: Recepción de materiales, almacenamiento, control de inventarios, manejo interno
                                </div>
                            </div>
                        </div>

                        <!-- Operaciones -->
                        <div class="activity-card operaciones-card">
                            <h3>
                                <i class="fas fa-industry" style="color: #f44336;"></i>
                                Operaciones
                            </h3>
                            <div class="activity-subtitle">Transformación de productos</div>
                            <div class="form-group">
                                <label for="operaciones">Operaciones:</label>
                                <textarea id="operaciones" name="operaciones" 
                                          placeholder="Describe manufactura, ensamblaje, control de calidad, mantenimiento..."
                                          ><%= operaciones %></textarea>
                                <div class="activity-examples">
                                    Ejemplos: Manufactura, ensamblaje, control de calidad, mantenimiento, procesos productivos
                                </div>
                            </div>
                        </div>

                        <!-- Logística Externa -->
                        <div class="activity-card logistica-externa-card">
                            <h3>
                                <i class="fas fa-truck" style="color: #607d8b;"></i>
                                Logística Externa
                            </h3>
                            <div class="activity-subtitle">Distribución de productos</div>
                            <div class="form-group">
                                <label for="logistica_externa">Logística Externa:</label>
                                <textarea id="logistica_externa" name="logistica_externa" 
                                          placeholder="Describe distribución, entrega, gestión de pedidos, canales de distribución..."
                                          ><%= logisticaExterna %></textarea>
                                <div class="activity-examples">
                                    Ejemplos: Distribución, entrega, gestión de pedidos, canales de distribución, transporte
                                </div>
                            </div>
                        </div>

                        <!-- Marketing y Ventas -->
                        <div class="activity-card marketing-card">
                            <h3>
                                <i class="fas fa-bullhorn" style="color: #e91e63;"></i>
                                Marketing
                            </h3>
                            <div class="activity-subtitle">Promoción y ventas</div>
                            <div class="form-group">
                                <label for="marketing">Marketing y Ventas:</label>
                                <textarea id="marketing" name="marketing" 
                                          placeholder="Describe promoción, publicidad, ventas, investigación de mercados, pricing..."
                                          ><%= marketingVentas %></textarea>
                                <div class="activity-examples">
                                    Ejemplos: Publicidad, promoción, ventas, investigación de mercados, estrategias de precios
                                </div>
                            </div>
                        </div>

                        <!-- Servicios -->
                        <div class="activity-card servicios-card">
                            <h3>
                                <i class="fas fa-headset" style="color: #00bcd4;"></i>
                                Servicios
                            </h3>
                            <div class="activity-subtitle">Postventa y soporte</div>
                            <div class="form-group">
                                <label for="servicios">Servicios Postventa:</label>
                                <textarea id="servicios" name="servicios" 
                                          placeholder="Describe servicio al cliente, soporte técnico, garantías, mantenimiento..."
                                          ><%= serviciosPostventa %></textarea>
                                <div class="activity-examples">
                                    Ejemplos: Servicio al cliente, soporte técnico, garantías, mantenimiento, capacitación de usuarios
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">
                        <i class="fas fa-save"></i> Guardar Cadena de Valor
                    </button>
                </div>
            </form>

            <!-- Vista Previa -->
            <div class="preview-section">
                <h3><i class="fas fa-eye"></i> Resumen de la Cadena de Valor</h3>
                <div class="preview-chain" id="previewChain">
                    <!-- Se llenará dinámicamente -->
                </div>
            </div>

            <div style="background: #e8f5e8; padding: 15px; border-radius: 8px; margin-top: 20px;">
                <p style="color: #2d5a3d; margin: 0;">
                    <i class="fas fa-info-circle"></i> 
                    <strong>Modo Colaborativo:</strong> La Cadena de Valor se guarda automáticamente y es visible 
                    para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                </p>
            </div>

            <% } %>
        </div>
    </div>

    <script>
        function actualizarPreview() {
            const actividades = {
                soporte: [
                    { id: 'infraestructura', titulo: 'Infraestructura', color: '#9c27b0' },
                    { id: 'recursos_humanos', titulo: 'RRHH', color: '#ff5722' },
                    { id: 'tecnologia', titulo: 'Tecnología', color: '#2196f3' },
                    { id: 'compras', titulo: 'Compras', color: '#ff9800' }
                ],
                primarias: [
                    { id: 'logistica_interna', titulo: 'Log. Interna', color: '#4caf50' },
                    { id: 'operaciones', titulo: 'Operaciones', color: '#f44336' },
                    { id: 'logistica_externa', titulo: 'Log. Externa', color: '#607d8b' },
                    { id: 'marketing', titulo: 'Marketing', color: '#e91e63' },
                    { id: 'servicios', titulo: 'Servicios', color: '#00bcd4' }
                ]
            };
            
            const previewChain = document.getElementById('previewChain');
            previewChain.innerHTML = '';
            
            // Actividades de Soporte
            const soporteRow = document.createElement('div');
            soporteRow.className = 'preview-row preview-support';
            
            actividades.soporte.forEach(actividad => {
                const elemento = document.getElementById(actividad.id);
                const texto = elemento ? elemento.value : '';
                
                const previewDiv = document.createElement('div');
                previewDiv.className = 'preview-item';
                previewDiv.style.borderTopColor = actividad.color;
                previewDiv.innerHTML = `
                    <h5 style="color: #333; margin-bottom: 8px; font-size: 14px;">
                        ${actividad.titulo}
                    </h5>
                    <p style="font-size: 12px; line-height: 1.4; color: #555;">
                        ${texto || 'No definido'}
                    </p>
                `;
                soporteRow.appendChild(previewDiv);
            });
            
            previewChain.appendChild(soporteRow);
            
            // Actividades Primarias
            const primariaRow = document.createElement('div');
            primariaRow.className = 'preview-row preview-primary';
            
            actividades.primarias.forEach(actividad => {
                const elemento = document.getElementById(actividad.id);
                const texto = elemento ? elemento.value : '';
                
                const previewDiv = document.createElement('div');
                previewDiv.className = 'preview-item';
                previewDiv.style.borderTopColor = actividad.color;
                previewDiv.innerHTML = `
                    <h5 style="color: #333; margin-bottom: 8px; font-size: 14px;">
                        ${actividad.titulo}
                    </h5>
                    <p style="font-size: 12px; line-height: 1.4; color: #555;">
                        ${texto || 'No definido'}
                    </p>
                `;
                primariaRow.appendChild(previewDiv);
            });
            
            previewChain.appendChild(primariaRow);
        }

        // Agregar listeners
        document.addEventListener('DOMContentLoaded', function() {
            const campos = ['infraestructura', 'recursos_humanos', 'tecnologia', 'compras', 
                           'logistica_interna', 'operaciones', 'logistica_externa', 'marketing', 'servicios'];
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