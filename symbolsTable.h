#ifndef SYMBOLSTABLE_H
#define SYMBOLSTABLE_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 1024
#define SIZE_NAME 64

typedef struct {
	char name[SIZE_NAME];
	int addr;
	int depth;
} Symbol;

typedef struct {
	char ins[SIZE_NAME];
	int i;
	int j;
	int k;
} Instruction;

void increase_depth();
void decrease_depth();
void update_jmp(int i);
void write_table_ins();
void add_symbol(char * name);
int add_symbol_tmp();
int add_ins(char * name, int i, int j, int k);
int get_addr(char * name);
int pop_symbol_tmp();
void print_table_sym();
void print_table_ins();

#endif
