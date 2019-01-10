a.out: y.tab.o lex.yy.o ass4_16CS10053.o 
	gcc ass4_16CS10053.o lex.yy.o y.tab.o -lfl
	./a.out < ass4_16CS10053_test.c
lex.yy.c: ass4_16CS10053.l y.tab.h
	flex ass4_16CS10053.l
y.tab.c: ass4_16CS10053.y
	bison -dty ass4_16CS10053.y
ass4_16CS10053.o: ass4_16CS10053.c y.tab.h
	gcc -c ass4_16CS10053.c
y.tab.h: ass4_16CS10053.y
	bison -dty ass4_16CS10053.y
lex.yy.o: lex.yy.c
	gcc -c lex.yy.c
y.tab.o:    y.tab.c y.tab.h
	gcc -c y.tab.c
clean:
	rm a.out lex.yy.o ass4_16CS10053.o lex.yy.c y.tab.c y.tab.h y.tab.o
run:
	./a.out < ass4_16CS10053_test.c