/*
Name : Vedic Partap 
Roll No. : 16CS10053
Test Case : 5
*/
int hello(int a, int b);
int kaiseho(int a,int b,int c);
int lol(int a,int b, int c);
double dont_know_what_to_do(int a,int b,int c,int d);
int main();
int main()
{
	int a=6,b=7,c=8,d=9;
	dont_know_what_to_do(a,b,c,d);
	return 0;
}
double dont_know_what_to_do(int a,int b,int c,int d)
{
	kaiseho(a,b,c);
	hello(a,b);
	lol(a,b,c);
	return 2.0*7;
}
int lol(int a,int b, int c)
{
	kaiseho(a,b,c);
	hello(a,b);
	return 3+4;
}
int kaiseho(int a,int b,int c)
{
	hello(a,b);
	return 3+9;
}
int hello(int a,int b)
{
	return 1;
}
