/*

  Name - Vedic Partap 
  Roll No. - 16CS10053
  Assignment 2 

*/

// incldue the header files 
#include "myl.h"
#include <stdio.h>

// main function
int main(){
	int n;
	float f;
	printStr("Welcome to Assignment 2 !!!\n\n");
	while(1)
	{
		printStr("Enter an integer :");     // prompt message for integer
		readInt(&n);                                      // accept the integer
		printStr("You have entered :");            
		printInt(n);                               
		printStr("\nEnter a floating number :");     // prompt message for accepting float
		readFlt(&f);                                  // accept float
		printStr("You have entered :"); // prompt message for printing float
		printFlt(f);                           // printing float
		printStr("\n++++++++\n");
	}
	
	
	return 0;
}