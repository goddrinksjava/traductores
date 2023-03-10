package traductores;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;

import java_cup.runtime.Symbol;

public class App {
  public static void main(String[] args) throws IOException {
    String path = App.class.getResource("/prueba.txt").getFile();
    Reader lector = new BufferedReader(new FileReader(path));
    BasicParser s = new BasicParser(new BasicLexer(lector));

    try {
      System.out.println(s.parse());
      System.out.println("Analisis realizado correctamente");
    } catch (Exception ex) {
      Symbol sym = s.getS();
      System.out.println("Error de sintaxis. Linea: " + (sym.right + 1) +
          " Columna: " + (sym.left + 1) + ", Texto: \"" + sym.value + "\"");
      System.out.println(ex.getMessage());
    }
  }
}
