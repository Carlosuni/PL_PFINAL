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
Comment = {TraditionalComment} | {EndOfLineComment} | {ModernComment} | {SharpComment}
TraditionalComment = "/*" {CommentContent} \*+ "/"
EndOfLineComment = "//" [^\r\n]* {Newline}
CommentContent = ( [^*] | \*+[^*/] )*

ModernComment = "<!--" ( . | {Newline} )* "-->"
SharpComment = "<#" .*

RealNumber = {Number} "." {Number}
ScienceNumber = ( [1-9] | [1-9] "." {Number} ) "E" ( "-" | "+" | "" ) {Number}
DoubleNumber = {RealNumber} | {ScienceNumber}
HexAlfaNumber = ( [0-9A-F] )+
HexNumber = "0x" {HexAlfaNumber} | "0X" {HexAlfaNumber}
Character = ( {SimpleComma1} . {SimpleComma1} ) | ( {SimpleComma2} . {SimpleComma2} )
BooleanValue = {TrueValue} | {FalseValue}
TrueValue = ( "T" | "t" ) ( "R" | "r" ) ( "U" | "u" ) ( "E" | "e" ) 
FalseValue = ( "F" | "f" ) ( "A" | "a" ) ( "L" | "l" ) ( "S" | "s" ) ( "E" | "e" ) 

//ident = ([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )*
//Whitespace = [ \t\f]
WhitespaceNewline = [ \t\f] | {Newline}

Id = [a-zA-Z_] [A-Z0-9a-z_]*
//AttributeId = "." [a-z] [A-Z0-9a-z]*

SimpleComma = {SimpleComma1} | {SimpleComma2}
SimpleComma1 = "'"
SimpleComma2 = "’"

And = ( "A" | "a" ) ( "N" | "n" ) ( "D" | "d" ) | "&"
Or = ( "O" | "o" ) ( "R" | "r" ) | "|"
Not = ( "N" | "n" ) ( "O" | "o" ) ( "T" | "t" ) 

IntType = ( "E" | "e" ) ( "N" | "n" ) ( "T" | "t" ) ( "E" | "e" ) ( "R" | "r" ) ( "O" | "o" )
RealType = ( "R" | "r" ) ( "E" | "e" ) ( "A" | "a" ) ( "L" | "l" ) 
BooleanType = ( "B" | "b" ) ( "O" | "o" ) ( "O" | "o" ) ( "L" | "l" ) ( "E" | "e" ) ( "A" | "a" ) ( "N" | "n" ) ( "O" | "o" ) 
CharType = ( "C" | "c" ) ( "A" | "a" ) ( "R" | "r" ) ( "A" | "a" ) ( "C" | "c" ) ( "T" | "t" ) ( "E" | "e" ) ( "R" | "r" ) 
StructType = ( "S" | "s" ) ( "T" | "t" ) ( "R" | "r" ) ( "U" | "u" ) ( "C" | "c" ) ( "T" | "t" ) 

Si = ( "S" | "s" ) ( "I" | "i" )
SiNo = ( "S" | "s" ) ( "I" | "i" ) ( "N" | "n" ) ( "O" | "o" ) 
FinSi = ( "F" | "f" ) ( "I" | "i" ) ( "N" | "n" ) ( "S" | "s" ) ( "I" | "i" ) 

Entonces = ( "E" | "e" ) ( "N" | "n" ) ( "T" | "t" ) ( "O" | "o" ) ( "N" | "n" ) ( "C" | "c" ) ( "E" | "e" ) ( "S" | "s" ) 
Mientras = ( "M" | "m" ) ( "I" | "i" ) ( "E" | "e" ) ( "N" | "n" ) ( "T" | "t" ) ( "R" | "r" ) ( "A" | "a" ) ( "S" | "s" )
FinMientras = ( "F" | "f" ) ( "I" | "i" ) ( "N" | "n" ) ( "M" | "m" ) ( "I" | "i" ) ( "E" | "e" ) ( "N" | "n" ) ( "T" | "t" ) ( "R" | "r" ) ( "A" | "a" ) ( "S" | "s" ) 

Funcion = ( "F" | "f" ) ( "U" | "u" ) ( "N" | "n" ) ( "C" | "c" ) ( "I" | "i" ) ( "O" | "o" ) ( "N" | "n" )  
Return = ( "R" | "r" ) ( "E" | "e" ) ( "T" | "t" ) ( "U" | "u" ) ( "R" | "r" ) ( "N" | "n" ) 


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {

  {WhitespaceNewline}	{                              }
  ";"          			{ return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          			{ return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          			{ return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          			{ return symbolFactory.newSymbol("TIMES", TIMES); }
  "/"          			{ return symbolFactory.newSymbol("DIVIDEDBY", DIVIDEDBY); }
  "("          			{ return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          			{ return symbolFactory.newSymbol("RPAREN", RPAREN); }
  {Number}     			{ return symbolFactory.newSymbol("NUMBER", NUMBER, Integer.parseInt(yytext())); }
  {Comment}				{ return symbolFactory.newSymbol("COMMENT", COMMENT, yytext()); }
  {DoubleNumber}		{ return symbolFactory.newSymbol("DOUBLENUMBER", DOUBLENUMBER, Double.parseDouble(yytext())); }
  {HexNumber} 	  	 	{ return symbolFactory.newSymbol("HEXNUMBER", HEXNUMBER, Integer.parseInt(yytext().substring(2,yytext().length()), 16)); }
  {And}          		{ return symbolFactory.newSymbol("AND", AND); }
  {Or}          		{ return symbolFactory.newSymbol("OR", OR); }
  {Not}          		{ return symbolFactory.newSymbol("NOT", NOT); }
  "<"          			{ return symbolFactory.newSymbol("LTHAN", LTHAN); }
  ">"          			{ return symbolFactory.newSymbol("GTHAN", GTHAN); }
  "=="          		{ return symbolFactory.newSymbol("EQUALTO", EQUALTO); }
  "<="          		{ return symbolFactory.newSymbol("LEQUAL", LEQUAL); }
  ">="          		{ return symbolFactory.newSymbol("GEQUAL", GEQUAL); }
  {IntType}      	    { return symbolFactory.newSymbol("INTTYPE", INTTYPE, yytext()); }
  {RealType}     	    { return symbolFactory.newSymbol("REALTYPE", REALTYPE, yytext()); }
  {BooleanType}   	    { return symbolFactory.newSymbol("BOOLEANTYPE", BOOLEANTYPE, yytext()); }
  {CharType}          	{ return symbolFactory.newSymbol("CHARTYPE", CHARTYPE, yytext()); }
  {StructType}      	{ return symbolFactory.newSymbol("STRUCTTYPE", STRUCTTYPE, yytext()); }
  "{"          			{ return symbolFactory.newSymbol("LBRACE", LBRACE); }
  "}"          			{ return symbolFactory.newSymbol("RBRACE", RBRACE); }
  "."          			{ return symbolFactory.newSymbol("DOT", DOT); }
  ","          			{ return symbolFactory.newSymbol("COMMA", COMMA); }
  ":="          		{ return symbolFactory.newSymbol("ASSIGNSYMBOL", ASSIGNSYMBOL); }
  {Si}          		{ return symbolFactory.newSymbol("SI", SI); }
  {Entonces}        	{ return symbolFactory.newSymbol("ENTONCES", ENTONCES); }
  {SiNo}          		{ return symbolFactory.newSymbol("SINO", SINO); }
  {FinSi}          		{ return symbolFactory.newSymbol("FINSI", FINSI); }
  {Mientras}        	{ return symbolFactory.newSymbol("MIENTRAS", MIENTRAS); }
  {FinMientras}     	{ return symbolFactory.newSymbol("FINMIENTRAS", FINMIENTRAS); }
  {Funcion}         	{ return symbolFactory.newSymbol("FUNCION", FUNCION); }
  {Return}          	{ return symbolFactory.newSymbol("RETURN", RETURN); }
  {BooleanValue}    	{ return symbolFactory.newSymbol("BOOLEANVALUE", BOOLEANVALUE, Boolean.parseBoolean(yytext())); }  
  {Character}      		{ return symbolFactory.newSymbol("CHARACTER", CHARACTER, yytext()); }
  {Id}    				{ return symbolFactory.newSymbol("ID", ID, yytext()); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
