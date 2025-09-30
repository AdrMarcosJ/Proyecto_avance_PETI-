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
    String visionActual = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevaVision = request.getParameter("vision");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        
        try {
            if (nuevaVision != null && !nuevaVision.trim().isEmpty()) {
                ClsEPeti datoVision = new ClsEPeti(grupoId, "vision", "declaracion", nuevaVision.trim(), usuarioId);
                boolean exito = negocioPeti.guardarDato(datoVision);
                
                if (exito) {
                    mensaje = "Visión guardada exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar la visión";
                    tipoMensaje = "error";
                }
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
            Map<String, String> datosVision = negocioPeti.obtenerDatosSeccion(grupoId, "vision");
            
            if (datosVision.containsKey("declaracion")) {
                visionActual = datosVision.get("declaracion");
            }
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
    <title>Visión Corporativa - PETI Colaborativo</title>
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
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            color: #333;
            font-size: 24px;
        }

        .grupo-info {
            font-size: 14px;
            color: #666;
        }

        .nav-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
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

        .alert-warning {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 18px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 5px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 14px;
            min-height: 120px;
            resize: vertical;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }

        .guidelines {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .guidelines h4 {
            color: #1976d2;
            margin-bottom: 10px;
        }

        .guidelines ul {
            color: #424242;
            padding-left: 20px;
        }

        .guidelines li {
            margin-bottom: 5px;
        }

        .preview {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            border-left: 4px solid #667eea;
        }

        .preview h4 {
            color: #333;
            margin-bottom: 10px;
        }

        .preview p {
            color: #666;
            line-height: 1.6;
            font-style: italic;
        }

        .vision-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-top: 20px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .vision-card h3 {
            font-size: 24px;
            margin-bottom: 15px;
        }

        .vision-card p {
            font-size: 16px;
            line-height: 1.6;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <i class="fas fa-eye"></i> Visión Corporativa
                    <% if (modoColaborativo) { %>
                        <small class="grupo-info">- Grupo: <%= grupoActual %> 
                        <% if ("admin".equals(rolUsuario)) { %>
                            <span style="color: #ffc107;">👑</span>
                        <% } %>
                        </small>
                    <% } else { %>
                        <small class="grupo-info">- Modo Individual</small>
                    <% } %>
                </h1>
            </div>
            <div class="nav-buttons">
                <a href="dashboard.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>" class="btn btn-secondary">
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
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Modo Individual:</strong> No puedes guardar cambios. 
                    <a href="../menuprincipal.jsp" style="color: #856404; text-decoration: underline;">Únete a un grupo</a> 
                    para trabajar colaborativamente.
                </div>
            <% } %>

            <form method="post" action="">
                <div class="form-section">
                    <h3><i class="fas fa-eye"></i> Definición de la Visión</h3>
                    
                    <div class="guidelines">
                        <h4>Guía para redactar la visión:</h4>
                        <ul>
                            <li>¿Cómo se ve la empresa en el futuro? (5-10 años)</li>
                            <li>¿Qué posición quiere alcanzar en su mercado?</li>
                            <li>¿Cuáles son sus aspiraciones a largo plazo?</li>
                            <li>¿Qué impacto quiere tener en su industria?</li>
                            <li>¿Cómo quiere ser reconocida por sus clientes?</li>
                            <li>Use un lenguaje inspirador y aspiracional</li>
                        </ul>
                    </div>

                    <div class="form-group">
                        <label for="vision">
                            Declaración de la Visión:
                            <% if (modoColaborativo && !visionActual.isEmpty()) { %>
                                <span style="color: #28a745; font-size: 12px;">
                                    <i class="fas fa-check-circle"></i> Datos guardados del grupo
                                </span>
                            <% } %>
                        </label>
                        <textarea 
                            id="vision" 
                            name="vision"
                            placeholder="Redacte la visión de su empresa hacia el futuro. Sea inspirador y específico sobre lo que aspiran alcanzar..."
                            <%= modoColaborativo ? "" : "readonly" %>
                            onkeyup="actualizarPreview()"
                        ><%= visionActual %></textarea>
                    </div>

                    <div class="preview">
                        <h4>Vista Previa de la Visión:</h4>
                        <p id="visionPreview"><%= !visionActual.isEmpty() ? visionActual : "La visión aparecerá aquí mientras la escribes..." %></p>
                    </div>

                    <% if (modoColaborativo) { %>
                        <div style="margin-top: 20px; text-align: center;">
                            <button type="submit" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">
                                <i class="fas fa-save"></i> Guardar Visión
                            </button>
                        </div>
                    <% } %>
                </div>
            </form>

            <!-- Tarjeta de Visión -->
            <% if (!visionActual.isEmpty()) { %>
                <div class="vision-card">
                    <h3>Nuestra Visión</h3>
                    <p id="visionCard"><%= visionActual %></p>
                </div>
            <% } else { %>
                <div class="vision-card" id="visionCardContainer" style="display: none;">
                    <h3>Nuestra Visión</h3>
                    <p id="visionCard">La visión aparecerá aquí cuando la escribas</p>
                </div>
            <% } %>

            <% if (modoColaborativo) { %>
                <div style="background: #e8f5e8; padding: 15px; border-radius: 8px; margin-top: 20px;">
                    <p style="color: #2d5a3d; margin: 0;">
                        <i class="fas fa-info-circle"></i> 
                        <strong>Modo Colaborativo Activo:</strong> Los cambios se guardan automáticamente y son visibles 
                        para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                    </p>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        function actualizarPreview() {
            const vision = document.getElementById('vision').value;
            const preview = document.getElementById('visionPreview');
            const card = document.getElementById('visionCard');
            const cardContainer = document.getElementById('visionCardContainer');
            
            if (vision.trim()) {
                preview.textContent = vision;
                preview.style.fontStyle = 'normal';
                preview.style.color = '#333';
                
                card.textContent = vision;
                if (cardContainer) {
                    cardContainer.style.display = 'block';
                }
            } else {
                preview.textContent = 'La visión aparecerá aquí mientras la escribes...';
                preview.style.fontStyle = 'italic';
                preview.style.color = '#666';
                
                card.textContent = 'La visión aparecerá aquí cuando la escribas';
                if (cardContainer) {
                    cardContainer.style.display = 'none';
                }
            }
        }
    </script>
    <% if (modoColaborativo) { %>
    <script>
        // Auto-refresh cada 15 segundos para ver cambios de otros usuarios
        setInterval(function() {
            // Solo recargar si no hay cambios sin guardar
            const visionInput = document.getElementById('vision');
            
            if (!visionInput.dataset.changed) {
                location.reload();
            }
        }, 15000);

        // Marcar como cambiado cuando el usuario escribe
        document.getElementById('vision').addEventListener('input', function() {
            this.dataset.changed = 'true';
        });
    </script>
    <% } %>
</body>
</html>