/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package in.co.sneh.controller;

import in.co.sneh.model.FileUpload;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import java.io.InputStream;
import java.io.PrintWriter;
import org.apache.commons.fileupload.FileItemIterator;
import javax.servlet.http.HttpSession;
import Clases.*;
import java.sql.ResultSet;

/**
 *
 * @author CEDIS TOLUCA3
 */
public class FileUploadServlet extends HttpServlet {
    
    LeeExcel lee = new LeeExcel();
    ConectionDB con = new ConectionDB();
    
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ConectionDB con = new ConectionDB();
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        HttpSession sesion = request.getSession(true);
        String Unidad = "";
        try {
            con.conectar();
            con.ejecuta("delete from abastoTemporal where servicio = '" + (String) sesion.getAttribute("servicio") + "'");
            con.cierraConexion();
        } catch (Exception e) {
        }
        boolean isMultiPart = ServletFileUpload.isMultipartContent(request);
        if (isMultiPart) {
            ServletFileUpload upload = new ServletFileUpload();
            try {
                FileItemIterator itr = upload.getItemIterator(request);
                while (itr.hasNext()) {
                    FileItemStream item = itr.next();
                    if (item.isFormField()) {
                        String fielName = item.getFieldName();
                        InputStream is = item.openStream();
                        byte[] b = new byte[is.available()];
                        is.read(b);
                        String value = new String(b);
                        response.getWriter().println(fielName + ":" + value + "<br/>");
                    } else {
                        String path = getServletContext().getRealPath("/");
                        if (FileUpload.processFile(path, item)) {
                            //response.getWriter().println("file uploaded successfully");
                            if (lee.obtieneArchivo(path, item.getName())) {
                                cargaInventario((String) sesion.getAttribute("servicio"));
                                out.println("<script>alert('Se cargó el Folio Correctamente')</script>");
                                out.println("<script>window.location='cargaAbasto.jsp'</script>");
                            }
                            //response.sendRedirect("cargaFotosCensos.jsp");
                        } else {
                            //response.getWriter().println("file uploading falied");
                            //response.sendRedirect("cargaFotosCensos.jsp");
                        }
                    }
                }
            } catch (FileUploadException fue) {
                fue.printStackTrace();
            }
            out.println("<script>alert('No se pudo cargar el Folio, verifique las celdas')</script>");
            out.println("<script>window.location='cargaAbasto.jsp'</script>");
            //response.sendRedirect("carga.jsp");
        }

        /*
         * Para insertar el excel en tablas
         */
    }
    
    public void cargaInventario(String servicio) {
        try {
            con.conectar();
            try {
                String idServ = "";
                ResultSet rset = con.consulta("select id from servicios where servicio = '" + servicio + "' ");
                while (rset.next()) {
                    idServ = rset.getString(1);
                }
                rset = con.consulta("select * from abastoTemporal where servicio = '" + servicio + "' ");
                while (rset.next()) {
                    int ban = 0;
                    int cantInv=0;
                    ResultSet rset2 = con.consulta("select id, piezas from inv where clave = '" + rset.getString("clave") + "' and id_serv = '"+idServ+"'");
                    while (rset2.next()) {
                        ban = 1;
                        cantInv = rset2.getInt(2);
                    }
                    System.out.println(ban);
                    int cantAmp = 0;
                    rset2 = con.consulta("select cant_disp from clave_med where clave = '" + rset.getString("clave") + "'");
                    while (rset2.next()) {
                        cantAmp=rset2.getInt(1);
                    }
                    
                    int nCanAmp=cantAmp*rset.getInt("cant");
                    if (ban == 0) {//Insumo Inexistente
                        System.out.println("insert into inv values (0,'" + rset.getString("clave") + "','" + nCanAmp + "','" + idServ + "') ");
                        con.ejecuta("insert into inv values (0,'" + rset.getString("clave") + "','" + nCanAmp + "','" + idServ + "') ");
                    } else {//Insumo Existente
                        int nCant=cantInv+nCanAmp;
                        con.ejecuta("update inv set piezas = '"+nCant+"' where clave = '" + rset.getString("clave") + "' and id_serv='" + idServ + "' ");
                    }
                }
            } catch (Exception e) {
            }
            con.cierraConexion();
        } catch (Exception e) {
        }
    }
    
}
