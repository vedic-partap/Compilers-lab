a.out: main.o libassn2.a
	gcc -Wall main.o -L. -lassn2 

main.o:	main.c myl.h
	gcc -Wall -c main.c

libassn2.a:	assn2_16CS10053.o
		ar -rcs libassn2.a assn2_16CS10053.o

assn2_16CS10053.o:	assn2_16CS10053.c myl.h
	gcc -Wall -c assn2_16CS10053.c
	
clean:
	rm a.out main.o libassn2.a assn2_16CS10053.o
