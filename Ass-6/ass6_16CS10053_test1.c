// Calculate Interest
int main()

{
    int principal_amt, rate, simple_interest;
    int time,err;
    prints("Enter the integer values of 1) principal_amt, 2) rate  3)time (Answer rounded in integers):\n");
    principal_amt = readi(&err);
    rate = readi(&err);
    time = readi(&err);

    simple_interest = (principal_amt * rate * time) / 100;

    prints("Simple interest = ");
    printi(simple_interest);
    prints("\n");
    prints("\n+++++++++++++++++++++++\n");
    return 0;

}