<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%
    ConectionDB con = new ConectionDB();
    try {
        con.conectar();
        try {
            ResultSet rset = con.consulta("select * from captura");
            while (rset.next()) {
                String clave = "", id_serv="", id_invN="";
                ResultSet rset2 = con.consulta("select clave from inv where id = '"+rset.getString("id_inv")+"' ");
                while (rset2.next()) {
                    clave = rset2.getString(1);
                }
				rset2 = con.consulta("select id_serv from usuarios where id = '"+rset.getString("id_usuario")+"' ");
                while (rset2.next()) {
                    id_serv = rset2.getString("id_serv");
                }
				
				rset2 = con.consulta("select id from inv where clave = '"+clave+"' and id_serv='"+id_serv+"' ");
                while (rset2.next()) {
                    id_invN = rset2.getString("id");
                }
				
                try {
                    con.ejecuta("update captura set id_inv = '"+id_invN+"' where id_inv= '"+rset.getString("id_inv")+"'");
                } catch (Exception e) { 
					System.out.println(e.getMessage());
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