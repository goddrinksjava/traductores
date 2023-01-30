/* seccion de paquetes e importacion */

import java_cup.runtime.*;
import traductores.BasicSym;

%%

%class HoloLive
%unicode
%cup
%line
%column
%{
    private Symbol symbol (int type) {
        return new Symbol (type, yyline, yycolumn) ;
    }

    private Symbol symbol (int type, Object value) {
        return new Symbol (type, yyline, yycolumn, value) ;
    }
%}

%eofval{
    return symbol (BasicSym.EOF);
%eofval}

%%
"=" { return symbol(BasicSym.ASIGNACION, yytext()); }
"+" { return symbol(BasicSym.SUMA, yytext()); }
"-" { return symbol(BasicSym.RESTA, yytext()); }
"*" { return symbol(BasicSym.MULTIPLICACION, yytext()); }
"/" { return symbol(BasicSym.DIVISION, yytext()); }
"%" { return symbol(BasicSym.RESIDUO, yytext()); }
[^] { throw new Error("Illegal character <"+yytext()+">"); }