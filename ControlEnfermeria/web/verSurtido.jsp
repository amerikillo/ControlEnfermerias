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

    String fecha = "";
    try {
        fecha = request.getParameter("fecha");
    } catch (Exception e) {

    }
    if (fecha == null) {
        fecha = df3.format(new Date());
    }

    String fechaQry = df2.format(df3.parse(fecha));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title><!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <link href="css/datepicker3.css" rel="stylesheet">
        <!---->

        <!-- 
        ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="js/jquery-1.9.1.js"></script>
        <script src="js/bootstrap.js"></script>
        <script src="js/bootstrap-datepicker.js"></script>
        <script src="js/jquery-ui-1.10.3.custom.js"></script>
    </head>
    <body>
        <div class="container">
            <h3>Ver Surtido Diario</h3>
            <div class="row">
                <div class="col-lg-1">
                    <h4>Fecha:</h4>
                </div>
                <form name="formFecha" id="formFecha">
                    <div class="col-lg-2">
                        <input type="text" name="fecha" id="fecha" class="form-control" data-date-format="dd/mm/yyyy" value="<%=fecha%>" />
                    </div>
                    <div class="col-lg-3">
                        <select name="central" id="central" class="form-control">
                            <option value="">--Seleccione una Central--</option>
                            <%
                            try{
                                con.conectar();
                                ResultSet rset = con.consulta("select u.servicio from captura c, usuarios u where c.id_usuario = u.id group by u.servicio");
                                while(rset.next()){
                                    %>
                                    <option value="<%=rset.getString(1)%>"
                                            <%
                                            if (rset.getString(1).equals(request.getParameter("central"))){
                                                out.println("selected");
                                            }
                                            %>
                                            ><%=rset.getString(1)%></option>
                                    <%
                                }
                                con.cierraConexion();
                            }catch(Exception e){
                                out.println(e.getMessage());
                            }
                            %>
                        </select>
                    </div>
                    <div class="col-lg-2">
                        <button class="btn btn-primary" type="submit">Buscar</button>
                    </div>
                </form>
                <div class="col-lg-1 col-sm-offset-3">
                    <a href="gnrSurtido.jsp?fecha=<%=fechaQry%>&central=<%=request.getParameter("central")%>"><img src="imagenes/excel.png" width="100%" alt="Exportar"/></a>
                </div>
            </div>
            <table class="table table-bordered table-striped table-condensed">
                <tr>
                    <td>Clave</td>
                    <td>Descripción</td>
                    <td>Tab/Amp</td>
                    <td>Reponer</td>
                </tr>
                <%
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("select c.clave, c.descrip, sum(cap.cant_sur) from catalogo c, inv i, captura cap, usuarios u where c.clave = i.clave and i.id = cap.id_inv and cap.fecha = '" + fechaQry + "' and u.servicio='"+request.getParameter("central")+"' group by c.clave order by c.clave+0 ");
                        while (rset.next()) {
                            int cant_disp = 0;
                            ResultSet rset2 = con.consulta("select cant_disp from clave_med where clave= '" + rset.getString(1) + "' ");
                            while (rset2.next()) {
                                cant_disp = rset2.getInt(1);
                            }
                            int total_cajas = (int) Math.ceil(rset.getInt(3) / cant_disp);
                %>
                <tr>
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
        </div>
    </body>
    <script>
        $(function() {
            $("#fecha").datepicker();
            $("#fecha").datepicker('option', {dateFormat: 'dd/mm/yy'});
        });
    </script>
</html>
