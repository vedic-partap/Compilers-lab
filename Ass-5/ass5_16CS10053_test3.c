/*
Name : Vedic Partap 
Roll No. : 16CS10053
Test Case : 3
*/
int test = 1;
int main();
int main () {
    int arr_int[20];
    double arr_d[43];
    int i=0;
    int n=9;
    for(i=0;i<n;i++)
        arr_int[i]=i+1;
    for(i=n;i>=0;i--)
        arr_d[i]=i*0.1;
    int timepass =90;
    timepass=timepass+timepass*timepass;
    for(i=0;i<n;i++)
        arr_int[i]=i+1;
    for(i=n;i>=0;i--)
        arr_d[i]=i*0.1;
    return timepass;
 }