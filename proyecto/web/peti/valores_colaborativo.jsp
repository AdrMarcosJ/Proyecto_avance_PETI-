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
    String valoresActuales = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevosValores = request.getParameter("valores");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        
        try {
            if (nuevosValores != null && !nuevosValores.trim().isEmpty()) {
                ClsEPeti datoValores = new ClsEPeti(grupoId, "valores", "lista", nuevosValores.trim(), usuarioId);
                boolean exito = negocioPeti.guardarDato(datoValores);
                
                if (exito) {
                    mensaje = "Valores guardados exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar los valores";
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
            Map<String, String> datosValores = negocioPeti.obtenerDatosSeccion(grupoId, "valores");
            
            if (datosValores.containsKey("lista")) {
                valoresActuales = datosValores.get("lista");
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
    <title>Valores Corporativos - PETI Colaborativo</title>
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
            min-height: 150px;
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

        .preview-card {
            background: #f8f9fa;
            border: 1px solid #e1e5e9;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .preview-card h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .preview-values {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }

        .value-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .value-item h4 {
            color: #333;
            margin-bottom: 5px;
            font-size: 16px;
        }

        .value-item p {
            color: #666;
            font-size: 14px;
            line-height: 1.4;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <i class="fas fa-heart"></i> Valores Corporativos
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
                    <h3><i class="fas fa-heart"></i> Definición de Valores Corporativos</h3>
                    
                    <div class="guidelines">
                        <h4>Guía para definir valores corporativos:</h4>
                        <ul>
                            <li>Defina de 5 a 7 valores fundamentales</li>
                            <li>Cada valor debe tener una descripción clara</li>
                            <li>Use el formato: "Valor: Descripción"</li>
                            <li>Un valor por línea</li>
                            <li>Ejemplo: "Integridad: Actuamos con honestidad y transparencia en todas nuestras acciones"</li>
                        </ul>
                    </div>

                    <div class="form-group">
                        <label for="valores">
                            Lista de Valores Corporativos:
                            <% if (modoColaborativo && !valoresActuales.isEmpty()) { %>
                                <span style="color: #28a745; font-size: 12px;">
                                    <i class="fas fa-check-circle"></i> Datos guardados del grupo
                                </span>
                            <% } %>
                        </label>
                        <textarea 
                            id="valores" 
                            name="valores"
                            placeholder="Escriba los valores corporativos, uno por línea. Ejemplo:&#10;Integridad: Actuamos con honestidad y transparencia&#10;Excelencia: Buscamos la perfección en todo lo que hacemos&#10;Innovación: Fomentamos la creatividad y el pensamiento disruptivo"
                            <%= modoColaborativo ? "" : "readonly" %>
                            onkeyup="actualizarPreview()"
                        ><%= valoresActuales %></textarea>
                    </div>

                    <% if (modoColaborativo) { %>
                        <div style="margin-top: 20px; text-align: center;">
                            <button type="submit" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">
                                <i class="fas fa-save"></i> Guardar Valores Corporativos
                            </button>
                        </div>
                    <% } %>
                </div>
            </form>

            <!-- Vista Previa -->
            <div class="preview-card">
                <h3><i class="fas fa-eye"></i> Vista Previa de Valores</h3>
                <div class="preview-values" id="valoresPreview">
                    <% if (!valoresActuales.isEmpty()) { %>
                        <%
                            String[] lineas = valoresActuales.split("\\n");
                            for (String linea : lineas) {
                                if (linea.trim().length() > 0) {
                                    String[] partes = linea.split(":", 2);
                                    if (partes.length == 2) {
                        %>
                        <div class="value-item">
                            <h4><%= partes[0].trim() %></h4>
                            <p><%= partes[1].trim() %></p>
                        </div>
                        <%
                                    } else {
                        %>
                        <div class="value-item">
                            <h4>Valor</h4>
                            <p><%= linea.trim() %></p>
                        </div>
                        <%
                                    }
                                }
                            }
                        %>
                    <% } else { %>
                        <div class="value-item">
                            <h4>Los valores aparecerán aquí</h4>
                            <p>Escriba los valores en el formato "Valor: Descripción" para verlos aquí.</p>
                        </div>
                    <% } %>
                </div>
            </div>

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
            const valores = document.getElementById('valores').value;
            const preview = document.getElementById('valoresPreview');
            
            if (valores.trim()) {
                const lineas = valores.split('\n');
                let html = '';
                
                lineas.forEach(linea => {
                    linea = linea.trim();
                    if (linea.length > 0) {
                        const partes = linea.split(':', 2);
                        if (partes.length === 2) {
                            html += `
                                <div class="value-item">
                                    <h4>${partes[0].trim()}</h4>
                                    <p>${partes[1].trim()}</p>
                                </div>
                            `;
                        } else {
                            html += `
                                <div class="value-item">
                                    <h4>Valor</h4>
                                    <p>${linea}</p>
                                </div>
                            `;
                        }
                    }
                });
                
                if (html === '') {
                    html = `
                        <div class="value-item">
                            <h4>Los valores aparecerán aquí</h4>
                            <p>Escriba los valores en el formato "Valor: Descripción" para verlos aquí.</p>
                        </div>
                    `;
                }
                
                preview.innerHTML = html;
            } else {
                preview.innerHTML = `
                    <div class="value-item">
                        <h4>Los valores aparecerán aquí</h4>
                        <p>Escriba los valores en el formato "Valor: Descripción" para verlos aquí.</p>
                    </div>
                `;
            }
        }
    </script>
    <% if (modoColaborativo) { %>
    <script>
        // Auto-refresh cada 15 segundos para ver cambios de otros usuarios
        setInterval(function() {
            // Solo recargar si no hay cambios sin guardar
            const valoresInput = document.getElementById('valores');
            
            if (!valoresInput.dataset.changed) {
                location.reload();
            }
        }, 15000);

        // Marcar como cambiado cuando el usuario escribe
        document.getElementById('valores').addEventListener('input', function() {
            this.dataset.changed = 'true';
        });
    </script>
    <% } %>
</body>
</html>