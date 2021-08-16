# Meir Klemfner(211954185), Aviel Berkowitz(211981105)
# Exercise 6

.data
matA:	.space 1000
matB:	.space 1000
matC:	.space 1000
rowA:	.word 0
cArB:	.word 0
colB:	.word 0
msgrA:	.asciiz "Enter number of rows of A: "
msgcA:	.asciiz "Enter number of columns of A: "
msgrB:	.asciiz "Enter number of rows of B: "
msgcB:	.asciiz "Enter number of columns of B: "
msgerr:	.asciiz	"Error: A columns and B rows must be the same!\n"
msg1:	.asciiz "Enter "
msg2A:	.asciiz " numbers for A: "
msg2B:	.asciiz " numbers for B: "
msgp1:	.asciiz	"\nThe matrix "
msgp2:	.asciiz " is: \n"
.text
	jal	read_matrices		# read the matrices A and B
	jal	mul_matrix		# multiply AxB
	
	# prints Matrix A
	li	$v0,4			# $v0 = 4
	la	$a0,msgp1		# $a0 points to msgp1
	syscall				# print msgp1
	li	$v0,11			# $v0 = 11
	li	$a0,'A'			# $a0 = A
	syscall				# print "A"
	li	$v0,4			# $v0 = 4
	la	$a0,msgp2		# $a0 points to msgp2
	syscall				# print msgp1
	
	la	$a0,matA		# $a0 points to MatA
	la	$a1,rowA
	lw	$a1,0($a1)		# $a1 = rowA
	la	$a2,cArB
	lw	$a2,0($a2)		# $a2 = colA
	jal	print_matrix		# print matA
	
	# prints Matrix B
	li	$v0,4			# $v0 = 4
	la	$a0,msgp1		# $a0 points to msgp1
	syscall				# print msgp1
	li	$v0,11			# $v0 = 11
	li	$a0,'B'			# $a0 = A
	syscall				# print "A"
	li	$v0,4			# $v0 = 4
	la	$a0,msgp2		# $a0 points to msgp2
	syscall				# print msgp1
	
	la	$a0,matB		# $a0 points to MatB
	la	$a1,cArB
	lw	$a1,0($a1)		# $a1 = rowB
	la	$a2,colB
	lw	$a2,0($a2)		# $a2 = colB
	jal	print_matrix		# print matB
	
	# prints Matrix C
	li	$v0,4			# $v0 = 4
	la	$a0,msgp1		# $a0 points to msgp1
	syscall				# print msgp1
	li	$v0,11			# $v0 = 11
	li	$a0,'C'			# $a0 = A
	syscall				# print "A"
	li	$v0,4			# $v0 = 4
	la	$a0,msgp2		# $a0 points to msgp2
	syscall				# print msgp1
	
	la	$a0,matC		# $a0 points to MatC
	la	$a1,rowA
	lw	$a1,0($a1)		# $a1 = rowC
	la	$a2,colB
	lw	$a2,0($a2)		# $a2 = colC
	jal	print_matrix		# print matC
	
	li	$v0,10			# $v0 = 10 (exit)
	syscall				# finish the program
#####################################################################	
############################ functions ##############################
#####################################################################
read_matrices:
	addi	$sp,$sp,-16		# Save room for 4 registers
	sw	$t0,0($sp)		# Save $t0
	sw	$t1,4($sp)		# Save $t1
	sw	$s1,8($sp)		# Save $s1
	sw	$s2,12($sp)		# Save $s2
	
	# receives A's dimensions
	li	$v0,4			# $v0 = 4
	la	$a0,msgrA		# $a0 points to msgrA
	syscall 			# print msgrA
	li	$v0,5			# $v0 = 5
	syscall				# receives an integer
	la	$s1,rowA
	sw	$v0,0($s1)		# rowA = $v0 (input)
	
	li	$v0,4			# $v0 = 4
	la	$a0,msgcA		# $a0 points to msgcA
	syscall 			# print msgcA
	li	$v0,5			# $v0 = 5
	syscall				# receives an integer
	la	$s2,cArB
	sw	$v0,0($s2)		# cArB = $v0 (input)
	
	# receives B's dimensions
getrb:	li	$v0,4			# $v0 = 4
	la	$a0,msgrB		# $a0 points to msgrB
	syscall 			# print msgrB
	li	$v0,5			# $v0 = 5
	syscall				# receives an integer
	lw	$t0,0($s2)
	beq	$v0,$t0,getcb		# if $v0(input) == $t0 (colA) - OK
	# ERROR - wrong B dimensions (cannot multiply)
	li	$v0,4			# $v0 = 4
	la	$a0,msgerr		# $a0 points to msgerr	
	syscall 			# print msgerr
	j	getrb			# receive new dimensions
	
getcb:	li	$v0,4			# $v0 = 4
	la	$a0,msgcB		# $a0 points to msgcB	
	syscall 			# print msgcB
	li	$v0,5			# $v0 = 5
	syscall				# receives an integer
	la	$s2,colB
	sw	$v0,0($s2)		# colB = $v0 (input)
	
	# multiply row x col (how many cells in matA)
	li	$v0,4			# $v0 = 4
	la	$a0,msg1		# $a0 points to msg1
	syscall				# print msg1
	la	$s1,rowA		
	la	$s2,cArB
	lw	$t0,0($s1)		# $t0 = rowA
	lw	$t1,0($s2)		# $t1 = colA
	mult	$t0,$t1			# lo = $t0 x $t1
	mflo	$t0			# $t0 = number of elements in matA
	li	$v0,1			# $v0 = 1
	add	$a0,$t0,$zero		# $a0 = $t0
	syscall				# print $a0 (number of elements in matA)
	li	$v0,4			# $v0 = 4
	la	$a0,msg2A		# $a0 points to msg2A
	syscall				# print msg2A
	
	# read to matA
	la	$t1,matA		# $t1 = pointer to matA
readA:	li	$v0,5			# $v0 = 5
	syscall				# receive an integer
	sw	$v0,0($t1)		# save $v0 in matA
	addi	$t1,$t1,4		# $t1 += 4 (next cell)
	addi	$t0,$t0,-1		# $t0-- (counter)
	beq	$t0,$zero,end_readA	# if ($t0 == 0) jump to end_readA	
	j	readA
	
end_readA:
	# multiply row x col (how many cells in matB)
	li	$v0,4			# $v0 = 4
	la	$a0,msg1		# $a0 points to msg1 
	syscall				# print msg1
	la	$s1,cArB
	la	$s2,colB
	lw	$t0,0($s1)		# $t0 = rowB
	lw	$t1,0($s2)		# $t1 = colB
	mult	$t0,$t1			# lo = $t0 x $t1
	mflo	$t0			# $t0 = number of elements in matB
	li	$v0,1			# $v0 = 1
	add	$a0,$t0,$zero		# $a0 = $t0
	syscall				# print $a0 (number of elements in matA)
	li	$v0,4			# $v0 = 4
	la	$a0,msg2B		# $a0 points to msg2B 
	syscall				# print msg2B
	
	# read to matB
	la	$t1,matB		# $t1 = pointer to matB
readB:	li	$v0,5			# $v0 = 5
	syscall				# receive an integer
	sw	$v0,0($t1)		# save $v0 in matB
	addi	$t1,$t1,4		# $t1 += 4 (next cell)
	addi	$t0,$t0,-1		# $t0-- (counter)
	beq	$t0,$zero,end_readB	# if ($t0 == 0) jump to end_readB
	j	readB
	
end_readB:
	nop
	lw	$t0,0($sp)		# Restore $t0
	lw	$t1,4($sp)		# Restore $t1
	lw	$s1,8($sp)		# Restore $s1
	lw	$s2,12($sp)		# Restore $s2
	addi	$sp,$sp,16		# Restore $sp
	jr	$ra			# return
#####################################################################
mul_matrix:
	addi	$sp,$sp,-40		# Save room for 10 registers
	sw	$t0,0($sp)		# Save $t0
	sw	$t1,4($sp)		# Save $t1
	sw	$t2,8($sp)		# Save $t2
	sw	$t3,12($sp)		# Save $t3
	sw	$t4,16($sp)		# Save $t4
	sw	$t5,20($sp)		# Save $t5
	sw	$s0,24($sp)		# Save $s0
	sw	$s1,28($sp)		# Save $s1
	sw	$s2,32($sp)		# Save $s2
	sw	$s3,36($sp)		# Save $s3
	
	la	$t5,colB		
	lw	$t5,0($t5)		# $t5 = colB
	li	$t0,4			# $t0 = 4
	mult	$t5,$t0			# lo = $t5 * $t0
	mflo	$t5			# $t5 = colB * 4
	la	$s1,matA		# $s1 points to matA
	la	$s2,matB		# $s2 points to matB
	la	$s3,matC		# $s3 points to matC
	la	$t0,rowA		
	lw	$t0,0($t0)		# $t0 = rowA
loop1:	beq	$t0,$zero,end_l1	# if ($t0 == 0) end loop1
	la	$t1,colB	
	lw	$t1,0($t1)		# $t1 = colB
loop2:	la	$t2,cArB		
	lw	$t2,0($t2)		# $t2 = cArB
	li	$s0,0			# $s0 = 0 (sum of dot product)
	# dot product
loop3:	beq	$t2,$zero,end_l3	# if ($t0 == 0) end loop3
	lw	$t3,0($s1)		# $t3 = [$s1]
	lw	$t4,0($s2)		# $t4 = [$s2]	
	addi	$s1,$s1,4		# $s1 += 4 (next cell)
	add	$s2,$s2,$t5		# $s2 += $t5
	mult	$t3,$t4			# lo = $t3 * $t4
	mflo	$t3			# $t4 = lo
	add	$s0,$s0,$t3		# $s0 += $t3
	addi	$t2,$t2,-1		# $t2--
	j	loop3			
end_l3:	sw	$s0,0($s3)		# save the element in matC
	addi	$s3,$s3,4		# $s3 += 4 (next cell)
	addi	$t1,$t1,-1		# $t1--
	beq	$t1,$zero,end_l2	# codition of loop2 (if ($t1 == 0) end loop2)
	la	$t3,colB	
	lw	$t3,0($t3)		# $t3 = colB
	sub	$t3,$t3,$t1		# $t3 -= $t1
	li	$t4,4			# $t4 = 4
	mult	$t3,$t4			# lo = $t3 * $t4
	mflo	$t3			# $t3 = lo (colB * 4)
	la	$s2,matB		# $s2 points to start of matB
	add	$s2,$s2,$t3		# $s2 += $t3
	la	$t3,cArB		
	lw	$t3,0($t3)		# $t3 = cArB
	li	$t4,4			# $t4 = 4
	mult	$t3,$t4			# lo = $t3 * $t4
	mflo	$t3			# $t3 = lo (cArB * 4)
	sub	$s1,$s1,$t3		# $s1 -= $t3
	j	loop2	
end_l2:	add	$t0,$t0,-1		# $t0--
	la	$s2,matB		# $s2 points to start of matB
	j	loop1
	
end_l1:	lw	$t0,0($sp)		# Restore $t0
	lw	$t1,4($sp)		# Restore $t1
	lw	$t2,8($sp)		# Restore $t2
	lw	$t3,12($sp)		# Restore $t3
	lw	$t4,16($sp)		# Restore $t4
	lw	$t5,20($sp)		# Restore $t5
	lw	$s0,24($sp)		# Restore $s0
	lw	$s1,28($sp)		# Restore $s1
	lw	$s2,32($sp)		# Restore $s2
	lw	$s3,36($sp)		# Restore $s3
	addi	$sp,$sp,40		# Restore $sp
	jr	$ra			# return
#####################################################################
print_matrix:
	addi	$sp,$sp,-12		# Save room for 3 registers
	sw	$t0,0($sp)		# Save $t0
	sw	$t1,4($sp)		# Save $t1
	sw	$t2,8($sp)		# Save $t2
	
	add	$t0,$a0,$zero		# $t0 = $a0 (matrix address)
	add	$t1,$a1,$zero		# $t1 = $a1 (matrix rows)
	add	$t2,$a2,$zero		# $t2 = $a2 (matrix cols)
print:  lw	$a0,0($t0)		# $a0 = [t0]
	li	$v0,1			# $v0 = 1
	syscall 			# print the integer in $a0
	li	$v0,11			# $v0 = 11
	li	$a0,'\t'		# $a0 = 9 (TAB)
	syscall				# print TAB
	addi	$t0,$t0,4		# $t0 += 4 (next cell)
	addi	$t2,$t2,-1		# $t2-- 
	bne	$t2,$zero,print		# if ($t2 != 0) jump to print
	add	$t2,$a2,$zero		# $t2 = $a2 (matrix cols)
	li	$v0,11			# $v0 = 11
	li	$a0,'\n'		# $a0 = '\n'
	syscall				# print '\n'
	addi	$t1,$t1,-1		# $t1--
	bne	$t1,$zero,print		# if ($t1 != 0) jump to print
	
	lw	$t0,0($sp)		# Restore $t0
	lw	$t1,4($sp)		# Restore $t1
	lw	$t2,8($sp)		# Restore $t2
	addi	$sp,$sp,12		# Restore $sp
	jr	$ra			# return
