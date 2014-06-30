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
    String id = "";
    try {
        id = (String) sesion.getAttribute("id");
    } catch (Exception e) {
    }

    if (id == null) {
        response.sendRedirect("indexAdmin.jsp");
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
        <link rel="stylesheet" type="text/css" href="css/dataTables.bootstrap.css">
        <!---->

        <!-- 
        ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="js/jquery-1.9.1.js"></script>
        <script src="js/bootstrap.js"></script>
        <script src="js/bootstrap-datepicker.js"></script>
        <script src="js/jquery-ui-1.10.3.custom.js"></script>
        <script src="js/jquery.dataTables.js"></script>
        <script src="js/dataTables.bootstrap.js"></script>
    </head>
    <body>
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <h2>Edita Insumo</h2>
                    <a href="mainAdmin.jsp" class="btn btn-default">Consulta Existencias</a>
                    <a href="editaMedicamento.jsp" class="btn btn-info">Edita Existencias</a>
                    <a href="indexAdmin.jsp" class="btn btn-default">Salir</a>
                </div>
                <div class="col-lg-6 text-right">
                    <img src="imagenes/logo_salud_gob.jpg" height="100px" />
                </div>
            </div>
            <br/>
            <div class="row">
                <div class="col-lg-12">
                    <h4></h4>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-3">
                    <form action="editaMedicamento.jsp" method="post">
                        <select class="form-control" onchange="this.form.submit();" name="central">
                            <option value="">--Seleccione Central--</option>
                            <%
                                try {
                                    con.conectar();
                                    ResultSet rset = con.consulta("select s.servicio from servicios s, inv i where i.id_serv = s.id group by s.servicio;");
                                    while (rset.next()) {
                            %>
                            <option value="<%=rset.getString(1)%>"
                                    <%
                                        try {
                                            if (request.getParameter("central").equals(rset.getString(1))) {
                                                out.println(" selected ");
                                            }
                                        } catch (Exception e) {

                                        }
                                    %>
                                    ><%=rset.getString(1)%></option>
                            <%
                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {

                                }
                            %>
                        </select>
                </div>
            </div>
            <br/>
            <form action="ActualizaInsumo">
                <div class="col-lg-3 col-sm-offset-9">
                    <button class="btn btn-primary btn-block">Actualizar</button>
                </div>
                <br/>
                <br/>
                <table class="table table-bordered table-striped table-condensed" id="tbSurtir">
                    <thead>
                        <tr>
                            <td>Clave</td>
                            <td>Descripción</td>
                            <td>Piezas</td>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                con.conectar();
                                ResultSet rset = con.consulta("select c.clave, c.descrip from catalogo c, stock st, servicios s where c.clave = st.clave and st.id_serv = s.id and s.servicio ='" + request.getParameter("central") + "' and st.maximo!=0 ");
                                while (rset.next()) {
                                    String max = "", min = "", inv = "0", idInv = "";
                                    int cant_disp = 0;
                                    ResultSet rset2 = con.consulta("select cant_disp from clave_med where clave= '" + rset.getString(1) + "' ");
                                    while (rset2.next()) {
                                        cant_disp = rset2.getInt(1);
                                    }

                                    rset2 = con.consulta("select piezas, i.id from inv i, servicios s where i.id_serv = s.id and clave = '" + rset.getString(1) + "' and s.servicio = '" + request.getParameter("central") + "'   ");
                                    while (rset2.next()) {
                                        inv = rset2.getString(1);
                                        idInv = rset2.getString(2);
                                    }
                                    int cajasExist = 0;
                                    try {
                                        cajasExist = (int) Math.ceil(Integer.parseInt(inv) / cant_disp);
                                    } catch (Exception e) {

                                    }

                                    rset2 = con.consulta("select st.maximo, st.minimo from stock st, servicios s where st.id_serv = s.id and clave = '" + rset.getString(1) + "' and s.servicio = '" + request.getParameter("central") + "'   ");
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
                            <td><input type="text" value="<%=inv%>" name="<%=idInv%>" id="<%=idInv%>" /></td>
                        </tr>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception e) {
                                out.println(e.getMessage());
                            }
                        %>
                    </tbody>
                </table>
            </form>
        </div>
    </body>
    <script>
        $(function() {
            $("#fecha").datepicker();
            $("#fecha").datepicker('option', {dateFormat: 'dd/mm/yy'});
        });
        $(document).ready(function() {
            $('#tbSurtir').dataTable();
        });
    </script>
</html>
