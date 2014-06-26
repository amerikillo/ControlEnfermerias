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
                                <option value = '' >--Seleccione una Cama--</option>
                                <%
                                    try {
                                        con.conectar();
                                        ResultSet rset = con.consulta("select cama, id from camas order by id+0");
                                        while (rset.next()) {
                                %>
                                <option value = '<%=rset.getString("id")%>' ><%=rset.getString("cama")%></option>
                                <%
                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {

                                    }
                                %>
                            </select>
                        </div>
                    </div>
                    <div id="divSurtir">
                        <form name="formSurtir" id="formSurtir">
                            <div class="panel panel-default">
                                <div class=" panel-heading">
                                    A Surtir
                                </div>
                                <div class="panel-body" id="tSurtir" style="padding: 0px">
                                    <table id="tablaSurtir" name="tablaSurtir" class="table table-bordered table-striped">
                                        <tr>
                                            <td>Insumo</td>
                                            <td>Cant</td>
                                        </tr>
                                        <%
                                            try {
                                                con.conectar();
                                                ResultSet rset = con.consulta("select c.descrip, t.cant, t.id from surtetemporal t, catalogo c where c.clave = t.clave and servicios = '" + sesion.getAttribute("servicio") + "'  ");
                                                while (rset.next()) {
                                        %>
                                        <tr>
                                            <td><button class="btn btn-default btn-block" name="btn<%=rset.getString(3)%>" id="btn<%=rset.getString(3)%>" onclick="eliminaInsumo(this);" >-1</button><%=rset.getString(1)%></td>
                                            <td><%=rset.getString(2)%></td>
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
                                <div class="panel-footer">
                                    <button class="btn btn-primary btn-block" name="btnSurtirSurtir" id="btnSurtirSurtir">Surtir</button>
                                    <button class="btn btn-danger btn-block" name="btnSurtirCancelar" id="btnSurtirCancelar">Cancelar</button>
                                </div>
                            </div>
                        </form>
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
                                <input class="form-control" placeholder="Buscar" id="btnBuscar" name="btnBuscar" onkeyup="buscaInsumo(this);" />
                            </div>
                            <div class="panel-body" id="tablaInsumos">

                                <%
                                    try {
                                        con.conectar();
                                        ResultSet rset = con.consulta("select c.descrip, i.clave from catalogo c, inv i where c.clave = i.clave  order by i.clave+0");
                                        while (rset.next()) {
                                %>
                                <div class="col-lg-3 span12">
                                    <button class="btn btn-lg btn-warning btn-block " id="<%=rset.getString(2)%>" onclick="alert(this.getAttribute('ID'))" name="medicamento"><h6><%=rset.getString(1)%></h6></button>

                                </div>
                                <script>

                                    $('#<%=rset.getString(2)%>').click(function() {
                                        var idMed = '<%=rset.getString(2)%>';
                                        var form = $('#formCatalogo');
                                        var cama = $('#cama').val();
                                        if (cama === "") {
                                            alert("Seleccione una Cama");
                                        } else {
                                            $.ajax({
                                                type: 'GET',
                                                url: 'SurteTemporal?ban=1&medicamento=' + idMed,
                                                data: form.serialize(),
                                                success: function(data) {
                                                    $('#tSurtir').load('mainMenu.jsp #tSurtir');
                                                }
                                            });
                                            return false;
                                        }

                                    });

                                </script>   



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

                                    function eliminaInsumo(item) {
                                        var id = $(item).attr("id");
                                        var clave = id.split("btn");
                                        var cla = clave[1];
                                        var form = $('#formSurtir');
                                        $.ajax({
                                            type: 'GET',
                                            url: 'SurteTemporal?ban=5&cla=' + cla,
                                            data: form.serialize(),
                                            success: function() {
                                                $('#tSurtir').load('mainMenu.jsp #tSurtir');
                                            }, error: function() {
                                                alert("Error");
                                            }
                                        });
                                    }
                                    /*$('#tablaInsumos').load('mainMenu.jsp?descrip= #tablaInsumos');
                                     function buscaInsumo(item) {
                                     $('#tablaInsumos').load('mainMenu.jsp?descrip=' + item.value + ' #tablaInsumos');
                                     }*/


                                    $('#formCatalogo').submit(function() {
                                        //alert("Ingresó");
                                        return false;
                                    });
                                    $('#formSurtir').submit(function() {
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


        <%
                    }
                } catch (Exception e) {

                }
                con.cierraConexion();
            } catch (Exception e) {

            }
        %>


                                    $('#btnSurtirCancelar').click(function() {
                                        var form = $('#formSurtir');
                                        $.ajax({
                                            type: 'GET',
                                            url: 'SurteTemporal?ban=3',
                                            data: form.serialize(),
                                            success: function() {
                                                $('#tSurtir').load('mainMenu.jsp #tSurtir');
                                            }
                                        });
                                    });

                                    $('#btnSurtirSurtir').click(function() {
                                        var form = $('#formSurtir');
                                        var cama = $('#cama').val();
                                        if (cama === "") {
                                            alert("Seleccione una Cama");
                                            return false;
                                        } else {
                                            $.ajax({
                                                type: 'GET',
                                                url: 'SurteTemporal?ban=4&cama=' + cama,
                                                data: form.serialize(),
                                                success: function(data) {
                                                    $('#tSurtir').load('mainMenu.jsp #tSurtir');
                                                }
                                            });
                                        }
                                    });



    </script>


</html>
