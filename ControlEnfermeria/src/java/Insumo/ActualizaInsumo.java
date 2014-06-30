/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Insumo;

import Clases.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Amerikillo
 */
public class ActualizaInsumo extends HttpServlet {

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
        try {
            con.conectar();
            try {
                int minInv = 0, maxInv = 0;
                ResultSet rset = con.consulta("select min(id), max(id) from inv");
                while (rset.next()) {
                    minInv = Integer.parseInt(rset.getString(1));
                    maxInv = Integer.parseInt(rset.getString(2));
                }
                System.out.println(minInv + "---" + maxInv);
                int i = minInv;
                while (i <= maxInv) {
                    System.out.println(i);
                    try {
                        String valor = request.getParameter(String.valueOf(i));
                        if (valor != null) {
                            System.out.println("update inv set piezas = '" + request.getParameter(i + "") + "' where id = '" + i + "' ");
                            con.ejecuta("update inv set piezas = '" + request.getParameter(i + "") + "' where id = '" + i + "' ");
                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                    i++;
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
            con.cierraConexion();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        response.sendRedirect("editaMedicamento.jsp");
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
