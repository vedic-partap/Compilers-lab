#// selSort.c
##define EXCH(X,Y,Z) ((Z)=(X), (X)=(Y), (Y)=(Z))
#void selectionSort(int data[], int nod) { // selSort.c
#     int i ;
#
#     for(i = 0; i < nod - 1; ++i) {
#         int max, j, temp;
#
#         temp = data[i] ;
#         max = i ;
#         for(j = i+1; j < nod; ++j)
#             if(data[j] > temp) {
#                temp = data[j] ;
#                max = j ;
#             }
#         EXCH(data[i], data[max], temp);
#     }
#} // selSort.c    
    .file    "selSort.c" # file name  
    .text
.globl selectionSort     # selectionSort is global
    .type    selectionSort, @function
selectionSort:
.LFB2:
    pushq    %rbp         # save old base pointer
.LCFI0:
    movq    %rsp, %rbp      # stack pointer is new 
.LCFI1:                     #    base pointer
    movq    %rdi, -24(%rbp) # M[rbp - 24] <-- data
    movl    %esi, -28(%rbp) # M[rbp - 28] <-- nod
#
    movl    $0, -16(%rbp)   # i <-- 0 (4-bytes)
                            #  init outer loop
    jmp    .L2              # goto .L2
                            #  test of outer loop
#
.L3:
    movl    -16(%rbp), %eax # eax <-- i 
    cltq                    # rax <-- eax
    salq    $2, %rax        # rax <-- 4*rax (4*i)
    addq    -24(%rbp), %rax # rax <-- data + 4*i
    movl    (%rax), %eax    # eax <-- data[i]
    movl    %eax, -4(%rbp)  # temp <-- eax (data[i])
    movl    -16(%rbp), %eax # eax <-- i
    movl    %eax, -12(%rbp) # max <-- eax (i)
#
    movl    -16(%rbp), %eax # eax <-- i
    addl    $1, %eax        # eax <-- eax + 1 (i+1)
    movl    %eax, -8(%rbp)  # j <-- i+1
                            #  init inner loop
    jmp    .L4              # goto .L4
                            #  test of inner loop
#
.L5:
    movl    -8(%rbp), %eax  # eax <-- j
    cltq                    # rax <-- eax
    salq    $2, %rax        # rax <-- 4*j
    addq    -24(%rbp), %rax # rax <-- data+4*j
    movl    (%rax), %eax    # eax <-- data[j]
    cmpl    -4(%rbp), %eax  # if data[j] <= temp
    jle    .L6              # goto .L6
                            #   inc. of inner loop
#
    movl    -8(%rbp), %eax  # eax <-- j
    cltq                    # rax <-- eax
    salq    $2, %rax        # rax <-- 4*j
    addq    -24(%rbp), %rax # rax <-- data + 4*j
    movl    (%rax), %eax    # eax <-- data[j]
    movl    %eax, -4(%rbp)  # temp <-- data[j]
    movl    -8(%rbp), %eax  # eax <-- j
    movl    %eax, -12(%rbp) # max <-- eax (j)
#    
.L6:                        # Inc. inner loop
    addl    $1, -8(%rbp)    # j <-- j+1
#
.L4:
    movl    -8(%rbp), %eax  # eax <-- j
    cmpl    -28(%rbp), %eax # if j < nod 
    jl    .L5               # goto .L5
                            #   continue inner loop
#                           # Exchange starts 
    movl    -16(%rbp), %eax # eax <-- i
    cltq                    # rax <-- eax
    salq    $2, %rax        # rax <-- 4*i
    addq    -24(%rbp), %rax # rax <-- data + 4*i
    movl    (%rax), %eax    # eax <-- data[i]
    movl    %eax, -4(%rbp)  # temp <-- data[i]
    movl    -16(%rbp), %eax # eax <-- i
    cltq                    # rax <-- eax
    salq    $2, %rax        # rax <-- 4*i
    movq    %rax, %rdx      # rdx <-- rax (4*i)
    addq    -24(%rbp), %rdx # rdx <-- data + 4*i
    movl    -12(%rbp), %eax # eax <-- max
    cltq                    # rax <-- eax
    salq    $2, %rax        # rax <-- 4*max
    addq    -24(%rbp), %rax # rax <-- data + 4*max
    movl    (%rax), %eax    # eax <-- data[max]
    movl    %eax, (%rdx)    # data[i] <-- data[max]
    movl    -12(%rbp), %eax # eax <-- max 
    cltq                    # rax <-- eax
    salq    $2, %rax        # rax <-- 4*max
    movq    %rax, %rdx      # rdx <-- rax (4*max)
    addq    -24(%rbp), %rdx # rdx <-- data + 4*max
    movl    -4(%rbp), %eax  # eax <-- temp
    movl    %eax, (%rdx)    # data[max] <-- temp
#
    addl    $1, -16(%rbp)   # i <-- i+1
.L2:
    movl    -28(%rbp), %eax # eax <-- nod
    subl    $1, %eax        # eax <-- eax - 1
    cmpl    -16(%rbp), %eax # if (nod - 1) > i
    jg    .L3               # goto .L3
    leave                   # clear stack
    ret                     # return

.LFE2:
    .size    selectionSort, .-selectionSort
