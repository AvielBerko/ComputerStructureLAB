# Meir Klemfner(211954185), Aviel Berkowitz(211981105)
# Exercise 3, question 2

.data
#ser:	.word -4, -1, 2, 5, 8, 11, 14, 17, 20, 23	# Invoice
ser:	.word 1, 2, 4, 8, 16, 32, 64, 128, 256, 513	# almost Engineering
size:	.word 10					# array size		

msg_in:	.asciiz	"Invoice Series: a1 = "
msg_d:	.asciiz ", d = "
msg_en:	.asciiz "Engineering Series: a1 = "
msg_q:	.asciiz	", q = "
msg_no:	.asciiz	"No Series"

.text
	# Invoice
	la	$s0,ser			# $s0 points to ser
	la	$s1,size		# $s1 points to size
	lw	$s1,0($s1)		# $s1 = size
	
	# d = ser[n+1]-ser[n]
	lw	$t1,0($s0)		# $t1 = ser[0]
	lw	$t2,4($s0)		# $t2 = ser[1]
	sub	$t0,$t2,$t1		# $t0 = $t2 - $t1 (d)
	
	addi	$s0,$s0,4		# $s0++ (next word)
	addi	$s1,$s1,-2		# $s1 -= 2 (need to perform n-1 iterations)

	
in_ser:	beq	$s1,$zero,is_in		# if ($s1 == 0) the series is invoice
	lw	$t1,0($s0)		# $t1 = ser[i]
	lw	$t2,4($s0)		# $t2 = ser[i+1]
	sub	$t3,$t2,$t1		# $t3 = $t2 - $t1 (d)
	
	addi	$s1,$s1,-1		# s1(size)--
	addi	$s0,$s0,4		# $s0++ (next word)
	beq	$t0,$t3,in_ser		# if ($t0 == $t3) continue the loop (same d)
	
	# Engineering
	la	$s0,ser			# $s0 points to ser
	la	$s1,size		# $s1 points to size
	lw	$s1,0($s1)		# $s1 = size
	
	# q = ser[n+1]/ser[n]
	lw	$t1,0($s0)		# $t1 = ser[0]
	lw	$t2,4($s0)		# $t2 = ser[1]
	div	$t2,$t1			# lo = $t2/$t1 (q)
	mflo	$t0			# $t0 = lo
	
	addi	$s1,$s1,-2		# $s1 -= 2 (need to perform n-1 iterations)
	addi	$s0,$s0,4		# $s0++ (next word)
	
en_ser:	beq	$s1,$zero,is_en		# if ($s1 == 0) the series is engineering
	lw	$t1,0($s0)		# $t1 = ser[i]
	lw	$t2,4($s0)		# $t2 = ser[i+1]
	div	$t2,$t1			# lo = $t2/$t1 (q)
	
	mfhi	$t3			# $t3 = hi (reminder)
	bne	$t3,$zero,is_no		# if the reminder is not 0 - not engineering
	
	mflo	$t3			# $t3 = lo
	addi	$s1,$s1,-1		# s1(size)--
	addi	$s0,$s0,4		# $s0++ (next word)
	beq	$t0,$t3,en_ser		# if ($t0 == $t3) continue the loop (same q)

# not invoice and not engineering
is_no:	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_no		# $a0 points to the message
	syscall				# prints the message
	j end				# end the program
	
is_in:	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_in		# $a0 points to the message
	syscall				# prints the message
	
	li	$v0,1			# $v0 = 1 (print int)
	la	$s0,ser			# $s0 points to ser 
	lw	$a0,0($s0)		# $a0 = ser[0]
	syscall				# prints the int
	
	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_d		# $a0 points to the message
	syscall
	
	li	$v0,1			# $v0 = 1 (print int)
	add	$a0,$t0,$zero		# $a0 = $t0 (d)
	syscall				# prints the int
	
	j end				# end the program	
	
is_en:	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_en		# $a0 points to the message
	syscall				# prints the message
	
	li	$v0,1			# $v0 = 1 (print int)
	la	$s0,ser			# $s0 points to ser 
	lw	$a0,0($s0)		# $a0 = ser[0]
	syscall				# prints the int
	
	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_q		# $a0 points to the message
	syscall				# prints the message
	
	li	$v0,1			# $v0 = 1 (print int)
	add	$a0,$t0,$zero		# $a0 = $t0 (q)
	syscall				# prints the int

end:	nop				# end of program