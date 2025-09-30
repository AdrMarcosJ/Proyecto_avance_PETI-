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
    String fortalezas = "";
    String debilidades = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevasFortalezas = request.getParameter("fortalezas");
        String nuevasDebilidades = request.getParameter("debilidades");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevasFortalezas != null && !nuevasFortalezas.trim().isEmpty()) {
                ClsEPeti datoFortalezas = new ClsEPeti(grupoId, "analisis_interno", "fortalezas", nuevasFortalezas.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoFortalezas);
            }
            if (nuevasDebilidades != null && !nuevasDebilidades.trim().isEmpty()) {
                ClsEPeti datoDebilidades = new ClsEPeti(grupoId, "analisis_interno", "debilidades", nuevasDebilidades.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoDebilidades);
            }
            
            if (exito) {
                mensaje = "Análisis interno guardado exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar el análisis interno";
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
            Map<String, String> datosAnalisis = negocioPeti.obtenerDatosSeccion(grupoId, "analisis_interno");
            
            if (datosAnalisis.containsKey("fortalezas")) {
                fortalezas = datosAnalisis.get("fortalezas");
            }
            if (datosAnalisis.containsKey("debilidades")) {
                debilidades = datosAnalisis.get("debilidades");
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
    <title>Análisis Interno - PETI Colaborativo</title>
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
            max-width: 1400px;
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
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            font-size: 16px;
            padding: 15px 40px;
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

        .analysis-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        @media (max-width: 768px) {
            .analysis-grid {
                grid-template-columns: 1fr;
            }
        }

        .analysis-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border-left: 5px solid;
        }

        .strengths {
            border-left-color: #007bff;
        }

        .weaknesses {
            border-left-color: #ffc107;
        }

        .analysis-section h3 {
            margin-bottom: 15px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .strengths h3 {
            color: #007bff;
        }

        .weaknesses h3 {
            color: #ffc107;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 14px;
            min-height: 150px;
            resize: vertical;
            transition: border-color 0.3s ease;
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
            font-size: 16px;
        }

        .guidelines ul {
            color: #424242;
            padding-left: 20px;
        }

        .guidelines li {
            margin-bottom: 5px;
            line-height: 1.4;
        }

        .preview-card {
            background: white;
            border: 1px solid #e1e5e9;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .preview-card h4 {
            color: #333;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .preview-list {
            list-style: none;
            padding: 0;
        }

        .preview-list li {
            background: #f8f9fa;
            padding: 10px 15px;
            margin-bottom: 8px;
            border-radius: 5px;
            border-left: 4px solid;
            position: relative;
        }

        .preview-list.strengths li {
            border-left-color: #007bff;
        }

        .preview-list.weaknesses li {
            border-left-color: #ffc107;
        }

        .preview-list li::before {
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            margin-right: 8px;
        }

        .preview-list.strengths li::before {
            content: "\f2f5";
            color: #007bff;
        }

        .preview-list.weaknesses li::before {
            content: "\f071";
            color: #ffc107;
        }

        .save-section {
            text-align: center;
            margin-top: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            color: white;
        }

        .save-section h3 {
            margin-bottom: 15px;
            font-size: 20px;
        }

        .swot-hint {
            background: linear-gradient(135deg, #fdbb2d 0%, #22c1c3 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
        }

        .swot-hint h4 {
            margin-bottom: 10px;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <i class="fas fa-chart-bar"></i> Análisis Interno
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

            <div class="swot-hint">
                <h4><i class="fas fa-lightbulb"></i> Análisis Interno FODA</h4>
                <p>Este análisis te ayudará a construir la matriz FODA/SWOT junto con el análisis externo</p>
            </div>

            <div class="guidelines">
                <h4><i class="fas fa-compass"></i> Guía para el Análisis Interno</h4>
                <p><strong>Evalúa los recursos y capacidades internas de tu organización:</strong></p>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 15px;">
                    <div>
                        <strong style="color: #007bff;">💪 Fortalezas:</strong>
                        <ul style="margin-top: 5px;">
                            <li>Recursos únicos o superiores</li>
                            <li>Capacidades distintivas</li>
                            <li>Ventajas competitivas</li>
                            <li>Talento humano calificado</li>
                            <li>Tecnología avanzada</li>
                            <li>Procesos eficientes</li>
                        </ul>
                    </div>
                    <div>
                        <strong style="color: #ffc107;">⚠️ Debilidades:</strong>
                        <ul style="margin-top: 5px;">
                            <li>Recursos limitados o insuficientes</li>
                            <li>Procesos ineficientes</li>
                            <li>Falta de capacidades clave</li>
                            <li>Problemas de gestión</li>
                            <li>Tecnología obsoleta</li>
                            <li>Carencias en el equipo</li>
                        </ul>
                    </div>
                </div>
            </div>

            <form method="post" action="">
                <div class="analysis-grid">
                    <!-- Fortalezas -->
                    <div class="analysis-section strengths">
                        <h3>
                            <i class="fas fa-thumbs-up"></i> Fortalezas
                            <% if (modoColaborativo && !fortalezas.isEmpty()) { %>
                                <span style="color: #28a745; font-size: 12px; margin-left: 10px;">
                                    <i class="fas fa-check-circle"></i> Guardado
                                </span>
                            <% } %>
                        </h3>
                        
                        <div class="form-group">
                            <label for="fortalezas">
                                Identifica las fortalezas de tu organización:
                            </label>
                            <textarea 
                                id="fortalezas" 
                                name="fortalezas"
                                placeholder="Escribe cada fortaleza en una línea diferente:&#10;&#10;• Equipo altamente capacitado&#10;• Tecnología de vanguardia&#10;• Procesos optimizados&#10;• Buena reputación en el mercado&#10;• Sólida situación financiera&#10;• Cultura organizacional fuerte"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarPreviewFortalezas()"
                            ><%= fortalezas %></textarea>
                        </div>

                        <div class="preview-card">
                            <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                            <ul class="preview-list strengths" id="previewFortalezas">
                                <% if (!fortalezas.isEmpty()) { %>
                                    <%
                                        String[] lineasFort = fortalezas.split("\\n");
                                        for (String linea : lineasFort) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li>Las fortalezas aparecerán aquí mientras las escribes</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <!-- Debilidades -->
                    <div class="analysis-section weaknesses">
                        <h3>
                            <i class="fas fa-exclamation-circle"></i> Debilidades
                            <% if (modoColaborativo && !debilidades.isEmpty()) { %>
                                <span style="color: #28a745; font-size: 12px; margin-left: 10px;">
                                    <i class="fas fa-check-circle"></i> Guardado
                                </span>
                            <% } %>
                        </h3>
                        
                        <div class="form-group">
                            <label for="debilidades">
                                Identifica las debilidades de tu organización:
                            </label>
                            <textarea 
                                id="debilidades" 
                                name="debilidades"
                                placeholder="Escribe cada debilidad en una línea diferente:&#10;&#10;• Recursos financieros limitados&#10;• Falta de personal especializado&#10;• Procesos manuales lentos&#10;• Infraestructura tecnológica obsoleta&#10;• Baja presencia en redes sociales&#10;• Dependencia de pocos clientes"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarPreviewDebilidades()"
                            ><%= debilidades %></textarea>
                        </div>

                        <div class="preview-card">
                            <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                            <ul class="preview-list weaknesses" id="previewDebilidades">
                                <% if (!debilidades.isEmpty()) { %>
                                    <%
                                        String[] lineasDeb = debilidades.split("\\n");
                                        for (String linea : lineasDeb) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li>Las debilidades aparecerán aquí mientras las escribes</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </div>

                <% if (modoColaborativo) { %>
                    <div class="save-section">
                        <h3><i class="fas fa-save"></i> Guardar Análisis Interno</h3>
                        <p>Los cambios se guardarán para todo el equipo y estarán disponibles para la matriz FODA</p>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Guardar Fortalezas y Debilidades
                        </button>
                    </div>
                <% } %>
            </form>

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
        function actualizarPreviewFortalezas() {
            const texto = document.getElementById('fortalezas').value;
            const preview = document.getElementById('previewFortalezas');
            
            if (texto.trim()) {
                const lineas = texto.split('\n').filter(linea => linea.trim().length > 0);
                let html = '';
                
                lineas.forEach(linea => {
                    const lineaLimpia = linea.trim().replace(/^[•\-\*]\s*/, '');
                    if (lineaLimpia.length > 0) {
                        html += `<li>${lineaLimpia}</li>`;
                    }
                });
                
                if (html === '') {
                    html = '<li>Las fortalezas aparecerán aquí mientras las escribes</li>';
                }
                
                preview.innerHTML = html;
            } else {
                preview.innerHTML = '<li>Las fortalezas aparecerán aquí mientras las escribes</li>';
            }
        }
        
        function actualizarPreviewDebilidades() {
            const texto = document.getElementById('debilidades').value;
            const preview = document.getElementById('previewDebilidades');
            
            if (texto.trim()) {
                const lineas = texto.split('\n').filter(linea => linea.trim().length > 0);
                let html = '';
                
                lineas.forEach(linea => {
                    const lineaLimpia = linea.trim().replace(/^[•\-\*]\s*/, '');
                    if (lineaLimpia.length > 0) {
                        html += `<li>${lineaLimpia}</li>`;
                    }
                });
                
                if (html === '') {
                    html = '<li>Las debilidades aparecerán aquí mientras las escribes</li>';
                }
                
                preview.innerHTML = html;
            } else {
                preview.innerHTML = '<li>Las debilidades aparecerán aquí mientras las escribes</li>';
            }
        }
    </script>
    <% if (modoColaborativo) { %>
    <script>
        // Auto-refresh cada 20 segundos para ver cambios de otros usuarios
        setInterval(function() {
            const fortalezasInput = document.getElementById('fortalezas');
            const debilidadesInput = document.getElementById('debilidades');
            
            if (!fortalezasInput.dataset.changed && !debilidadesInput.dataset.changed) {
                location.reload();
            }
        }, 20000);

        // Marcar como cambiado cuando el usuario escribe
        document.getElementById('fortalezas').addEventListener('input', function() {
            this.dataset.changed = 'true';
        });
        
        document.getElementById('debilidades').addEventListener('input', function() {
            this.dataset.changed = 'true';
        });
    </script>
    <% } %>
</body>
</html>