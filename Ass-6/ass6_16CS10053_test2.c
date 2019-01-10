int main()
{
    int n, reversedInteger , remainder, originalInteger;
    reversedInteger = 0;
    prints("++++++++++++ Palindrome or Not ++++++++++++\n");
    prints("Enter an integer: ");
    int err;
    n = readi(&err);

    originalInteger = n;
    while( n!=0 )
    {
        remainder = n%10;
        reversedInteger = reversedInteger*10 + remainder;
        n = n/10;
    }
    if (originalInteger == reversedInteger)
        prints("Yes, It is a palindrome.\n");
    else
        prints("No, It is not a palindrome.\n");
    prints("\n+++++++++++++++++++++++++\n");
    
    return 0;
}