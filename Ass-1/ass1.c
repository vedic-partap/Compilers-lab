#include <stdlib.h>
#include <stdio.h>
double monteCarlo(long int n);
double iSeries(long int n);
int main()
{
	long int num;
	double piD1,piD2;
	printf("Number of iterations to estimate PI: ");
	scanf("%ld",&num);
	piD1=monteCarlo(num);
	piD2=iSeries(num);
	printf("\nPI: %10.8lf (using Infinite Series)",piD2);
	printf("\tPI: %10.8lf (using Monte Carlo method)\n\n",piD1);
	return 0;
}
double iSeries(long int n)
{
	int i;
	double pi=0.0;
	for(i=1;i<=n;i++) {
		if(i%2==0) pi-=(4.0/(2*i-1));
		else pi+=(4.0/(2*i-1));
	}
	return pi;
}
double monteCarlo(long int n)
{
	double x,y;
	int i,count=0;
	srand(12345);
	for(i=1;i<=n;i++) {
		x = (double)rand()/RAND_MAX;
		y = (double)rand()/RAND_MAX;
		if ((x*x+y*y)<=1) count++;
	}
	return (double)count/n*4.0;
}
