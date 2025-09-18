<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%
    // Verificar si el usuario está autenticado
    String usuario = (String) session.getAttribute("usuario");
    String email = (String) session.getAttribute("email");
    
    if (usuario == null || email == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Obtener las iniciales del usuario
    String iniciales = "";
    if (usuario != null && !usuario.isEmpty()) {
        String[] nombres = usuario.split(" ");
        for (String nombre : nombres) {
            if (!nombre.isEmpty()) {
                iniciales += nombre.charAt(0);
            }
        }
        iniciales = iniciales.toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Matriz de Participación - Plan Estratégico</title>
    <link rel="stylesheet" href="estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar de navegación -->
        <div class="dashboard-sidebar">
            <div class="user-profile">
                <div class="user-avatar">
                    <span id="userInitials"><%= iniciales %></span>
                </div>
                <div class="user-info">
                    <h3 id="userName"><%= usuario %></h3>
                    <p id="userEmail"><%= email %></p>
                </div>
            </div>
            
            <!-- Navegación principal -->
            <nav class="dashboard-nav">
                <ul>
                    <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                    <li class="active"><a href="empresa.jsp"><i class="fas fa-file-alt"></i> Plan Estratégico</a></li>
                    <li><a href="#"><i class="fas fa-user"></i> Perfil</a></li>
                    <li><a href="#"><i class="fas fa-cog"></i> Configuración</a></li>
                    <li><a href="#" id="logoutBtn"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                </ul>
            </nav>
            
            <!-- Navegación del plan estratégico -->
            <div class="plan-nav-container">
                <h3>Plan Estratégico</h3>
                <!-- El menú se generará con JavaScript -->
            </div>
        </div>
        
        <!-- Contenido principal -->
        <div class="dashboard-content">
            <!-- Encabezado -->
            <header class="dashboard-header">
                <div class="breadcrumb-container">
                    <ul class="breadcrumb">
                        <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                        <li><a href="empresa.jsp">Información de la Empresa</a></li>
                        <li><a href="cadena-valor.jsp">Cadena de Valor</a></li>
                        <li>Matriz de Participación</li>
                    </ul>
                </div>
                <div class="header-actions">
                    <span class="section-status pending"><i class="fas fa-clock"></i> Pendiente</span>
                </div>
            </header>
            
            <!-- Contenido de la sección -->
            <main class="dashboard-main">
                <div class="plan-section">
                    <h1><i class="fas fa-users"></i> Matriz de Participación (Stakeholders)</h1>
                    <p class="section-description">
                        El análisis de stakeholders o grupos de interés permite identificar a las personas, grupos u organizaciones que pueden afectar o verse afectados por las actividades y decisiones de la empresa. Este análisis es fundamental para desarrollar estrategias que consideren las expectativas y necesidades de todos los involucrados.
                    </p>
                    
                    <!-- Barra de progreso -->
                    <div class="progress-bar-container">
                        <div class="progress">
                            <div class="progress-bar" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <div class="progress-text">0% Completado</div>
                    </div>
                    
                    <!-- Formulario -->
                    <form class="plan-form">
                        <div class="form-section">
                            <h2>Identificación de Stakeholders</h2>
                            <p class="section-intro">Identifique todos los grupos de interés relevantes para su empresa, tanto internos como externos.</p>
                            
                            <div class="tips-container">
                                <h3><i class="fas fa-lightbulb"></i> Instrucciones</h3>
                                <p>Para cada stakeholder, considere:</p>
                                <ol>
                                    <li>Su nivel de interés en las actividades de la empresa</li>
                                    <li>Su nivel de poder o influencia sobre la empresa</li>
                                    <li>Su actitud actual hacia la empresa (positiva, neutral o negativa)</li>
                                    <li>Estrategias específicas para gestionar la relación</li>
                                </ol>
                            </div>
                            
                            <!-- Stakeholders internos -->
                            <div class="subsection">
                                <h3>Stakeholders Internos</h3>
                                <p class="subsection-intro">Personas o grupos dentro de la organización que tienen interés o influencia en el éxito de la empresa.</p>
                                
                                <div id="stakeholdersInternosContainer">
                                    <!-- Plantilla para stakeholder interno -->
                                    <div class="stakeholder-item">
                                        <div class="form-group">
                                            <label for="nombreStakeholderInterno1">Nombre del stakeholder <span class="required">*</span></label>
                                            <input type="text" id="nombreStakeholderInterno1" name="nombreStakeholderInterno1" class="form-control" required>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="interesStakeholderInterno1">Nivel de interés <span class="required">*</span></label>
                                                <select id="interesStakeholderInterno1" name="interesStakeholderInterno1" class="form-control" required>
                                                    <option value="">Seleccionar...</option>
                                                    <option value="alto">Alto</option>
                                                    <option value="medio">Medio</option>
                                                    <option value="bajo">Bajo</option>
                                                </select>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="poderStakeholderInterno1">Nivel de poder/influencia <span class="required">*</span></label>
                                                <select id="poderStakeholderInterno1" name="poderStakeholderInterno1" class="form-control" required>
                                                    <option value="">Seleccionar...</option>
                                                    <option value="alto">Alto</option>
                                                    <option value="medio">Medio</option>
                                                    <option value="bajo">Bajo</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="actitudStakeholderInterno1">Actitud hacia la empresa <span class="required">*</span></label>
                                            <select id="actitudStakeholderInterno1" name="actitudStakeholderInterno1" class="form-control" required>
                                                <option value="">Seleccionar...</option>
                                                <option value="positiva">Positiva</option>
                                                <option value="neutral">Neutral</option>
                                                <option value="negativa">Negativa</option>
                                            </select>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="necesidadesStakeholderInterno1">Necesidades y expectativas</label>
                                            <textarea id="necesidadesStakeholderInterno1" name="necesidadesStakeholderInterno1" class="form-control" rows="2"></textarea>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="estrategiaStakeholderInterno1">Estrategia de gestión <span class="required">*</span></label>
                                            <textarea id="estrategiaStakeholderInterno1" name="estrategiaStakeholderInterno1" class="form-control" rows="2" required></textarea>
                                        </div>
                                        
                                        <button type="button" class="btn btn-danger remove-stakeholder"><i class="fas fa-trash"></i> Eliminar</button>
                                    </div>
                                </div>
                                
                                <button type="button" class="btn btn-primary" id="addStakeholderInterno"><i class="fas fa-plus"></i> Agregar stakeholder interno</button>
                            </div>
                            
                            <!-- Stakeholders externos -->
                            <div class="subsection">
                                <h3>Stakeholders Externos</h3>
                                <p class="subsection-intro">Personas, grupos u organizaciones fuera de la empresa que tienen interés o influencia en el éxito de la empresa.</p>
                                
                                <div id="stakeholdersExternosContainer">
                                    <!-- Plantilla para stakeholder externo -->
                                    <div class="stakeholder-item">
                                        <div class="form-group">
                                            <label for="nombreStakeholderExterno1">Nombre del stakeholder <span class="required">*</span></label>
                                            <input type="text" id="nombreStakeholderExterno1" name="nombreStakeholderExterno1" class="form-control" required>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="interesStakeholderExterno1">Nivel de interés <span class="required">*</span></label>
                                                <select id="interesStakeholderExterno1" name="interesStakeholderExterno1" class="form-control" required>
                                                    <option value="">Seleccionar...</option>
                                                    <option value="alto">Alto</option>
                                                    <option value="medio">Medio</option>
                                                    <option value="bajo">Bajo</option>
                                                </select>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="poderStakeholderExterno1">Nivel de poder/influencia <span class="required">*</span></label>
                                                <select id="poderStakeholderExterno1" name="poderStakeholderExterno1" class="form-control" required>
                                                    <option value="">Seleccionar...</option>
                                                    <option value="alto">Alto</option>
                                                    <option value="medio">Medio</option>
                                                    <option value="bajo">Bajo</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="actitudStakeholderExterno1">Actitud hacia la empresa <span class="required">*</span></label>
                                            <select id="actitudStakeholderExterno1" name="actitudStakeholderExterno1" class="form-control" required>
                                                <option value="">Seleccionar...</option>
                                                <option value="positiva">Positiva</option>
                                                <option value="neutral">Neutral</option>
                                                <option value="negativa">Negativa</option>
                                            </select>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="necesidadesStakeholderExterno1">Necesidades y expectativas</label>
                                            <textarea id="necesidadesStakeholderExterno1" name="necesidadesStakeholderExterno1" class="form-control" rows="2"></textarea>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="estrategiaStakeholderExterno1">Estrategia de gestión <span class="required">*</span></label>
                                            <textarea id="estrategiaStakeholderExterno1" name="estrategiaStakeholderExterno1" class="form-control" rows="2" required></textarea>
                                        </div>
                                        
                                        <button type="button" class="btn btn-danger remove-stakeholder"><i class="fas fa-trash"></i> Eliminar</button>
                                    </div>
                                </div>
                                
                                <button type="button" class="btn btn-primary" id="addStakeholderExterno"><i class="fas fa-plus"></i> Agregar stakeholder externo</button>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Matriz de Poder-Interés</h2>
                            <p class="section-intro">Clasifique a los stakeholders según su nivel de poder e interés para determinar las estrategias de gestión adecuadas.</p>
                            
                            <div class="tips-container">
                                <h3><i class="fas fa-lightbulb"></i> Estrategias recomendadas por cuadrante</h3>
                                <ul>
                                    <li><strong>Alto poder, alto interés (Gestionar de cerca):</strong> Involucrar intensamente y hacer el mayor esfuerzo para satisfacer.</li>
                                    <li><strong>Alto poder, bajo interés (Mantener satisfechos):</strong> Dedicar suficiente trabajo para mantener su satisfacción.</li>
                                    <li><strong>Bajo poder, alto interés (Mantener informados):</strong> Mantener adecuadamente informados y hablar con ellos para asegurar que no surjan problemas.</li>
                                    <li><strong>Bajo poder, bajo interés (Monitorear):</strong> Vigilar pero sin comunicación excesiva.</li>
                                </ul>
                            </div>
                            
                            <div class="form-group">
                                <label for="stakeholdersGestionarCerca">Stakeholders a gestionar de cerca (Alto poder, alto interés) <span class="required">*</span></label>
                                <textarea id="stakeholdersGestionarCerca" name="stakeholdersGestionarCerca" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Liste los stakeholders que requieren gestión cercana y estrategias específicas.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="stakeholdersMantenerSatisfechos">Stakeholders a mantener satisfechos (Alto poder, bajo interés) <span class="required">*</span></label>
                                <textarea id="stakeholdersMantenerSatisfechos" name="stakeholdersMantenerSatisfechos" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Liste los stakeholders que deben mantenerse satisfechos.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="stakeholdersMantenerInformados">Stakeholders a mantener informados (Bajo poder, alto interés) <span class="required">*</span></label>
                                <textarea id="stakeholdersMantenerInformados" name="stakeholdersMantenerInformados" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Liste los stakeholders que deben mantenerse informados.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="stakeholdersMonitorear">Stakeholders a monitorear (Bajo poder, bajo interés) <span class="required">*</span></label>
                                <textarea id="stakeholdersMonitorear" name="stakeholdersMonitorear" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Liste los stakeholders que deben ser monitoreados.</small>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Plan de Comunicación y Participación</h2>
                            
                            <div class="form-group">
                                <label for="planComunicacion">Plan de comunicación con stakeholders clave <span class="required">*</span></label>
                                <textarea id="planComunicacion" name="planComunicacion" class="form-control" rows="4" required></textarea>
                                <small class="form-text">Describa cómo planea comunicarse con los stakeholders clave (frecuencia, canales, mensajes principales).</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="estrategiasParticipacion">Estrategias de participación <span class="required">*</span></label>
                                <textarea id="estrategiasParticipacion" name="estrategiasParticipacion" class="form-control" rows="4" required></textarea>
                                <small class="form-text">Describa cómo involucrará a los stakeholders en la toma de decisiones y en la implementación de la estrategia.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="indicadoresExito">Indicadores de éxito en la gestión de stakeholders <span class="required">*</span></label>
                                <textarea id="indicadoresExito" name="indicadoresExito" class="form-control" rows="3" required></textarea>
                                <small class="form-text">¿Cómo medirá el éxito de su gestión de stakeholders?</small>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="button" class="btn save-button"><i class="fas fa-save"></i> Guardar</button>
                            <button type="button" class="btn reset-button"><i class="fas fa-undo"></i> Restablecer</button>
                            <div class="navigation-buttons">
                                <a href="cadena-valor.jsp" class="btn prev-button"><i class="fas fa-arrow-left"></i> Anterior: Cadena de Valor</a>
                                <a href="identificacion-estrategia.jsp" class="btn next-button"><i class="fas fa-arrow-right"></i> Siguiente: Identificación de Estrategias</a>
                            </div>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
    
    <script src="js/auth.js"></script>
    <script src="js/storage.js"></script>
    <script src="js/navigation.js"></script>
    <script src="js/forms.js"></script>
    <script src="js/progress.js"></script>
    
    <!-- Script específico para la matriz de participación -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Contador para los IDs de los stakeholders
            let stakeholderInternoCount = 1;
            let stakeholderExternoCount = 1;
            
            // Función para agregar un nuevo stakeholder interno
            document.getElementById('addStakeholderInterno').addEventListener('click', function() {
                stakeholderInternoCount++;
                const container = document.getElementById('stakeholdersInternosContainer');
                const newStakeholder = document.createElement('div');
                newStakeholder.className = 'stakeholder-item';
                newStakeholder.innerHTML = `
                    <hr>
                    <div class="form-group">
                        <label for="nombreStakeholderInterno${stakeholderInternoCount}">Nombre del stakeholder <span class="required">*</span></label>
                        <input type="text" id="nombreStakeholderInterno${stakeholderInternoCount}" name="nombreStakeholderInterno${stakeholderInternoCount}" class="form-control" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="interesStakeholderInterno${stakeholderInternoCount}">Nivel de interés <span class="required">*</span></label>
                            <select id="interesStakeholderInterno${stakeholderInternoCount}" name="interesStakeholderInterno${stakeholderInternoCount}" class="form-control" required>
                                <option value="">Seleccionar...</option>
                                <option value="alto">Alto</option>
                                <option value="medio">Medio</option>
                                <option value="bajo">Bajo</option>
                            </select>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="poderStakeholderInterno${stakeholderInternoCount}">Nivel de poder/influencia <span class="required">*</span></label>
                            <select id="poderStakeholderInterno${stakeholderInternoCount}" name="poderStakeholderInterno${stakeholderInternoCount}" class="form-control" required>
                                <option value="">Seleccionar...</option>
                                <option value="alto">Alto</option>
                                <option value="medio">Medio</option>
                                <option value="bajo">Bajo</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="actitudStakeholderInterno${stakeholderInternoCount}">Actitud hacia la empresa <span class="required">*</span></label>
                        <select id="actitudStakeholderInterno${stakeholderInternoCount}" name="actitudStakeholderInterno${stakeholderInternoCount}" class="form-control" required>
                            <option value="">Seleccionar...</option>
                            <option value="positiva">Positiva</option>
                            <option value="neutral">Neutral</option>
                            <option value="negativa">Negativa</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="necesidadesStakeholderInterno${stakeholderInternoCount}">Necesidades y expectativas</label>
                        <textarea id="necesidadesStakeholderInterno${stakeholderInternoCount}" name="necesidadesStakeholderInterno${stakeholderInternoCount}" class="form-control" rows="2"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="estrategiaStakeholderInterno${stakeholderInternoCount}">Estrategia de gestión <span class="required">*</span></label>
                        <textarea id="estrategiaStakeholderInterno${stakeholderInternoCount}" name="estrategiaStakeholderInterno${stakeholderInternoCount}" class="form-control" rows="2" required></textarea>
                    </div>
                    
                    <button type="button" class="btn btn-danger remove-stakeholder"><i class="fas fa-trash"></i> Eliminar</button>
                `;
                container.appendChild(newStakeholder);
                
                // Agregar evento para eliminar el stakeholder
                newStakeholder.querySelector('.remove-stakeholder').addEventListener('click', function() {
                    container.removeChild(newStakeholder);
                });
            });
            
            // Función para agregar un nuevo stakeholder externo
            document.getElementById('addStakeholderExterno').addEventListener('click', function() {
                stakeholderExternoCount++;
                const container = document.getElementById('stakeholdersExternosContainer');
                const newStakeholder = document.createElement('div');
                newStakeholder.className = 'stakeholder-item';
                newStakeholder.innerHTML = `
                    <hr>
                    <div class="form-group">
                        <label for="nombreStakeholderExterno${stakeholderExternoCount}">Nombre del stakeholder <span class="required">*</span></label>
                        <input type="text" id="nombreStakeholderExterno${stakeholderExternoCount}" name="nombreStakeholderExterno${stakeholderExternoCount}" class="form-control" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="interesStakeholderExterno${stakeholderExternoCount}">Nivel de interés <span class="required">*</span></label>
                            <select id="interesStakeholderExterno${stakeholderExternoCount}" name="interesStakeholderExterno${stakeholderExternoCount}" class="form-control" required>
                                <option value="">Seleccionar...</option>
                                <option value="alto">Alto</option>
                                <option value="medio">Medio</option>
                                <option value="bajo">Bajo</option>
                            </select>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="poderStakeholderExterno${stakeholderExternoCount}">Nivel de poder/influencia <span class="required">*</span></label>
                            <select id="poderStakeholderExterno${stakeholderExternoCount}" name="poderStakeholderExterno${stakeholderExternoCount}" class="form-control" required>
                                <option value="">Seleccionar...</option>
                                <option value="alto">Alto</option>
                                <option value="medio">Medio</option>
                                <option value="bajo">Bajo</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="actitudStakeholderExterno${stakeholderExternoCount}">Actitud hacia la empresa <span class="required">*</span></label>
                        <select id="actitudStakeholderExterno${stakeholderExternoCount}" name="actitudStakeholderExterno${stakeholderExternoCount}" class="form-control" required>
                            <option value="">Seleccionar...</option>
                            <option value="positiva">Positiva</option>
                            <option value="neutral">Neutral</option>
                            <option value="negativa">Negativa</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="necesidadesStakeholderExterno${stakeholderExternoCount}">Necesidades y expectativas</label>
                        <textarea id="necesidadesStakeholderExterno${stakeholderExternoCount}" name="necesidadesStakeholderExterno${stakeholderExternoCount}" class="form-control" rows="2"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="estrategiaStakeholderExterno${stakeholderExternoCount}">Estrategia de gestión <span class="required">*</span></label>
                        <textarea id="estrategiaStakeholderExterno${stakeholderExternoCount}" name="estrategiaStakeholderExterno${stakeholderExternoCount}" class="form-control" rows="2" required></textarea>
                    </div>
                    
                    <button type="button" class="btn btn-danger remove-stakeholder"><i class="fas fa-trash"></i> Eliminar</button>
                `;
                container.appendChild(newStakeholder);
                
                // Agregar evento para eliminar el stakeholder
                newStakeholder.querySelector('.remove-stakeholder').addEventListener('click', function() {
                    container.removeChild(newStakeholder);
                });
            });
            
            // Agregar evento para eliminar el primer stakeholder interno
            document.querySelector('#stakeholdersInternosContainer .remove-stakeholder').addEventListener('click', function() {
                const item = this.closest('.stakeholder-item');
                if (document.querySelectorAll('#stakeholdersInternosContainer .stakeholder-item').length > 1) {
                    item.parentNode.removeChild(item);
                } else {
                    alert('Debe mantener al menos un stakeholder interno.');
                }
            });
            
            // Agregar evento para eliminar el primer stakeholder externo
            document.querySelector('#stakeholdersExternosContainer .remove-stakeholder').addEventListener('click', function() {
                const item = this.closest('.stakeholder-item');
                if (document.querySelectorAll('#stakeholdersExternosContainer .stakeholder-item').length > 1) {
                    item.parentNode.removeChild(item);
                } else {
                    alert('Debe mantener al menos un stakeholder externo.');
                }
            });
        });
    </script>
</body>
</html>