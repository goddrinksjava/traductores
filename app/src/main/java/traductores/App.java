package traductores;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;

import java_cup.sym;
import java_cup.runtime.Symbol;

public class App {
  public static void main(String[] args) throws IOException {
    String path = App.class.getResource("/prueba.txt").getFile();
    Reader lector = new BufferedReader(new FileReader(path));
    BasicLexer lexer = new BasicLexer(lector);
    while (true) {
      Symbol token = lexer.next_token();
      if (token.sym == sym.EOF) {
        System.out.println("FIN");
        break;
      }
    }
  }
}