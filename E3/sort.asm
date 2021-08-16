# Meir Klemfner(211954185), Aviel Berkowitz(211981105)
# Exercise 3, question 1

.data
arr:	.word 8, 34, 9, -2, 0, 234, 89, 4, 8	# array of words
size:	.word 9					# array size

.text
	la	$s1,size			# $s1 points to size
	lw	$s1,0($s1)			# $s1 = size

# first loop	
f_loop:	la	$s0,arr				# $s0 points to arr
	beq	$s1,$zero,end_f			# if ($s1 == 0) end the 1st loop
	li	$s2,1				# $s2 = 1			
	
# second loop	
s_loop:	beq	$s2,$s1,end_s			# if ($s2 == $s1) end the 2nd loop
	lw	$t0,0($s0)			# $t0 = arr[i]			
	lw	$t1,4($s0)			# $t1 = arr[i+1]
	
	slt	$t2,$t1,$t0			# $t2 = 1 if $t1 < $t0  
	beq	$t2,$zero,next			# if $t2 = 0 ($t1 >= $t0) don't swap
	
	# swaps the cells
	sw	$t1,0($s0)			# arr[i] = $t1
	sw	$t0,4($s0)			# arr[i+1] = $t0
	
next:	addi	$s2,$s2,1			# $s2++
	addi	$s0,$s0,4			# $s0++ (next word)
	j	s_loop				# continue the 2nd loop
	
end_s:	addi	$s1,$s1,-1			# $s1(size)--
	j	f_loop				# continue the 1st loop

end_f:	la	$s1,size			# $s1 points to size
	lw	$s1,0($s1)			# $s1 = size
	
# printing loop	
p_loop:	beq	$s1,$zero,end			# if ($s1 == 0) end the program
	li	$v0,1				# $v0 = 1 (print int)
	lw	$a0,0($s0)			# $a0 = arr[i]
	syscall					# prints the array's current value
	
	li	$v0,11				# $v0 = 11 (print char)
	li	$a0,' '				# $a0 = ' '
	syscall					# prints a space
	
	addi	$s1,$s1,-1			# $s1(size)--
	addi	$s0,$s0,4			# $s0++ (next word)
	j	p_loop				# continue the printing loop

end:	nop					# end of program