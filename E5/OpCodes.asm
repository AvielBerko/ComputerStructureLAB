.data
inp:	.asciiz "\nInput = 0x"
res:	.asciiz "Result = "
err:	.asciiz "ERROR: WRONG OP CODE"
.align 2
number:	.space 10			# The number in ASCII
.text
loop:	# prints inp
	li	$v0,4			# $v0 = 4
	la	$a0,inp			# $a0 points to inp
	syscall
	jal	read_hex_number		# receive a hexa number from the user
	beq	$v1,$zero,exit		# if the number is 0 - exit
	li	$t0,0xFF000000		# $t0 = 0xFF000000
	and	$t0,$v1,$t0		# $t0 = $t0 & $v0 (only last byte)
	srl	$t0,$t0,24		# shift $t0 6 bytes right (to start)
	
	li	$t1,0x30		# $t1 = 0x30
	beq	$t0,$t1,op1		# if $t0 == $t1 jump to op1
	li	$t1,0x31		# $t1 = 0x31
	beq	$t0,$t1,op2		# if $t0 == $t1 jump to op2
	li	$t1,0x48		# $t1 = 0x48
	beq	$t0,$t1,op3		# if $t0 == $t1 jump to op3
	li	$t1,0x74		# $t1 = 0x74
	beq	$t0,$t1,op4		# if $t0 == $t1 jump to op4
	
	# The code is not valid - ERROR #
	# prints err
	li	$v0,4			# $v0 = 4
	la	$a0,err			# $a0 points to err
	syscall
	j	loop
	
op1:	li	$t1,0xFFFFFF3C		# $t1 = 0xFFFFFF3C (11...00111100)
	and	$v1,$v1,$t1		# $t0 = $t0 & $v0 (bits 0,1,6,7 = 0)
	j	print
op2:	li	$t1,0x000000C3		# $t1 = 0x000000C3 (00...11000011)
	or	$v1,$v1,$t1		# $t0 = $t0 | $v0 (bits 0,1,6,7 = 1)
	j	print
op3:	li	$t1,0x0000FF00		# $t1 = 0x0000FF00 (bits 8-15 = 1)
	xor	$v1,$v1,$t1		# $t0 = $t0 ^ $v0 (reverse bits 8-15)
	j	print
op4:	li	$t1,0x00F00000		# $t1 = 0x00F00000 (bits 20-24 = 1)
	and	$t1,$v1,$t1		# $t1 = $t1 & $v1 (only bits 20-24)	
	srl	$t1,$t1,20		# shift $t0 5 bytes right (to start)
	sllv	$v1,$v1,$t1		# shift $v1 left N bits (N = $t1)
	
print:	# prints res
	li	$v0,4			# $v0 = 4
	la	$a0,res			# $a0 points to res
	syscall
	# prints the hexa result
	li	$v0,34			# $v0 = 34
	add	$a0,$v1,$zero		# $a0 = $v1
	syscall
	j	loop
	
exit:	li	$v0,10			# exit
	syscall
#####################################################################	
############################ functions ##############################
#####################################################################
read_hex_number:
# This function reads a number in hex A to F must be BIG LETTERS
	addi	$sp,$sp,-20		# Save room for 5 registers
	sw	$t0,0($sp)		# Save $t0
	sw	$t1,4($sp)		# Save $t1
	sw	$t2,8($sp)		# Save $t2
	sw	$t3,12($sp)		# Save $t3
	sw	$t4,16($sp)		# Save $t4
	li	$v0,8
	la	$a0,number
	li	$a1,10
	syscall				# Read number as string
	li	$t0,0			# $t0 = The result
	la	$t1,number		# $t1 = pointer to number
next:	lb	$t2,0($t1)		# $t2 = next digit
	li	$t4,10
	beq	$t2,$t4,end		# if $t2 = enter --> finish
	sll	$t0,$t0,4		# $t0 *= 16
	slti	$t3,$t2,0x3a		# check if tav <= '9'
	bne	$t3,$zero,digit
	addi	$t2,$t2,-55		# $t2 = $t2 -'A' + 10
	j cont
digit:	addi	$t2,$t2,-48		# $t2 = $t2 - '0'
cont:	add	$t0,$t0,$t2		# add to sum
	addi	$t1,$t1,1		# increment pointer
	j next
end:	addi	$v1,$t0,0		# return value in $v1
	lw	$t0,0($sp)		# Restore $t0
	lw	$t1,4($sp)		# Restore $t1
	lw	$t2,8($sp)		# Restore $t2
	lw	$t3,12($sp)		# Restore $t3
	lw	$t4,16($sp)		# Restore $t4
	addi	$sp,$sp,20		# Restore $sp
	jr	$ra 			# return
