<%-- 
    Document   : crearGrupo
    Created on : 15 set. 2025
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.sql.*"%>
<%@page import="conexion.conexion"%>
<%@page import="entidad.ClsEGrupo"%>
<%@page import="negocio.ClsNGrupo"%>
<%@page import="negocio.ClsNLogin"%>
<%@page import="entidad.ClsELogin"%>

<%
    // Verificar que el usuario esté logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Verificar que el usuario no tenga ya un grupo
    String grupoActual = (String) session.getAttribute("grupoActual");
    if (grupoActual != null) {
        response.sendRedirect("menuprincipal.jsp?error=ya_tiene_grupo");
        return;
    }
    
    // Obtener parámetros del formulario
    String nombreGrupo = request.getParameter("nombreGrupo");
    String limiteUsuariosStr = request.getParameter("limiteUsuarios");
    
    // Validar parámetros
    if (nombreGrupo == null || limiteUsuariosStr == null || 
        nombreGrupo.trim().isEmpty() || limiteUsuariosStr.trim().isEmpty()) {
        response.sendRedirect("menuprincipal.jsp?error=campos_vacios");
        return;
    }
    
    nombreGrupo = nombreGrupo.trim();
    int limiteUsuarios;
    
    try {
        limiteUsuarios = Integer.parseInt(limiteUsuariosStr);
        if (limiteUsuarios < 2 || limiteUsuarios > 100) {
            throw new NumberFormatException();
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("menuprincipal.jsp?error=limite_invalido");
        return;
    }
    
    // Crear grupo usando las nuevas clases
    ClsNGrupo negocioGrupo = new ClsNGrupo();
    ClsEGrupo grupo = new ClsEGrupo();
    
    // Configurar el grupo
    grupo.setNombre(nombreGrupo);
    grupo.setLimiteUsuarios(limiteUsuarios);
    
    try {
        // Obtener el ID del usuario administrador usando la clase de negocio
        ClsNLogin negocioLogin = new ClsNLogin();
        int idAdmin = negocioLogin.obtenerIdUsuario(usuario);
        
        if (idAdmin <= 0) {
            response.sendRedirect("menuprincipal.jsp?error=usuario_no_encontrado");
            return;
        }
        
        grupo.setAdminId(idAdmin);
        
        // Crear el grupo usando la clase de negocio
        int resultado = negocioGrupo.crearGrupo(grupo);
        
        if (resultado > 0) {
            // Asignar el grupo al usuario en la sesión
            session.setAttribute("grupoActual", nombreGrupo);
            session.setAttribute("rolUsuario", "admin");
            session.setAttribute("codigoGrupo", grupo.getCodigo());
            session.setAttribute("idGrupo", grupo.getId());
            
            // Redirigir al menú principal con mensaje de éxito
            response.sendRedirect("menuprincipal.jsp?success=grupo_creado");
        } else if (resultado == -3) {
            response.sendRedirect("menuprincipal.jsp?error=nombre_grupo_existe");
        } else if (resultado == -2) {
            response.sendRedirect("menuprincipal.jsp?error=ya_tiene_grupo");
        } else {
            response.sendRedirect("menuprincipal.jsp?error=error_crear_grupo");
        }
        
    } catch (Exception e) {
        // Error al crear grupo
        e.printStackTrace();
        response.sendRedirect("menuprincipal.jsp?error=error_base_datos");
    }
%>