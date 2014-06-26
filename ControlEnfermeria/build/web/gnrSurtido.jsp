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

%>
<!DOCTYPE html>
<table border="1">
    <tr>
        <td>Servicio</td>
        <td>Clave</td>
        <td>Descripción</td>
        <td>Tab/Amp</td>
        <td>Reponer</td>
    </tr>
    <%        try {
            con.conectar();
            ResultSet rset = con.consulta("select c.clave, c.descrip, sum(cap.cant_sur) from catalogo c, inv i, captura cap, usuarios u where c.clave = i.clave and i.id = cap.id_inv and cap.fecha = '" + request.getParameter("fecha") + "' and u.servicio='" + request.getParameter("central") + "' group by c.clave order by c.clave+0 ");
            while (rset.next()) {
                int cant_disp = 0;
                ResultSet rset2 = con.consulta("select cant_disp from clave_med where clave= '" + rset.getString(1) + "' ");
                while (rset2.next()) {
                    cant_disp = rset2.getInt(1);
                }
                int total_cajas = (int) Math.ceil(rset.getInt(3) / cant_disp);
    %>
    <tr>
        <td><%=request.getParameter("central")%></td>
        <td><%=rset.getString(1)%></td>
        <td><%=rset.getString(2)%></td>
        <td><%=rset.getString(3)%></td>
        <td><%=total_cajas%></td>
    </tr>
    <%
            }
            con.cierraConexion();
        } catch (Exception e) {
            out.println(e.getMessage());
        }
    %>
</table>

<%
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"Surtido-"+request.getParameter("central")+"-"+request.getParameter("fecha")+".xls\"");

%>