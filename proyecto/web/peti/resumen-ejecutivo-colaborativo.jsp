<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, negocio.ClsNGrupo, entidad.ClsEPeti, entidad.ClsELogin"%>
<%@page import="java.util.Map, java.util.ArrayList, java.util.List"%>
<%@page import="java.text.SimpleDateFormat, java.util.Date"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    
    boolean modoColaborativo = grupoActual != null && grupoId != null;
    
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) userEmail = "usuario@ejemplo.com";
    
    String userInitials = "U";
    if (usuario != null && usuario.length() > 0) {
        userInitials = usuario.substring(0, 1).toUpperCase();
        if (usuario.contains(" ") && usuario.length() > usuario.indexOf(" ") + 1) {
            userInitials += usuario.substring(usuario.indexOf(" ") + 1, usuario.indexOf(" ") + 2).toUpperCase();
        }
    }
    
    String mensaje = "";
    String tipoMensaje = "";
    
    // Variables automáticas
    String nombreProyecto = "";
    String fechaElaboracion = "";
    List<String> emprendedores = new ArrayList<>();
    String mision = "";
    String vision = "";
    List<String> valores = new ArrayList<>();
    String objetivoGeneral = "";
    List<String> objetivosEspecificos = new ArrayList<>();
    List<String> fortalezas = new ArrayList<>();
    List<String> debilidades = new ArrayList<>();
    List<String> oportunidades = new ArrayList<>();
    List<String> amenazas = new ArrayList<>();
    List<String> accionesCame = new ArrayList<>();
    
    // Variables editables
    String unidadesEstrategicas = "";
    String estrategiaIdentificada = "";
    String conclusiones = "";
    
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String accion = request.getParameter("accion");
        if ("guardar_resumen".equals(accion)) {
            String uenData = request.getParameter("uen_data");
            String estrategiaData = request.getParameter("estrategia_data");
            String conclusionesData = request.getParameter("conclusiones_data");
            
            ClsNPeti negocioPeti = new ClsNPeti();
            boolean exito = true;
            
            try {
                if (uenData != null && !uenData.trim().isEmpty()) {
                    ClsEPeti datoUEN = new ClsEPeti(grupoId, "resumen_ejecutivo", "unidades_estrategicas", uenData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoUEN);
                }
                if (estrategiaData != null && !estrategiaData.trim().isEmpty()) {
                    ClsEPeti datoEstrategia = new ClsEPeti(grupoId, "resumen_ejecutivo", "estrategia_identificada", estrategiaData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoEstrategia);
                }
                if (conclusionesData != null && !conclusionesData.trim().isEmpty()) {
                    ClsEPeti datoConclusiones = new ClsEPeti(grupoId, "resumen_ejecutivo", "conclusiones", conclusionesData.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(datoConclusiones);
                }
                
                if (exito) {
                    mensaje = "Resumen ejecutivo guardado exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar el resumen";
                    tipoMensaje = "error";
                }
            } catch (Exception e) {
                mensaje = "Error interno: " + e.getMessage();
                tipoMensaje = "error";
            }
        }
    }
    
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            ClsNGrupo negocioGrupo = new ClsNGrupo();
            
            nombreProyecto = grupoActual;
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            fechaElaboracion = sdf.format(new Date());
            
            List<ClsELogin> miembros = negocioGrupo.obtenerMiembrosGrupo(grupoId);
            for (ClsELogin miembro : miembros) {
                emprendedores.add(miembro.getUsername());
            }
            
            Map<String, String> datosMision = negocioPeti.obtenerDatosSeccion(grupoId, "mision");
            if (datosMision.containsKey("declaracion")) {
                mision = datosMision.get("declaracion");
            }
            
            Map<String, String> datosVision = negocioPeti.obtenerDatosSeccion(grupoId, "vision");
            if (datosVision.containsKey("declaracion")) {
                vision = datosVision.get("declaracion");
            }
            
            Map<String, String> datosValores = negocioPeti.obtenerDatosSeccion(grupoId, "valores");
            if (datosValores.containsKey("lista")) {
                String listaValores = datosValores.get("lista");
                if (listaValores != null && !listaValores.trim().isEmpty()) {
                    String[] valoresArray = listaValores.split("\\r?\\n");
                    for (String valor : valoresArray) {
                        if (valor != null && !valor.trim().isEmpty()) {
                            valores.add(valor.trim());
                        }
                    }
                }
            }
            
            Map<String, String> datosObjetivos = negocioPeti.obtenerDatosSeccion(grupoId, "objetivos");
            if (datosObjetivos.containsKey("objetivo_general")) {
                objetivoGeneral = datosObjetivos.get("objetivo_general");
            }
            for (int i = 1; i <= 20; i++) {
                String key = "objetivo" + i;
                if (datosObjetivos.containsKey(key)) {
                    String objetivo = datosObjetivos.get(key);
                    if (objetivo != null && !objetivo.trim().isEmpty()) {
                        objetivosEspecificos.add(objetivo);
                    }
                }
            }
            
            Map<String, String> datosCadena = negocioPeti.obtenerDatosSeccion(grupoId, "cadena_valor");
            if (datosCadena.containsKey("fortaleza1")) { 
                String f = datosCadena.get("fortaleza1");
                if (f != null && !f.trim().isEmpty()) fortalezas.add(f);
            }
            if (datosCadena.containsKey("fortaleza2")) { 
                String f = datosCadena.get("fortaleza2");
                if (f != null && !f.trim().isEmpty()) fortalezas.add(f);
            }
            
            Map<String, String> datosBCG = negocioPeti.obtenerDatosSeccion(grupoId, "bcg");
            if (datosBCG.containsKey("fortaleza3")) { 
                String f = datosBCG.get("fortaleza3");
                if (f != null && !f.trim().isEmpty()) fortalezas.add(f);
            }
            if (datosBCG.containsKey("fortaleza4")) { 
                String f = datosBCG.get("fortaleza4");
                if (f != null && !f.trim().isEmpty()) fortalezas.add(f);
            }
            
            if (datosCadena.containsKey("debilidad1")) { 
                String d = datosCadena.get("debilidad1");
                if (d != null && !d.trim().isEmpty()) debilidades.add(d);
            }
            if (datosCadena.containsKey("debilidad2")) { 
                String d = datosCadena.get("debilidad2");
                if (d != null && !d.trim().isEmpty()) debilidades.add(d);
            }
            if (datosBCG.containsKey("debilidad3")) { 
                String d = datosBCG.get("debilidad3");
                if (d != null && !d.trim().isEmpty()) debilidades.add(d);
            }
            if (datosBCG.containsKey("debilidad4")) { 
                String d = datosBCG.get("debilidad4");
                if (d != null && !d.trim().isEmpty()) debilidades.add(d);
            }
            
            Map<String, String> datosPest = negocioPeti.obtenerDatosSeccion(grupoId, "pest_analisis");
            if (datosPest.containsKey("oportunidad3")) { 
                String o = datosPest.get("oportunidad3");
                if (o != null && !o.trim().isEmpty()) oportunidades.add(o);
            }
            if (datosPest.containsKey("oportunidad4")) { 
                String o = datosPest.get("oportunidad4");
                if (o != null && !o.trim().isEmpty()) oportunidades.add(o);
            }
            
            Map<String, String> datosPorter = negocioPeti.obtenerDatosSeccion(grupoId, "porter_analisis");
            if (datosPorter.containsKey("oportunidad_1")) { 
                String o = datosPorter.get("oportunidad_1");
                if (o != null && !o.trim().isEmpty()) oportunidades.add(o);
            }
            if (datosPorter.containsKey("oportunidad_2")) { 
                String o = datosPorter.get("oportunidad_2");
                if (o != null && !o.trim().isEmpty()) oportunidades.add(o);
            }
            
            if (datosPest.containsKey("amenaza3")) { 
                String a = datosPest.get("amenaza3");
                if (a != null && !a.trim().isEmpty()) amenazas.add(a);
            }
            if (datosPest.containsKey("amenaza4")) { 
                String a = datosPest.get("amenaza4");
                if (a != null && !a.trim().isEmpty()) amenazas.add(a);
            }
            if (datosPorter.containsKey("amenaza_1")) { 
                String a = datosPorter.get("amenaza_1");
                if (a != null && !a.trim().isEmpty()) amenazas.add(a);
            }
            if (datosPorter.containsKey("amenaza_2")) { 
                String a = datosPorter.get("amenaza_2");
                if (a != null && !a.trim().isEmpty()) amenazas.add(a);
            }
            
            Map<String, String> datosCame = negocioPeti.obtenerDatosSeccion(grupoId, "matriz_came");
            String[] secciones = {"acciones_corregir", "acciones_afrontar", "acciones_mantener", "acciones_explotar"};
            String[] prefijos = {"C", "A", "M", "E"};
            int contadorSeccion = 0;
            for (String seccion : secciones) {
                if (datosCame.containsKey(seccion)) {
                    String jsonData = datosCame.get(seccion);
                    if (jsonData != null && !jsonData.trim().isEmpty()) {
                        jsonData = jsonData.replace("{", "").replace("}", "").replace("\"", "");
                        String[] pares = jsonData.split(",");
                        for (String par : pares) {
                            if (par.contains(":")) {
                                String[] keyValue = par.split(":", 2);
                                if (keyValue.length == 2) {
                                    String accion = keyValue[1].trim();
                                    if (!accion.isEmpty()) {
                                        accionesCame.add(prefijos[contadorSeccion] + " - " + accion);
                                    }
                                }
                            }
                        }
                    }
                }
                contadorSeccion++;
            }
            
            Map<String, String> datosResumen = negocioPeti.obtenerDatosSeccion(grupoId, "resumen_ejecutivo");
            if (datosResumen.containsKey("unidades_estrategicas")) {
                unidadesEstrategicas = datosResumen.get("unidades_estrategicas");
            }
            if (datosResumen.containsKey("estrategia_identificada")) {
                estrategiaIdentificada = datosResumen.get("estrategia_identificada");
            }
            if (datosResumen.containsKey("conclusiones")) {
                conclusiones = datosResumen.get("conclusiones");
            }
            
        } catch (Exception e) {
            mensaje = "Error al cargar datos: " + e.getMessage();
            tipoMensaje = "error";
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resumen Ejecutivo - PETI System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.31/jspdf.plugin.autotable.min.js"></script>
    <style>
        :root {
            --primary-color: #1a365d;
            --accent-color: #2563eb;
            --success-color: #16a34a;
            --light-bg: #f8fafc;
            --card-bg: #ffffff;
            --text-primary: #1e293b;
            --border-color: #cbd5e1;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: var(--light-bg);
            min-height: 100vh;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .dashboard-sidebar {
            width: 280px;
            min-width: 280px;
            background: var(--primary-color);
            color: white;
            padding: 0;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            height: 100vh;
            overflow-y: auto;
            position: sticky;
            top: 0;
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
        }

        .dashboard-nav a i {
            margin-right: 12px;
            width: 18px;
            text-align: center;
        }

        .dashboard-nav a:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .dashboard-nav li.active a {
            background: var(--accent-color);
            color: white;
        }

        .dashboard-content {
            flex: 1;
            overflow-y: auto;
        }

        .dashboard-header {
            background: var(--card-bg);
            padding: 20px 32px;
            border-bottom: 2px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .dashboard-header h1 {
            color: var(--text-primary);
            font-size: 24px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            background: rgba(37, 99, 235, 0.1);
            color: var(--accent-color);
            border-radius: 6px;
            font-size: 13px;
            font-weight: 500;
        }

        .header-actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-primary {
            background: var(--accent-color);
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .btn-success {
            background: var(--success-color);
            color: white;
        }

        .btn-success:hover {
            background: #15803d;
            transform: translateY(-1px);
        }

        .dashboard-main {
            padding: 32px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .alert {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success {
            background: #d1fae5;
            border: 1px solid #6ee7b7;
            color: #065f46;
        }

        .alert-warning {
            background: #fef3c7;
            border: 1px solid #fcd34d;
            color: #92400e;
        }

        .alert-error {
            background: #fee2e2;
            border: 1px solid #fca5a5;
            color: #991b1b;
        }

        #resumeContent {
            background: white;
            padding: 60px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .resume-title {
            text-align: center;
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 40px;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 4px solid var(--accent-color);
            padding-bottom: 16px;
        }

        .resume-section {
            margin-bottom: 36px;
            page-break-inside: avoid;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 12px 20px;
            margin-bottom: 24px;
            border-left: 4px solid var(--accent-color);
            padding-left: 20px;
        }

        .info-label {
            font-weight: 700;
            color: var(--primary-color);
            font-size: 14px;
        }

        .info-value {
            color: var(--text-primary);
            font-size: 14px;
            line-height: 1.6;
        }

        .section-header {
            background: linear-gradient(135deg, var(--accent-color), #1e40af);
            color: white;
            padding: 14px 24px;
            font-weight: 700;
            font-size: 16px;
            margin: 24px 0 16px 0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .section-header i {
            font-size: 18px;
        }

        .content-box {
            border: 2px solid var(--border-color);
            padding: 20px;
            min-height: 80px;
            border-radius: 8px;
            background: #fafafa;
            font-size: 14px;
            line-height: 1.8;
            color: var(--text-primary);
        }

        .content-box-editable {
            border: 2px solid var(--border-color);
            border-radius: 8px;
            background: white;
        }

        .content-box-editable textarea {
            width: 100%;
            min-height: 150px;
            border: none;
            padding: 20px;
            font-size: 14px;
            font-family: inherit;
            line-height: 1.8;
            resize: vertical;
            color: var(--text-primary);
        }

        .content-box-editable textarea:focus {
            outline: none;
            background: #fafafa;
        }

        .values-list {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 12px;
        }

        .value-item {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            padding: 10px 18px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .objectives-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .objectives-table th,
        .objectives-table td {
            border: 2px solid var(--border-color);
            padding: 14px;
            vertical-align: top;
            font-size: 13px;
        }

        .objectives-table th {
            background: linear-gradient(135deg, #1e40af, #1e3a8a);
            color: white;
            font-weight: 700;
            text-align: left;
        }

        .objectives-table .mission-cell {
            background: #dbeafe;
            width: 120px;
            text-align: center;
            font-weight: 700;
            color: var(--primary-color);
        }

        .objectives-table .general-obj {
            background: #e0f2fe;
            font-weight: 500;
        }

        .objectives-table .specific-obj {
            background: #f0f9ff;
        }

        .foda-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-top: 16px;
        }

        .foda-card {
            border: 3px solid;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .foda-card.debilidades {
            border-color: #fbbf24;
        }

        .foda-card.amenazas {
            border-color: #f87171;
        }

        .foda-card.fortalezas {
            border-color: #34d399;
        }

        .foda-card.oportunidades {
            border-color: #60a5fa;
        }

        .foda-header {
            padding: 12px 16px;
            font-weight: 700;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            color: white;
        }

        .foda-card.debilidades .foda-header {
            background: #f59e0b;
        }

        .foda-card.amenazas .foda-header {
            background: #ef4444;
        }

        .foda-card.fortalezas .foda-header {
            background: #10b981;
        }

        .foda-card.oportunidades .foda-header {
            background: #3b82f6;
        }

        .foda-content {
            padding: 16px;
            min-height: 120px;
            background: white;
        }

        .foda-item {
            margin-bottom: 10px;
            font-size: 13px;
            line-height: 1.6;
            display: flex;
            gap: 8px;
            color: var(--text-primary);
        }

        .foda-item i {
            margin-top: 4px;
            font-size: 8px;
        }

        .actions-list {
            border: 2px solid var(--border-color);
            border-radius: 8px;
            margin-top: 16px;
            background: white;
        }

        .action-item {
            padding: 12px 20px;
            border-bottom: 1px solid var(--border-color);
            font-size: 13px;
            line-height: 1.6;
        }

        .action-item:last-child {
            border-bottom: none;
        }

        .action-item strong {
            color: var(--accent-color);
            margin-right: 8px;
        }

        @media print {
            /* Ocultar elementos no necesarios */
            .dashboard-sidebar,
            .dashboard-header,
            .no-print {
                display: none !important;
            }

            /* Configuración de página */
            @page {
                size: A4;
                margin: 15mm 15mm 15mm 15mm;
            }

            body {
                background: white !important;
                margin: 0;
                padding: 0;
            }

            .dashboard-container {
                display: block !important;
                width: 100% !important;
            }

            .dashboard-content {
                width: 100% !important;
            }

            .dashboard-main {
                padding: 0 !important;
                margin: 0 !important;
                max-width: 100% !important;
            }

            #resumeContent {
                box-shadow: none !important;
                padding: 0 !important;
                margin: 0 !important;
                border-radius: 0 !important;
                background: white !important;
                max-width: 100% !important;
            }

            /* Título más compacto para impresión */
            .resume-title {
                font-size: 20px !important;
                margin-bottom: 20px !important;
                padding-bottom: 10px !important;
                border-bottom: 3px solid #2563eb !important;
                color: #1e40af !important;
            }

            /* Secciones */
            .resume-section {
                page-break-inside: avoid !important;
                margin-bottom: 18px !important;
            }

            /* Grid de información */
            .info-grid {
                grid-template-columns: 150px 1fr !important;
                gap: 8px 15px !important;
                margin-bottom: 18px !important;
                border-left: 3px solid #2563eb !important;
                padding-left: 12px !important;
            }

            .info-label {
                font-size: 11px !important;
                font-weight: 700 !important;
            }

            .info-value {
                font-size: 11px !important;
            }

            /* Headers de sección */
            .section-header {
                background: linear-gradient(135deg, #2563eb, #1e40af) !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
                color: white !important;
                padding: 8px 15px !important;
                font-size: 13px !important;
                margin: 15px 0 10px 0 !important;
                border-radius: 4px !important;
                page-break-after: avoid !important;
            }

            .section-header i {
                font-size: 14px !important;
            }

            /* Cajas de contenido */
            .content-box {
                border: 1.5px solid #cbd5e1 !important;
                padding: 12px !important;
                min-height: 50px !important;
                border-radius: 4px !important;
                background: #f8fafc !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
                font-size: 10px !important;
                line-height: 1.5 !important;
            }

            .content-box-editable {
                border: 1.5px solid #cbd5e1 !important;
                border-radius: 4px !important;
                background: white !important;
            }

            .content-box-editable textarea {
                padding: 12px !important;
                font-size: 10px !important;
                line-height: 1.5 !important;
                min-height: 80px !important;
            }

            /* Valores */
            .values-list {
                gap: 8px !important;
                margin-top: 10px !important;
            }

            .value-item {
                background: linear-gradient(135deg, #3b82f6, #2563eb) !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
                color: white !important;
                padding: 6px 12px !important;
                border-radius: 12px !important;
                font-size: 10px !important;
                font-weight: 600 !important;
            }

            /* Tabla de objetivos */
            .objectives-table {
                margin-top: 12px !important;
                font-size: 9px !important;
                border-collapse: collapse !important;
            }

            .objectives-table th,
            .objectives-table td {
                border: 1.5px solid #cbd5e1 !important;
                padding: 8px !important;
                font-size: 9px !important;
            }

            .objectives-table th {
                background: linear-gradient(135deg, #1e40af, #1e3a8a) !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
                color: white !important;
                font-weight: 700 !important;
            }

            .objectives-table .mission-cell {
                background: #dbeafe !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
                font-weight: 700 !important;
            }

            .objectives-table .general-obj {
                background: #e0f2fe !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
                font-weight: 500 !important;
            }

            .objectives-table .specific-obj {
                background: #f0f9ff !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            /* Grid FODA */
            .foda-grid {
                display: grid !important;
                grid-template-columns: 1fr 1fr !important;
                gap: 10px !important;
                margin-top: 12px !important;
                page-break-inside: avoid !important;
            }

            .foda-card {
                border: 2px solid !important;
                border-radius: 6px !important;
                overflow: hidden !important;
                page-break-inside: avoid !important;
            }

            .foda-card.debilidades {
                border-color: #fbbf24 !important;
            }

            .foda-card.amenazas {
                border-color: #f87171 !important;
            }

            .foda-card.fortalezas {
                border-color: #34d399 !important;
            }

            .foda-card.oportunidades {
                border-color: #60a5fa !important;
            }

            .foda-header {
                padding: 8px 12px !important;
                font-weight: 700 !important;
                font-size: 11px !important;
                color: white !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            .foda-card.debilidades .foda-header {
                background: #f59e0b !important;
            }

            .foda-card.amenazas .foda-header {
                background: #ef4444 !important;
            }

            .foda-card.fortalezas .foda-header {
                background: #10b981 !important;
            }

            .foda-card.oportunidades .foda-header {
                background: #3b82f6 !important;
            }

            .foda-content {
                padding: 10px !important;
                min-height: 80px !important;
                background: white !important;
            }

            .foda-item {
                margin-bottom: 6px !important;
                font-size: 9px !important;
                line-height: 1.4 !important;
                display: flex !important;
                gap: 6px !important;
            }

            .foda-item i {
                margin-top: 3px !important;
                font-size: 6px !important;
            }

            /* Lista de acciones */
            .actions-list {
                border: 1.5px solid #cbd5e1 !important;
                border-radius: 4px !important;
                margin-top: 12px !important;
            }

            .action-item {
                padding: 8px 12px !important;
                border-bottom: 1px solid #e2e8f0 !important;
                font-size: 9px !important;
                line-height: 1.4 !important;
            }

            .action-item:last-child {
                border-bottom: none !important;
            }

            .action-item strong {
                color: #2563eb !important;
                margin-right: 6px !important;
            }

            /* Evitar saltos de página no deseados */
            h1, h2, h3, .section-header {
                page-break-after: avoid !important;
            }

            .foda-grid, .objectives-table, .actions-list {
                page-break-inside: avoid !important;
            }

            /* Ajustes finales */
            * {
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }
        }

        @media (max-width: 768px) {
            .dashboard-sidebar {
                display: none;
            }

            .dashboard-main {
                padding: 16px;
            }

            #resumeContent {
                padding: 24px 16px;
            }

            .foda-grid {
                grid-template-columns: 1fr;
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
                    <div class="user-avatar"><%= userInitials %></div>
                    <div class="user-info">
                        <h3><%= usuario %></h3>
                        <p><%= userEmail %></p>
                        <% if (modoColaborativo) { %>
                            <p style="margin-top: 4px; font-size: 11px; color: #86efac;">
                                <i class="fas fa-users"></i> <%= grupoActual %>
                            </p>
                        <% } %>
                    </div>
                </div>
            </div>
            <nav class="dashboard-nav">
                <div class="nav-section">
                    <div class="nav-section-title">Principal</div>
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li class="active"><a href="resumen-ejecutivo-colaborativo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Planificación</div>
                    <ul>
                        <li><a href="empresa_colaborativo.jsp"><i class="fas fa-building"></i> Empresa</a></li>
                        <li><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión</a></li>
                        <li><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión</a></li>
                        <li><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores</a></li>
                        <li><a href="objetivos_colaborativo.jsp"><i class="fas fa-tasks"></i> Objetivos</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Análisis</div>
                    <ul>
                        <li><a href="pest_colaborativo.jsp"><i class="fas fa-chart-line"></i> PEST</a></li>
                        <li><a href="porter_colaborativo.jsp"><i class="fas fa-shield-alt"></i> Porter</a></li>
                        <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena Valor</a></li>
                        <li><a href="autodiagnostico_BCG.jsp"><i class="fas fa-chart-pie"></i> BCG</a></li>
                        <li><a href="IDENTIFICACIÓN DE ESTRATEGIAS.jsp"><i class="fas fa-chess"></i> Estrategias</a></li>
                        <li><a href="MATRIZ CAME.jsp"><i class="fas fa-th"></i> CAME</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Sistema</div>
                    <ul>
                        <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                    </ul>
                </div>
            </nav>
        </div>

        <div class="dashboard-content">
            <header class="dashboard-header no-print">
                <h1>
                    <i class="fas fa-file-alt"></i>
                    RESUMEN EJECUTIVO
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i> <%= grupoActual %>
                        </span>
                    <% } %>
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <button onclick="guardarResumen()" class="btn btn-success">
                            <i class="fas fa-save"></i> Guardar
                        </button>
                        <button onclick="generarPDF()" class="btn btn-primary">
                            <i class="fas fa-file-pdf"></i> Generar PDF
                        </button>
                    <% } %>
                    <a href="dashboard.jsp" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Dashboard
                    </a>
                </div>
            </header>

            <main class="dashboard-main">
                <% if (!mensaje.isEmpty()) { %>
                    <div class="alert alert-<%= tipoMensaje %> no-print">
                        <i class="fas fa-<%= "error".equals(tipoMensaje) ? "exclamation-triangle" : "check-circle" %>"></i>
                        <%= mensaje %>
                    </div>
                <% } %>

                <% if (!modoColaborativo) { %>
                    <div class="alert alert-warning no-print">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Modo Individual:</strong> Únete a un grupo para utilizar el Resumen Ejecutivo.
                    </div>
                <% } %>

                <div id="resumeContent">
                    <h1 class="resume-title">RESUMEN EJECUTIVO DEL PLAN ESTRATÉGICO</h1>
                    
                    <div class="resume-section">
                        <div class="info-grid">
                            <div class="info-label">Nombre del proyecto:</div>
                            <div class="info-value"><%= nombreProyecto.isEmpty() ? "No definido" : nombreProyecto %></div>
                            
                            <div class="info-label">Fecha de elaboración:</div>
                            <div class="info-value"><%= fechaElaboracion %></div>
                            
                            <div class="info-label">Emprendedores/Promotores:</div>
                            <div class="info-value">
                                <% if (emprendedores.isEmpty()) { %>
                                    No hay miembros en el grupo
                                <% } else { %>
                                    <%= String.join(", ", emprendedores) %>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="resume-section">
                        <div class="section-header"><i class="fas fa-bullseye"></i> MISIÓN</div>
                        <div class="content-box">
                            <%= mision.isEmpty() ? "Misión no definida en el módulo correspondiente." : mision %>
                        </div>
                        
                        <div class="section-header"><i class="fas fa-eye"></i> VISIÓN</div>
                        <div class="content-box">
                            <%= vision.isEmpty() ? "Visión no definida en el módulo correspondiente." : vision %>
                        </div>
                    </div>
                    
                    <div class="resume-section">
                        <div class="section-header"><i class="fas fa-heart"></i> VALORES ORGANIZACIONALES</div>
                        <% if (valores.isEmpty()) { %>
                            <div class="content-box">No hay valores definidos en el módulo correspondiente.</div>
                        <% } else { %>
                            <div class="values-list">
                                <% for (String valor : valores) { %>
                                    <div class="value-item"><%= valor %></div>
                                <% } %>
                            </div>
                        <% } %>

                        <div class="section-header"><i class="fas fa-industry"></i> UNIDADES ESTRATÉGICAS DE NEGOCIO (UEN)</div>
                        <div class="content-box-editable">
                            <textarea id="unidades_estrategicas" placeholder="Ingrese las Unidades Estratégicas de Negocio..."><%= unidadesEstrategicas %></textarea>
                        </div>
                    </div>

                    <div class="resume-section">
                        <div class="section-header"><i class="fas fa-target"></i> OBJETIVOS ESTRATÉGICOS</div>
                        <table class="objectives-table">
                            <thead>
                                <tr>
                                    <th style="width: 120px;">MISIÓN</th>
                                    <th style="width: 45%;">OBJETIVOS GENERALES</th>
                                    <th style="width: 45%;">OBJETIVOS ESPECÍFICOS</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                int maxObjetivos = Math.max(1, objetivosEspecificos.size());
                                if (objetivoGeneral.isEmpty() && objetivosEspecificos.isEmpty()) { %>
                                    <tr>
                                        <td class="mission-cell" rowspan="1">MISIÓN</td>
                                        <td class="general-obj" colspan="2">No hay objetivos definidos en el módulo correspondiente.</td>
                                    </tr>
                                <% } else {
                                    for (int i = 0; i < maxObjetivos; i++) { %>
                                        <tr>
                                            <% if (i == 0) { %>
                                                <td class="mission-cell" rowspan="<%= maxObjetivos %>">
                                                    <%= objetivoGeneral.isEmpty() ? "MISIÓN" : objetivoGeneral.substring(0, Math.min(50, objetivoGeneral.length())) + "..." %>
                                                </td>
                                            <% } %>
                                            <% if (i == 0) { %>
                                                <td class="general-obj" rowspan="<%= maxObjetivos %>">
                                                    <%= objetivoGeneral.isEmpty() ? "No definido" : objetivoGeneral %>
                                                </td>
                                            <% } %>
                                            <td class="specific-obj">
                                                <% if (i < objetivosEspecificos.size()) { %>
                                                    <i class="fas fa-arrow-right" style="color: #3b82f6; margin-right: 6px;"></i>
                                                    <%= objetivosEspecificos.get(i) %>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% }
                                } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="resume-section">
                        <div class="section-header"><i class="fas fa-chart-line"></i> ANÁLISIS FODA</div>
                        <div class="foda-grid">
                            <div class="foda-card debilidades">
                                <div class="foda-header">
                                    <i class="fas fa-times-circle"></i> DEBILIDADES
                                </div>
                                <div class="foda-content">
                                    <% if (debilidades.isEmpty()) { %>
                                        <p style="color: #999;">No hay debilidades identificadas.</p>
                                    <% } else {
                                        for (String d : debilidades) { %>
                                            <div class="foda-item">
                                                <i class="fas fa-circle" style="color: #f59e0b;"></i>
                                                <span><%= d %></span>
                                            </div>
                                        <% }
                                    } %>
                                </div>
                            </div>

                            <div class="foda-card amenazas">
                                <div class="foda-header">
                                    <i class="fas fa-exclamation-triangle"></i> AMENAZAS
                                </div>
                                <div class="foda-content">
                                    <% if (amenazas.isEmpty()) { %>
                                        <p style="color: #999;">No hay amenazas identificadas.</p>
                                    <% } else {
                                        for (String a : amenazas) { %>
                                            <div class="foda-item">
                                                <i class="fas fa-circle" style="color: #ef4444;"></i>
                                                <span><%= a %></span>
                                            </div>
                                        <% }
                                    } %>
                                </div>
                            </div>

                            <div class="foda-card fortalezas">
                                <div class="foda-header">
                                    <i class="fas fa-check-circle"></i> FORTALEZAS
                                </div>
                                <div class="foda-content">
                                    <% if (fortalezas.isEmpty()) { %>
                                        <p style="color: #999;">No hay fortalezas identificadas.</p>
                                    <% } else {
                                        for (String f : fortalezas) { %>
                                            <div class="foda-item">
                                                <i class="fas fa-circle" style="color: #10b981;"></i>
                                                <span><%= f %></span>
                                            </div>
                                        <% }
                                    } %>
                                </div>
                            </div>

                            <div class="foda-card oportunidades">
                                <div class="foda-header">
                                    <i class="fas fa-lightbulb"></i> OPORTUNIDADES
                                </div>
                                <div class="foda-content">
                                    <% if (oportunidades.isEmpty()) { %>
                                        <p style="color: #999;">No hay oportunidades identificadas.</p>
                                    <% } else {
                                        for (String o : oportunidades) { %>
                                            <div class="foda-item">
                                                <i class="fas fa-circle" style="color: #3b82f6;"></i>
                                                <span><%= o %></span>
                                            </div>
                                        <% }
                                    } %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="resume-section">
                        <div class="section-header"><i class="fas fa-chess"></i> ESTRATEGIA IDENTIFICADA</div>
                        <div class="content-box-editable">
                            <textarea id="estrategia_identificada" placeholder="Escriba la estrategia identificada en la Matriz FODA/CAME..."><%= estrategiaIdentificada %></textarea>
                        </div>
                    </div>

                    <div class="resume-section">
                        <div class="section-header"><i class="fas fa-list-ol"></i> ACCIONES COMPETITIVAS (MATRIZ CAME)</div>
                        <% if (accionesCame.isEmpty()) { %>
                            <div class="content-box">No hay acciones CAME definidas. Complete la Matriz CAME para verlas aquí.</div>
                        <% } else { %>
                            <div class="actions-list">
                                <% for (String accion : accionesCame) { %>
                                    <div class="action-item">
                                        <strong>•</strong> <%= accion %>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>

                    <div class="resume-section">
                        <div class="section-header"><i class="fas fa-clipboard-check"></i> CONCLUSIONES</div>
                        <div class="content-box-editable">
                            <textarea id="conclusiones" placeholder="Anote las conclusiones más relevantes del Plan Estratégico..."><%= conclusiones %></textarea>
                        </div>
                    </div>

                    <% if (modoColaborativo) { %>
                        <div style="background: #dbeafe; padding: 16px; border-radius: 8px; margin-top: 32px; border-left: 4px solid #3b82f6;" class="no-print">
                            <p style="color: #1e40af; margin: 0; font-size: 14px;">
                                <i class="fas fa-info-circle"></i> 
                                <strong>Información:</strong> Los datos se cargan automáticamente del plan del grupo <strong><%= grupoActual %></strong>. Los campos editables (UEN, Estrategia, Conclusiones) deben guardarse manualmente.
                            </p>
                        </div>
                    <% } %>
                </div>
            </main>
        </div>
    </div>

    <script>
        // Variables del servidor
        const datosProyecto = {
            nombreProyecto: '<%= nombreProyecto.replace("'", "\\\\'") %>',
            fechaElaboracion: '<%= fechaElaboracion %>',
            emprendedores: '<%= String.join(", ", emprendedores).replace("'", "\\\\'") %>',
            mision: '<%= mision.replace("\n", " ").replace("'", "\\\\'").replace("\"", "&quot;") %>',
            vision: '<%= vision.replace("\n", " ").replace("'", "\\\\'").replace("\"", "&quot;") %>',
            valores: [
                <% for (int i = 0; i < valores.size(); i++) { %>
                    '<%= valores.get(i).replace("'", "\\\\'").replace("\"", "&quot;") %>'<%= i < valores.size() - 1 ? "," : "" %>
                <% } %>
            ],
            objetivoGeneral: '<%= objetivoGeneral.replace("\n", " ").replace("'", "\\\\'").replace("\"", "&quot;") %>',
            objetivosEspecificos: [
                <% for (int i = 0; i < objetivosEspecificos.size(); i++) { %>
                    '<%= objetivosEspecificos.get(i).replace("\n", " ").replace("'", "\\\\'").replace("\"", "&quot;") %>'<%= i < objetivosEspecificos.size() - 1 ? "," : "" %>
                <% } %>
            ],
            fortalezas: [
                <% for (int i = 0; i < fortalezas.size(); i++) { %>
                    '<%= fortalezas.get(i).replace("\n", " ").replace("'", "\\\\'").replace("\"", "&quot;") %>'<%= i < fortalezas.size() - 1 ? "," : "" %>
                <% } %>
            ],
            debilidades: [
                <% for (int i = 0; i < debilidades.size(); i++) { %>
                    '<%= debilidades.get(i).replace("\n", " ").replace("'", "\\\\'").replace("\"", "&quot;") %>'<%= i < debilidades.size() - 1 ? "," : "" %>
                <% } %>
            ],
            oportunidades: [
                <% for (int i = 0; i < oportunidades.size(); i++) { %>
                    '<%= oportunidades.get(i).replace("\n", " ").replace("'", "\\\\'").replace("\"", "&quot;") %>'<%= i < oportunidades.size() - 1 ? "," : "" %>
                <% } %>
            ],
            amenazas: [
                <% for (int i = 0; i < amenazas.size(); i++) { %>
                    '<%= amenazas.get(i).replace("\n", " ").replace("'", "\\\\'").replace("\"", "&quot;") %>'<%= i < amenazas.size() - 1 ? "," : "" %>
                <% } %>
            ],
            accionesCame: [
                <% for (int i = 0; i < accionesCame.size(); i++) { %>
                    '<%= accionesCame.get(i).replace("\n", " ").replace("'", "\\\\'").replace("\"", "&quot;") %>'<%= i < accionesCame.size() - 1 ? "," : "" %>
                <% } %>
            ]
        };

        function guardarResumen() {
            if (!<%= modoColaborativo %>) {
                alert('Función disponible solo en modo colaborativo');
                return;
            }

            const uen = document.getElementById('unidades_estrategicas').value;
            const estrategia = document.getElementById('estrategia_identificada').value;
            const conclusiones = document.getElementById('conclusiones').value;

            const form = document.createElement('form');
            form.method = 'POST';
            form.style.display = 'none';

            const uenInput = document.createElement('input');
            uenInput.name = 'uen_data';
            uenInput.value = uen;
            form.appendChild(uenInput);

            const estrategiaInput = document.createElement('input');
            estrategiaInput.name = 'estrategia_data';
            estrategiaInput.value = estrategia;
            form.appendChild(estrategiaInput);

            const conclusionesInput = document.createElement('input');
            conclusionesInput.name = 'conclusiones_data';
            conclusionesInput.value = conclusiones;
            form.appendChild(conclusionesInput);

            const accionInput = document.createElement('input');
            accionInput.name = 'accion';
            accionInput.value = 'guardar_resumen';
            form.appendChild(accionInput);

            document.body.appendChild(form);
            form.submit();
        }

       function generarPDF() {
    if (!window.jspdf) {
        alert('Error: La librería jsPDF no se ha cargado correctamente.');
        return;
    }
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF('p', 'mm', 'a4');

    let yPos = 20;
    const pageWidth = doc.internal.pageSize.getWidth();
    const pageHeight = doc.internal.pageSize.getHeight();
    const margin = 20;
    const contentWidth = pageWidth - (margin * 2);

    // Configuración de estilos
    const FONT_SIZE_TITLE = 16;
    const FONT_SIZE_HEADER = 12;
    const FONT_SIZE_SUBHEADER = 10;
    const FONT_SIZE_NORMAL = 9; // Reducido ligeramente para más espacio
    const PRIMARY_COLOR = [30, 64, 175];
    const ACCENT_COLOR = [59, 130, 246];
    const LINE_HEIGHT = 4.5; // Espaciado vertical reducido ligeramente para optimizar

    // Función helper para verificar espacio y agregar página
    const checkPageBreak = (requiredSpace) => {
        if (yPos + requiredSpace > pageHeight - 20) {
            doc.addPage();
            yPos = 20;
            return true;
        }
        return false;
    };

    // Función para crear encabezados de sección limpios
    const addSectionHeader = (text) => {
        checkPageBreak(15);
        doc.setFillColor(...PRIMARY_COLOR);
        doc.rect(margin, yPos, contentWidth, 8, 'F');
        doc.setTextColor(255, 255, 255);
        doc.setFontSize(FONT_SIZE_HEADER);
        doc.setFont(undefined, 'bold');
        doc.text(text, margin + 3, yPos + 5.5);
        yPos += 12; // AUMENTADO el espacio final para evitar montaje
    };

    // --- PORTADA/TÍTULO ---
    doc.setTextColor(PRIMARY_COLOR[0], PRIMARY_COLOR[1], PRIMARY_COLOR[2]);
    doc.setFontSize(22);
    doc.setFont(undefined, 'bold');
    doc.text('RESUMEN EJECUTIVO', pageWidth / 2, yPos + 5, { align: 'center' });
    yPos += 10;

    doc.setTextColor(ACCENT_COLOR[0], ACCENT_COLOR[1], ACCENT_COLOR[2]);
    doc.setFontSize(FONT_SIZE_TITLE);
    doc.text('PLAN ESTRATÉGICO', pageWidth / 2, yPos + 5, { align: 'center' });
    yPos += 20;

    // --- INFORMACIÓN DEL PROYECTO (Usando autoTable) ---
    doc.autoTable({
        startY: yPos,
        head: [['INFORMACIÓN DEL PROYECTO', '']],
        body: [
            ['Nombre del Proyecto', datosProyecto.nombreProyecto || 'No definido'],
            ['Fecha de Elaboración', datosProyecto.fechaElaboracion],
            ['Emprendedores/Promotores', datosProyecto.emprendedores || 'No hay miembros en el grupo']
        ],
        theme: 'striped',
        headStyles: { 
            fillColor: PRIMARY_COLOR, 
            textColor: 255, 
            fontSize: FONT_SIZE_SUBHEADER 
        },
        styles: { 
            fontSize: FONT_SIZE_NORMAL, 
            cellPadding: 3, 
            lineColor: [200, 200, 200] 
        },
        columnStyles: { 
            0: { fontStyle: 'bold', cellWidth: 45, fillColor: [240, 248, 255] }, // Fondo gris para etiquetas
            1: { cellWidth: contentWidth - 45 }
        },
        margin: { left: margin, right: margin }
    });
    yPos = doc.lastAutoTable.finalY + 10;

    // --- MISIÓN ---
    addSectionHeader('MISIÓN');
    doc.setTextColor(50, 50, 50);
    doc.setFontSize(FONT_SIZE_NORMAL);
    doc.setFont(undefined, 'normal');
    let textMision = datosProyecto.mision || 'Misión no definida en el módulo correspondiente.';
    const linesMision = doc.splitTextToSize(textMision, contentWidth - 6);
    doc.text(linesMision, margin + 5, yPos); // Añadido margen izquierdo (5)
    yPos += linesMision.length * LINE_HEIGHT + 8;

    // --- VISIÓN ---
    addSectionHeader('VISIÓN');
    doc.setTextColor(50, 50, 50);
    doc.setFontSize(FONT_SIZE_NORMAL);
    let textVision = datosProyecto.vision || 'Visión no definida en el módulo correspondiente.';
    const linesVision = doc.splitTextToSize(textVision, contentWidth - 6);
    doc.text(linesVision, margin + 5, yPos); // Añadido margen izquierdo (5)
    yPos += linesVision.length * LINE_HEIGHT + 8;

    // --- VALORES ORGANIZACIONALES ---
    addSectionHeader('VALORES ORGANIZACIONALES');
    if (datosProyecto.valores.length > 0) {
        datosProyecto.valores.forEach((valor) => {
            checkPageBreak(LINE_HEIGHT + 2);
            doc.setTextColor(50, 50, 50);
            doc.setFontSize(FONT_SIZE_NORMAL);
            doc.text('• ' + valor, margin + 8, yPos); // Más sangría (8)
            yPos += LINE_HEIGHT;
        });
    } else {
        doc.setTextColor(150, 150, 150);
        doc.text('No hay valores definidos.', margin + 5, yPos);
        yPos += LINE_HEIGHT;
    }
    yPos += 5;

    // --- UNIDADES ESTRATÉGICAS DE NEGOCIO (UEN) ---
    addSectionHeader('UNIDADES ESTRATÉGICAS DE NEGOCIO (UEN)');
    const uenText = document.getElementById('unidades_estrategicas').value || 'No definidas';
    doc.setTextColor(50, 50, 50);
    doc.setFontSize(FONT_SIZE_NORMAL);
    const linesUEN = doc.splitTextToSize(uenText, contentWidth - 6);
    doc.text(linesUEN, margin + 5, yPos);
    yPos += linesUEN.length * LINE_HEIGHT + 8;

    // --- OBJETIVOS ESTRATÉGICOS ---
    checkPageBreak(30);
addSectionHeader('OBJETIVOS ESTRATÉGICOS'); // Usamos el encabezado de sección azul

// 1. Preparar el cuerpo de la tabla de Objetivos (Misón, General, Específicos)
const objetivosBody = [];
const maxObjetivos = datosProyecto.objetivosEspecificos.length || 1;

for (let i = 0; i < maxObjetivos; i++) {
    let row = [];
    
    // Columna MISIÓN (solo en la primera fila)
    if (i === 0) {
        row.push(datosProyecto.mision || 'No definida');
    }
    
    // Columna OBJETIVO GENERAL (solo en la primera fila)
    if (i === 0) {
        row.push(datosProyecto.objetivoGeneral || 'No definido');
    }
    
    // Columna OBJETIVOS ESPECÍFICOS (en todas las filas)
    const objEspec = i < datosProyecto.objetivosEspecificos.length 
        ? (i + 1) + '. ' + datosProyecto.objetivosEspecificos[i] 
        : '';
    row.push(objEspec);
    
    objetivosBody.push(row);
}

// 2. Dibujar la tabla con autoTable
doc.autoTable({
    startY: yPos,
    head: [['MISIÓN', 'OBJETIVOS GENERALES', 'OBJETIVOS ESPECÍFICOS']],
    body: objetivosBody,
    theme: 'grid',
    headStyles: {
        fillColor: PRIMARY_COLOR,
        textColor: 255,
        fontStyle: 'bold',
        fontSize: 9,
        halign: 'center'
    },
    styles: {
        fontSize: 8,
        cellPadding: 3,
        lineColor: [200, 200, 200],
        lineWidth: 0.1,
        valign: 'top'
    },
    columnStyles: {
        0: { cellWidth: 50, fontStyle: 'italic', fillColor: [240, 248, 255] }, // MISIÓN (con rowspan)
        1: { cellWidth: 50, fillColor: [240, 255, 240] }, // GENERAL (con rowspan)
        2: { cellWidth: contentWidth - 100 } // ESPECÍFICOS
    },
    // Configuración para celdas combinadas
    didParseCell: function (data) {
        if (data.section === 'body') {
            // Combinar MISIÓN y OBJETIVO GENERAL en la primera fila
            if (data.row.index === 0) {
                if (data.column.index === 0 || data.column.index === 1) {
                    data.cell.rowSpan = maxObjetivos;
                }
            }
            // Eliminar celdas duplicadas por el rowspan
            if (data.row.index > 0 && (data.column.index === 0 || data.column.index === 1)) {
                data.cell.styles.textColor = [255, 255, 255]; // Hace que el texto sea blanco (invisible)
                data.cell.styles.fillColor = [255, 255, 255]; // Opcional, asegurar que sea blanco
            }
        }
    },
    margin: { left: margin, right: margin }
});
yPos = doc.lastAutoTable.finalY + 10;

    // --- ANÁLISIS FODA (Nueva página para claridad) ---
    doc.addPage();
    yPos = 20;

    addSectionHeader('ANÁLISIS FODA');
    
    // Preparar el cuerpo de la tabla para la Matriz FODA
    const fodaBody = [];
    const allItems = Math.max(
        datosProyecto.fortalezas.length,
        datosProyecto.debilidades.length,
        datosProyecto.oportunidades.length,
        datosProyecto.amenazas.length
    );

    for (let i = 0; i < allItems; i++) {
        fodaBody.push([
            (i < datosProyecto.fortalezas.length ? '• ' + datosProyecto.fortalezas[i] : ''),
            (i < datosProyecto.debilidades.length ? '• ' + datosProyecto.debilidades[i] : ''),
            (i < datosProyecto.oportunidades.length ? '• ' + datosProyecto.oportunidades[i] : ''),
            (i < datosProyecto.amenazas.length ? '• ' + datosProyecto.amenazas[i] : '')
        ]);
    }

    doc.autoTable({
        startY: yPos,
        head: [['FORTALEZAS', 'DEBILIDADES', 'OPORTUNIDADES', 'AMENAZAS']],
        body: fodaBody.length > 0 ? fodaBody : [['No definidas', 'No definidas', 'No definidas', 'No definidas']],
        theme: 'grid',
        headStyles: {
            fillColor: PRIMARY_COLOR,
            textColor: 255,
            fontStyle: 'bold',
            fontSize: 9,
            halign: 'center'
        },
        styles: {
            fontSize: 8,
            cellPadding: 3,
            lineColor: [200, 200, 200],
            lineWidth: 0.1,
            valign: 'top'
        },
        columnStyles: {
            0: { fillColor: [230, 255, 230] },
            1: { fillColor: [255, 240, 230] },
            2: { fillColor: [230, 240, 255] },
            3: { fillColor: [255, 230, 230] }
        },
        margin: { left: margin, right: margin }
    });
    yPos = doc.lastAutoTable.finalY + 10;
    
    // --- ACCIONES CAME ---
    checkPageBreak(30);
    addSectionHeader('ACCIONES COMPETITIVAS (MATRIZ CAME)');

    if (datosProyecto.accionesCame.length > 0) {
        datosProyecto.accionesCame.forEach((accion, index) => {
            const accionLines = doc.splitTextToSize(accion, contentWidth - 10);
            const accionHeight = accionLines.length * LINE_HEIGHT;
            checkPageBreak(accionHeight + 2);

            const prefix = accion.substring(0, 1);
            let prefixColor = [50, 50, 50]; 
            if (prefix === 'C') prefixColor = [239, 68, 68];
            if (prefix === 'A') prefixColor = [249, 115, 22];
            if (prefix === 'M') prefixColor = [34, 197, 94];
            if (prefix === 'E') prefixColor = [59, 130, 246];

            doc.setFillColor(...prefixColor);
            doc.circle(margin + 4, yPos - 1.5, 1.5, 'F');
            
            doc.setTextColor(50, 50, 50);
            doc.setFontSize(FONT_SIZE_NORMAL);
            doc.setFont(undefined, 'normal');
            doc.text(accionLines, margin + 8, yPos);
            yPos += accionHeight + 2;
        });
    } else {
        doc.setTextColor(150, 150, 150);
        doc.text('No se han definido acciones CAME.', margin + 3, yPos);
        yPos += 5;
    }
    yPos += 5;

    // --- ESTRATEGIA IDENTIFICADA ---
    checkPageBreak(30);
    addSectionHeader('ESTRATEGIA IDENTIFICADA');
    const estrategiaText = document.getElementById('estrategia_identificada').value || 'No definida';
    doc.setTextColor(50, 50, 50);
    doc.setFontSize(FONT_SIZE_NORMAL);
    const linesEstrategia = doc.splitTextToSize(estrategiaText, contentWidth - 6);
    doc.text(linesEstrategia, margin + 5, yPos);
    yPos += linesEstrategia.length * LINE_HEIGHT + 8;
    
    // --- CONCLUSIONES ---
    checkPageBreak(30);
    addSectionHeader('CONCLUSIONES');
    const conclusionesText = document.getElementById('conclusiones').value || 'No definidas';
    doc.setTextColor(50, 50, 50);
    doc.setFontSize(FONT_SIZE_NORMAL);
    const linesConclusiones = doc.splitTextToSize(conclusionesText, contentWidth - 6);
    doc.text(linesConclusiones, margin + 5, yPos);
    yPos += linesConclusiones.length * LINE_HEIGHT + 10;
    
    // --- PIE DE PÁGINA (Final) ---
    yPos = pageHeight - 15;
    doc.setFillColor(...PRIMARY_COLOR);
    doc.rect(0, yPos, pageWidth, 10, 'F');
    doc.setTextColor(255, 255, 255);
    doc.setFontSize(8);
    doc.setFont(undefined, 'normal');
    doc.text('Generado automáticamente - PETI System - ' + new Date().toLocaleDateString('es-ES'), pageWidth / 2, yPos + 6, { align: 'center' });

    // GUARDAR PDF
    const fechaActual = new Date().toLocaleDateString('es-ES').replace(/\//g, '-');
    const nombreLimpio = datosProyecto.nombreProyecto.replace(/[^a-zA-Z0-9]/g, '_');
    const fileName = 'Resumen_Ejecutivo_' + nombreLimpio + '_' + fechaActual + '.pdf';
    doc.save(fileName);
}
    </script>
</body>
</html>
