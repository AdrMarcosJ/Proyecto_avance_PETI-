<%-- 
    Document   : unirseGrupo
    Created on : 15 set. 2025
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
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
    
    // Obtener el código del formulario
    String codigoUnirse = request.getParameter("codigoUnirse");
    
    // Validar parámetro
    if (codigoUnirse == null || codigoUnirse.trim().isEmpty()) {
        response.sendRedirect("menuprincipal.jsp?error=codigo_vacio");
        return;
    }
    
    codigoUnirse = codigoUnirse.trim().toUpperCase();
    
    // Unirse a grupo usando las nuevas clases
    ClsNGrupo negocioGrupo = new ClsNGrupo();
    
    try {
        // Obtener el ID del usuario usando la clase de negocio
        ClsNLogin negocioLogin = new ClsNLogin();
        int idUsuario = negocioLogin.obtenerIdUsuario(usuario);
        
        if (idUsuario <= 0) {
            response.sendRedirect("menuprincipal.jsp?error=usuario_no_encontrado");
            return;
        }
        
        // Buscar el grupo por código usando la clase de negocio
        ClsEGrupo grupo = negocioGrupo.obtenerGrupoPorCodigo(codigoUnirse);
        
        if (grupo == null) {
            response.sendRedirect("unirseGrupo.jsp?error=codigo_invalido");
            return;
        }
        
        // Unirse al grupo usando la clase de negocio
        boolean resultado = negocioGrupo.unirseGrupo(idUsuario, codigoUnirse);
        
        if (resultado) {
            // Información del grupo ya obtenida anteriormente
            
            if (grupo != null) {
                session.setAttribute("grupoActual", grupo.getNombre());
                session.setAttribute("rolUsuario", "miembro");
                session.setAttribute("codigoGrupo", grupo.getCodigo());
                session.setAttribute("idGrupo", grupo.getId());
                
                // Redirigir al menú principal con mensaje de éxito
                response.sendRedirect("menuprincipal.jsp?success=unido_grupo");
            } else {
                response.sendRedirect("unirseGrupo.jsp?error=error_grupo");
            }
        } else {
            response.sendRedirect("unirseGrupo.jsp?error=no_se_pudo_unir");
        }
        
    } catch (Exception e) {
        // Error al unirse al grupo
        e.printStackTrace();
        response.sendRedirect("menuprincipal.jsp?error=error_base_datos");
    }
%>