package cup.pFinal;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

/* Custom Imports */


%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
Number     = [0-9]+


/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {ModernComment}
TraditionalComment = "/*" {CommentContent} \*+ "/"
EndOfLineComment = "//" [^\r\n]* {Newline}
CommentContent = ( [^*] | \*+[^*/] )*

/* Parte 1. Ejercicio A */
ModernComment = "<!--" ( . | {Newline} )* "-->"

/* Parte 1. Ejercicio B */
RealNumber = {Number} "." {Number}
ScienceNumber = ( {Number} | {RealNumber} ) ( "e" | "E" )( "-" | "+" | "" ) {Number}
DoubleNumber = {RealNumber} | {ScienceNumber}
HexAlfaNumber = ( [0-9A-F] )+
HexNumber = "0x" {HexAlfaNumber} | "0X" {HexAlfaNumber}

/* Parte 1. Ejercicio C */
Whitespace = [ \t\f]
WhitespaceNewline = [ \t\f] | {Newline}
NombrePalabra = [A-ZÑÁÉÍÓÚ] [a-zñáéíóú]+
NombreApellidos = ( {NombrePalabra} {Whitespace}* )+
Email = .+ "@" .+ "." .+
Dni = [0-9]?[0-9]{7} "-" [A-Z] | [0-9]{7,8} [A-Z]
MatriculaRetro = [A-Z]{1,2} "-" [0-9]{5} | [A-Z]{1,2} [0-9]{5}
MatriculaAntigua = [A-Z]{1,2} "-" [0-9]{4} "-" [A-Z]{1,2} | [A-Z]{1,2} [0-9]{4} [A-Z]{1,2}
MatriculaNueva = [0-9]{4} "-" [A-Z]{1,3} | [0-9]{4} [A-Z]{1,3}
Matricula = {MatriculaRetro} | {MatriculaAntigua} | {MatriculaNueva}
Fecha = [0-3]? [0-9] "/" [0-1]? [0-9] "/" [0-9]{4}

/* Parte 2. Ejercicio A */
Exponential = "exp("
Logarithm = "log("


ident = ([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )*


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {

  {WhitespaceNewline} {                              }
  ";"          		{ return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          		{ return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          		{ return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          		{ return symbolFactory.newSymbol("TIMES", TIMES); }
  "/"          		{ return symbolFactory.newSymbol("DIVIDEDBY", DIVIDEDBY); }
  "("          		{ return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          		{ return symbolFactory.newSymbol("RPAREN", RPAREN); }
  {Number}     		{ return symbolFactory.newSymbol("NUMBER", NUMBER, Integer.parseInt(yytext())); }
  {Comment}			{ return symbolFactory.newSymbol("COMMENT", COMMENT, yytext()); }
  {DoubleNumber}	{ return symbolFactory.newSymbol("DOUBLENUMBER", DOUBLENUMBER, Double.parseDouble(yytext())); }
  {HexNumber} 	    { return symbolFactory.newSymbol("HEXNUMBER", HEXNUMBER, Integer.parseInt(yytext().substring(2,yytext().length()), 16)); }
  {NombreApellidos}	{ return symbolFactory.newSymbol("NOMBREAPELLIDOS", NOMBREAPELLIDOS, yytext()); }
  {Email}			{ return symbolFactory.newSymbol("EMAIL", EMAIL, yytext()); }
  {Dni}				{ return symbolFactory.newSymbol("DNI", DNI, yytext()); }
  {Matricula}		{ return symbolFactory.newSymbol("MATRICULA", MATRICULA, yytext()); }
  {Fecha}			{ return symbolFactory.newSymbol("FECHA", FECHA, yytext()); }
  {Exponential}		{ return symbolFactory.newSymbol("EXPONENTIAL", EXPONENTIAL, yytext()); }
  {Logarithm}		{ return symbolFactory.newSymbol("LOGARITHM", LOGARITHM, yytext()); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
