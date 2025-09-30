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
    String nombreEmpresa = "";
    String sectorEmpresa = "";
    String ubicacionEmpresa = "";
    String descripcionEmpresa = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevoNombre = request.getParameter("nombre_empresa");
        String nuevoSector = request.getParameter("sector_empresa");
        String nuevaUbicacion = request.getParameter("ubicacion_empresa");
        String nuevaDescripcion = request.getParameter("descripcion_empresa");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevoNombre != null && !nuevoNombre.trim().isEmpty()) {
                ClsEPeti datoNombre = new ClsEPeti(grupoId, "empresa", "nombre", nuevoNombre.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoNombre);
            }
            if (nuevoSector != null && !nuevoSector.trim().isEmpty()) {
                ClsEPeti datoSector = new ClsEPeti(grupoId, "empresa", "sector", nuevoSector.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoSector);
            }
            if (nuevaUbicacion != null && !nuevaUbicacion.trim().isEmpty()) {
                ClsEPeti datoUbicacion = new ClsEPeti(grupoId, "empresa", "ubicacion", nuevaUbicacion.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoUbicacion);
            }
            if (nuevaDescripcion != null && !nuevaDescripcion.trim().isEmpty()) {
                ClsEPeti datoDescripcion = new ClsEPeti(grupoId, "empresa", "descripcion", nuevaDescripcion.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoDescripcion);
            }
            
            if (exito) {
                mensaje = "Información de la empresa guardada exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar algunos datos";
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
            Map<String, String> datosEmpresa = negocioPeti.obtenerDatosSeccion(grupoId, "empresa");
            
            if (datosEmpresa.containsKey("nombre")) {
                nombreEmpresa = datosEmpresa.get("nombre");
            }
            if (datosEmpresa.containsKey("sector")) {
                sectorEmpresa = datosEmpresa.get("sector");
            }
            if (datosEmpresa.containsKey("ubicacion")) {
                ubicacionEmpresa = datosEmpresa.get("ubicacion");
            }
            if (datosEmpresa.containsKey("descripcion")) {
                descripcionEmpresa = datosEmpresa.get("descripcion");
            }
        } catch (Exception e) {
    // System.err.println("Error al cargar datos: " + e.getMessage());
            }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Información de la Empresa - PETI Colaborativo</title>
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

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }

        .form-section {
            margin-bottom: 25px;
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

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
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

        .preview-item {
            display: flex;
            margin-bottom: 10px;
        }

        .preview-item strong {
            min-width: 120px;
            color: #666;
        }

        .preview-item span {
            color: #333;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <i class="fas fa-building"></i> Información de la Empresa
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
                <div class="form-grid">
                    <div>
                        <div class="form-section">
                            <h3><i class="fas fa-info-circle"></i> Datos Básicos</h3>
                            
                            <div class="form-group">
                                <label for="nombre_empresa">
                                    Nombre de la Empresa:
                                    <% if (modoColaborativo && !nombreEmpresa.isEmpty()) { %>
                                        <span style="color: #28a745; font-size: 12px;">
                                            <i class="fas fa-check-circle"></i> Guardado
                                        </span>
                                    <% } %>
                                </label>
                                <input 
                                    type="text" 
                                    id="nombre_empresa" 
                                    name="nombre_empresa"
                                    placeholder="Ej: TechSolutions S.A.C."
                                    value="<%= nombreEmpresa %>"
                                    <%= modoColaborativo ? "" : "readonly" %>
                                >
                            </div>

                            <div class="form-group">
                                <label for="sector_empresa">
                                    Sector/Industria:
                                    <% if (modoColaborativo && !sectorEmpresa.isEmpty()) { %>
                                        <span style="color: #28a745; font-size: 12px;">
                                            <i class="fas fa-check-circle"></i> Guardado
                                        </span>
                                    <% } %>
                                </label>
                                <select 
                                    id="sector_empresa" 
                                    name="sector_empresa"
                                    <%= modoColaborativo ? "" : "disabled" %>
                                >
                                    <option value="">Seleccione un sector</option>
                                    <option value="Tecnología" <%= "Tecnología".equals(sectorEmpresa) ? "selected" : "" %>>Tecnología</option>
                                    <option value="Servicios" <%= "Servicios".equals(sectorEmpresa) ? "selected" : "" %>>Servicios</option>
                                    <option value="Manufactura" <%= "Manufactura".equals(sectorEmpresa) ? "selected" : "" %>>Manufactura</option>
                                    <option value="Comercio" <%= "Comercio".equals(sectorEmpresa) ? "selected" : "" %>>Comercio</option>
                                    <option value="Educación" <%= "Educación".equals(sectorEmpresa) ? "selected" : "" %>>Educación</option>
                                    <option value="Salud" <%= "Salud".equals(sectorEmpresa) ? "selected" : "" %>>Salud</option>
                                    <option value="Financiero" <%= "Financiero".equals(sectorEmpresa) ? "selected" : "" %>>Financiero</option>
                                    <option value="Otros" <%= "Otros".equals(sectorEmpresa) ? "selected" : "" %>>Otros</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="ubicacion_empresa">
                                    Ubicación Principal:
                                    <% if (modoColaborativo && !ubicacionEmpresa.isEmpty()) { %>
                                        <span style="color: #28a745; font-size: 12px;">
                                            <i class="fas fa-check-circle"></i> Guardado
                                        </span>
                                    <% } %>
                                </label>
                                <input 
                                    type="text" 
                                    id="ubicacion_empresa" 
                                    name="ubicacion_empresa"
                                    placeholder="Ej: Lima, Perú"
                                    value="<%= ubicacionEmpresa %>"
                                    <%= modoColaborativo ? "" : "readonly" %>
                                >
                            </div>
                        </div>
                    </div>

                    <div>
                        <div class="form-section">
                            <h3><i class="fas fa-file-alt"></i> Descripción</h3>
                            
                            <div class="form-group">
                                <label for="descripcion_empresa">
                                    Descripción de la Empresa:
                                    <% if (modoColaborativo && !descripcionEmpresa.isEmpty()) { %>
                                        <span style="color: #28a745; font-size: 12px;">
                                            <i class="fas fa-check-circle"></i> Guardado
                                        </span>
                                    <% } %>
                                </label>
                                <textarea 
                                    id="descripcion_empresa" 
                                    name="descripcion_empresa"
                                    placeholder="Describa brevemente a qué se dedica la empresa, sus principales productos o servicios, y cualquier información relevante..."
                                    <%= modoColaborativo ? "" : "readonly" %>
                                ><%= descripcionEmpresa %></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Vista Previa -->
                <div class="preview-card">
                    <h3><i class="fas fa-eye"></i> Vista Previa de la Empresa</h3>
                    <div class="preview-item">
                        <strong>Nombre:</strong>
                        <span id="preview_nombre"><%= !nombreEmpresa.isEmpty() ? nombreEmpresa : "No especificado" %></span>
                    </div>
                    <div class="preview-item">
                        <strong>Sector:</strong>
                        <span id="preview_sector"><%= !sectorEmpresa.isEmpty() ? sectorEmpresa : "No especificado" %></span>
                    </div>
                    <div class="preview-item">
                        <strong>Ubicación:</strong>
                        <span id="preview_ubicacion"><%= !ubicacionEmpresa.isEmpty() ? ubicacionEmpresa : "No especificado" %></span>
                    </div>
                    <div class="preview-item">
                        <strong>Descripción:</strong>
                        <span id="preview_descripcion"><%= !descripcionEmpresa.isEmpty() ? descripcionEmpresa : "No especificado" %></span>
                    </div>
                </div>

                <% if (modoColaborativo) { %>
                    <div style="margin-top: 30px; text-align: center;">
                        <button type="submit" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">
                            <i class="fas fa-save"></i> Guardar Información de la Empresa
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
        function actualizarPreviews() {
            const nombre = document.getElementById('nombre_empresa').value;
            const sector = document.getElementById('sector_empresa').value;
            const ubicacion = document.getElementById('ubicacion_empresa').value;
            const descripcion = document.getElementById('descripcion_empresa').value;
            
            document.getElementById('preview_nombre').textContent = nombre || 'No especificado';
            document.getElementById('preview_sector').textContent = sector || 'No especificado';
            document.getElementById('preview_ubicacion').textContent = ubicacion || 'No especificado';
            document.getElementById('preview_descripcion').textContent = descripcion || 'No especificado';
        }

        // Agregar listeners para actualizar preview
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = ['nombre_empresa', 'sector_empresa', 'ubicacion_empresa', 'descripcion_empresa'];
            inputs.forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    element.addEventListener('input', actualizarPreviews);
                    element.addEventListener('change', actualizarPreviews);
                }
            });
        });

        // Auto-refresh cada 15 segundos para ver cambios de otros usuarios
        <% if (modoColaborativo) { %>
        setInterval(function() {
            // Solo recargar si no hay cambios sin guardar
            const inputs = document.querySelectorAll('input, select, textarea');
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

        // Marcar como cambiado cuando el usuario escribe
        document.querySelectorAll('input, select, textarea').forEach(element => {
            element.addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
            element.addEventListener('change', function() {
                this.dataset.changed = 'true';
            });
        });
        <% } %>
    </script>
</body>
</html>