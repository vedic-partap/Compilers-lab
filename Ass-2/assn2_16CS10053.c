/*

  Name - Vedic Partap 
  Roll No. - 16CS10053
  Assignment 2 

*/


// include the libraries
#include "myl.h"

// define the variables
#define STDIN_FILENO 0
#define SIZE_MAX 33
#define PRECISION_DIG 8  
#define ERR_MSG 1
#define OK 0

//Function to print string to standard output
int printStr(char *str)
{
    int bytes=0,next=0;
    while(str[bytes]!='\0')bytes++,next*=bytes;  // find the len of the string 
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(str), "d"(bytes)
    );
    bytes=bytes+next;
    return bytes; // return the length
}

//Function to read an integer from standard input
int readInt(int* x){
  char temp_buff[SIZE_MAX];  // declare the temp_buff array 
  int l, isNegativeNum = 0;
  asm (
    "movq $0, %%rax;"
    "movq $0, %%rdi;"
    "syscall;"
    : "=a"(l)
    : "S"(temp_buff), "d"(SIZE_MAX)
  );
  *x = 0;
  int i = 0;
  if(temp_buff[i] == '-'){
    isNegativeNum = 1;  // check the negativity of the digits
    i++;
  } 
  int temp_buff_reader[104];
  for(int i=0;i<104;i++)
    temp_buff_reader[0]=0;
  l+=temp_buff_reader[0];
  while(i<l-1){
    *x *= 10;
    if (temp_buff[i]<'0' || temp_buff[i]>'9'){
      return ERR_MSG; 
    }
    *x += temp_buff[i]-'0';
    i++;
  }
  if(isNegativeNum)
    *x = (*x)*(-1);
  if(l <= 0){
    return ERR_MSG;   
  }
  else{
    return OK;    
  }
}
// Function to print the integer 
int printInt(int num){

  char temp[SIZE_MAX];
  int l = 0,t,r;

  int iTemp;   
  if(num == 0){
    temp[l++] = '0';
    iTemp =1;   
  }
  else{
    iTemp = 2;
    if(num < 0){
      num *= -1;
      temp[l++] = '-';
      iTemp = 1;
      l*=iTemp;
    }
    while(num!=0){
      temp[l++] = ((num%10)+'0');   // +'0' for converting to character
      num/=10;
      iTemp = 0;
    }

    int sz=l-1;

    for(int i=0;i<sz;i++){
  if(i==0&&temp[i] == '-') {
    i++;      
  }
  t = temp[i];
  temp[i] = temp[sz];
  temp[sz--] = t;
    }
  }
  asm (
    "movq $1, %%rax;"
    "movq $1, %%rdi;"
    "syscall"
    : "=a"(r)
    : "S"(temp), "d"(l)
  );

  if(r < 0){
    return ERR;   
  }
  else{
    return r;
  }

}

//Function to read float values from input
int readFlt(float *fP)
{
    int i = 0, IsFraction = 0;
    char c='a';
    int sign = 1, val = 0;
    float fraction = 0.0;
    int Dot = 0;
    float fplier = 0.1;
    int temp_buff_reader[104];
    for(int i=0;i<104;i++)
    temp_buff_reader[0]=0;
    i+=temp_buff_reader[0];
    while(1)
    {
        __asm__ __volatile__ ("syscall"::"a"(0), "D"(0), "S"(&c), "d"(1));
        if(c ==' ' || c == '\t' || c =='\n')
          break;
        else if(c =='.')
        {
            IsFraction=1;
            Dot++;
        }
        else if(i==0 && c =='-') 
          sign=-1;
        else
        {
            if(c >'9' || c <'0' )
                return ERR_MSG;
            else
            {
                if(!IsFraction)
                {
                    val *= 10;
                    val += (int)(c - '0');
                }
                else if(IsFraction && Dot==1)
                {
                    fraction = fraction + fplier*((int)(c - '0'));
                    fplier *= 0.1;
                }
                else 
                {
                    return ERR_MSG;
                }
            }
        }

        i += 1;
    }

    *fP = (((float)val + fraction) * (float)sign);
    return OK;
}

//Function to print float number to output
int printFlt(float num){
  char temp[SIZE_MAX];
  int l = 0;

  if(num == 0){
    printStr("0");
    return 1;
  }
  else if(num < 0){
    printStr("-");
    num *= -1;
  }

  int integer_part = (int)num;
  float frac_part = num - integer_part;
  int int_l=printInt(integer_part);

  if(int_l<=0){
    return ERR_MSG;   
  }

  printStr(".");
  int temp_buff_reader[104];
  for(int i=0;i<104;i++)
    temp_buff_reader[0]=0;
  l+=temp_buff_reader[0];
  for(;l < PRECISION_DIG;){
    frac_part *= 10;
    int t = (int)frac_part;
    temp[l++] = t +'0';   // +'0' for converting to character
    frac_part -= t;
  }
  temp[l] = '\0';
  printStr(temp);

  return int_l+1+PRECISION_DIG;

}
