#include "myl.h"
#define MAX 50

int prints(char *s)
{
    int bytes=0;
    while(s[bytes]!='\0')bytes++;
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(s), "d"(bytes)
    );
    return bytes;
}


int printi(int n)
{
    char buff[MAX],zero='0';
    int i=0,j=0,bytes,k;
    if(n<0){n=-n;buff[i++]='-';}
    if(n==0)buff[i++]=zero;
    while(n!=0){
        buff[i++]= (char)(n%10 + zero);
        n=n/10;
    }
    if(buff[0]=='-')j=1;
    k=i-1;
    bytes=i;
    while(j<k){
        char tmp;
        tmp=buff[j];
        buff[j]=buff[k];
        buff[k]=tmp;
        j++;k--;
    }
  __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(bytes)
    );
	return bytes;
}

int readi (int* eP) {
    int i=0;
    char str[10];
    int sign=1,val=0;
    *eP=OK;
    while(1){
        __asm__ __volatile__ ("syscall"::"a"(0), "D"(0), "S"(str), "d"(1));
        if(str[0]==' ' || str[0] == '\t' || str[0]=='\n')break;
        if(!i && str[0]=='-')sign=-1;
        else{
            if(str[0] >'9' || str[0]<'0' )*eP=ERR;
            else{
                val=10*val+(int)(str[0]-'0');
            }
        }
        i++;
    }
    return val*sign;
}

