/* seccion de paquetes e importacion */
package traductores;

import java_cup.runtime.*;

%%

%class BasicLexer
%unicode
%cup
%line
%column
%{
    Object v;
    StringBuffer stringBuffer = new StringBuffer();

    private Symbol symbol (BasicSym type) {
        System.out.printf("%s Operador: <%s>\n", yytext(), type.toString());
        return new Symbol (type.getValue(), yyline, yycolumn) ;
    }

    private Symbol symbol (BasicSym type, Object value) {
        System.out.printf("%s Operador: <%s>\n", value.toString(), type.toString());
        return new Symbol (type.getValue(), yyline, yycolumn, value) ;
    }
%}

%eofval{
    return symbol (BasicSym.EOF);
%eofval}

LineTerminator = \r|\n|\r\n
WhiteSpace     = [ \t\f]
Identifier     = [A-Z]+
Label          = ([0-9][0-9A-Z]*":"? | [0-9A-Z]*":")
Remark         = "REM"{WhiteSpace}.*
Integer        = [0-9]+
Floating       = [0-9]+\.[0-9]+
Char           = "CHAR("{ Integer }")"

%state A
%state STRING
%state CHAR
%%

<YYINITIAL> {
    { Label } { yybegin(A); return symbol(BasicSym.LABEL, yytext()); }
} 

<YYINITIAL,A> {
    { WhiteSpace } {}
    { LineTerminator } {yybegin(YYINITIAL);}
}

<A> {
    { Integer } { return symbol(BasicSym.INTEGER, yytext()); }
    { Floating } { return symbol(BasicSym.FLOAT, yytext()); }
    { Char } { return symbol(BasicSym.CHAR, yytext()); }
    { Remark } { return symbol(BasicSym.REMARK, yytext()); }
    \" { stringBuffer.setLength(0); yybegin(STRING); }
    "," { return symbol(BasicSym.SEPARATOR, yytext()); }
    "(" { return symbol(BasicSym.PL, yytext()); }
    ")" { return symbol(BasicSym.PR, yytext()); }
    "[" { return symbol(BasicSym.BL, yytext()); }
    "]" { return symbol(BasicSym.BR, yytext()); }
    "EQ" { return symbol(BasicSym.IGUAL, yytext()); }
    "#" { return symbol(BasicSym.DIFERENTE, yytext()); }
    ">" { return symbol(BasicSym.MAYOR, yytext()); }
    ">=" { return symbol(BasicSym.MAYOR_IGUAL, yytext()); }
    "<" { return symbol(BasicSym.MENOR, yytext()); }
    "<=" { return symbol(BasicSym.MENOR_IGUAL, yytext()); }
    "=" { return symbol(BasicSym.ASIGNACION, yytext()); }
    "+" { return symbol(BasicSym.SUMA, yytext()); }
    "-" { return symbol(BasicSym.RESTA, yytext()); }
    "*" { return symbol(BasicSym.MULTIPLICACION, yytext()); }
    "/" { return symbol(BasicSym.DIVISION, yytext()); }
    "%" { return symbol(BasicSym.RESIDUO, yytext()); }
    "**" { return symbol(BasicSym.EXPONENTE, yytext()); }
    "^" { return symbol(BasicSym.EXPONENTE, yytext()); }
    ":" { return symbol(BasicSym.CONCAT, yytext()); }
    "CAT" { return symbol(BasicSym.CONCAT, yytext()); }
    "IF" { return symbol(BasicSym.IF, yytext()); }
    "THEN" { return symbol(BasicSym.THEN, yytext()); }
    "ELSE" { return symbol(BasicSym.ELSE, yytext()); }
    "AND" { return symbol(BasicSym.AND, yytext()); }
    "OR" { return symbol(BasicSym.OR, yytext()); }
    "NOT" { return symbol(BasicSym.NOT, yytext()); }
    "MATCH" { return symbol(BasicSym.MATCH, yytext()); }
    "MATCHES" { return symbol(BasicSym.MATCH, yytext()); }
    "REUSE" { return symbol(BasicSym.REUSE, yytext()); }
    "LET" { return symbol(BasicSym.LET, yytext()); }
    "DATA" { return symbol(BasicSym.DATA, yytext()); }
    "READ" { return symbol(BasicSym.READ, yytext()); }
    "DIM" { return symbol(BasicSym.DIM, yytext()); }
    "FOR" { return symbol(BasicSym.FOR, yytext()); }
    "TO" { return symbol(BasicSym.TO, yytext()); }
    "NEXT" { return symbol(BasicSym.NEXT, yytext()); }
    "REPEAT" { return symbol(BasicSym.REPEAT, yytext()); }
    "UNTIL" { return symbol(BasicSym.UNTIL, yytext()); }
    "DO" { return symbol(BasicSym.DO, yytext()); }
    "LOOP" { return symbol(BasicSym.LOOP, yytext()); }
    "GOTO" { return symbol(BasicSym.GOTO, yytext()); }
    "GOSUB" { return symbol(BasicSym.GOSUB, yytext()); }
    "RETURN" { return symbol(BasicSym.RETURN, yytext()); }
    "LIST" { return symbol(BasicSym.LIST, yytext()); }
    "INPUT" { return symbol(BasicSym.INPUT, yytext()); }
    "PRINT" { return symbol(BasicSym.PRINT, yytext()); }
    { Identifier } { return symbol(BasicSym.IDENTIFIER, yytext()); }
    . { System.out.println(yytext()+" Error no se reconoce simbolo"); return symbol(BasicSym.ERROR); }
}

<STRING> {
    \"           { yybegin(YYINITIAL); return symbol(BasicSym.STRING_LITERAL, stringBuffer.toString()); }
    [^\n\r\"\\]+ { stringBuffer.append( yytext() ); }
    \\t          { stringBuffer.append('\t'); }
    \\n          { stringBuffer.append('\n'); }
    \\r          { stringBuffer.append('\r'); }
    \\\"         { stringBuffer.append('\"'); }
    \\           { stringBuffer.append('\\'); }
}

<CHAR> {
    { Integer } { v = Integer.parseInt(yytext()); }
    ")" {
        char chara = (char) v;
        v = null;
        yybegin(YYINITIAL);
        return symbol(BasicSym.CHAR, chara);
    }
}

[^] { throw new Error("Illegal character: \"" + yytext() + "\""); }