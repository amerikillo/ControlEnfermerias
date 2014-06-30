<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%
    ConectionDB con = new ConectionDB();
    try {
        con.conectar();
        con.ejecuta("delete from stock;");
        try {
            ResultSet rset = con.consulta("select field1, field2, field6,field7 from stockTodo");
            while (rset.next()) {
                String idServ = "";
                ResultSet rset2 = con.consulta("select id from servicios where servicio = '" + rset.getString(1) + "' ");
                while (rset2.next()) {
                    idServ = rset2.getString(1);
                }
                try {

                    con.ejecuta("insert into stock values('" + rset.getString(2) + "','" + rset.getString(3) + "','" + rset.getString(4) + "',0,'" + idServ + "')");
                } catch (Exception e) {

                    System.out.println(rset.getString(1)+"insert into stock values('" + rset.getString(2) + "','" + rset.getString(3) + "','" + rset.getString(4) + "',0,'" + idServ + "')");
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        con.cierraConexion();
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }
%>