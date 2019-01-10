//Longest Common Subseq.
int max(int a, int b)
{
	if(a>b)
	{
		return a;
	}    
	else
	{
		return b;
	}
}

int lcs( int X[], int Y[], int m, int n )
{
   if (m == 0 || n == 0)
   {
	return 0;
   }
   if (X[m-1] == Y[n-1])
   {
	//printi(X[m-1]);
	//prints("\n");
	return (1 + lcs(X, Y, m-1, n-1));
   }
   else
   {
	return max(lcs(X, Y, m, n-1), lcs(X, Y, m-1, n));
   }
}
 
/* Driver program to test above function */
int main()
{
  int x[100];
  int y[100];
  int n,m,i;
  int err=1;
  prints("++++++++ Length of longest common subsequence ++++++++\n");
  prints("Enter the number of elements in first array\n");
  n=readi(&err);
  prints("Enter the elements of the first array one by one\n");
  for(i=0;i<n;i++)
  {
	x[i]=readi(&err);
  }
  
  prints("Enter the number of elements in second array\n");
  m=readi(&err);
  prints("Enter the elements of the second array one by one\n");
  for(i=0;i<m;i++)
  {
	y[i]=readi(&err);
  }
  int len;
  len=lcs(x,y,n,m);
  prints("Length of longest common subsequence is: ");
  printi(len);
  prints("\n++++++++++++++++++++\n");
  return 0;
}
