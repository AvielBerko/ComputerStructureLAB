.data
msg_b:	.asciiz "Enter block of digits (0-9) and -1 to finish: "
msg_c:	.asciiz "Enter basic code: "
msg_1:	.asciiz	"The code "
msg_y2:	.asciiz " exists in the block"
msg_n2:	.asciiz " doesn't exist in the block"

block:	.space 32				# 32 bytes for the block
code:	.space 6				# 6 bytes for the basic code

.text
	# prints msg_b (to enter the block)
	li	$v0,4				# $v0 = 4
	la	$a0,msg_b			# $a0 points to msg_b
	syscall
	
	# gets the block from the user
	la	$t0,block			# $t0 points to block
	li	$t1,-1				# $t1 = -1 (end sign)
	li	$s0,0				# $s0 = 0 (size of block)		
loop_b:	li	$v0,5				# $v0 = 5 (int read)
	syscall					# reads an integer
	beq	$v0,$t1,end_b			# if $v0(input) == -1 end the loop
	sb	$v0,0($t0)			# store the byte at block[$t0]
	addi	$t0,$t0,1			# $t0++ (points to next cell)
	addi	$s0,$s0,1			# $s0++ (counter)
	j	loop_b
	
end_b:	# prints msg_c (to enter the basic code)
	li	$v0,4				# $v0 = 4
	la	$a0,msg_c			# $a0 points to msg_c
	syscall
	
	# gets the basic code from the user
	la	$t0,code			# $t0 points to code
	li	$t1,6				# $t1 = 6 (count down)
loop_c:	beq	$t1,$zero,end_c			# if $t1 == 0 end the loop
	li	$v0,5				# $v0 = 5 (int read)
	syscall					# reads an integer
	sb	$v0,0($t0)			# store the byte at block[$t0]
	addi	$t0,$t0,1			# $t0++ (points to next cell)
	addi	$t1,$t1,-1			# $t1-- (counter)
	j	loop_c	

end_c:	########### THE ALGORITHM ###########
	# loops on block while checking     #
	# each value. if it equals to       #
	# the first value of the code,      #
	# then it loops at the same time    #
	# on the code checking each value.  #
	# if we've counted 6 equal bytes -  #
	# the code exists. else return back #
	# to the next byte from the start   #
	# of the check.                     #
	#####################################
	la	$t0,block			# $t0 points to block
	la	$t1,code			# $t1 points to code
	li	$t4,6				# $t4 = 6 (counter)
loop:	beq	$s0,$zero,end_n			# if $s0 == 0 (size of block) end the loop
	lb	$t2,0($t0)			# $t2 = block[0]
	lb	$t3,0($t1)			# $t3 = code[0]
	bne	$t2,$t3,reset			# if $t2 != $t1 then reset
	addi	$t0,$t0,1			# $t0++ (next byte)
	addi	$s0,$s0,-1			# $s0--
	addi	$t1,$t1,1			# $t1++	(next byte)
	addi	$t4,$t4,-1			# $t4--
	beq	$t4,$zero,end_y			# if $t4 == 0 then end (code was found)
	j	loop
reset:	la	$t1,code			# $t1 points to the start of code
	addi	$t0,$t0,-5			# $t0 -= 5
	add	$t0,$t0,$t4			# $t0 += $t4 [$t0 -= (5 - $t4)]
	addi	$s0,$s0,5			# $s0 += 5
	sub	$s0,$s0,$t4			# $s0 -= $t4 [$s0 += (5 - $t4)]
	li	$t4,6				# $t4 = 6 (reset)
	j	loop	
	
end_n:	jal	out_c				# call the printing function
	
	# prints msg_n2
	li	$v0,4				# $v0 = 4
	la	$a0,msg_n2			# $a0 points to msg_n2
	syscall
	j	exit
	
end_y:	jal	out_c				# call the printing function
	
	# prints msg_y2
	li	$v0,4				# $v0 = 4
	la	$a0,msg_y2			# $a0 points to msg_y2
	syscall

exit:	li	$v0,10				# exit
	syscall
#####################################################################	
############################ functions ##############################
#####################################################################	
out_c:	
# this function saves the registers
# it doesn't need input and doesn't give output
# it prints: The code <CODE>
	addi	$sp, $sp, -8			# $sp -= 8 (2 words back)
	sw	$t0, 0($sp)			# save $t0 in the stack
	sw	$t1, 4($sp)			# save $t1 in the stack
	
	# prints msg_1: The code
	li	$v0,4				# $v0 = 4
	la	$a0,msg_1			# $a0 points to msg_1
	syscall
	
	# prints the code
	la	$t0,code			# $t0 points to code
	li	$t1,6				# $t1 = 6 (count down)
	li	$v0,1				# $v0 = 1
lp_c:	beq	$t1,$zero,e_c			# if $t1 == 0 end the loop
	lb	$a0,0($t0)			# $a0 = code[0]
	syscall					# prints the integer
	addi	$t0,$t0,1			# $t0++
	addi	$t1,$t1,-1			# $t1--
	j	lp_c
	
e_c:	lw	$t0, 0($sp)			# retrieve $t0 value from the stack
	lw	$t1, 4($sp)			# retrieve $t1 value from the stack
	addi	$sp, $sp, 8			# $sp += 8 (2 words forward)
	jr	$ra				# jump to $ra
