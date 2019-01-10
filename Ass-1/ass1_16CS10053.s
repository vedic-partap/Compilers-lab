#########################################################
##########      Vedic Partap             ################
##########      16CS10053                ################
##########      Assignment -1            ################
##########     Comment the given code    ################
#########################################################

############### Data ###############
	.file	"assgn1.c"					# Source file name
	.section	.rodata					# Read-only data section
	.align 8							# Align with 8 byte boundary
.LC0:									# Label for string for 1st printf
	.string	"Number of iterations to estimate PI: "
.LC1:									# Label of string for scanf
	.string	"%ld"
	.align 8
.LC2:									# Label of 2nd printf
	.string	"\nPI: %10.8lf (using Infinite Series)"
	.align 8
.LC3:									# Label of 3rd printf
	.string	"\tPI: %10.8lf (using Monte Carlo method)\n\n"

############### Text ###############

	.text							# Code starts
	.globl	main					# main is a global name
	.type	main, @function			# main is a function
main:								# main: starts

.LFB2:
	.cfi_startproc					# Call Frame Information
	pushq	%rbp					# Save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp				# rbp = rsp, set new stack base pointer
	.cfi_def_cfa_register 6
	subq	$48, %rsp				# make space for local variables
	movq	%fs:40, %rax			# Access value of %fs:40 and store it in %rax
	movq	%rax, -8(%rbp)			# (rbp - 8) = rax
	xorl	%eax, %eax				# eax = 0 
									# printf("Number of iterations to estimate PI: ");
	movl	$.LC0, %edi				# Load the .LC0 string in edi (1st parameter in printf)
	movl	$0, %eax				# eax = 0 
	call	printf					# Call printf
									# scanf("%ld",&num);	
	leaq	-32(%rbp), %rax			# rax = (rbp - 32) (Making space to store num)
	movq	%rax, %rsi 				# Set rsi = rax (Second argument)[&num]
	movl	$.LC1, %edi				# Load "%ld" string in edi (first argument)
	movl	$0, %eax				# eax = 0 (since no floating point data is printed, so vector register is set to 0)
	call	__isoc99_scanf	
									# piD1=monteCarlo(num);
	movq	-32(%rbp), %rax			# rax = (rbp - 32) 
	movq	%rax, %rdi				# rdi = rax 
	call	monteCarlo 				# Call monteCarlo(num)
	movq	%xmm0, %rax				# rax = xmm0 
	movq	%rax, -24(%rbp)			# (rbp - 24) = rax 
									# piD2=iSeries(num);
	movq	-32(%rbp), %rax			# rax = (rbp - 32) 
	movq	%rax, %rdi				# rdi = rax 
	call	iSeries 
	movq	%xmm0, %rax				# rax = xmm0 
	movq	%rax, -16(%rbp)			# (rbp - 16) = rax 
									# printf("\nPI: %10.8lf (using Infinite Series)",piD2);
	movq	-16(%rbp), %rax			# rax = (rbp - 16) 
	movq	%rax, -40(%rbp)			# (rbp - 40) = rax 
	movsd	-40(%rbp), %xmm0		# xmm0 = (double)(rbp - 40) 
	movl	$.LC2, %edi				# Load .LC3 string in edi 
	movl	$1, %eax				# eax = 1 
	call	printf
									# printf("\tPI: %10.8lf 
	movq	-24(%rbp), %rax			# rax = (rbp - 24) 
	movq	%rax, -40(%rbp)			# (rbp - 40) = rax 
	movsd	-40(%rbp), %xmm0		# xmm0 = (double)(rbp - 40) 
	movl	$.LC3, %edi				# Load .LC3 string in edi 
	movl	$1, %eax				# eax = 1 
	call	printf					# Call printf
									# return 0;
	movl	$0, %eax				# Store 0 in eax
	movq	-8(%rbp), %rdx			# rdx = (rbp - 8)
	xorq	%fs:40, %rdx
	je	.L3
	call	__stack_chk_fail
.L3:
	leave
	.cfi_def_cfa 7, 8
	ret 							# Return
	.cfi_endproc
.LFE2:
	.size	main, .-main
									# double iSeries(long int n)
	.globl	iSeries 				# iSeries is a global name
	.type	iSeries, @function		# iSeries is a function
iSeries:							# iSeries: starts

.LFB3:
	.cfi_startproc					# Call Frame Information
	pushq	%rbp					# Save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp				# rbp = rsp, Set new stack pointer
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)			# Store the argument passed to the function, i.e., n in (rbp - 24)

		#	# double pi=0.0;
	pxor	%xmm0, %xmm0			# Set xmm0 = 0
	movsd	%xmm0, -8(%rbp)			# Store xmm0 in (rbp - 8)

		#	# int i = 1
	movl	$1, -12(%rbp)			# Set 1 in (rbp - 12) [i = 1]
	jmp	.L5 						# Run loop

.L8:

		#	# if(i%2==0)
	movl	-12(%rbp), %eax			# eax = (rbp - 12), Get value of i
	andl	$1, %eax				# eax = eax & 1 ,
	testl	%eax, %eax				# Sets a zero flag if eax & eax = 0, i.e., sets zero flag when eax = 0 (Only then eax & eax = 0)
	jne	.L6 						# Jump to .LC6 if flag != 0, i.e., eax = 1

		#	# pi-=(4.0/(2*i-1));			# if flag == 0, i.e., eax = 0
	movl	-12(%rbp), %eax			# eax = (rbp - 12), i.e., set eax = i
	addl	%eax, %eax				# eax += eax 
	subl	$1, %eax				# eax -= 1 [(2*i) - 1]
	pxor	%xmm0, %xmm0			# Set xmm0 = 0 
	cvtsi2sd	%eax, %xmm0			# Converting integer value of eax to float and storing in xmm0
	movsd	.LC5(%rip), %xmm1		# xmm1 = 4.0
	divsd	%xmm0, %xmm1			# xmm1 /= xmm0 
	movapd	%xmm1, %xmm0			# xmm0 = xmm1, i.e., move the value of xmm1 to xmm0
	movsd	-8(%rbp), %xmm1			# xmm1 = (rbp - 8) 
	subsd	%xmm0, %xmm1			# xmm1 -= xmm0 
	movapd	%xmm1, %xmm0			# Move the value of xmm1 to xmm0
	movsd	%xmm0, -8(%rbp)			# (rbp - 8) = xmm0 (Store the current value of pi to stack)
	jmp	.L7 						# Jump to .L7 for next iteration

.L6:

									#	# pi+=(4.0/(2*i-1));
	movl	-12(%rbp), %eax			# eax = (rbp - 12), i.e., set eax = i
	addl	%eax, %eax				# eax += eax (Corresponding to the 2*i operation)
	subl	$1, %eax				# eax -= 1 [(2*i) - 1]
	pxor	%xmm0, %xmm0			# Set xmm0 = 0 (xmm0 -> term for this iteration)
	cvtsi2sd	%eax, %xmm0			# Converting integer value of eax to float and storing in xmm0
	movsd	.LC5(%rip), %xmm1		# xmm1 = 4.0
	divsd	%xmm0, %xmm1			# xmm1 /= xmm0 
	movapd	%xmm1, %xmm0			# xmm0 = xmm1, i.e., move the value of xmm1 to xmm0
	movsd	-8(%rbp), %xmm1			# xmm1 = (rbp - 8) (Get the previously stored value of pi from the stack)
	addsd	%xmm1, %xmm0			# xmm0 += xmm1 (Add the new term with the previous value of pi)
	movsd	%xmm0, -8(%rbp)			# (rbp - 8) = xmm0 

.L7:
	addl	$1, -12(%rbp)			# Increment the value of i [i++]

.L5:
	movl	-12(%rbp), %eax			# eax = (rbp - 12) (Store i in eax)
	cltq							# rax = eax (Sign extension from 32 bits to 64 bits)
	cmpq	-24(%rbp), %rax 		# Compare rax with (rbp - 24), i.e., n (Exit condition of for loop)
	jle	.L8							# Goto .L8 if (i <= n)
	movsd	-8(%rbp), %xmm0			# xmm0 = (rbp - 8), Store the return value in xmm0
	popq	%rbp					# Pop base pointer
	.cfi_def_cfa 7, 8
	ret 							# Return
	.cfi_endproc
.LFE3:
	.size	iSeries, .-iSeries
	.globl	monteCarlo 				# monteCarlo is a global name
	.type	monteCarlo, @function 	# monteCarlo is a function
monteCarlo:							# monteCarlo: starts

.LFB4:
	.cfi_startproc					# Call Frame Information
	pushq	%rbp					# Save odl base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp				# rbp = rsp, Set new stack pointer
	.cfi_def_cfa_register 6
	subq	$48, %rsp				# Create space for local variables
	movq	%rdi, -40(%rbp)			# Store the argument passed to the function, i.e., n in (rbp - 40)
	movl	$0, -20(%rbp)			# (rbp - 20) = 0 [count = 0]

	movl	$12345, %edi			# edi = 12345 (Stroing 12345 in first argument for calling srand(12345))
	call	srand					# Call srand with argument in edi
	movl	$1, -24(%rbp)			# (rbp - 24) = 1 [int i =1 (for loop initial condition)]
	jmp	.L11						# Run for loop
.L14:
									#	# x = (double)rand()/RAND_MAX;
	call	rand					# Call rand function (Value return in eax)
	pxor	%xmm0, %xmm0			# Bitwise xor of xmm0 with itself; xmm0 = 0
	cvtsi2sd	%eax, %xmm0			# Converting integer value of eax to float and storing in xmm0
	movsd	.LC6(%rip), %xmm1		# Get RAND_MAX value in xmm1
	divsd	%xmm1, %xmm0			# Divide (double)rand() by RAND_MAX
	movsd	%xmm0, -16(%rbp)		# (rbp - 16) = xmm0 
	call	rand 					# Call rand function 
	pxor	%xmm0, %xmm0			# Bitwise xor of xmm0 with itself; xmm0 = 0	
	cvtsi2sd	%eax, %xmm0			# Converting integer value of eax to float and storing in xmm0
	movsd	.LC6(%rip), %xmm1		# Get RAND_MAX value in xmm1
	divsd	%xmm1, %xmm0			# Divide (double)rand() by RAND_MAX
	movsd	%xmm0, -8(%rbp)			# (rbp - 8) = xmm0 (Store the value of y in stack)
	movsd	-16(%rbp), %xmm0		# Get x value from (rbp - 16) to xmm0
	movapd	%xmm0, %xmm1			# xmm1 = xmm0 
	mulsd	-16(%rbp), %xmm1		# Multiply xmm1 with  [x*x]
	movsd	-8(%rbp), %xmm0			# Get y value from (rbp - 8) to xmm0
	mulsd	-8(%rbp), %xmm0			# Multiply xmm0 with (rbp - 8) [y*y]
	addsd	%xmm1, %xmm0			# xmm0 = xmm0 + xmm1 [x*x +y*y]
	movsd	.LC7(%rip), %xmm1		# xmm1 = 1.0
	ucomisd	%xmm0, %xmm1			# Compare if xmm0 <= xmm1 [(x*x+y*y) <= 1]
	jb	.L12						# Jump to .L12 if condition is satisfied

	addl	$1, -20(%rbp)			# (rbp - 20) += 1 

.L12:
	addl	$1, -24(%rbp)			# (rbp - 24) += 1 [i++]

.L11:
	movl	-24(%rbp), %eax			# Get value of i from stack
	cltq							# rax = eax (Sign extension (32 bits to 64 bits))

	cmpq	-40(%rbp), %rax			# Comparing i with n (Exit condition of for loop)
	jle	.L14						# jump to .L14 if (i<=n)
									# if condition does not hold
	pxor	%xmm0, %xmm0			# Set xmm0 to 0 by XORing
	cvtsi2sd	-20(%rbp), %xmm0 	# Convert integer in (rbp - 20), i.e., count to double
	pxor	%xmm1, %xmm1			# Set xmm1 to 0 by XORing
	cvtsi2sdq	-40(%rbp), %xmm1 	# Convert integer in (rbp - 40), i.e, n to double
	divsd	%xmm1, %xmm0			# xmm0 = xmm0 / xmm1 [(double)count/n]
	movsd	.LC5(%rip), %xmm1		# xmm1 = 4.0
	mulsd	%xmm1, %xmm0			# xmm0 = xmm0 * xmm1 (Multiply xmm0 by xmm1, i.e., by 4)
	leave							# Enter the value of xmm0 in stack
	.cfi_def_cfa 7, 8
	ret 							# Return
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
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
