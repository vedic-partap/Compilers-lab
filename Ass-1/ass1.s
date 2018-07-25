	.file	"ass1.c"         # file name
	.section	.rodata	     # read-only data section
	.align 8                 # align with 8-byte boundary
.LC0:                        # Label of f-string-1st printf							
	.string	"Number of iterations to estimate PI: "
.LC1:                        # Label of f-string scanf
	.string	"%ld"
	.align 8
.LC2:                        # Label of f-string-2nd printf
	.string	"\nPI: %10.8lf (using Infinite Series)"
	.align 8
.LC3:                        # Label of f-string-3rd printf
	.string	"\tPI: %10.8lf (using Monte Carlo method)\n\n"

########### Code Segment ###########
	.text
	.globl	main             # main is global name 
	.type	main, @function  # main is function type
main:                        # main Start 
.LFB2:
	.cfi_startproc
	pushq	%rbp             # Save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp       # rsb<--rsp set new stack base pointer
	.cfi_def_cfa_register 6
	subq	$48, %rsp        # Create space for local variables
	movl	$.LC0, %edi      # edi<-- 1st paramter of printf
	movl	$0, %eax         # eax<--0
	call	printf           # calling the printf function 
	leaq	-24(%rbp), %rax  # rax<-- (rbp-24)(&data)
	movq	%rax, %rsi       # rsi<-- rax
	movl	$.LC1, %edi      # edi<-- ist parametr of scanf
	movl	$0, %eax         # eax<--0 
	call	__isoc99_scanf   # call the scanf function
	movq	-24(%rbp), %rax  # rax<--(rbp-24)
	movq	%rax, %rdi       # rdi<--rax
	call	monteCarlo       # call the monteCarlo function
	movsd	%xmm0, -40(%rbp) # move or merge scalar double floating point value xmm0<-- rbq-40
	movq	-40(%rbp), %rax  # move of a quadword (64-bit value) rax<-- rbp-40
	movq	%rax, -8(%rbp)   # move of a quadword (64-bit value) (rbp-8)<-- rax
	movq	-24(%rbp), %rax  # move of a quadword (64-bit value) (rax)<-- (rbp-24)
	movq	%rax, %rdi       # move of a quadword (64-bit value) rdi<-rax
	call	iSeries          # Call iSeries function 
	movsd	%xmm0, -40(%rbp) # move or merge scalar double floating point value rsb-40 xmm0
	movq	-40(%rbp), %rax  # move of a quadword (64-bit value) rax<-- rbp-40
	movq	%rax, -16(%rbp)  # move (rbp-16)<-- rax
	movq	-16(%rbp), %rax  # move rax <-- rbp-16
	movq	%rax, -40(%rbp)  # move rbp-40 <--rax
	movsd	-40(%rbp), %xmm0 # move the scalar double FPV rbp-40 <-- xmm0
	movl	$.LC2, %edi      # 
	movl	$1, %eax
	call	printf
	movq	-8(%rbp), %rax
	movq	%rax, -40(%rbp)
	movsd	-40(%rbp), %xmm0
	movl	$.LC3, %edi
	movl	$1, %eax
	call	printf
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.globl	iSeries
	.type	iSeries, @function
iSeries:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	$0, %eax
	movq	%rax, -16(%rbp)
	movl	$1, -4(%rbp)
	jmp	.L4
.L7:
	movl	-4(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L5
	movl	-4(%rbp), %eax
	addl	%eax, %eax
	subl	$1, %eax
	cvtsi2sd	%eax, %xmm0
	movsd	.LC5(%rip), %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	-16(%rbp), %xmm1
	subsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	jmp	.L6
.L5:
	movl	-4(%rbp), %eax
	addl	%eax, %eax
	subl	$1, %eax
	cvtsi2sd	%eax, %xmm0
	movsd	.LC5(%rip), %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	-16(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
.L6:
	addl	$1, -4(%rbp)
.L4:
	movl	-4(%rbp), %eax
	cltq
	cmpq	-24(%rbp), %rax
	jle	.L7
	movq	-16(%rbp), %rax
	movq	%rax, -32(%rbp)
	movsd	-32(%rbp), %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	iSeries, .-iSeries
	.globl	monteCarlo
	.type	monteCarlo, @function
monteCarlo:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	$0, -8(%rbp)
	movl	$12345, %edi
	call	srand
	movl	$1, -4(%rbp)
	jmp	.L10
.L13:
	call	rand
	cvtsi2sd	%eax, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	call	rand
	cvtsi2sd	%eax, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-16(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	-16(%rbp), %xmm1
	movsd	-24(%rbp), %xmm0
	mulsd	-24(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	.LC7(%rip), %xmm1
	ucomisd	%xmm0, %xmm1
	jb	.L11
	addl	$1, -8(%rbp)
.L11:
	addl	$1, -4(%rbp)
.L10:
	movl	-4(%rbp), %eax
	cltq
	cmpq	-40(%rbp), %rax
	jle	.L13
	cvtsi2sd	-8(%rbp), %xmm0
	cvtsi2sdq	-40(%rbp), %xmm1
	divsd	%xmm1, %xmm0
	movsd	.LC5(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -48(%rbp)
	movsd	-48(%rbp), %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	monteCarlo, .-monteCarlo
	.section	.rodata
	.align 8
.LC5:
	.long	0
	.long	1074790400
	.align 8
.LC6:
	.long	4290772992
	.long	1105199103
	.align 8
.LC7:
	.long	0
	.long	1072693248
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-11)"
	.section	.note.GNU-stack,"",@progbits
