#declare variable
CC=gcc
FC=flex

CFLAG=-c -Wall
CFLAGW=-Wall

#Commmands
output.txt: a.out ass3_16CS10053_test.c
	./a.out < ass3_16CS10053_test.c > output.txt

a.out: lex.yy.c assgn3_16CS10053.o 
	$(CC) $(CFLAGW) assgn3_16CS10053.o -lfl

lex.yy.c: ass3_16CS10053.l
	$(FC) ass3_16CS10053.l

assg3_16CS10053.o: assgn3_16CS10053.c
	$(CC) $(CFLAG) assgn3_16CS10053.c 

clean:
	rm ass3_16CS10053.c output.txt lex.yy.c a.out *.o