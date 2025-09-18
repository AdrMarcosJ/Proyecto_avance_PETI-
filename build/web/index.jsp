<%-- 
    Document   : index
    Created on : 15 set. 2025, 11:07:20 p. m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema de Login - Proyecto PETI</title>
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
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            .login-container {
                background: white;
                padding: 2rem;
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 400px;
                backdrop-filter: blur(10px);
            }
            
            .login-header {
                text-align: center;
                margin-bottom: 2rem;
            }
            
            .login-header h1 {
                color: #333;
                font-size: 2rem;
                margin-bottom: 0.5rem;
            }
            
            .login-header p {
                color: #666;
                font-size: 0.9rem;
            }
            
            .form-group {
                margin-bottom: 1.5rem;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                color: #333;
                font-weight: 500;
            }
            
            .form-group input {
                width: 100%;
                padding: 0.75rem;
                border: 2px solid #e1e5e9;
                border-radius: 8px;
                font-size: 1rem;
                transition: border-color 0.3s ease;
            }
            
            .form-group input:focus {
                outline: none;
                border-color: #667eea;
            }
            
            .optional-field {
                position: relative;
            }
            
            .optional-label {
                font-size: 0.8rem;
                color: #888;
                font-style: italic;
            }
            
            .btn-login {
                width: 100%;
                padding: 0.75rem;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.2s ease;
            }
            
            .btn-login:hover {
                transform: translateY(-2px);
            }
            
            .divider {
                text-align: center;
                margin: 1.5rem 0;
                position: relative;
            }
            
            .divider::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 1px;
                background: #e1e5e9;
            }
            
            .divider span {
                background: white;
                padding: 0 1rem;
                color: #666;
                font-size: 0.9rem;
            }
            
            .info-box {
                background: #f8f9fa;
                border-left: 4px solid #667eea;
                padding: 1rem;
                margin-top: 1.5rem;
                border-radius: 0 8px 8px 0;
            }
            
            .info-box h4 {
                color: #333;
                margin-bottom: 0.5rem;
                font-size: 0.9rem;
            }
            
            .info-box p {
                color: #666;
                font-size: 0.8rem;
                line-height: 1.4;
            }
            
            .alert {
                padding: 1rem;
                border-radius: 8px;
                margin-bottom: 1rem;
                font-size: 0.9rem;
            }
            
            .alert-error {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
            }
            
            .alert-success {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
            }
            
            /* Estilos para las pestañas */
            .tabs {
                display: flex;
                margin-bottom: 0;
                background: white;
                border-radius: 15px 15px 0 0;
                overflow: hidden;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            }
            
            .tab-button {
                flex: 1;
                padding: 1rem 2rem;
                border: none;
                background: #f8f9fa;
                color: #666;
                cursor: pointer;
                font-size: 1rem;
                font-weight: 500;
                transition: all 0.3s ease;
                border-bottom: 3px solid transparent;
            }
            
            .tab-button.active {
                background: white;
                color: #667eea;
                border-bottom-color: #667eea;
            }
            
            .tab-button:hover {
                background: #e9ecef;
                color: #495057;
            }
            
            .tab-button.active:hover {
                background: white;
                color: #667eea;
            }
            
            /* Estilos para el contenido de las pestañas */
            .tab-content {
                display: none;
                border-radius: 0 0 15px 15px;
            }
            
            .tab-content.active {
                display: block;
            }
            
            /* Ajustar el border-radius del primer tab-content */
            #loginTab {
                border-radius: 0 0 15px 15px;
            }
        </style>
    </head>
    <body>
        <!-- Pestañas para alternar entre Login y Registro -->
        <div class="tabs">
            <button class="tab-button active" onclick="showTab('login')">🔐 Iniciar Sesión</button>
            <button class="tab-button" onclick="showTab('register')">📝 Registrarse</button>
        </div>
        
        <!-- Formulario de Login -->
        <div id="loginTab" class="login-container tab-content active">
            <div class="login-header">
                <h1>Bienvenido</h1>
                <p>Inicia sesión para acceder al sistema</p>
            </div>
            
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                
                if (error != null) {
                    String mensajeError = "";
                    switch (error) {
                        case "campos_vacios":
                            mensajeError = "Por favor, completa todos los campos obligatorios.";
                            break;
                        case "credenciales_invalidas":
                            mensajeError = "Usuario o contraseña incorrectos.";
                            break;
                        case "codigo_invalido":
                            mensajeError = "El código de grupo ingresado no es válido.";
                            break;
                        case "grupo_lleno":
                            mensajeError = "El grupo ha alcanzado su límite máximo de usuarios.";
                            break;
                        case "campos_vacios_registro":
                            mensajeError = "Todos los campos obligatorios deben estar completos.";
                            break;
                        case "passwords_no_coinciden":
                            mensajeError = "Las contraseñas no coinciden.";
                            break;
                        case "password_muy_corta":
                            mensajeError = "La contraseña debe tener al menos 3 caracteres.";
                            break;
                        case "username_invalido":
                            mensajeError = "El nombre de usuario debe tener entre 3 y 50 caracteres.";
                            break;
                        case "email_invalido":
                            mensajeError = "El formato del email no es válido.";
                            break;
                        case "usuario_ya_existe":
                            mensajeError = "Este nombre de usuario ya está registrado.";
                            break;
                        case "email_ya_existe":
                            mensajeError = "Este email ya está registrado.";
                            break;
                        case "datos_duplicados":
                            mensajeError = "Los datos ingresados ya están en uso.";
                            break;
                        case "error_base_datos":
                            mensajeError = "Error de conexión con la base de datos.";
                            break;
                        case "error_interno":
                            mensajeError = "Error interno del servidor. Inténtalo más tarde.";
                            break;
                        case "error_registro":
                            mensajeError = "No se pudo completar el registro. Inténtalo de nuevo.";
                            break;
                        default:
                            mensajeError = "Ha ocurrido un error. Inténtalo de nuevo.";
                    }
            %>
                    <div class="alert alert-error">
                        <%= mensajeError %>
                    </div>
            <%
                }
                
                if (success != null) {
                    String mensajeExito = "";
                    switch (success) {
                        case "logout":
                            mensajeExito = "Has cerrado sesión correctamente.";
                            break;
                        case "registro_exitoso":
                            String usernameParam = request.getParameter("username");
                            mensajeExito = "¡Cuenta creada exitosamente" + 
                                         (usernameParam != null ? " para " + usernameParam : "") + 
                                         "! Ya puedes iniciar sesión.";
                            break;
                        default:
                            mensajeExito = "Operación realizada con éxito.";
                    }
            %>
                    <div class="alert alert-success">
                        <%= mensajeExito %>
                    </div>
            <%
                }
            %>
            
            <form action="validarLogin.jsp" method="post">
                <div class="form-group">
                    <label for="usuario">Usuario:</label>
                    <input type="text" id="usuario" name="usuario" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Contraseña:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div class="divider">
                    <span>Opcional</span>
                </div>
                
                <div class="form-group optional-field">
                    <label for="codigoGrupo">Código de Grupo <span class="optional-label">(opcional)</span>:</label>
                    <input type="text" id="codigoGrupo" name="codigoGrupo" placeholder="Ingresa el código si tienes uno">
                </div>
                
                <button type="submit" class="btn-login">Iniciar Sesión</button>
            </form>
            
            <div class="info-box">
                <h4>¿Cómo funciona?</h4>
                <p><strong>Sin código:</strong> Accederás al menú principal donde podrás crear tu propio grupo.</p>
                <p><strong>Con código:</strong> Te unirás a un grupo existente creado por otro usuario.</p>
            </div>
        </div>
        
        <!-- Formulario de Registro -->
        <div id="registerTab" class="login-container tab-content">
            <div class="login-header">
                <h1>📝 Crear Cuenta</h1>
                <p>Regístrate para crear o unirte a grupos</p>
            </div>
            
            <form action="registrarUsuario.jsp" method="post">
                <div class="form-group">
                    <label for="regUsername">👤 Usuario:</label>
                    <input type="text" id="regUsername" name="username" required 
                           placeholder="Ingresa tu nombre de usuario" maxlength="50">
                </div>
                
                <div class="form-group">
                    <label for="regPassword">🔒 Contraseña:</label>
                    <input type="password" id="regPassword" name="password" required 
                           placeholder="Ingresa tu contraseña" minlength="3">
                </div>
                
                <div class="form-group">
                    <label for="regConfirmPassword">🔒 Confirmar Contraseña:</label>
                    <input type="password" id="regConfirmPassword" name="confirmPassword" required 
                           placeholder="Confirma tu contraseña" minlength="3">
                </div>
                
                <div class="form-group">
                    <label for="regEmail">📧 Email (opcional):</label>
                    <input type="email" id="regEmail" name="email" 
                           placeholder="tu@email.com" maxlength="100">
                </div>
                
                <button type="submit" class="btn-login">✨ Crear Cuenta</button>
            </form>
        </div>
        
        <script>
            function showTab(tabName) {
                // Ocultar todos los contenidos de pestañas
                const tabContents = document.querySelectorAll('.tab-content');
                tabContents.forEach(tab => {
                    tab.classList.remove('active');
                });
                
                // Remover clase active de todos los botones
                const tabButtons = document.querySelectorAll('.tab-button');
                tabButtons.forEach(button => {
                    button.classList.remove('active');
                });
                
                // Mostrar la pestaña seleccionada
                if (tabName === 'login') {
                    document.getElementById('loginTab').classList.add('active');
                    document.querySelector('[onclick="showTab(\'login\')"]').classList.add('active');
                } else if (tabName === 'register') {
                    document.getElementById('registerTab').classList.add('active');
                    document.querySelector('[onclick="showTab(\'register\')"]').classList.add('active');
                }
            }
        </script>
    </body>
</html>
