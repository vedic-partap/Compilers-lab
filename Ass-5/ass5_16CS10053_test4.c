/*
Name : Vedic Partap 
Roll No. : 16CS10053
Test Case : 4
*/
double multiply_time_pass(double a,int b);
char do_not_what_it_is(int a,double b, char c);
int main();
int main()
{
    //declaration of all types
    int n=9;
    if(n>=0)
    {
        if(n<=10)
        {
            char a='a',b='b',c='c';
            double dp[20][15];
            char *d=&a;
            int k=9;
            int l=k+10;
            int  i = 50, *p = &i;
        }
        else
        {
            char a = 'a';
            int ans = 90;
        }
        
    }
    else
    {
        return 0;
    }
    n=89;
    return 0;
    
}

double multiply_time_pass(double a,int b)
{
    double ans;
    ans=a * b;
    ans = ans*a;
    a = b*ans;
    ans = a*a+b*b+ans*ans;
    return ans;
}

char do_not_what_it_is(int a,double b, char c)
{
    double kt=b;
    char *p=&c;
    int i=a+b;
    return c;
}