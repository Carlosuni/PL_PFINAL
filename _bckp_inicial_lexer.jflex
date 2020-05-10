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

ModernComment = "<!--" ( . | {Newline} )* "-->"

RealNumber = {Number} "." {Number}
ScienceNumber = ( {Number} | {RealNumber} ) ( "e" | "E" )( "-" | "+" | "" ) {Number}
DoubleNumber = {RealNumber} | {ScienceNumber}
HexAlfaNumber = ( [0-9A-F] )+
HexNumber = "0x" {HexAlfaNumber} | "0X" {HexAlfaNumber}

Whitespace = [ \t\f]
WhitespaceNewline = [ \t\f] | {Newline}


Exponential = "exp("
Logarithm = "log("

Id = [a-z] [A-Z0-9a-z]*
CapsId = [A-Z] [A-Z0-9]*

AttributeId = "." [a-z] [A-Z0-9a-z]*

SimpleComma = "'" | "’"



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
  {Exponential}		{ return symbolFactory.newSymbol("EXPONENTIAL", EXPONENTIAL, yytext()); }
  {Logarithm}		{ return symbolFactory.newSymbol("LOGARITHM", LOGARITHM, yytext()); }
  "AND"          	{ return symbolFactory.newSymbol("AND", AND); }
  "OR"          	{ return symbolFactory.newSymbol("OR", OR); }
  "NOT"          	{ return symbolFactory.newSymbol("NOT", NOT); }
  "=="          	{ return symbolFactory.newSymbol("EQUALTO", EQUALTO); }
  "<="          	{ return symbolFactory.newSymbol("LEQUAL", LEQUAL); }
  ">="          	{ return symbolFactory.newSymbol("GEQUAL", GEQUAL); }
  "ENTERO"         	{ return symbolFactory.newSymbol("INTTYPE", INTTYPE); }
  "REAL"          	{ return symbolFactory.newSymbol("REALTYPE", REALTYPE); }
  "BOOLEANO"        { return symbolFactory.newSymbol("BOOLEANTYPE", BOOLEANTYPE); }
  "CARACTER"        { return symbolFactory.newSymbol("CHARTYPE", CHARTYPE); }
  "STRUCT"          { return symbolFactory.newSymbol("STRUCTTYPE", STRUCTTYPE); }
  "{"          		{ return symbolFactory.newSymbol("LBRACE", LBRACE); }
  "}"          		{ return symbolFactory.newSymbol("RBRACE", RBRACE); }
  "."          		{ return symbolFactory.newSymbol("DOT", DOT); }
  ","          		{ return symbolFactory.newSymbol("COMMA", COMMA); }
  {SimpleComma} 	{ return symbolFactory.newSymbol("SIMPLECOMMA", SIMPLECOMMA); }
  ":="          	{ return symbolFactory.newSymbol("ASSIGNSYMBOL", ASSIGNSYMBOL); }
  "SI"          	{ return symbolFactory.newSymbol("SI", SI); }
  "ENTONCES"        { return symbolFactory.newSymbol("ENTONCES", ENTONCES); }
  "SINO"          	{ return symbolFactory.newSymbol("SINO", SINO); }
  "FINSI"          	{ return symbolFactory.newSymbol("FINSI", FINSI); }
  "MIENTRAS"        { return symbolFactory.newSymbol("MIENTRAS", MIENTRAS); }
  "FINMIENTRAS"     { return symbolFactory.newSymbol("FINMIENTRAS", FINMIENTRAS); }
  "FUNCION"         { return symbolFactory.newSymbol("FUNCION", FUNCION); }
  "RETURN"          { return symbolFactory.newSymbol("RETURN", RETURN); }
  {Id}    			{ return symbolFactory.newSymbol("ID", ID, yytext()); }
  {CapsId}          { return symbolFactory.newSymbol("CAPSID", CAPSID, yytext()); }
  {AttributeId}    	{ return symbolFactory.newSymbol("ATTRIBUTEID", ATTRIBUTEID, yytext()); }
  "TRUE"         	{ return symbolFactory.newSymbol("TRUEVALUE", TRUEVALUE); }
  "FALSE"         	{ return symbolFactory.newSymbol("FALSEVALUE", FALSEVALUE); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
