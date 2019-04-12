%{
	#include <stdio.h>
	#include "symbolsTable.h"
	int yylex(void);
	void yyerror(char*);

%}

%union {
	int entier;
	char* variable;
}

%token tMAIN tACCO tACCF tCONST tINT tPTF tID tIF tELSE tVAL tPLUS tMOINS tMUL tDIV tEGAL tPARO tPARF tVIRG tPV tERR

%type <entier> tVAL
%type <variable> tID
%type <entier> tINT
%type <entier> Expression
%type <entier> JMPC
%type <entier> JMP

%left tPLUS tMOINS
%left tMUL tDIV



%%
Start: tMAIN tPARO tPARF Body {
															 write_table_ins();
															};

JMPC: {
		int addr2 = pop_symbol_tmp();
		int addr1 = pop_symbol_tmp();
		add_ins("LOAD",0,addr1,0);
		add_ins("LOAD",1,addr2,0);
		add_ins("EQU",0,0,1);
		$$ = add_ins("JMPC",-1,0,0);
	};

JMP: {$$ = add_ins("JMP",-1,0,0);};

IfSansElse: tIF tPARO Egalite tPARF JMPC Body {update_jmp($5);};

IfAvecElse: tIF tPARO Egalite tPARF JMPC Body JMP tELSE {update_jmp($5);}Body {update_jmp($7);};

If : IfSansElse | IfAvecElse;

Egalite: Expression tEGAL tEGAL Expression;

Body: tACCO {increase_depth();} Instructions tACCF {decrease_depth();};

Instructions: Instruction Instructions | ;

Instruction: Affectation
		| Declaration
		| If;

Declaration: tINT tID tPV {add_symbol($2);
													}
			| tINT tID {add_symbol($2);} tEGAL Expression tPV {
																													pop_symbol_tmp();
																													add_ins("LOAD", 0, $5, 0);
																													add_ins("STORE", get_addr($2), 0, 0);
																												}
			;

Affectation: tID tEGAL Expression tPV {
																				pop_symbol_tmp();
																				add_ins("LOAD", 0, $3, 0);
																				add_ins("STORE", get_addr($1), 0, 0);
																			}
			;


Expression: Expression tPLUS Expression {
																					pop_symbol_tmp();
																				  pop_symbol_tmp();
																				  add_ins("LOAD", 0, $1, 0);
																			  	add_ins("LOAD", 1, $3, 0);
																			  	add_ins("ADD", 0, 0, 1);
																				  int addr3 = add_symbol_tmp();
																				  add_ins("STORE", addr3, 0, 0);
																				  $$ = addr3;
																			  }
	 		| Expression tMOINS Expression {
																			 pop_symbol_tmp();
																			 pop_symbol_tmp();
																		   add_ins("LOAD", 0, $1, 0);
																			 add_ins("LOAD", 1, $3, 0);
												 							 add_ins("SUB", 0, 0, 1);
																			 int addr3 = add_symbol_tmp();
																			 add_ins("STORE", addr3, 0, 0);
																			 $$ = addr3;
																		 }
	 		| Expression tMUL Expression {
																		 pop_symbol_tmp();
																		 pop_symbol_tmp();
																	   add_ins("LOAD", 0, $1, 0);
																		 add_ins("LOAD", 1, $3, 0);
											 							 add_ins("MUL", 0, 0, 1);
																		 int addr3 = add_symbol_tmp();
																		 add_ins("STORE", addr3, 0, 0);
																		 $$ = addr3;
																	 }
	 		| Expression tDIV Expression {
																		 pop_symbol_tmp();
																		 pop_symbol_tmp();
																	   add_ins("LOAD", 0, $1, 0);
																		 add_ins("LOAD", 1, $3, 0);
											 							 add_ins("DIV", 0, 0, 1);
																		 int addr3 = add_symbol_tmp();
																		 add_ins("STORE", addr3, 0, 0);
																		 $$ = addr3;
																	 }
			| tID
					{
						add_symbol_tmp();
						int addr = get_addr($1);
						$$ = addr;
					}
			| tVAL {int addr = add_symbol_tmp();
							add_ins("AFC", 0, $1, 0);
							add_ins("STORE", addr, 0, 0);
							$$ = addr;
				}
				| tMOINS tVAL {int addr = add_symbol_tmp();
								add_ins("AFC", 0, -$2, 0);
								add_ins("STORE", addr, 0, 0);
								$$ = addr;
					}
			;

%%
void yyerror(char* msg) {
		fprintf(stderr, "err: %s\n", msg);
		exit(1);
}

int main(void) {
		yyparse();
}
