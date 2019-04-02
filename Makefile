compiler : y.tab.c lex.yy.c symbolsTable.c
	gcc lex.yy.c y.tab.c symbolsTable.c -o compiler -ly -ll

lex.yy.c : compiler.l
	flex compiler.l

y.tab.c : compiler.y
	yacc -d -v compiler.y

test : compiler
	./compiler < test.c

clear :
	rm lex.yy.c
	rm y.tab.*
	rm y.output
	rm compiler
	rm instructions.asm
