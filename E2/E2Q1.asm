# Meir Klemfner(211954185), Aviel Berkowitz(211981105)
# Exercise 2, question 1

.data
arr:	.byte 122,-12,48,-128,127,2,126,0	# array of signed bytes (8 bits)
size:	.word 8					# array size
msgMax:	.asciiz "Maximum: "
msgMin:	.asciiz "\nMinimum: "

.text
	la	$t0,arr				# $t0 points to arr
	la	$t1,size			# $t1 points to size
	lw	$t1,0($t1)			# $t1 = size
	lb	$t2,0($t0)			# $t2 saves the maximum value
	add	$t3,$t2,$zero			# $t3 saves the minimum value
loop:	beq	$t1,$zero,end			# loops while $t1(size) > 0
	addi	$t0,$t0,1			# moves to next cell (byte) in arr
	lb	$t4,0($t0)			# $t4(temp) = arr[t0] (current cell)
	slt	$t5,$t4,$t3			# $t5 = 1 if $t4 < $t3(minimun)
	bne	$t5,$zero,min			# if $t5 = 1 jump to min
	slt	$t5,$t2,$t4			# $t5 = 1 if $t4 > $t2(maximun) 
	bne	$t5,$zero,max			# if $t5 = 1 jump to max
	j	end_lp				# jump to the end of the loop
min:	add	$t3,$t4,$zero			# set the new minimum
	j	end_lp				# jump to the end of the loop
max:	add	$t2,$t4,$zero			# set the new maximum
end_lp:	addi	$t1,$t1,-1			# $t1(size)--
	j	loop				# jump to loop start
end:	li	$v0,4				# $v0 = 4 (print string)
	la	$a0,msgMax			# $a0 point to msgMax
	syscall					# prints msgMax
	li	$v0,1				# $v0 = 1 (print int)
	add	$a0,$t2,$zero			# $a0 = $t2(maximum)
	syscall					# prints the maximun
	li	$v0,4				# $v0 = 4 (print string)
	la	$a0,msgMin			# $a0 point to msgMin
	syscall					# prints msgMin
	li	$v0,1				# $v0 = 1 (print int)
	add	$a0,$t3,$zero			# $a0 = $t3(minimum)
	syscall					# prints the minimum
