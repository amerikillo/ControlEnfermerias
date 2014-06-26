/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Surtir;

import Clases.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 *
 * @author Amerikillo
 */
public class SurteTemporal extends HttpServlet {

    ConectionDB con = new ConectionDB();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();
        JSONArray jsona = new JSONArray();
        HttpSession sesion = request.getSession(true);
        try {
            String idMed = request.getParameter("medicamento");
            con.conectar();
            try {
                if (request.getParameter("ban").equals("1")) {
                    try {
                        String clave = "", idTemp = "", idInv = "";
                        int banExisteIns = 0, cantTemp = 0, cantInv = 0;
                        System.out.println("select clave from inv where id = '" + idMed + "' ");
                        ResultSet rset = con.consulta("select id, cant from surtetemporal where clave = '" + idMed + "' ");
                        while (rset.next()) {
                            banExisteIns = 1;
                            idTemp = rset.getString(1);
                            cantTemp = rset.getInt(2);
                        }
                        rset = con.consulta("select id, piezas from inv where clave = '" + idMed + "' ");
                        while (rset.next()) {
                            idInv = rset.getString(1);
                            cantInv = rset.getInt(2);
                        }
                        if (cantInv <= 0) {

                        } else {
                            if (banExisteIns == 1) {
                                con.ejecuta("update  surtetemporal set cant = '" + (cantTemp + 1) + "' where id = '" + idTemp + "' ");
                                con.ejecuta("update  inv set piezas = '" + (cantInv - 1) + "' where id = '" + idInv + "' ");
                            } else {
                                con.ejecuta("insert into surtetemporal values (0,'" + idMed + "','1','" + sesion.getAttribute("id") + "','" + sesion.getAttribute("servicio") + "')");
                                con.ejecuta("update  inv set piezas = '" + (cantInv - 1) + "' where id = '" + idInv + "' ");
                            }
                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                } else if (request.getParameter("ban").equals("2")) {
                    ResultSet rset = con.consulta("select c.descrip, t.cant from surtetemporal t, catalogo c where c.clave = t.clave and servicios = '" + sesion.getAttribute("servicio") + "' ");
                    while (rset.next()) {
                        json.put("descrip", rset.getString("descrip"));
                        json.put("cant", rset.getString("cant"));
                        jsona.add(json);
                        json = new JSONObject();
                    }
                    out.println(jsona);
                } else if (request.getParameter("ban").equals("3")) {
                    con.conectar();
                    ResultSet rset = con.consulta("select clave, cant from surtetemporal");
                    while (rset.next()) {
                        String clave = rset.getString("clave");
                        int cantInv = rset.getInt("cant");
                        ResultSet rset2 = con.consulta("select piezas from inv where clave = '" + clave + "' ");
                        while (rset2.next()) {
                            con.ejecuta("update inv set piezas = '"+(rset2.getInt(1)+cantInv)+"' where clave = '"+clave+"'  ");
                        }
                    }
                    con.ejecuta("delete from surtetemporal");
                    con.cierraConexion();
                } else if (request.getParameter("ban").equals("4")) {
                    int folio = dameFolioCaptura();

                    con.conectar();
                    ResultSet rset = con.consulta("select clave, cant from surtetemporal where id_usu = '" + sesion.getAttribute("id") + "' ");
                    while (rset.next()) {
                        String id = "";
                        ResultSet rset2 = con.consulta("select id from inv where clave = '" + rset.getString(1) + "' ");
                        while (rset2.next()) {
                            id = rset2.getString(1);
                        }
                        con.ejecuta("insert into captura values (0, '" + folio + "', CURDATE(), CURTIME(), '" + id + "', '" + rset.getString(2) + "', '" + request.getParameter("cama") + "', '" + sesion.getAttribute("id") + "'  )");
                    }
                    con.ejecuta("delete from surtetemporal");
                    con.cierraConexion();
                } else if (request.getParameter("ban").equals("5")) {
                    con.conectar();
                    String idInv = "", clave = "";
                    int cant = 0, cantInv = 0;
                    ResultSet rset = con.consulta("select cant, clave from surtetemporal where id = '" + request.getParameter("cla") + "' ");
                    while (rset.next()) {
                        cant = rset.getInt(1);
                        clave = rset.getString(2);
                    }

                    rset = con.consulta("select id, piezas from inv where clave = '" + clave + "' ");
                    while (rset.next()) {
                        idInv = rset.getString(1);
                        cantInv = rset.getInt(2);
                    }
                    System.out.println(cantInv);
                    if (cant > 0) {
                        System.out.println("update surtetemporal set cant = '" + (cant - 1) + "' where id = '" + request.getParameter("cla") + "' ");
                        con.ejecuta("update surtetemporal set cant = '" + (cant - 1) + "' where id = '" + request.getParameter("cla") + "' ");
                    } else {
                        System.out.println("delete from surtetemporal where id = '" + request.getParameter("cla") + "'");
                        con.ejecuta("delete from surtetemporal where id = '" + request.getParameter("cla") + "'");
                    }

                    con.ejecuta("update  inv set piezas = '" + (cantInv + 1) + "' where clave = '" + clave + "' ");
                    con.cierraConexion();
                }

            } catch (Exception e) {
                System.out.println("Error1" + e.getMessage());
            }
            con.cierraConexion();
        } catch (Exception e) {
            System.out.println("Error2" + e.getMessage());
        }
    }

    public int dameFolioCaptura() {
        int folio = 0;
        try {
            con.conectar();
            try {
                ResultSet rset = con.consulta("select folioCaptura from indices");
                while (rset.next()) {
                    folio = rset.getInt(1);
                }
                if (folio == 0) {
                    con.ejecuta("insert into indices (folioCaptura) values (1)");
                    folio = 1;
                } else {
                    con.ejecuta("update indices set folioCaptura = '" + (folio + 1) + "' ");
                }
            } catch (Exception e) {
                System.out.println("ErrorFolio" + e.getMessage());
            }
            con.cierraConexion();
        } catch (Exception e) {
            System.out.println("ErrorFolio" + e.getMessage());
        }
        return folio;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
