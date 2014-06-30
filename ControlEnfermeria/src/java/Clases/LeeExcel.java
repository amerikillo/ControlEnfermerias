package Clases;

import java.io.File;
import java.sql.ResultSet;
import jxl.*;

/**
 *
 * @author Indra Hidayatulloh
 */
public class LeeExcel {

    ConectionDB con = new ConectionDB();

    public boolean obtieneArchivo(String path, String file) {
        String excelXLSXFileName = path + "/exceles/" + file;
        leerArchivoExcel(excelXLSXFileName);
        return true;
    }

    private void leerArchivoExcel(String archivoDestino) {
        try {
            Workbook archivoExcel = Workbook.getWorkbook(new File(archivoDestino));
            for (int sheetNo = 0; sheetNo < archivoExcel.getNumberOfSheets(); sheetNo++) // Recorre 
            // cada    
            // hoja                                                                                                                                                       
            {
                Sheet hoja = archivoExcel.getSheet(sheetNo);
                int numColumnas = hoja.getColumns();
                int numFilas = hoja.getRows();
                String data;
                for (int fila = 1; fila < numFilas; fila++) {
                    /*Recorre cada 
                     // fila de la 
                     // hoja */

                    String qry = "insert into abastoTemporal values('";
                    for (int columna = 0; columna < numColumnas; columna++) {
                        /* Recorre cada                                                                                
                         // columna                                                                            
                         // de                                                                                
                         // la                                                                                
                         // fila */

                        //System.out.print(data + " ");
                        if (columna == 0 || columna == 1) {
                            data = hoja.getCell(columna, fila).getContents();
                            qry = qry +data+ "', '";
                        }
                        if (columna==3){
                            
                            data = hoja.getCell(columna, fila).getContents();
                            qry = qry +data+ "',0);";
                        }
                    }
                    System.out.println(qry);
                    try {
                        con.conectar();
                        con.ejecuta(qry);
                        con.cierraConexion();
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

    }
    
    
    

}
