//Sum of Digits
int sumOfDigits(int x)       // Recursive function that will return the sum 
{
    if((x/10)==0)
    {
        return x;
    }
    else
    {
        return (sumOfDigits(x%10)+sumOfDigits(x/10));     // It will calculate the sum of the digits of the number.
    }
}

int main()
{
    int n;
    prints("++++++ Sum of Digit ++++++\n");
    prints("Enter Integer\n"); 
    int err=1;
    n=readi(&err);
    int s;
    s = sumOfDigits(n);
    prints("Sum of Digit: ");
    printi(s);
    prints("\n++++++++++\n");
    return 0;
}
