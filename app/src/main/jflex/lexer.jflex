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

    private Symbol symbol (int type) {
        System.out.printf("%s\n", yytext());
        return new Symbol (type, yyline, yycolumn) ;
    }

    private Symbol symbol (int type, Object value) {
        System.out.printf("%s\n", value.toString());
        return new Symbol (type, yyline, yycolumn, value) ;
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
    { Remark } { }

    { Integer } { return symbol(BasicSym.INTEGER_LITERAL, yytext()); }
    { Floating } { return symbol(BasicSym.FLOAT_LITERAL, yytext()); }

    { Char } { return symbol(BasicSym.CHAR, yytext()); }

    \" { stringBuffer.setLength(0); yybegin(STRING); }

    "," { return symbol(BasicSym.COMMA, yytext()); }
    "(" { return symbol(BasicSym.PL, yytext()); }
    ")" { return symbol(BasicSym.PR, yytext()); }
    "[" { return symbol(BasicSym.BL, yytext()); }
    "]" { return symbol(BasicSym.BR, yytext()); }

    "+" { return symbol(BasicSym.NUMBINOP, BasicConstants.SUMA); }
    "-" { return symbol(BasicSym.NUMBINOP, BasicConstants.RESTA); }
    "*" { return symbol(BasicSym.NUMBINOP, BasicConstants.MULTIPLICACION); }
    "/" { return symbol(BasicSym.NUMBINOP, BasicConstants.DIVISION); }
    "%" { return symbol(BasicSym.NUMBINOP, BasicConstants.RESIDUO); }
    "**" { return symbol(BasicSym.NUMBINOP, BasicConstants.EXPONENTE); }
    "^" { return symbol(BasicSym.NUMBINOP, BasicConstants.EXPONENTE); }

    "AND" { return symbol(BasicSym.BOOLBINOP, BasicConstants.AND); }
    "OR" { return symbol(BasicSym.BOOLBINOP, BasicConstants.OR); }

    ">" { return symbol(BasicSym.COMP, BasicConstants.MAYOR); }
    "<" { return symbol(BasicSym.COMP, BasicConstants.MENOR); }
    ">=" { return symbol(BasicSym.COMP, BasicConstants.MAYOR_IGUAL); }
    "<=" { return symbol(BasicSym.COMP, BasicConstants.MENOR_IGUAL); }
    "EQ" { return symbol(BasicSym.COMP, BasicConstants.IGUAL); }
    "#" { return symbol(BasicSym.COMP, BasicConstants.DIFERENTE); }

    "NOT" { return symbol(BasicSym.NOT, yytext()); }

    "LET" { return symbol(BasicSym.LET, yytext()); }

    "=" { return symbol(BasicSym.ASSIGN, yytext()); }
    
    ":" { return symbol(BasicSym.CONCAT, yytext()); }
    "CAT" { return symbol(BasicSym.CONCAT, yytext()); }

    "IF" { return symbol(BasicSym.IF, yytext()); }
    "THEN" { return symbol(BasicSym.THEN, yytext()); }
    "ELSE" { return symbol(BasicSym.ELSE, yytext()); }

    "FOR" { return symbol(BasicSym.FOR, yytext()); }
    "TO" { return symbol(BasicSym.TO, yytext()); }
    "NEXT" { return symbol(BasicSym.NEXT, yytext()); }

    "DO" { return symbol(BasicSym.DO, yytext()); }
    "LOOP" { return symbol(BasicSym.LOOP, yytext()); }
    "UNTIL" { return symbol(BasicSym.UNTIL, yytext()); }

    "INPUT" { return symbol(BasicSym.INPUT, yytext()); }
    "PRINT" { return symbol(BasicSym.PRINT, yytext()); }

    { Identifier } { return symbol(BasicSym.IDENTIFIER, yytext()); }

    . { System.out.println(yytext()+" Error no se reconoce simbolo"); }
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