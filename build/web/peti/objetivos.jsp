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
    <title>Objetivos Estratégicos - PETI</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .user-profile {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
        }

        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            color: white;
            font-weight: bold;
            font-size: 24px;
        }

        .user-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .user-email {
            font-size: 12px;
            color: #666;
        }

        .nav-menu {
            padding: 20px 0;
        }

        .nav-item {
            margin: 5px 0;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: #555;
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .nav-link:hover, .nav-link.active {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
            border-left-color: #667eea;
        }

        .nav-link i {
            margin-right: 10px;
            width: 20px;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
        }

        .content-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            font-size: 14px;
            color: #666;
        }

        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }

        .breadcrumb i {
            margin: 0 8px;
            font-size: 12px;
        }

        .section-status {
            display: inline-flex;
            align-items: center;
            background: #e8f5e8;
            color: #2e7d32;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .section-status i {
            margin-right: 5px;
        }

        .content-body {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .page-title {
            color: #333;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .page-title i {
            margin-right: 15px;
            color: #667eea;
        }

        .page-description {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .progress-bar {
            background: #f0f0f0;
            height: 8px;
            border-radius: 4px;
            margin-bottom: 30px;
            overflow: hidden;
        }

        .progress-fill {
            background: linear-gradient(90deg, #667eea, #764ba2);
            height: 100%;
            width: 60%;
            border-radius: 4px;
            transition: width 0.3s ease;
        }

        .form-section {
            margin-bottom: 30px;
            padding: 25px;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            background: #fafafa;
        }

        .form-section h2 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
            display: flex;
            align-items: center;
        }

        .form-section h2 i {
            margin-right: 10px;
            color: #667eea;
        }

        .form-group {
            margin-bottom: 20px;
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

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .required {
            color: #e74c3c;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        .objetivo-item {
            margin-bottom: 25px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: white;
        }

        .objetivo-item hr {
            margin: 0 0 20px 0;
            border: none;
            height: 1px;
            background: #e0e0e0;
        }

        .form-actions-center {
            text-align: center;
            margin: 20px 0;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            margin: 0 5px;
        }

        .btn i {
            margin-right: 8px;
        }

        .add-button {
            background: #27ae60;
            color: white;
        }

        .add-button:hover {
            background: #219a52;
            transform: translateY(-2px);
        }

        .remove-button {
            background: #e74c3c;
            color: white;
        }

        .remove-button:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }

        .remove-button:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
            transform: none;
        }

        .save-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .save-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .reset-button {
            background: #95a5a6;
            color: white;
        }

        .reset-button:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .navigation-buttons {
            display: flex;
            gap: 10px;
        }

        .prev-button {
            background: #95a5a6;
            color: white;
        }

        .prev-button:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }

        .next-button {
            background: #27ae60;
            color: white;
        }

        .next-button:hover {
            background: #219a52;
            transform: translateY(-2px);
        }

        .tips-container {
            background: #e8f4fd;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 0 8px 8px 0;
        }

        .tips-container h4 {
            color: #1976D2;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .tips-container h4 i {
            margin-right: 8px;
        }

        .tips-container ul {
            margin-left: 20px;
            color: #333;
        }

        .tips-container li {
            margin-bottom: 5px;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                order: 2;
            }
            
            .main-content {
                order: 1;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .form-actions {
                flex-direction: column;
                gap: 15px;
            }
            
            .navigation-buttons {
                width: 100%;
                justify-content: space-between;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="user-profile">
                <div class="user-avatar"><%= iniciales %></div>
                <div class="user-name"><%= nombreUsuario %></div>
                <div class="user-email"><%= emailUsuario %></div>
            </div>
            <nav class="nav-menu">
                <div class="nav-item">
                    <a href="dashboard.jsp" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        Dashboard
                    </a>
                </div>
                <div class="nav-item">
                    <a href="empresa.jsp" class="nav-link">
                        <i class="fas fa-building"></i>
                        Información de la Empresa
                    </a>
                </div>
                <div class="nav-item">
                    <a href="mision.jsp" class="nav-link">
                        <i class="fas fa-bullseye"></i>
                        Misión
                    </a>
                </div>
                <div class="nav-item">
                    <a href="vision.jsp" class="nav-link">
                        <i class="fas fa-eye"></i>
                        Visión
                    </a>
                </div>
                <div class="nav-item">
                    <a href="valores.jsp" class="nav-link">
                        <i class="fas fa-heart"></i>
                        Valores
                    </a>
                </div>
                <div class="nav-item">
                    <a href="objetivos.jsp" class="nav-link active">
                        <i class="fas fa-target"></i>
                        Objetivos Estratégicos
                    </a>
                </div>
                <div class="nav-item">
                    <a href="analisis-interno.jsp" class="nav-link">
                        <i class="fas fa-search-plus"></i>
                        Análisis Interno
                    </a>
                </div>
                <div class="nav-item">
                    <a href="analisis-externo.jsp" class="nav-link">
                        <i class="fas fa-globe"></i>
                        Análisis Externo
                    </a>
                </div>
                <div class="nav-item">
                    <a href="porter.jsp" class="nav-link">
                        <i class="fas fa-chess"></i>
                        5 Fuerzas de Porter
                    </a>
                </div>
                <div class="nav-item">
                    <a href="cadena-valor.jsp" class="nav-link">
                        <i class="fas fa-link"></i>
                        Cadena de Valor
                    </a>
                </div>
                <div class="nav-item">
                    <a href="matriz-participacion.jsp" class="nav-link">
                        <i class="fas fa-users"></i>
                        Matriz de Participación
                    </a>
                </div>
                <div class="nav-item">
                    <a href="matriz-came.jsp" class="nav-link">
                        <i class="fas fa-th"></i>
                        Matriz CAME
                    </a>
                </div>
                <div class="nav-item">
                    <a href="resumen-ejecutivo.jsp" class="nav-link">
                        <i class="fas fa-file-alt"></i>
                        Resumen Ejecutivo
                    </a>
                </div>
            </nav>
        </aside>

        <main class="main-content">
            <div class="content-header">
                <div class="breadcrumb">
                    <a href="dashboard.jsp">Dashboard</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Objetivos Estratégicos</span>
                </div>
                <div class="section-status">
                    <i class="fas fa-clock"></i>
                    En progreso
                </div>
            </div>

            <div class="content-body">
                <h1 class="page-title">
                    <i class="fas fa-target"></i>
                    Objetivos Estratégicos
                </h1>
                <p class="page-description">
                    Define los objetivos estratégicos que guiarán el desarrollo y crecimiento de tu empresa. 
                    Estos objetivos deben ser específicos, medibles, alcanzables, relevantes y con un tiempo definido (SMART).
                </p>

                <div class="progress-bar">
                    <div class="progress-fill"></div>
                </div>

                <div class="tips-container">
                    <h4><i class="fas fa-lightbulb"></i> Consejos para definir objetivos estratégicos</h4>
                    <ul>
                        <li>Utiliza la metodología SMART (Específicos, Medibles, Alcanzables, Relevantes, Temporales)</li>
                        <li>Alinea los objetivos con la misión y visión de la empresa</li>
                        <li>Considera diferentes perspectivas: financiera, clientes, procesos internos, aprendizaje</li>
                        <li>Define indicadores claros para medir el progreso</li>
                        <li>Establece plazos realistas y responsables específicos</li>
                    </ul>
                </div>

                <form id="objetivosForm">
                    <div class="form-section">
                        <h2><i class="fas fa-bullseye"></i> Objetivos Estratégicos</h2>
                        
                        <div id="objetivosContainer">
                            <div class="objetivo-item">
                                <div class="form-group">
                                    <label for="objetivo1">Objetivo 1 <span class="required">*</span></label>
                                    <input type="text" id="objetivo1" name="objetivo1" class="form-control" required>
                                    <small class="form-text">Ejemplo: "Aumentar la participación de mercado en un 15% para finales de 2023"</small>
                                </div>
                                
                                <div class="form-group">
                                    <label for="categoria1">Categoría <span class="required">*</span></label>
                                    <select id="categoria1" name="categoria1" class="form-control" required>
                                        <option value="">Seleccionar...</option>
                                        <option value="financiero">Financiero</option>
                                        <option value="clientes">Clientes</option>
                                        <option value="procesos">Procesos Internos</option>
                                        <option value="aprendizaje">Aprendizaje y Crecimiento</option>
                                        <option value="otro">Otro</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="descripcion1">Descripción <span class="required">*</span></label>
                                    <textarea id="descripcion1" name="descripcion1" class="form-control" rows="3" required></textarea>
                                    <small class="form-text">Explica en detalle qué se busca lograr con este objetivo.</small>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="indicador1">Indicador de Medición <span class="required">*</span></label>
                                        <input type="text" id="indicador1" name="indicador1" class="form-control" required>
                                        <small class="form-text">¿Cómo se medirá el éxito de este objetivo?</small>
                                    </div>
                                    
                                    <div class="form-group col-md-6">
                                        <label for="meta1">Meta <span class="required">*</span></label>
                                        <input type="text" id="meta1" name="meta1" class="form-control" required>
                                        <small class="form-text">Valor específico a alcanzar.</small>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="plazo1">Plazo <span class="required">*</span></label>
                                        <input type="date" id="plazo1" name="plazo1" class="form-control" required>
                                    </div>
                                    
                                    <div class="form-group col-md-6">
                                        <label for="responsable1">Responsable <span class="required">*</span></label>
                                        <input type="text" id="responsable1" name="responsable1" class="form-control" required>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="recursos1">Recursos Necesarios</label>
                                    <textarea id="recursos1" name="recursos1" class="form-control" rows="2"></textarea>
                                    <small class="form-text">Describe los recursos humanos, financieros o materiales necesarios.</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-actions-center">
                            <button type="button" class="btn add-button" id="addObjetivoBtn"><i class="fas fa-plus"></i> Agregar otro objetivo</button>
                            <button type="button" class="btn remove-button" id="removeObjetivoBtn"><i class="fas fa-minus"></i> Eliminar último objetivo</button>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h2>Alineación Estratégica</h2>
                        
                        <div class="form-group">
                            <label for="alineacion">¿Cómo se alinean estos objetivos con la misión y visión? <span class="required">*</span></label>
                            <textarea id="alineacion" name="alineacion" class="form-control" rows="3" required></textarea>
                            <small class="form-text">Explica cómo estos objetivos contribuyen a cumplir la misión y alcanzar la visión de la empresa.</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="prioridades">Priorización de Objetivos <span class="required">*</span></label>
                            <textarea id="prioridades" name="prioridades" class="form-control" rows="3" required></textarea>
                            <small class="form-text">Establece el orden de prioridad de los objetivos y justifica esta priorización.</small>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn save-button"><i class="fas fa-save"></i> Guardar</button>
                        <button type="button" class="btn reset-button"><i class="fas fa-undo"></i> Restablecer</button>
                        <div class="navigation-buttons">
                            <a href="valores.jsp" class="btn prev-button"><i class="fas fa-arrow-left"></i> Anterior: Valores</a>
                            <a href="analisis-interno.jsp" class="btn next-button"><i class="fas fa-arrow-right"></i> Siguiente: Análisis Interno</a>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <script src="js/auth.js"></script>
    <script src="js/storage.js"></script>
    <script src="js/navigation.js"></script>
    <script src="js/forms.js"></script>
    <script src="js/progress.js"></script>
    <script>
        // Script específico para esta página
        document.addEventListener('DOMContentLoaded', function() {
            const objetivosContainer = document.getElementById('objetivosContainer');
            const addObjetivoBtn = document.getElementById('addObjetivoBtn');
            const removeObjetivoBtn = document.getElementById('removeObjetivoBtn');
            let objetivoCount = 1;
            
            // Función para agregar un nuevo objetivo
            addObjetivoBtn.addEventListener('click', function() {
                objetivoCount++;
                const objetivoItem = document.createElement('div');
                objetivoItem.className = 'objetivo-item';
                objetivoItem.innerHTML = `
                    <hr>
                    <div class="form-group">
                        <label for="objetivo${objetivoCount}">Objetivo ${objetivoCount} <span class="required">*</span></label>
                        <input type="text" id="objetivo${objetivoCount}" name="objetivo${objetivoCount}" class="form-control" required>
                        <small class="form-text">Ejemplo: "Aumentar la participación de mercado en un 15% para finales de 2023"</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="categoria${objetivoCount}">Categoría <span class="required">*</span></label>
                        <select id="categoria${objetivoCount}" name="categoria${objetivoCount}" class="form-control" required>
                            <option value="">Seleccionar...</option>
                            <option value="financiero">Financiero</option>
                            <option value="clientes">Clientes</option>
                            <option value="procesos">Procesos Internos</option>
                            <option value="aprendizaje">Aprendizaje y Crecimiento</option>
                            <option value="otro">Otro</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="descripcion${objetivoCount}">Descripción <span class="required">*</span></label>
                        <textarea id="descripcion${objetivoCount}" name="descripcion${objetivoCount}" class="form-control" rows="3" required></textarea>
                        <small class="form-text">Explica en detalle qué se busca lograr con este objetivo.</small>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="indicador${objetivoCount}">Indicador de Medición <span class="required">*</span></label>
                            <input type="text" id="indicador${objetivoCount}" name="indicador${objetivoCount}" class="form-control" required>
                            <small class="form-text">¿Cómo se medirá el éxito de este objetivo?</small>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="meta${objetivoCount}">Meta <span class="required">*</span></label>
                            <input type="text" id="meta${objetivoCount}" name="meta${objetivoCount}" class="form-control" required>
                            <small class="form-text">Valor específico a alcanzar.</small>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="plazo${objetivoCount}">Plazo <span class="required">*</span></label>
                            <input type="date" id="plazo${objetivoCount}" name="plazo${objetivoCount}" class="form-control" required>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="responsable${objetivoCount}">Responsable <span class="required">*</span></label>
                            <input type="text" id="responsable${objetivoCount}" name="responsable${objetivoCount}" class="form-control" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="recursos${objetivoCount}">Recursos Necesarios</label>
                        <textarea id="recursos${objetivoCount}" name="recursos${objetivoCount}" class="form-control" rows="2"></textarea>
                        <small class="form-text">Describe los recursos humanos, financieros o materiales necesarios.</small>
                    </div>
                `;
                objetivosContainer.appendChild(objetivoItem);
                
                // Actualizar el estado del botón de eliminar
                removeObjetivoBtn.disabled = false;
            });
            
            // Función para eliminar el último objetivo
            removeObjetivoBtn.addEventListener('click', function() {
                if (objetivoCount > 1) {
                    objetivosContainer.removeChild(objetivosContainer.lastChild);
                    objetivoCount--;
                    
                    // Deshabilitar el botón si solo queda un objetivo
                    if (objetivoCount === 1) {
                        removeObjetivoBtn.disabled = true;
                    }
                }
            });
            
            // Inicializar el estado del botón de eliminar
            removeObjetivoBtn.disabled = (objetivoCount === 1);
        });
    </script>
</body>
</html>