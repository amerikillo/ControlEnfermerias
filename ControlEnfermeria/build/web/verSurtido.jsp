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
                    <h2>Surtido Diario</h2>
                    <a href="mainMenu.jsp" class="btn btn-default">Surtir</a>
                    <a href="cargaAbasto.jsp" class="btn btn-default">Cargar Abasto</a>
                    <a href="verExistencias.jsp" class="btn btn-default">Existencias</a>
                    <a href="verSurtido.jsp" class="btn btn-info">Surtido</a>
                    <a href="verCatalogo.jsp" class="btn btn-default">Catálogo</a>
                    <a href="index.jsp" class="btn btn-default">Salir</a>
                </div>
                <div class="col-lg-6 text-right">
                    <img src="imagenes/logo_salud_gob.jpg" height="100px" />
                </div>
            </div>
            <br/>
            <div class="row">
                <div class="col-lg-12">
                    <h4><%=(String) sesion.getAttribute("servicio")%></h4>
                </div>
            </div>
            <div class="row">
                <form action="verSurtido.jsp" method="post">
                    <div class="col-lg-2">
                        <input type="text" id="fecha" name="fecha" class="form-control" onchange="this.form.submit();" value="<%=fecha%>"  data-date-format="dd/mm/yyyy"/>
                    </div>

                </form>
                <div class="col-lg-1 col-sm-offset-9">
                    <a href="gnrConsumoDiario.jsp?central=<%=(String) sesion.getAttribute("servicio")%>&fecha=<%=fecha%>"><img src="imagenes/excel.png" width="100%" alt="Exportar"/></a>
                </div>
            </div>
            <table class="table table-bordered table-striped table-condensed" id="tbSurtir">
                <thead>
                    <tr>
                        <td>Clave</td>
                        <td>Descripción</td>
                        <td>Piezas</td>
                        <td>Camas</td>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
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
                </tbody>
            </table>
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
