#// main.c
##include <stdio.h>
##define MAXNO 100
#void selectionSort(int [], int);
#int main() // main.c
#{
#    int no = 0, i ;
#    int data[MAXNO] ;
#
#    printf("Enter the data, terminate with Ctrl+D\n") ;
#    while(scanf("%d", &data[no]) != EOF) ++no;
#    selectionSort(data, no) ;
#    printf("Data in sorted Order are: ") ;
#    for(i = 0; i < no; ++i) printf("%d ", data[i]);
#    putchar('\n') ;
#    return 0 ;
#}   
   .file   "main.c"    # source file name
   .section   .rodata  # read-only data section
   .align 8            # align with 8-byte boundary
.LC0:                  # Label of f-string-1st printf
   .string   "Enter the data, terminate with Ctrl+D"
.LC1:                  # Label of f-string scanf
   .string   "%d"
.LC2:                  # Label of f-string - 2nd printf
   .string   "Data in sorted Order are: "
.LC3:                  # Label of f-string - 3rd printf
   .string   "%d "
#
   .text                 # Code starts 
   .globl main           # main is a global name
   .type   main, @function  # main is a function:
main:                    # main: starts 
   pushq   %rbp          # Save old base pointer 
   movq   %rsp, %rbp     # rbp <-- rsp set new 
                         #   stack base pointer
   subq   $416, %rsp     # Create space for local  
                         # array and variables
#
   movl   $0, -8(%rbp)   # no <-- 0
   movl   $.LC0, %edi    # edi <-- 1st parameter 
                         #             of printf
   call   puts           # Calls puts for printf
   jmp   .L2             # Goto the beginning of the 
                         #   while loop
#
.L3:                     # Increment code
   addl   $1, -8(%rbp)   # M[rbp-8]<--M[rbp-8]+1
                         #     no <-- no+1  
.L2:                     # label, body of the loop
   movl   -8(%rbp), %eax # eax <-- M[rbp-8] (no)
   cltq                  # rax <-- eax (32-bits to 
                         #    sign ext. 64-bit)
   salq   $2, %rax       # rax <-- shift-arithmetic
                         #    2-bit left (4*no)
   leaq   -416(%rbp), %rsi  # rsi <-- (rbp - 416)
                         #       (&data)
   addq   %rax, %rsi     # rsi <-- rsi + rax 
                         #   (data+4*no = &data[no])
                         #   2nd parameter
   movl   $.LC1, %edi    # edi <-- starting of the 
                         #   format string,
                         #   1st parameter
   movl   $0, %eax       # eax <-- 0 (?)
   call   scanf          # call scanf, return   
                         # value is in eax
   cmpl   $-1, %eax      # if return value 
                         #  != -1 (EOF) 
                         # (jne, jump not equal) 
   jne   .L3             # goto .L3 (loop)
                         # continue reading data
#
   movl   -8(%rbp), %esi # esi <-- no 
                         #  2nd parameter
   leaq   -416(%rbp), %rdi  # rdi <-- data  
                         #  1st parameter
   call   selectionSort  # call selectionSort
#
   movl   $.LC2, %edi    # edi <-- starting address
                         #  of printf format string
                         #  1st parameter
   movl   $0, %eax       # eax <-- 0 (?)
   call   printf         # Call printf (2nd call)
   movl   $0, -4(%rbp)   # M[rbp-4] <-- 0,
                         #  i <-- 0
   jmp   .L5             # Goto loop test
#
.L6:
   movl   -4(%rbp), %eax # eax <-- i
   cltq                  # rax <-- signExt(eax)
   movl   -416(%rbp,%rax,4), %esi # esi <-- 
                         #  Mem[(rbp - 416)+4*rax]
                         #  esi <-- data[i] 
                         #   2nd param   
   movl   $.LC3, %edi    # edi <-- addr, of format str
                         #   1st parameter
   movl   $0, %eax       # eax <-- 0
   call   printf         # Call printf
   addl   $1, -4(%rbp)   # i <-- i+1
#
.L5:                     # Loop test 
   movl   -4(%rbp), %eax # eax <-- i
   cmpl   -8(%rbp), %eax # if i < no 
                         # (jl is jump less than)
   jl   .L6              # reEnter loop
#
   movl   $10, %edi      # edi <-- 10 (\n)
   call   putchar        # call putchar
   movl   $0, %eax       # eax <-- 0 (return 0)
   leave                 # remove stack frame
   ret                   # return
.LFE2:
   .size   main, .-main
   .section   .eh_frame,"a",@progbits
