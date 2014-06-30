<%-- 
    Document   : cargaExcel
    Created on : 04-jun-2014, 8:30:07
    Author     : Amerikillo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    String user=""; String servi = "";
    try {
        servi = (String) sesion.getAttribute("servicio");
    } catch (Exception e) {
    }
    
    if (servi==null){
        response.sendRedirect("index.jsp");
    }

    try{
        user =(String) sesion.getAttribute("usuario");
    }catch (Exception e){
        
    }
    if (user==null){
        //response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cargar Abasto</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css"> 
    </head>
    <body>
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <h2>Cargar Abasto</h2>
                    <a href="mainMenu.jsp" class="btn btn-default">Surtir</a>
                    <a href="cargaAbasto.jsp" class="btn btn-info">Cargar Abasto</a>
                    <a href="verExistencias.jsp" class="btn btn-default">Existencias</a>
                    <a href="verSurtido.jsp" class="btn btn-default">Surtido</a>
                    <a href="index.jsp" class="btn btn-default">Salir</a>
                </div>
                <div class="col-lg-6 text-right">
                    <img src="imagenes/logo_salud_gob.jpg" height="100px" />
                </div>
            </div>
            <br/>
            <form method="post" class="jumbotron"  action="FileUploadServlet" enctype="multipart/form-data" name="form1">
                <div class="row">
                    <div class="col-lg-4 text-success">
                        <h4>Seleccione el Excel a Cargar</h4>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-4">
                        <input class="form-control" type="file" name="file1" accept=".xls"/>
                    </div>
                    <div class="col-lg-4">
                        <button class="btn btn-block btn-success" type="submit">Enviar</button>
                    </div>
                </div>
            </form>
        </div>
    </body>
</html>
