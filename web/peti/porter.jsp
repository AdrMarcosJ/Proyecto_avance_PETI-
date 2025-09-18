<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Obtener información del usuario
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        userEmail = "usuario@ejemplo.com";
    }
    
    // Generar iniciales del usuario
    String userInitials = "U";
    if (usuario != null && usuario.length() > 0) {
        userInitials = usuario.substring(0, 1).toUpperCase();
        if (usuario.contains(" ") && usuario.length() > usuario.indexOf(" ") + 1) {
            userInitials += usuario.substring(usuario.indexOf(" ") + 1, usuario.indexOf(" ") + 2).toUpperCase();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Análisis de Porter - Plan Estratégico</title>
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

        .porter-diagram {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            grid-template-rows: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
            height: 600px;
        }

        .porter-force {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            display: flex;
            flex-direction: column;
            border-left: 4px solid;
            position: relative;
        }

        .porter-force.suppliers {
            grid-column: 1;
            grid-row: 2;
            border-left-color: #e74c3c;
        }

        .porter-force.new-entrants {
            grid-column: 2;
            grid-row: 1;
            border-left-color: #f39c12;
        }

        .porter-force.buyers {
            grid-column: 3;
            grid-row: 2;
            border-left-color: #3498db;
        }

        .porter-force.substitutes {
            grid-column: 2;
            grid-row: 3;
            border-left-color: #9b59b6;
        }

        .porter-force.rivalry {
            grid-column: 2;
            grid-row: 2;
            border-left-color: #2ecc71;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px solid #2ecc71;
        }

        .porter-force h3 {
            margin-bottom: 15px;
            color: #2c3e50;
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .porter-force h3 i {
            margin-right: 8px;
            font-size: 18px;
        }

        .suppliers h3 i { color: #e74c3c; }
        .new-entrants h3 i { color: #f39c12; }
        .buyers h3 i { color: #3498db; }
        .substitutes h3 i { color: #9b59b6; }
        .rivalry h3 i { color: #2ecc71; }

        .form-group {
            margin-bottom: 15px;
            flex: 1;
        }

        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 13px;
            resize: vertical;
            min-height: 80px;
            height: 100%;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .intensity-selector {
            margin-top: 10px;
        }

        .intensity-selector label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #333;
            font-size: 12px;
        }

        .intensity-buttons {
            display: flex;
            gap: 5px;
        }

        .intensity-btn {
            flex: 1;
            padding: 5px 8px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 4px;
            cursor: pointer;
            font-size: 11px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .intensity-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .intensity-btn:hover {
            background: #f8f9fa;
        }

        .intensity-btn.active:hover {
            background: #5a6fd8;
        }

        .btn-save {
            background: #007bff;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }

        .btn-save:hover {
            background: #0056b3;
            transform: translateY(-1px);
        }

        .guidelines {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 0 8px 8px 0;
        }

        .guidelines h4 {
            color: #1976d2;
            margin-bottom: 10px;
        }

        .guidelines p {
            color: #555;
            margin: 0;
            font-size: 14px;
        }

        .intensity-indicator {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #ddd;
        }

        .intensity-indicator.low { background: #28a745; }
        .intensity-indicator.medium { background: #ffc107; }
        .intensity-indicator.high { background: #dc3545; }

        @media (max-width: 1200px) {
            .porter-diagram {
                grid-template-columns: 1fr 1fr;
                grid-template-rows: auto;
                height: auto;
            }
            
            .porter-force.suppliers { grid-column: 1; grid-row: 1; }
            .porter-force.new-entrants { grid-column: 2; grid-row: 1; }
            .porter-force.buyers { grid-column: 1; grid-row: 2; }
            .porter-force.substitutes { grid-column: 2; grid-row: 2; }
            .porter-force.rivalry { grid-column: 1 / 3; grid-row: 3; }
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
            
            .porter-diagram {
                grid-template-columns: 1fr;
            }
            
            .porter-force.rivalry {
                grid-column: 1;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-sidebar">
            <div class="user-profile">
                <div class="user-avatar">
                    <span><%= userInitials %></span>
                </div>
                <div class="user-info">
                    <h3><%= usuario %></h3>
                    <p><%= userEmail %></p>
                </div>
            </div>
            <nav class="dashboard-nav">
                <ul>
                    <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                    <li><a href="empresa.jsp"><i class="fas fa-building"></i> Empresa</a></li>
                    <li><a href="mision.jsp"><i class="fas fa-bullseye"></i> Misión</a></li>
                    <li><a href="vision.jsp"><i class="fas fa-eye"></i> Visión</a></li>
                    <li><a href="valores.jsp"><i class="fas fa-heart"></i> Valores</a></li>
                    <li><a href="analisis-externo.jsp"><i class="fas fa-search"></i> Análisis Externo</a></li>
                    <li><a href="analisis-interno.jsp"><i class="fas fa-chart-bar"></i> Análisis Interno</a></li>
                    <li><a href="pest.jsp"><i class="fas fa-list"></i> Análisis PEST</a></li>
                    <li class="active"><a href="porter.jsp"><i class="fas fa-shield-alt"></i> Porter</a></li>
                    <li><a href="matriz-came.jsp"><i class="fas fa-th"></i> Matriz CAME</a></li>
                    <li><a href="cadena-valor.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                    <li><a href="objetivos.jsp"><i class="fas fa-target"></i> Objetivos</a></li>
                    <li><a href="identificacion-estrategia.jsp"><i class="fas fa-lightbulb"></i> Estrategias</a></li>
                    <li><a href="matriz-participacion.jsp"><i class="fas fa-users"></i> Matriz Participación</a></li>
                    <li><a href="resumen-ejecutivo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                </ul>
            </nav>
        </div>
        <div class="dashboard-content">
            <header class="dashboard-header">
                <h1>Análisis de las 5 Fuerzas de Porter</h1>
                <div class="header-actions">
                    <button class="btn-primary" onclick="guardarAnalisis()"><i class="fas fa-save"></i> Guardar</button>
                </div>
            </header>
            <main class="dashboard-main">
                <div class="guidelines">
                    <h4>Análisis de las 5 Fuerzas de Porter</h4>
                    <p>Evalúe cada una de las cinco fuerzas competitivas que afectan a su industria. Analice la intensidad de cada fuerza y describa los factores específicos que la influencian.</p>
                </div>
                
                <div class="porter-diagram">
                    <!-- Poder de Negociación de Proveedores -->
                    <div class="porter-force suppliers">
                        <div class="intensity-indicator" id="suppliersIndicator"></div>
                        <h3><i class="fas fa-truck"></i> Poder de Proveedores</h3>
                        <div class="form-group">
                            <textarea id="suppliersText" placeholder="Analice el poder de negociación de sus proveedores: concentración, diferenciación de productos, costos de cambio, amenaza de integración vertical..."></textarea>
                        </div>
                        <div class="intensity-selector">
                            <label>Intensidad:</label>
                            <div class="intensity-buttons">
                                <button class="intensity-btn" onclick="setIntensity('suppliers', 'low')">Baja</button>
                                <button class="intensity-btn" onclick="setIntensity('suppliers', 'medium')">Media</button>
                                <button class="intensity-btn" onclick="setIntensity('suppliers', 'high')">Alta</button>
                            </div>
                        </div>
                    </div>

                    <!-- Amenaza de Nuevos Entrantes -->
                    <div class="porter-force new-entrants">
                        <div class="intensity-indicator" id="newEntrantsIndicator"></div>
                        <h3><i class="fas fa-door-open"></i> Nuevos Entrantes</h3>
                        <div class="form-group">
                            <textarea id="newEntrantsText" placeholder="Evalúe las barreras de entrada: economías de escala, diferenciación de productos, requisitos de capital, acceso a canales de distribución..."></textarea>
                        </div>
                        <div class="intensity-selector">
                            <label>Intensidad:</label>
                            <div class="intensity-buttons">
                                <button class="intensity-btn" onclick="setIntensity('newEntrants', 'low')">Baja</button>
                                <button class="intensity-btn" onclick="setIntensity('newEntrants', 'medium')">Media</button>
                                <button class="intensity-btn" onclick="setIntensity('newEntrants', 'high')">Alta</button>
                            </div>
                        </div>
                    </div>

                    <!-- Poder de Negociación de Compradores -->
                    <div class="porter-force buyers">
                        <div class="intensity-indicator" id="buyersIndicator"></div>
                        <h3><i class="fas fa-users"></i> Poder de Compradores</h3>
                        <div class="form-group">
                            <textarea id="buyersText" placeholder="Analice el poder de sus clientes: concentración de compradores, volumen de compras, sensibilidad al precio, disponibilidad de sustitutos..."></textarea>
                        </div>
                        <div class="intensity-selector">
                            <label>Intensidad:</label>
                            <div class="intensity-buttons">
                                <button class="intensity-btn" onclick="setIntensity('buyers', 'low')">Baja</button>
                                <button class="intensity-btn" onclick="setIntensity('buyers', 'medium')">Media</button>
                                <button class="intensity-btn" onclick="setIntensity('buyers', 'high')">Alta</button>
                            </div>
                        </div>
                    </div>

                    <!-- Amenaza de Productos Sustitutos -->
                    <div class="porter-force substitutes">
                        <div class="intensity-indicator" id="substitutesIndicator"></div>
                        <h3><i class="fas fa-exchange-alt"></i> Productos Sustitutos</h3>
                        <div class="form-group">
                            <textarea id="substitutesText" placeholder="Identifique productos o servicios sustitutos: disponibilidad, relación precio-rendimiento, propensión del comprador a sustituir..."></textarea>
                        </div>
                        <div class="intensity-selector">
                            <label>Intensidad:</label>
                            <div class="intensity-buttons">
                                <button class="intensity-btn" onclick="setIntensity('substitutes', 'low')">Baja</button>
                                <button class="intensity-btn" onclick="setIntensity('substitutes', 'medium')">Media</button>
                                <button class="intensity-btn" onclick="setIntensity('substitutes', 'high')">Alta</button>
                            </div>
                        </div>
                    </div>

                    <!-- Rivalidad entre Competidores -->
                    <div class="porter-force rivalry">
                        <div class="intensity-indicator" id="rivalryIndicator"></div>
                        <h3><i class="fas fa-sword"></i> Rivalidad Competitiva</h3>
                        <div class="form-group">
                            <textarea id="rivalryText" placeholder="Analice la intensidad de la competencia: número de competidores, crecimiento de la industria, diferenciación de productos, costos fijos..."></textarea>
                        </div>
                        <div class="intensity-selector">
                            <label>Intensidad:</label>
                            <div class="intensity-buttons">
                                <button class="intensity-btn" onclick="setIntensity('rivalry', 'low')">Baja</button>
                                <button class="intensity-btn" onclick="setIntensity('rivalry', 'medium')">Media</button>
                                <button class="intensity-btn" onclick="setIntensity('rivalry', 'high')">Alta</button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <button class="btn-save" onclick="guardarAnalisis()">
                    <i class="fas fa-save"></i> Guardar Análisis de Porter Completo
                </button>
            </main>
        </div>
    </div>
    
    <script>
        let porterData = {
            suppliers: { text: '', intensity: '' },
            newEntrants: { text: '', intensity: '' },
            buyers: { text: '', intensity: '' },
            substitutes: { text: '', intensity: '' },
            rivalry: { text: '', intensity: '' }
        };
        
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }
        
        function setIntensity(force, level) {
            // Remover clase active de todos los botones de esta fuerza
            const buttons = document.querySelectorAll(`.porter-force.${force} .intensity-btn`);
            buttons.forEach(btn => btn.classList.remove('active'));
            
            // Agregar clase active al botón seleccionado
            event.target.classList.add('active');
            
            // Actualizar indicador visual
            const indicator = document.getElementById(force + 'Indicator');
            indicator.className = 'intensity-indicator ' + level;
            
            // Guardar en el objeto de datos
            porterData[force].intensity = level;
        }
        
        function updateText(force) {
            const textarea = document.getElementById(force + 'Text');
            porterData[force].text = textarea.value;
        }
        
        function guardarAnalisis() {
            // Actualizar textos
            Object.keys(porterData).forEach(force => {
                const textarea = document.getElementById(force + 'Text');
                porterData[force].text = textarea.value;
            });
            
            // Verificar que al menos algunos campos estén completos
            const hasContent = Object.values(porterData).some(data => 
                data.text.trim() !== '' || data.intensity !== ''
            );
            
            if (!hasContent) {
                alert('Por favor, complete al menos una fuerza antes de guardar.');
                return;
            }
            
            // Aquí se puede agregar la lógica para guardar en la base de datos
            alert('Análisis de Porter guardado exitosamente.');
        }
        
        // Agregar event listeners para actualizar texto en tiempo real
        window.onload = function() {
            Object.keys(porterData).forEach(force => {
                const textarea = document.getElementById(force + 'Text');
                textarea.addEventListener('input', () => updateText(force));
            });
        };
    </script>
</body>
</html>