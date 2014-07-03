<%-- 
    Document   : verSurtido
    Created on : 26-jun-2014, 10:57:26
    Author     : Amerikillo
--%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%
    HttpSession sesion = request.getSession();
    ConectionDB con = new ConectionDB();
    String servi = "";
    try {
        servi = (String) sesion.getAttribute("servicio");
    } catch (Exception e) {
    }

    if (servi == null) {
        response.sendRedirect("index.jsp");
    }

    String fecha = "";
    try {
        fecha = request.getParameter("fecha");
    } catch (Exception e) {

    }
    if (fecha == null) {
        fecha = df3.format(new Date());
    }

    String fechaQry = df2.format(df3.parse(fecha));
    
    
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"ConsumoDiario-" + request.getParameter("central") + "-" + new Date() + ".xls\"");

%>
<!DOCTYPE html>
<table border="1">
    <tr>
        <td>Clave</td>
        <td>Descripción</td>
        <td>Piezas</td>
        <td>Camas</td>
    </tr>
    <%                        try {
            con.conectar();
            ResultSet rset = con.consulta("SELECT	cat.clave,	cat.descrip,	c.cant_sur, cam.cama FROM	captura c,	catalogo cat,	inv i,	servicios s, camas cam WHERE cam.id = c.id_cama and c.id_inv = i.id AND cat.clave = i.clave AND i.id_serv = s.id AND c.fecha = '" + fechaQry + "' AND s.servicio = '" + (String) sesion.getAttribute("servicio") + "'");
            while (rset.next()) {

    %>
    <tr>
        <td><%=rset.getString(1)%></td>
        <td><%=rset.getString(2)%></td>
        <td><strong><%=rset.getString(3)%></strong></td>
        <td><strong><%=rset.getString(4)%></strong></td>
    </tr>
    <%
            }
            con.cierraConexion();
        } catch (Exception e) {
            out.println(e.getMessage());
        }
    %>
</table>