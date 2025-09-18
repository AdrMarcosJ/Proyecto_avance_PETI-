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
    <title>Análisis PEST - Plan Estratégico</title>
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

        .pest-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .pest-section {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            border-left: 4px solid;
        }

        .pest-section.political {
            border-left-color: #e74c3c;
        }

        .pest-section.economic {
            border-left-color: #f39c12;
        }

        .pest-section.social {
            border-left-color: #3498db;
        }

        .pest-section.technological {
            border-left-color: #2ecc71;
        }

        .pest-section h2 {
            margin-bottom: 20px;
            color: #2c3e50;
            font-size: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .pest-section h2 i {
            margin-right: 10px;
            font-size: 24px;
        }

        .political h2 i { color: #e74c3c; }
        .economic h2 i { color: #f39c12; }
        .social h2 i { color: #3498db; }
        .technological h2 i { color: #2ecc71; }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            resize: vertical;
            min-height: 120px;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .factor-item {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            position: relative;
        }

        .factor-item p {
            margin: 0;
            color: #555;
            line-height: 1.5;
        }

        .btn-remove {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            cursor: pointer;
            font-size: 12px;
        }

        .btn-remove:hover {
            background: #c82333;
        }

        .btn-add {
            background: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .btn-add:hover {
            background: #218838;
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
            margin-top: 20px;
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

        .factors-list {
            margin-top: 15px;
        }

        .empty-state {
            text-align: center;
            color: #6c757d;
            font-style: italic;
            padding: 20px;
            font-size: 14px;
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
            
            .pest-grid {
                grid-template-columns: 1fr;
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
                    <li class="active"><a href="pest.jsp"><i class="fas fa-list"></i> Análisis PEST</a></li>
                    <li><a href="porter.jsp"><i class="fas fa-shield-alt"></i> Porter</a></li>
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
                <h1>Análisis PEST</h1>
                <div class="header-actions">
                    <button class="btn-primary" onclick="guardarAnalisis()"><i class="fas fa-save"></i> Guardar</button>
                </div>
            </header>
            <main class="dashboard-main">
                <div class="guidelines">
                    <h4>¿Qué es el Análisis PEST?</h4>
                    <p>El análisis PEST examina los factores externos que pueden afectar a la organización: Políticos, Económicos, Sociales y Tecnológicos. Identifique los factores más relevantes para su empresa en cada categoría.</p>
                </div>
                
                <div class="pest-grid">
                    <!-- Factores Políticos -->
                    <div class="pest-section political">
                        <h2><i class="fas fa-landmark"></i> Factores Políticos</h2>
                        <div class="form-group">
                            <textarea id="politicalInput" placeholder="Ej: Cambios en regulaciones, políticas gubernamentales, estabilidad política..."></textarea>
                        </div>
                        <button class="btn-add" onclick="agregarFactor('political')">
                            <i class="fas fa-plus"></i> Agregar Factor
                        </button>
                        <div class="factors-list" id="politicalFactors">
                            <div class="empty-state">No hay factores políticos agregados</div>
                        </div>
                    </div>

                    <!-- Factores Económicos -->
                    <div class="pest-section economic">
                        <h2><i class="fas fa-chart-line"></i> Factores Económicos</h2>
                        <div class="form-group">
                            <textarea id="economicInput" placeholder="Ej: Inflación, tasas de interés, crecimiento económico, desempleo..."></textarea>
                        </div>
                        <button class="btn-add" onclick="agregarFactor('economic')">
                            <i class="fas fa-plus"></i> Agregar Factor
                        </button>
                        <div class="factors-list" id="economicFactors">
                            <div class="empty-state">No hay factores económicos agregados</div>
                        </div>
                    </div>

                    <!-- Factores Sociales -->
                    <div class="pest-section social">
                        <h2><i class="fas fa-users"></i> Factores Sociales</h2>
                        <div class="form-group">
                            <textarea id="socialInput" placeholder="Ej: Cambios demográficos, tendencias culturales, estilo de vida..."></textarea>
                        </div>
                        <button class="btn-add" onclick="agregarFactor('social')">
                            <i class="fas fa-plus"></i> Agregar Factor
                        </button>
                        <div class="factors-list" id="socialFactors">
                            <div class="empty-state">No hay factores sociales agregados</div>
                        </div>
                    </div>

                    <!-- Factores Tecnológicos -->
                    <div class="pest-section technological">
                        <h2><i class="fas fa-microchip"></i> Factores Tecnológicos</h2>
                        <div class="form-group">
                            <textarea id="technologicalInput" placeholder="Ej: Innovaciones tecnológicas, automatización, digitalización..."></textarea>
                        </div>
                        <button class="btn-add" onclick="agregarFactor('technological')">
                            <i class="fas fa-plus"></i> Agregar Factor
                        </button>
                        <div class="factors-list" id="technologicalFactors">
                            <div class="empty-state">No hay factores tecnológicos agregados</div>
                        </div>
                    </div>
                </div>
                
                <button class="btn-save" onclick="guardarAnalisis()">
                    <i class="fas fa-save"></i> Guardar Análisis PEST Completo
                </button>
            </main>
        </div>
    </div>
    
    <script>
        let pestFactors = {
            political: [],
            economic: [],
            social: [],
            technological: []
        };
        
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }
        
        function agregarFactor(category) {
            const input = document.getElementById(category + 'Input');
            const text = input.value.trim();
            
            if (!text) {
                alert('Por favor, ingrese un factor antes de agregar.');
                return;
            }
            
            const factor = {
                id: Date.now(),
                text: text
            };
            
            pestFactors[category].push(factor);
            input.value = '';
            
            renderizarFactores(category);
        }
        
        function eliminarFactor(category, id) {
            if (confirm('¿Está seguro que desea eliminar este factor?')) {
                pestFactors[category] = pestFactors[category].filter(f => f.id !== id);
                renderizarFactores(category);
            }
        }
        
        function renderizarFactores(category) {
            const container = document.getElementById(category + 'Factors');
            const factors = pestFactors[category];
            
            if (factors.length === 0) {
                container.innerHTML = '<div class="empty-state">No hay factores ' + getCategoryName(category) + ' agregados</div>';
                return;
            }
            
            const factorsHTML = factors.map(factor => `
                <div class="factor-item">
                    <button class="btn-remove" onclick="eliminarFactor('${category}', ${factor.id})">
                        <i class="fas fa-times"></i>
                    </button>
                    <p>${factor.text}</p>
                </div>
            `).join('');
            
            container.innerHTML = factorsHTML;
        }
        
        function getCategoryName(category) {
            const names = {
                political: 'políticos',
                economic: 'económicos',
                social: 'sociales',
                technological: 'tecnológicos'
            };
            return names[category];
        }
        
        function guardarAnalisis() {
            const totalFactors = Object.values(pestFactors).reduce((sum, factors) => sum + factors.length, 0);
            
            if (totalFactors === 0) {
                alert('Por favor, agregue al menos un factor en cualquier categoría antes de guardar.');
                return;
            }
            
            // Aquí se puede agregar la lógica para guardar en la base de datos
            alert(`Análisis PEST guardado exitosamente con ${totalFactors} factores.`);
        }
        
        // Cargar datos guardados al cargar la página
        window.onload = function() {
            // Aquí se puede agregar la lógica para cargar datos existentes
            Object.keys(pestFactors).forEach(category => {
                renderizarFactores(category);
            });
        };
    </script>
</body>
</html>