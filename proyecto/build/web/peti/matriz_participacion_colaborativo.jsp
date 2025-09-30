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
    
    // Variables para la matriz de participación
    String directivosEjecutivos = "";
    String gerentesDirectores = "";
    String jefesCoordinadores = "";
    String supervisoresLideres = "";
    String operativosEspecialistas = "";
    String consultoresExternos = "";
    String stakeholdersClaves = "";
    String comitesGrupos = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevosDirectivos = request.getParameter("directivos");
        String nuevosGerentes = request.getParameter("gerentes");
        String nuevosJefes = request.getParameter("jefes");
        String nuevosSupervisores = request.getParameter("supervisores");
        String nuevosOperativos = request.getParameter("operativos");
        String nuevosConsultores = request.getParameter("consultores");
        String nuevosStakeholders = request.getParameter("stakeholders");
        String nuevosComites = request.getParameter("comites");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevosDirectivos != null && !nuevosDirectivos.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "directivos", nuevosDirectivos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosGerentes != null && !nuevosGerentes.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "gerentes", nuevosGerentes.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosJefes != null && !nuevosJefes.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "jefes", nuevosJefes.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosSupervisores != null && !nuevosSupervisores.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "supervisores", nuevosSupervisores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosOperativos != null && !nuevosOperativos.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "operativos", nuevosOperativos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosConsultores != null && !nuevosConsultores.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "consultores", nuevosConsultores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosStakeholders != null && !nuevosStakeholders.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "stakeholders", nuevosStakeholders.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosComites != null && !nuevosComites.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "comites", nuevosComites.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Matriz de Participación guardada exitosamente";
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
            Map<String, String> datosMatriz = negocioPeti.obtenerDatosSeccion(grupoId, "matriz_participacion");
            
            directivosEjecutivos = datosMatriz.getOrDefault("directivos", "");
            gerentesDirectores = datosMatriz.getOrDefault("gerentes", "");
            jefesCoordinadores = datosMatriz.getOrDefault("jefes", "");
            supervisoresLideres = datosMatriz.getOrDefault("supervisores", "");
            operativosEspecialistas = datosMatriz.getOrDefault("operativos", "");
            consultoresExternos = datosMatriz.getOrDefault("consultores", "");
            stakeholdersClaves = datosMatriz.getOrDefault("stakeholders", "");
            comitesGrupos = datosMatriz.getOrDefault("comites", "");
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
    <title>Matriz de Participación - PETI Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #667eea 100%);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 40% 40%, rgba(120, 119, 198, 0.2) 0%, transparent 50%);
            pointer-events: none;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 20px;
            position: relative;
            z-index: 1;
        }

        .header {
            background: linear-gradient(145deg, rgba(255, 255, 255, 0.25), rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 35px 40px;
            border-radius: 25px;
            margin-bottom: 40px;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.15),
                inset 0 1px 0 rgba(255, 255, 255, 0.4);
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
            border-radius: 25px 25px 0 0;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 25px;
        }

        .header h1 {
            color: white;
            font-size: 2.8rem;
            font-weight: 700;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            display: flex;
            align-items: center;
            gap: 20px;
            letter-spacing: -0.5px;
        }

        .header h1 i {
            color: #f093fb;
            filter: drop-shadow(0 2px 10px rgba(240, 147, 251, 0.5));
        }

        .header p {
            color: rgba(255, 255, 255, 0.95);
            font-size: 1.2rem;
            font-weight: 500;
            margin-top: 12px;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        .header p strong {
            color: #f093fb;
            font-weight: 700;
        }

        .nav-buttons {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 16px 28px;
            border: none;
            border-radius: 15px;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            position: relative;
            overflow: hidden;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.6s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #667eea 0%, #2a5298 100%);
            color: white;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.25);
        }

        .btn:active {
            transform: translateY(-1px) scale(0.98);
        }

        .content {
            background: linear-gradient(145deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0.05));
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 25px;
            padding: 40px;
            box-shadow: 
                0 25px 70px rgba(0, 0, 0, 0.15),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
            margin-bottom: 30px;
        }

        .matriz-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .participante-card {
            background: linear-gradient(145deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            padding: 30px;
            border-radius: 20px;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }

        .participante-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 20px 20px 0 0;
        }

        .participante-card:hover {
            transform: translateY(-5px);
            box-shadow: 
                0 20px 50px rgba(0, 0, 0, 0.2),
                inset 0 1px 0 rgba(255, 255, 255, 0.4);
            border-color: rgba(255, 255, 255, 0.4);
        }

        .participante-title {
            color: white;
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
        }

        .participante-title::before {
            content: '';
            width: 8px;
            height: 8px;
            background: linear-gradient(135deg, #f093fb, #667eea);
            border-radius: 50%;
            box-shadow: 0 2px 8px rgba(240, 147, 251, 0.5);
        }

        .form-group textarea {
            width: 100%;
            padding: 20px;
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            color: white;
            font-size: 16px;
            min-height: 140px;
            resize: vertical;
            transition: all 0.3s ease;
            font-family: inherit;
            line-height: 1.6;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: rgba(240, 147, 251, 0.8);
            box-shadow: 
                0 0 0 3px rgba(240, 147, 251, 0.2),
                0 8px 25px rgba(0, 0, 0, 0.15);
            background: rgba(255, 255, 255, 0.15);
        }

        .form-group textarea::placeholder {
            color: rgba(255, 255, 255, 0.6);
            font-style: italic;
        }

        .form-group label {
            color: rgba(255, 255, 255, 0.95);
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 12px;
            display: block;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
        }

        .btn-save {
            background: linear-gradient(135deg, #10ac84 0%, #1dd1a1 100%);
            color: white;
            border: none;
            padding: 18px 35px;
            border-radius: 15px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.4s ease;
            box-shadow: 0 10px 30px rgba(16, 172, 132, 0.4);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 30px;
            width: 100%;
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
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.6s;
        }

        .btn-save:hover::before {
            left: 100%;
        }

        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(16, 172, 132, 0.5);
        }

        .btn-save:active {
            transform: translateY(-1px);
        }

        .alert {
            padding: 20px 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            font-weight: 600;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: slideInDown 0.5s ease;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 172, 132, 0.9), rgba(29, 209, 161, 0.8));
            color: white;
            box-shadow: 0 10px 30px rgba(16, 172, 132, 0.3);
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(231, 76, 60, 0.9), rgba(192, 57, 43, 0.8));
            color: white;
            box-shadow: 0 10px 30px rgba(231, 76, 60, 0.3);
        }

        @keyframes slideInDown {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 20px 15px;
            }
            
            .header {
                padding: 25px 20px;
            }
            
            .header h1 {
                font-size: 2.2rem;
            }
            
            .header-content {
                flex-direction: column;
                text-align: center;
            }
            
            .nav-buttons {
                width: 100%;
                justify-content: center;
            }
            
            .matriz-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .content {
                padding: 25px 20px;
            }
        }

        @media (max-width: 480px) {
            .header h1 {
                font-size: 1.8rem;
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
            
            .btn {
                padding: 14px 20px;
                font-size: 0.9rem;
                width: 100%;
                justify-content: center;
            }
            
            .nav-buttons {
                flex-direction: column;
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-content">
                <div>
                    <h1><i class="fas fa-sitemap"></i> Matriz de Participación</h1>
                    <p style="color: white;">Grupo: <strong><%= grupoActual %></strong></p>
                </div>
                <div class="nav-buttons">
                    <a href="dashboard.jsp" class="btn btn-primary">
                        🏠 Dashboard
                    </a>
                    <a href="../menuprincipal.jsp" class="btn btn-secondary">
                        📋 Menú Principal
                    </a>
                </div>
            </div>
        </div>

        <div class="content">
            <% if (!mensaje.isEmpty()) { %>
                <div class="alert alert-<%= tipoMensaje %>">
                    <%= mensaje %>
                </div>
            <% } %>

            <% if (!modoColaborativo) { %>
                <div class="alert alert-error">
                    Error: Debes estar en un grupo para acceder a esta página.
                </div>
            <% } else { %>

            <form method="post" action="">
                <div class="matriz-grid">
                    <div class="participante-card">
                        <h3 class="participante-title">
                            <i class="fas fa-user-tie"></i>
                            Directivos/Ejecutivos
                        </h3>
                        <div class="form-group">
                            <textarea id="directivos" name="directivos" 
                                      placeholder="Define roles, responsabilidades y nivel de participación de directivos y ejecutivos en el PETI..."
                                      ><%= directivosEjecutivos %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <h3 class="participante-title">
                            <i class="fas fa-users-cog"></i>
                            Gerentes/Directores
                        </h3>
                        <div class="form-group">
                            <textarea id="gerentes" name="gerentes" 
                                      placeholder="Define roles, responsabilidades y nivel de participación de gerentes y directores..."
                                      ><%= gerentesDirectores %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <h3 class="participante-title">
                            <i class="fas fa-user-friends"></i>
                            Jefes/Coordinadores
                        </h3>
                        <div class="form-group">
                            <textarea id="jefes" name="jefes" 
                                      placeholder="Define roles, responsabilidades y nivel de participación de jefes y coordinadores..."
                                      ><%= jefesCoordinadores %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <h3 class="participante-title">
                            <i class="fas fa-user-check"></i>
                            Supervisores/Líderes
                        </h3>
                        <div class="form-group">
                            <textarea id="supervisores" name="supervisores" 
                                      placeholder="Define roles, responsabilidades y nivel de participación de supervisores y líderes..."
                                      ><%= supervisoresLideres %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <h3 class="participante-title">
                            <i class="fas fa-laptop-code"></i>
                            Operativos/Especialistas
                        </h3>
                        <div class="form-group">
                            <textarea id="operativos" name="operativos" 
                                      placeholder="Define roles, responsabilidades y nivel de participación del personal operativo y especialistas técnicos..."
                                      ><%= operativosEspecialistas %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <h3 class="participante-title">
                            <i class="fas fa-handshake"></i>
                            Consultores/Externos
                        </h3>
                        <div class="form-group">
                            <textarea id="consultores" name="consultores" 
                                      placeholder="Define roles, responsabilidades y nivel de participación de consultores y personal externo..."
                                      ><%= consultoresExternos %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <h3 class="participante-title">
                            <i class="fas fa-star"></i>
                            Stakeholders Clave
                        </h3>
                        <div class="form-group">
                            <textarea id="stakeholders" name="stakeholders" 
                                      placeholder="Define roles, responsabilidades y nivel de participación de stakeholders clave y otros interesados..."
                                      ><%= stakeholdersClaves %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <h3 class="participante-title">
                            <i class="fas fa-users"></i>
                            Comités/Grupos
                        </h3>
                        <div class="form-group">
                            <textarea id="comites" name="comites" 
                                      placeholder="Define la participación de comités, grupos de trabajo y otras estructuras organizacionales..."
                                      ><%= comitesGrupos %></textarea>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn-save">
                    <i class="fas fa-save"></i> Guardar Matriz
                </button>
            </form>

            <% } %>
        </div>
    </div>

    <script>
        // JavaScript simplificado estilo visión
        console.log('=== MATRIZ PARTICIPACION ===');
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM cargado correctamente');
            
            // Solo marcar cambios
            document.querySelectorAll('textarea').forEach(element => {
                element.addEventListener('input', function() {
                    this.dataset.changed = 'true';
                });
            });
            
            // Auto-refresh cada 30 segundos
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
            }, 30000);
        });
    </script>
</body>
</html>