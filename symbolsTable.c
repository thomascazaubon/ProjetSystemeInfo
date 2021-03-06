#include "symbolsTable.h"

void yyerror(char*);

#define ERR(...) \
	{ \
		char tmp[1024]; \
		sprintf(tmp, __VA_ARGS__); \
		yyerror(tmp); \
	}

Symbol tab_sym[SIZE];
Instruction tab_ins[SIZE];

int index_symbol = 0;
int index_instruction = 0;
int current_depth = 0;

void add_symbol(char * name)
{
	if (get_addr(name) == -1)
	{
		printf("ADDING SYMBOL\n");
		strncpy(tab_sym[index_symbol].name,name,SIZE_NAME);
		tab_sym[index_symbol].addr = index_symbol;
		tab_sym[index_symbol].depth = current_depth;
		index_symbol++;
		print_table_sym();
	}
	else
	{
		ERR("Symbol already defined : '%s'\n", name);
	}
}

int add_symbol_tmp()
{
		printf("ADDING SYMBOL\n");
		int ret;
		strncpy(tab_sym[index_symbol].name,"TMP",SIZE_NAME);
		tab_sym[index_symbol].addr = index_symbol;
		tab_sym[index_symbol].depth = current_depth;
		ret = tab_sym[index_symbol].addr;
		index_symbol++;
		print_table_sym();
		return ret;
}

int pop_symbol_tmp()
{
		printf("POPPING SYMBOL\n");
		int ret = tab_sym[index_symbol-1].addr;
		index_symbol--;
		if (index_symbol < 0)
			index_symbol = 0;
		print_table_sym();
		return ret;
}

int get_addr(char * name)
{
	int addr = -1;
	int i = 0;
	for (i = index_symbol - 1; i >= 0 ; i--)
	{
		if ((strcmp(tab_sym[i].name,name) == 0))
		{
			addr = tab_sym[i].addr;
		}
	}
	return addr;
}

int add_ins(char * name, int i, int j, int k){
	printf("[%s %d %d %d]\n", name, i, j, k);
	strncpy(tab_ins[index_instruction].ins,name,SIZE_NAME);
	tab_ins[index_instruction].i = i;
	tab_ins[index_instruction].j = j;
	tab_ins[index_instruction].k = k;
	index_instruction++;
	return index_instruction-1;
}

void increase_depth(){
	current_depth++;
}

void decrease_depth(){
	while(tab_sym[index_symbol-1].depth == current_depth){
		index_symbol--;
	}
	current_depth--;
	if (index_symbol < 0)
		index_symbol = 0;
}

void update_jmp(int i)
{
	tab_ins[i].i = index_instruction+1;
}

int get_curr_instr()
{
	return index_instruction;
}

void print_table_sym()
{
	int i = 0;
	printf("[------------------ Symbols Table -----------------]\n");
	for (i = 0 ; i<index_symbol ; i++)
	{
		printf("index = %d, name = %s, addr = %d, depth = %d\n",i,tab_sym[i].name,tab_sym[i].addr, tab_sym[i].depth);
	}
	printf("[----------------------- END ----------------------]\n");
}

void print_table_ins()
{
	int i = 0;
	printf("\n[--------------- Instructions Table ---------------]\n");
	for (i = 0 ; i<index_instruction ; i++){
		if ((strcmp(tab_ins[i].ins,"AFC") == 0)){
			printf("%s R%d %d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
		} else {
			if ((strcmp(tab_ins[i].ins,"STORE") == 0)){
				printf("%s @%d R%d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
			} else {
				if ((strcmp(tab_ins[i].ins,"LOAD") == 0)){
					printf("%s R%d @% d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
				} else {
					if ((strcmp(tab_ins[i].ins,"ADD") == 0)){
						printf("%s R%d R%d R%d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
					} else {
						if ((strcmp(tab_ins[i].ins,"SUB") == 0)){
							printf("%s R%d R%d R%d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
						} else {
							if ((strcmp(tab_ins[i].ins,"MUL") == 0)){
								printf("%s R%d R%d R%d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
							} else {
								if ((strcmp(tab_ins[i].ins,"DIV") == 0)){
									printf("%s R%d R%d R%d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
								} else {
									if ((strcmp(tab_ins[i].ins,"JMPC") == 0)){
										printf("%s @%d R%d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
									} else {
										if ((strcmp(tab_ins[i].ins,"JMP") == 0)){
												printf("%s @%d R%d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
										} else {
											if ((strcmp(tab_ins[i].ins,"EQU") == 0)){
													printf("%s R%d R%d R%d,\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
											} else {
												printf("ERROR print_table_ins");
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	printf("[-------------------- END -------------------------]\n");
}

void write_table_ins(){
	FILE * file = fopen("instructions.asm","w+");
	int i;
	for(i = 0 ; i < index_instruction ; i++){
		if ((strcmp(tab_ins[i].ins,"AFC") == 0)){
			fprintf(file,"%s        R%d %d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
		} else {
			if ((strcmp(tab_ins[i].ins,"STORE") == 0)){
				fprintf(file,"%s      @%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
			} else {
				if ((strcmp(tab_ins[i].ins,"LOAD") == 0)){
					fprintf(file,"%s       R%d @%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
				} else {
					if ((strcmp(tab_ins[i].ins,"ADD") == 0)){
						fprintf(file,"%s        R%d R%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
					} else {
						if ((strcmp(tab_ins[i].ins,"SUB") == 0)){
							fprintf(file,"%s        R%d R%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
						} else {
							if ((strcmp(tab_ins[i].ins,"MUL") == 0)){
								fprintf(file,"%s        R%d R%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
							} else {
								if ((strcmp(tab_ins[i].ins,"DIV") == 0)){
									fprintf(file,"%s        R%d R%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
								} else {
									if ((strcmp(tab_ins[i].ins,"JMPC") == 0)){
										fprintf(file,"%s       @%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
									} else {
										if ((strcmp(tab_ins[i].ins,"EQU") == 0)){
												fprintf(file,"%s        R%d R%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
										} else {
											if ((strcmp(tab_ins[i].ins,"SUP") == 0)){
													fprintf(file,"%s        R%d R%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
											}
											else {
												if ((strcmp(tab_ins[i].ins,"INF") == 0)){
														fprintf(file,"%s        R%d R%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j, tab_ins[i].k);
												}
												else {
													if ((strcmp(tab_ins[i].ins,"JMP") == 0)){
															fprintf(file,"%s        @%d R%d\n",tab_ins[i].ins,tab_ins[i].i, tab_ins[i].j);
													}else {
														printf("ERROR print_table_ins");
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	fclose(file);
}
