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

    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"Surtido-" + request.getParameter("central") + "-" + new Date() + ".xls\"");

%>
<!DOCTYPE html>
<table border="1">
    <tr>
        <td>Clave</td>
        <td>Descripción</td>
        <td>Piezas</td>
        <td>Cajas</td>
        <td>Stock Min</td>
        <td>Stock Max</td>
        <td>Reponer</td>
    </tr>
    <%                    try {
            con.conectar();
            ResultSet rset = con.consulta("select c.clave, c.descrip from catalogo c, stock st, servicios s where c.clave = st.clave and st.id_serv = s.id and s.servicio ='" + (String) sesion.getAttribute("servicio") + "' and st.maximo!=0 ");
            while (rset.next()) {
                String max = "", min = "", inv = "0";
                int cant_disp = 0;
                ResultSet rset2 = con.consulta("select cant_disp from clave_med where clave= '" + rset.getString(1) + "' ");
                while (rset2.next()) {
                    cant_disp = rset2.getInt(1);
                }

                rset2 = con.consulta("select piezas from inv i, servicios s where i.id_serv = s.id and clave = '" + rset.getString(1) + "' and s.servicio = '" + (String) sesion.getAttribute("servicio") + "'   ");
                while (rset2.next()) {
                    inv = rset2.getString(1);
                }
                int cajasExist = 0;
                try {
                    cajasExist = (int) Math.ceil(Integer.parseInt(inv) / cant_disp);
                } catch (Exception e) {

                }

                rset2 = con.consulta("select st.maximo, st.minimo from stock st, servicios s where st.id_serv = s.id and clave = '" + rset.getString(1) + "' and s.servicio = '" + (String) sesion.getAttribute("servicio") + "'   ");
                while (rset2.next()) {
                    max = rset2.getString(1);
                    min = rset2.getString(2);
                }

                int reponer = Integer.parseInt(max) - cajasExist;
                if (reponer < 0) {
                    reponer = 0;
                }
    %>
    <tr>
        <td><%=rset.getString(1)%></td>
        <td><%=rset.getString(2)%></td>
        <td><%=inv%></td>
        <td><%=cajasExist%></td>
        <td><%=min%></td>
        <td><%=max%></td>
        <td><strong><%=reponer%></strong></td>
    </tr>
    <%
            }
            con.cierraConexion();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    %>
</table>

