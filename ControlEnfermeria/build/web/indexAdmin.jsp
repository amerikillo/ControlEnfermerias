<%-- 
    Document   : login
    Created on : 23-jun-2014, 13:12:34
    Author     : Amerikillo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    String info = "";
    try {
        info = (String) session.getAttribute("mensaje");
    } catch (Exception e) {
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Administrador</title>
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
    </head>
    <body>
        <div class="container" style="width: 500px">
            <form class="form-signin" action="Login" method="POST">
                <div class="row">
                    <div class="col-lg-6">
                        <img src="imagenes/logo_salud_gob.jpg" width="100%" />
                    </div>
                    <div class="col-lg-6 text-right" style="padding-top: 43px;">
                        <img src="imagenes/Logo GNK claro2.jpg.png" height="70px" />
                    </div>
                </div>
                <div class="panel panel-body">
                    <h3>Módulo Central de Enfermería - Administrador</h3>
                    <h4 class="form-signin-heading">Ingrese sus Credenciales</h4>
                    <div class="input-group">
                        <span class="input-group-addon">
                            <label class="glyphicon glyphicon-user"></label>
                        </span>
                        <input type="text" name="user" id="user" class="form-control" placeholder="Introduzca Nombre de Usuario">
                    </div>
                    <div class="input-group">
                        <span class="input-group-addon">
                            <label class="glyphicon glyphicon-lock"></label>
                        </span>
                        <input type="password" name="pass" id="pass" class="form-control"  placeholder="Introduzca Contrase&ntilde;a V&aacute;lida">
                    </div>
                    <%
                        if (info != null) {
                    %>
                    <div class="input-group">
                        <div>Datos inv&aacute;lidos, intente otra vez...</div>
                    </div>
                    <%
                        }
                    %>
                    <button class="btn btn-lg btn-success btn-block" type="submit" name="accion" value="2">Entrar</button>
                </div>
                <div class="row">
                    <div class="col-lg-12 text-center">
                        <img src="imagenes/logo_soriana2.jpg" />
                    </div>
                </div>
            </form>
        </div>
    </body>
    <!-- 
    ================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="js/jquery-1.9.1.js"></script>
    <script src="js/bootstrap.js"></script>
    <script src="js/jquery-ui-1.10.3.custom.js"></script>
</html>
<%
sesion.invalidate();
%>