%{
	#include "y.tab.h"
%}
%%

"main" {return tMAIN;}
"{" {return tACCO;}
"}" {return tACCF;}
"const" {return tCONST;}
"int" {return tINT;}
"printf" {return tPTF;}
"if" {return tIF;}
"else" {return tELSE;}

[a-zA-Z][a-zA-Z0-9_]* {yylval.variable = strdup(yytext);
					   					 return tID;}
[0-9]+ {yylval.entier = atoi(yytext);
				return tVAL;}

"+" {return tPLUS;}
"-" {return tMOINS;}
"*" {return tMUL;}
"/" {return tDIV;}
"=" {return tEGAL;}
"(" {return tPARO;}
")" {return tPARF;}

" " {}
"\t" {}
"\n" {}

"," {return tVIRG;}
";" {return tPV;}

. {return tERR;}
