# Meir Klemfner(211954185), Aviel Berkowitz(211981105)
# Exercise 2, question 2

.data
msg_v:	.asciiz "\nENTER VALUE: "
msg_op:	.asciiz	"ENTER OP CODE: "
msg_r:	.asciiz "\nTHE RESULT IS: "
msg_e:	.asciiz	"OVERFLOW ERROR"
.text
	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_v		# $a0 point to msg_v
	syscall				# prints msg_v
	li	$v0,5			# $v0 = 5 (int input)
	syscall	
	add	$t0,$v0,$zero		# $t0 = input (result)
loop:	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_op		# $a0 point to msg_op
	syscall				# prints msg_op
	li	$v0,12			# $v0 = 12 (char input)
	syscall
	add	$t1,$v0,$zero		# $t1 = input
	li	$s0,'@'			# $s0 = '@'
	beq	$s0,$t1,res		# if $t1(char) == '@' jump to res
	
	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_v		# $a0 point to msg_v
	syscall				# prints msg_v
	li	$v0,5			# $v0 = 5 (int input)
	syscall
	add	$t2,$v0,$zero		# $t2 = input
		
	li	$s0,'+'			# $s0 = '+'
	beq	$s0,$t1,plus		# if $t1(char) == '+' jump to plus
	li	$s0,'-'			# $s0 = '+'
	beq	$s0,$t1,minus		# if $t1(char) == '-' jump to minus
	li	$s0,'*'			# $s0 = '+'
	beq	$s0,$t1,times		# if $t1(char) == '*' jump to times

plus:	add	$t0,$t0,$t2		# $t0(result) += $t2
	j	loop			# jump to loop start
minus:	sub	$t0,$t0,$t2		# $t0(result) -= $t2
	j	loop			# jump to loop start
times:	mult	$t0,$t2			# hi,lo = $t0 * $t2
	mflo	$t0			# $t0(result) = lo
	mfhi	$t4			# $t4 = hi
	#andi	$t3,$t0, 0x80000000	# $t3 = 0 if low is positive and -2^31 if not (sign bit) - OLD
	slt	$t3, $t0, $zero		# $t3 = 0 if low is positive and 1 if not - NEW
	bne	$t3,$zero,ngtv		# if $t3 is 1 - jump to ngtv
	bne	$t4,$zero,error		# (if $t3 is 0, and) $t4(hi) = is not 0 - jump to error (overflow)
	j	loop			# jump to loop start (no overflow) 
ngtv:	li	$t3,0xFFFFFFFF		# $t3 is 32 bits of 1s (= -1)
	bne	$t3,$t4,error		# if $t4(hi) != $t3 - jump to error (overflow)
	j	loop			# jump to loop start (no overflow)
error:	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_e		# $a0 point to msg_e
	syscall				# # prints msg_e
	li	$v0,10			# $v0 = 10 (exit)
	syscall				# exit
res:	li	$v0,4			# $v0 = 4 (print string)
	la	$a0,msg_r		# $a0 point to msg_r
	syscall				# print msg_r
	li	$v0,1			# $v0 = 1 (print int)
	add	$a0,$t0,$zero		# $a0 = $t0 (result)
	syscall				# prints the result
