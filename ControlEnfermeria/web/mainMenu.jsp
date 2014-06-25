<%-- 
    Document   : index
    Created on : 21-jun-2014, 12:46:00
    Author     : Amerikillo
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    ConectionDB con = new ConectionDB();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <!---->

    </head>
    <body>
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <h2>Control de Medicamento a Camas</h2>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-3">
                    <div class="panel panel-default">
                        <div class=" panel-heading">
                            Camas
                        </div>
                        <div class="panel-body">
                            <select class="form-control" name="cama" id="cama" onchange="selectCama();">
                                <%
                                    try {
                                        con.conectar();
                                        ResultSet rset = con.consulta("select cama, id from camas order by id+0");
                                        while (rset.next()) {
                                %>
                                <option><%=rset.getString("cama")%></option>
                                <%
                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {

                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="panel panel-default">
                        <div class=" panel-heading">
                            A Surtir
                        </div>
                        <div class="panel-body">
                            Paracetamol 4
                        </div>
                        <div class="panel-footer">
                            <button class="btn btn-primary btn-block">Surtir</button>
                        </div>
                    </div>
                </div>
                <div class="col-lg-9">
                    <div class="row">
                        <label class="col-lg-3 form-inline">
                            Cama Seleccionada:
                        </label>
                        <div class="col-lg-7 form-inline">
                            <input type="text" value="" class="form-control" id="camaSeleccionada" />
                        </div>
                    </div>
                    <br/>
                    <form name="formCatalogo" id="formCatalogo">
                        <div class="panel panel-success">
                            <div class=" panel-heading">
                                Catálogo
                                <input class="form-control" placeholder="Buscar" />
                            </div>
                            <div class="panel-body">

                                <%
                                    try {
                                        con.conectar();
                                        ResultSet rset = con.consulta("select c.descrip, i.clave from catalogo c, inv i where c.clave = i.clave order by i.clave+0");
                                        while (rset.next()) {
                                %>
                                <div class="col-lg-3 span12">
                                    <button class="btn btn-lg btn-warning btn-block " id="<%=rset.getString(2)%>" name="medicamento"><h6><%=rset.getString(1)%></h6></button>

                                </div>
                                <%
                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {

                                    }
                                %>

                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
    <!-- 
    ================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="js/jquery-1.9.1.js"></script>
    <script src="js/bootstrap.js"></script>
    <script src="js/jquery-ui-1.10.3.custom.js"></script>
    <script>
                                function selectCama() {
                                    var cama = document.getElementById("cama").value;
                                    document.getElementById("camaSeleccionada").value = cama;
                                }


                                $('#formCatalogo').submit(function() {
                                    //alert("Ingresó");
                                    return false;
                                });

        <%
            try {
                con.conectar();
                try {
                    ResultSet rset = con.consulta("select c.descrip, i.clave from catalogo c, inv i where c.clave = i.clave order by i.clave+0");
                    while (rset.next()) {
        %>
                                $('#<%=rset.getString(2)%>').click(function() {
                                    var idMed = '<%=rset.getString(2)%>';
                                    var form = $('#formCatalogo');
                                    $.ajax({
                                        type: 'GET',
                                        url: 'SurteTemporal?medicamento='+idMed,
                                        data: form.serialize(),
                                        success: function(data) {
                                            alert("Todo ok");
                                        }
                                    });
                                    return false;
                                });
        <%
                    }
                } catch (Exception e) {

                }
                con.cierraConexion();
            } catch (Exception e) {

            }
        %>

    </script>
</html>
