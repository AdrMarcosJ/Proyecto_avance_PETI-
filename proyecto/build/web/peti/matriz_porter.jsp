<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener información del usuario para mostrar en el dashboard
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
    <title>Análisis Externo - Matriz de Porter</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a365d;
            --secondary-color: #2d3748;
            --accent-color: #3182ce;
            --success-color: #38a169;
            --warning-color: #d69e2e;
            --danger-color: #e53e3e;
            --light-bg: #f7fafc;
            --card-bg: #ffffff;
            --text-primary: #2d3748;
            --text-secondary: #4a5568;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        body {
            background: var(--light-bg);
            height: 100vh;
            overflow: hidden;
            color: var(--text-primary);
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
            background: var(--primary-color);
            color: white;
            padding: 0;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-lg);
            border-right: 1px solid var(--border-color);
            height: 100vh;
            overflow: hidden;
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
        }

        .company-logo {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
        }

        .company-logo i {
            font-size: 28px;
            margin-right: 12px;
            color: var(--accent-color);
        }

        .company-logo h2 {
            font-size: 20px;
            font-weight: 700;
            letter-spacing: -0.025em;
        }

        .user-profile {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            margin-top: 8px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: var(--accent-color);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            font-weight: 600;
            margin-right: 12px;
            flex-shrink: 0;
        }

        .user-info h3 {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 2px;
        }

        .user-info p {
            font-size: 12px;
            opacity: 0.7;
        }

        .dashboard-nav {
            flex: 1;
            padding: 20px 0;
            overflow-y: auto;
            overflow-x: hidden;
        }

        .nav-section {
            margin-bottom: 24px;
        }

        .nav-section-title {
            padding: 0 20px 8px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: rgba(255, 255, 255, 0.6);
        }

        .dashboard-nav ul {
            list-style: none;
            padding: 0;
        }

        .dashboard-nav li {
            margin-bottom: 2px;
        }

        .dashboard-nav a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            transition: all 0.2s ease;
            font-size: 14px;
            font-weight: 500;
            position: relative;
        }

        .dashboard-nav a i {
            margin-right: 12px;
            width: 18px;
            text-align: center;
            font-size: 16px;
        }

        .dashboard-nav a:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .dashboard-nav li.active a {
            background: var(--accent-color);
            color: white;
        }

        .dashboard-nav li.active a::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: white;
        }

        .dashboard-content {
            flex: 1;
            background: var(--light-bg);
            overflow-y: auto;
            height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 20px auto;
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }

        .header {
            background: var(--primary-color);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 1.75rem;
            margin-bottom: 10px;
            font-weight: 700;
            letter-spacing: -0.025em;
        }

        .header p {
            font-size: 0.95rem;
            opacity: 0.9;
            line-height: 1.6;
        }

        .content {
            padding: 40px;
        }

        .porter-diagram {
            position: relative;
            margin: 40px auto;
            max-width: 900px;
        }

        .context-box {
            position: absolute;
            top: -60px;
            right: 0;
            background: #f8f9fa;
            border: 2px dashed #6c757d;
            border-radius: 10px;
            padding: 15px 20px;
            max-width: 250px;
        }

        .context-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            color: #495057;
            margin-bottom: 5px;
        }

        .context-label i {
            color: var(--accent-color);
        }

        .context-content {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-top: 10px;
        }

        .context-item {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .porter-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            grid-template-rows: auto auto auto;
            gap: 20px;
            margin-top: 80px;
        }

        .force-box {
            background: var(--accent-color);
            color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: var(--shadow-md);
            position: relative;
            min-height: 150px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            transition: all 0.2s ease;
        }

        .force-box:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .force-number {
            position: absolute;
            top: 10px;
            left: 15px;
            background: white;
            color: var(--accent-color);
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.9rem;
        }

        .force-box h3 {
            font-size: 1rem;
            line-height: 1.4;
            margin: 5px 0;
            font-weight: 600;
        }

        .force-box.center {
            grid-column: 2;
            grid-row: 2;
            background: var(--primary-color);
            min-height: 180px;
            font-size: 1.1rem;
        }

        .force-box.top {
            grid-column: 2;
            grid-row: 1;
        }

        .force-box.left {
            grid-column: 1;
            grid-row: 2;
        }

        .force-box.right {
            grid-column: 3;
            grid-row: 2;
        }

        .force-box.bottom {
            grid-column: 2;
            grid-row: 3;
        }

        .axis-label {
            position: absolute;
            font-size: 0.75rem;
            color: #6c757d;
            font-weight: 600;
        }

        .axis-creation {
            bottom: -30px;
            right: 20px;
        }

        .axis-stability {
            bottom: 40px;
            left: -100px;
            writing-mode: vertical-rl;
            transform: rotate(180deg);
        }

        .info-section {
            margin-top: 60px;
            padding: 30px;
            background: var(--light-bg);
            border-radius: 12px;
        }

        .info-title {
            font-size: 1.3rem;
            color: var(--primary-color);
            margin-bottom: 20px;
            font-weight: 700;
        }

        .force-detail {
            margin-bottom: 25px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: var(--shadow-sm);
            border-left: 4px solid var(--accent-color);
        }

        .force-detail h4 {
            color: var(--primary-color);
            font-size: 1.1rem;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .force-detail h4 i {
            color: var(--accent-color);
        }

        .force-detail p {
            color: var(--text-secondary);
            line-height: 1.7;
            margin-bottom: 10px;
            text-align: justify;
        }

        .force-detail ul {
            margin-left: 20px;
            color: var(--text-secondary);
        }

        .force-detail li {
            margin-bottom: 8px;
            line-height: 1.6;
        }

        .force-detail li strong {
            color: var(--text-primary);
        }

        .note-box {
            background: #fef3c7;
            border-left: 4px solid var(--warning-color);
            padding: 15px 20px;
            margin-top: 30px;
            border-radius: 8px;
        }

        .note-box p {
            color: #78350f;
            font-style: italic;
            margin: 0;
            line-height: 1.6;
        }

        .btn-back {
            display: inline-block;
            margin: 30px auto;
            padding: 12px 30px;
            background: var(--accent-color);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.2s ease;
            box-shadow: var(--shadow-sm);
        }

        .btn-back:hover {
            background: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-back i {
            margin-right: 8px;
        }

        .btn-container {
            text-align: center;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }

            .dashboard-sidebar {
                width: 100%;
                order: 2;
            }

            .dashboard-content {
                order: 1;
            }

            .porter-grid {
                grid-template-columns: 1fr;
                grid-template-rows: auto;
            }

            .force-box.center,
            .force-box.top,
            .force-box.left,
            .force-box.right,
            .force-box.bottom {
                grid-column: 1;
                grid-row: auto;
            }

            .context-box {
                position: relative;
                top: 0;
                max-width: 100%;
                margin-bottom: 20px;
            }

            .axis-label {
                display: none;
            }

            .container {
                margin: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="company-logo">
                    <i class="fas fa-building"></i>
                    <h2>PETI System</h2>
                </div>
                <div class="user-profile">
                    <div class="user-avatar">
                        <span id="userInitials"><%= userInitials %></span>
                    </div>
                    <div class="user-info">
                        <h3 id="userName"><%= usuario %></h3>
                        <p id="userEmail"><%= userEmail %></p>
                    </div>
                </div>
            </div>
            <nav class="dashboard-nav">
    <div class="nav-section">
        <div class="nav-section-title">Principal</div>
        <ul>
            <li><a href="dashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a></li>
        </ul>
    </div>
    
    <div class="nav-section">
        <div class="nav-section-title">Planificación Estratégica</div>
        <ul>
            <li><a href="empresa_colaborativo.jsp"><i class="fas fa-building"></i> Información Empresarial</a></li>
            <li><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
            <li><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
            <li><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
            <li><a href="objetivos_colaborativo.jsp"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
        </ul>
    </div>

    <div class="nav-section">
        <div class="nav-section-title">Análisis Estratégico</div>
        <ul>
            <li><a href="analisis_externo_colaborativo.jsp"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
            <li><a href="analisis_interno_colaborativo.jsp"><i class="fas fa-chart-bar"></i> Análisis Organizacional</a></li>
        </ul>
    </div>

    <div class="nav-section">
        <div class="nav-section-title">Herramientas de Gestión</div>
        <ul>
            <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
            <li><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-users"></i> Matriz de Participación</a></li>
            <li><a href="autodiagnostico_BCG.jsp"><i class="fas fa-users"></i> autodiagnostico_BCG</a></li>
            <li class="active"><a href="matriz_porter.jsp"><i class="fas fa-industry"></i> Matriz de Porter</a></li>
            <li><a href="analisis_porter_colaborativo.jsp"><i class="fas fa-industry"></i> Análisis de Porter</a></li>
            <li><a href="ANÁLISIS EXTERNO MACROENTORNO_PEST.jsp"><i class="fas fa-industry"></i> Análisis PEST</a></li>
            <li><a href="IDENTIFICACIÓN DE ESTRATEGIAS.jsp"><i class="fas fa-industry"></i> Estrategias</a></li>
            <li><a href="MATRIZ CAME.jsp"><i class="fas fa-industry"></i> Matriz CAME</a></li>
            <li><a href="resumen-ejecutivo-colaborativo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
        </ul>
    </div>
    
    <div class="nav-section">
        <div class="nav-section-title">Sistema</div>
        <ul>
            <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
        </ul>
    </div>
</nav>
        </div>
        <div class="dashboard-content">
            <div class="container">
        <div class="header">
            <h1><i class="fas fa-industry"></i> 8. ANÁLISIS EXTERNO MICROENTORNO: MATRIZ DE PORTER</h1>
            <p>El Modelo de las 5 Fuerzas de Porter estudia un determinado negocio en función de la amenaza de nuevos competidores 
            a productos similares y también del poder de negociación de los proveedores y clientes, teniendo en cuenta el grado de 
            competencia del sector. Esto proporciona una clara imagen de la situación competitiva del mercado en concreto. El 
            conjunto de las cinco fuerzas determina la intensidad competitiva, la rentabilidad del sector y, de forma derivada, las 
            posibilidades futuras de éste. Por ejemplo, si un sector está obteniendo rendimientos excesos, es dudoso que disponga 
            de tiempo para financiar el crecimiento y el desarrollo de productos sustitutorios dentro del mismo sector.</p>
        </div>

        <div class="content">
            <div class="porter-diagram">
                <div class="context-box">
                    <div class="context-label">
                        <i class="fas fa-info-circle"></i>
                        <strong>Contexto institucional</strong>
                    </div>
                    <div class="context-content">
                        <div class="context-item">Capacea de emitir normas</div>
                    </div>
                </div>

                <div class="porter-grid">
                    <div class="force-box top">
                        <div class="force-number">1</div>
                        <h3>Amenaza de entrada de nuevos competidores</h3>
                    </div>

                    <div class="force-box left">
                        <div class="force-number">4</div>
                        <h3>Posición de fuerza de proveedores</h3>
                    </div>

                    <div class="force-box center">
                        <div class="force-number">2</div>
                        <h3>Competidores<br>Rivalidad entre las<br>Empresas del sector</h3>
                    </div>

                    <div class="force-box right">
                        <div class="force-number">5</div>
                        <h3>Posición de fuerza de clientes</h3>
                        <div class="axis-label axis-creation">Eje de creación de valor</div>
                    </div>

                    <div class="force-box bottom">
                        <div class="force-number">3</div>
                        <h3>Amenaza de llegada de nuevos productos sustitutivos</h3>
                    </div>
                </div>

                <div class="axis-label axis-stability">Eje de estabilidad</div>
            </div>

            <div class="info-section">
                <div class="info-title">Pasemos a repasar de forma abreviada como funciona cada una de las cinco fuerzas:</div>

                <div class="force-detail">
                    <h4><i class="fas fa-user-plus"></i> Amenaza de nuevos entrantes</h4>
                    <p>La aparición de nuevas empresas en el sector supone un incremento de recursos, de capacidad y el deseo de obtener una participación del mercado en detrimento de las empresas ya existentes. El resultado neto de la entrada de un nuevo competidor dependerá de hasta qué punto la capacidad de reacción de las empresas que ya están (tecnológica, financiera, productiva, etc.) y las denominadas <em>barreras de entrada al sector</em> contribuyan a evitar la invasión. Estas barreras se caracterizan por:</p>
                    <ul>
                        <li><strong>Economía de escala:</strong> Reducción de costes unitarios debido al volumen (ofrecida a menudo a reducción de precios, por el efecto experiencia). Como por ejemplo: vehículos, acciones...</li>
                        <li><strong>Grado de diferenciación del producto:</strong> Un mercado diferenciado y las clientes obliga a realizar inversiones muy fuertes en comunicación para poder configurar una imagen de marca. Los recién llegados se encuentran así con graves dificultades (bebidas carbónicas), se ven obligados a aceptar una baja de márgenes de confianza es fundamental (bancos, farmacéuticas, etc.)</li>
                        <li><strong>Necesidades de capital:</strong> La inversión puede resultar relativamente cuando éste tiene que ser desembolsado inicialmente o su recuperación, en caso de fallo, es difícil, construye una barrera muy importante (coches, acero, industria minera, etc.)</li>
                        <li><strong>Costes de cambio:</strong> Enlacen método de productos y servicios en los que comprarse tiene que asumir un coste extra si quiere cambiar. Dicho coste puede ser de tiempo, dinero, servicio técnico y psicológicos (servicios públicos que usan marcas comerciales, etc.)</li>
                        <li><strong>Acceso a los canales de distribución:</strong> El control de los canales de distribución puede dificultar seriamente el acceso a un número limitado puede obligar al competidor a los que comprar tiene que asumir un coste extra (distribuciones de gama, canales de marca comercial, etc.)</li>
                        <li><strong>Otros factores:</strong> Dentro de este apartado podemos incluir las patentes, el acceso privilegiado a materias primas, la experiencia acumulada, etc.</li>
                    </ul>
                </div>

                <div class="force-detail">
                    <h4><i class="fas fa-users"></i> Rivalidad de los competidores</h4>
                    <p>La rivalidad aparece cuando uno o varios competidores sienten la presión o ven la oportunidad de mejorar. El grado de rivalidad depende de una serie de factores estructurales, entre los que podemos destacar:</p>
                    <ul>
                        <li><strong>Gran número de competidores o competidores muy equilibrados:</strong> Igualmente tanto en el número como en cuanto a los recursos, la única forma de mejorar los resultados es quitarles a los demás participación del mercado.</li>
                        <li><strong>Crecimiento lento del mercado:</strong> Obliga a luchar por mayor participación cuando el mercado crece.</li>
                        <li><strong>Costes fijos o de almacenamiento elevados:</strong> Al darle esa situación, es necesario hacer un gran esfuerzo para operar a plena capacidad, por ello tiene que bajar los precios.</li>
                        <li><strong>Falta diferenciación de productos:</strong> El consumidor se ve atraído por el precio, y los competidores tendrán a bajarlo.</li>
                        <li><strong>Incrementos importantes de la capacidad:</strong> Si el incremento de capacidad es en saltos grandes cuando pueden verse en pagar con incrementar su capacidad, hay que hacerlo a saltos.</li>
                        <li><strong>Intereses estratégicos:</strong> En determinados mercados, puede ocurrir que varias empresas se importantes tienen, por simultáneamente sobre un mismo mercado: tienen importancia estratégica.</li>
                        <li><strong>Barreras de salida:</strong> Cuando los competidores tienen dificultades para salir de un mercado que ha perdido interés, mantienen una intensidad competitiva alta, si las barreras de salida son importantes. Entre las barreras de salida podemos destacar los activos especializados, los costes fijos de salida, las restricciones sociales (sindicatos) e intensas emocionales.</li>
                    </ul>
                </div>

                <div class="force-detail">
                    <h4><i class="fas fa-exchange-alt"></i> Presión de los productos sustitutivos</h4>
                    <p>El nivel de precio/calidad de los productos sustitutivos marca el nivel de precios de la industria. Los productos sustitutivos pueden ser los que desempeñan la misma función pero pertenecen a industrias diferentes. Acción de sustituir no siempre son absolutas, y suponen un techo en bloqueo, no hacerlo en absoluto, o cambiar de necesidad satisfecha adaptando el producto (un crucero no puede competir con el avión en el transporte de viajeros, pero es un medio de vacaciones de lujo insuperable). Desde la óptica estratégica, hay que prestar mucha atención a los "sustitutivos no evidentes" (ejemplo, jaula/conferencia contra hotel, teléfono, videoconferencia, etc.).</p>
                </div>

                <div class="force-detail">
                    <h4><i class="fas fa-shopping-cart"></i> Poder de negociación de los compradores/clientes</h4>
                    <p>Los compradores fuerzan los precios a la baja y la calidad al alta, en perjuicio de la rentabilidad del sector. Su poder de negociación es grande cuando:</p>
                    <ul>
                        <li>El volúmen de compra es importante</li>
                        <li>Están concentrados, o compran grandes volúmenes relativos</li>
                        <li>El coste de la materia prima es importante</li>
                        <li>Los productos no son diferenciados</li>
                        <li>El coste de cambio de proveedor es pequeño</li>
                        <li>Tienen bajos beneficios</li>
                        <li>Tienen información total</li>
                        <li>La calidad no es importante</li>
                    </ul>
                </div>

                <div class="force-detail">
                    <h4><i class="fas fa-truck"></i> Poder de negociación de los proveedores</h4>
                    <p>Los proveedores poderosos pueden amenazar con subir los precios y/o disminuir la calidad. Las empresas del sector pueden ver disminuidos sus beneficios si no consiguen repercutir los incrementos de costes a través del consumidor final. Su poder dependerá del grado en que estén concentrados, o compra en gran volúmenes relativos:</p>
                    <ul>
                        <li>No están obligados a competir con sustitutivos</li>
                        <li>El comprador no es un cliente importante</li>
                        <li>El producto es importante para el comprador</li>
                        <li>El producto está diferenciado</li>
                        <li>Representan una amenaza de integración</li>
                    </ul>
                </div>

                <div class="note-box">
                    <p><strong>Según Porter, estas fuerzas se encuentran en interacción y cambio permanente. Nuestro objetivo como empresa es una posición en la que se puedan defender de las amenazas que las fuerzas competitivas plantean.</strong></p>
                </div>
            </div>

            <div class="btn-container">
                <a href="dashboard.jsp" class="btn-back"><i class="fas fa-arrow-left"></i> Volver al Dashboard</a>
            </div>
        </div>
            </div>
        </div>
    </div>
    
    <script>
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }
    </script>
</body>
</html>
