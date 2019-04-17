%{
	#include "y.tab.h"
%}
%%

"main" {return tMAIN;}
"{" {return tACCO;}
"}" {return tACCF;}
"const" {return tCONST;}
"int" {return tINT;}
"if" {return tIF;}
"else" {return tELSE;}
"while" {return tWHILE;}

[a-zA-Z][a-zA-Z0-9_]* {yylval.variable = strdup(yytext);
					   					 return tID;}
[0-9]+ {yylval.entier = atoi(yytext);
				return tVAL;}

"+" {return tPLUS;}
"-" {return tMOINS;}
"*" {return tMUL;}
"/" {return tDIV;}
"=" {return tEGAL;}
">" {return tSUP;}
"<" {return tINF;}
"(" {return tPARO;}
")" {return tPARF;}

" " {}
"\t" {}
"\n" {}

"," {return tVIRG;}
";" {return tPV;}

. {return tERR;}
