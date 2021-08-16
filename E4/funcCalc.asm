# Meir Klemfner(211954185), Aviel Berkowitz(211981105)
# Exercise 4

.data
msg_f:	.asciiz "Enter first number: "
msg_s:	.asciiz "\nEnter second number: "
msg_o:	.asciiz "Enter operator: "
msg_e:	.asciiz "The result is: "
msg_i:	.asciiz "Invalid operation..."

.text   # Main Function
	li	$v0,4 		        	# $v0 = 4
	la	$a0, msg_f			# $a0 points to msg_f
	syscall					# prints msg_f

	li	$v0,5				# $v0 = 5
	syscall					# gets an integer
	add	$t0, $v0, $zero			# $t0 = $v0 (input)

	li	$v0,4				# $v0 = 4
	la	$a0, msg_o			# $a0 points to msg_o
	syscall					# prints msg_o
        
	li	$v0,12				# $v0 = 12
	syscall					# gets a char
	add	$t1,$v0,$zero			# $t1 = $v0 (input)
        
	li	$v0,4				# $v0 = 4
	la	$a0, msg_s			# $a0 points to msg_s
	syscall					# prints msg_s

	li	$v0,5				# $v0 = 5
	syscall					# gets an integer

	add	$a0, $t0, $zero			# $a0 = $t0 (first number)
	add	$a1, $v0, $zero			# $a1 = $v0 (second number)

	li	$s0, '+'			# $s0 = '+'
	beq	$t1,$s0,jadd			# if $t1(char) == $s0 (add)
	li	$s0, '-'			# $s0 = '-'
	beq	$t1,$s0,jsub			# if $t1(char) == $s0 (sub)
	li	$s0, '*'			# $s0 = '*'
	beq	$t1,$s0,jmult			# if $t1(char) == $s0 (mult)
	li	$s0, '/'			# $s0 = '/'
	beq	$t1,$s0,jdiv			# if $t1(char) == $s0 (div)
	li	$s0, '^'			# $s0 = '^'
	beq	$t1,$s0,jpow			# if $t1(char) == $s0 (pow)
	
	# the operation was invalid - terminate
	li	$v0,4				# $v0 = 4
	la	$a0, msg_i			# $a0 points to msg_i
	syscall					# prints msg_i
	j	exit				# exit the program

jadd:	jal	ADD				# jump to ADD and save position to $ra
	j	end
jsub:   jal	SUB				# jump to SUB and save position to $ra
	j	end
jmult:	jal	MULT				# jump to MULT and save position to $ra
	j	end
jdiv:	jal	DIV				# jump to DIV and save position to $ra
	j	end
jpow:	jal	POW				# jump to POW and save position to $ra
	j	end

end:	# end of program - print the result and exit
	add	$t0, $v0, $zero			# $t0 = $v0 
        
	li	$v0,4				# $v0 = 4
	la	$a0, msg_e			# $a0 points to msg_e
	syscall					# prints msg_e

        li	$v0,1 		        	# $v0 = 1
        add	$a0, $t0, $zero     		# $a0 = $t0 
        syscall                     		# prints $a0

exit:	li	$v0,10
	syscall

##########################################################
##################### Functions Area #####################
##########################################################
# $v0 = $a0 + $a1
ADD:	add	$v0, $a0, $a1			# $v0 = $a0 + $a1
	jr	$ra				# jump to $ra
##########################################################
# $v0 = $a0 - $a1
SUB:	sub	$v0, $a0, $a1			# $v0 = $a0 - $a1
	jr	$ra				# jump to $ra
##########################################################
# $v0 = $a0 * $a1
MULT:	addi	$sp, $sp, -16			# $sp -= 16 (4 words back)
	sw	$t0, 0($sp)			# save $t0 in the stack
	sw	$t1, 4($sp)			# save $t1 in the stack
	sw	$t2, 8($sp)			# save $t2 in the stack
	sw	$ra, 12($sp)			# save $ra in the stack
	
	# sign check
	slt	$t0,$a0,$zero			# if $a0 < 0 then $t0 = 1
	bne	$t0,$zero,nega0m		# if $a0 is negative - switch the sign 
	j	end0m				# if $a0 is not negative (don't switch)
nega0m:	nor	$a0,$a0,$a0			# reverse every bit in $a0	
	addi	$a0,$a0,1			# $a0 += 1 (2's compliment)
end0m:	slt	$t1,$a1,$zero			# if $a1 < 0 then $t1 = 1	
	bne	$t1,$zero,nega1m		# if $a1 is negative - switch the sign 
	j	end1m				# if $a1 is not negative (don't switch)
nega1m:	nor	$a1,$a1,$a1			# reverse every bit in $a1
	addi	$a1,$a1,1			# $a1 += 1 (2's compliment)
end1m:	bne	$t0,$t1,isnegm			# if $t0 != $t1 (the signs are different)
	j	startm				# else - start the multiplication
isnegm:	li	$t2,1				# $t2 = 1 (marks that the signs are different)

startm:	li	$t0, 0				# $t0 = 0
	add	$t1, $a1, $zero			# $t1 = $a1
	li	$a1, 0				# $a1 = 0

mloop:	beq	$t1, $zero, emult		# if $t1 == 0 jump to emult
	jal	ADD				# jump to ADD and save position to $ra
	add	$t0, $t0, $v0			# $t0 += $v0
	addi	$t1, $t1, -1			# $t1--
	j	mloop				# jump to mloop

emult:	add	$v0, $t0, $zero			# $v0 = $t0
	bne	$t2,$zero,swsnm			# if $t2 != 0 (different signs)
	j	lsm				# skip to load stack
	
swsnm:	nor	$v0,$v0,$v0			# reverse every bit in $v0
	addi	$v0,$v0,1			# $v0 += 1 (2's compliment)

lsm:	lw	$t0, 0($sp)			# retrieve $t0 value from the stack
	lw	$t1, 4($sp)			# retrieve $t1 value from the stack
	lw	$t2, 8($sp)			# retrieve $t2 value from the stack
	lw	$ra, 12($sp)			# retrieve $ra value from the stack
	addi	$sp, $sp, 16			# $sp += 16 (4 words forward)
	jr	$ra				# jump to $ra
##########################################################
# $v0 = $a0 // $a1
DIV:	addi	$sp, $sp, -16			# $sp -= 16 (4 words back)
	sw	$t0, 0($sp)			# save $t0 in the stack
	sw	$t1, 4($sp)			# save $t1 in the stack
	sw	$t2, 8($sp)			# save $t2 in the stack
	sw	$ra, 12($sp)			# save $ra in the stack
	
	# sign check
	slt	$t0,$a0,$zero			# if $a0 < 0 then $t0 = 1
	bne	$t0,$zero,nega0d		# if $a0 is negative - switch the sign 
	j	end0d				# if $a0 is not negative (don't switch)
nega0d:	nor	$a0,$a0,$a0			# reverse every bit in $a0
	addi	$a0,$a0,1			# $a0 += 1 (2's compliment)
end0d:	slt	$t1,$a1,$zero			# if $a1 < 0 then $t1 = 1
	bne	$t1,$zero,nega1d		# if $a1 is negative - switch the sign
	j	end1d				# if $a1 is not negative (don't switch)
nega1d:	nor	$a1,$a1,$a1			# reverse every bit in $a1
	addi	$a1,$a1,1			# $a1 += 1 (2's compliment)
end1d:	bne	$t0,$t1,isnegd			# if $t0 != $t1 (the signs are different)
	j	startd				# else - start the division
isnegd:	li	$t2,1				# $t2 = 1 (marks that the signs are different)
							
startd:	li	$t0, 0				# $t0 = 0

dloop:	jal	SUB				# jump to SUB and save position to $ra
	slt	$t1,$v0, $zero			# if $v0 < 0 then $t1 = 1
	bne	$t1, $zero, ediv		# if $t1 = 1 jump to ediv
	add	$a0, $v0, $zero			# $a0 = $v0
	addi	$t0, $t0, 1			# $t0++
	j	dloop				# jump to dloop

ediv:	add	$v0, $t0, $zero			# $v0 = $t0
	bne	$t2,$zero,swsnd			# if $t2 != 0 (different signs)
	j	lsd				# skip to load stack
	
swsnd:	nor	$v0,$v0,$v0			# reverse every bit in $v0
	addi	$v0,$v0,1			# $v0 += 1 (2's compliment)

lsd:	lw	$t0, 0($sp)			# retrieve $t0 value from the stack
	lw	$t1, 4($sp)			# retrieve $t1 value from the stack
	lw	$t2, 8($sp)			# retrieve $t2 value from the stack
	lw	$ra, 12($sp)			# retrieve $ra value from the stack
	addi	$sp, $sp, 16			# $sp += 16 (4 words forward)
	jr	$ra				# jump to $ra
##########################################################
# $v0 = $a0 ^ $a1
POW:	addi	$sp, $sp, -12			# $sp -= 12 (3 words back)
	sw	$t0, 0($sp)			# save $t0 in the stack
	sw	$t1, 4($sp)			# save $t1 in the stack
	sw	$ra, 8($sp)			# save $ra in the stack
	
	add	$t0, $a1, $zero			# $t0 = $a1
	add	$t1, $a0, $zero			# $t1 = $a0
	li	$a0, 1				# $a0 = 1

ploop:	beq	$t0, $zero, epow		# if $t1 == 0 jump to epow
	add	$a1, $t1, $zero			# $a1 = $t1
	jal	MULT				# jump to MULT and save position to $ra
	add	$a0, $v0, $zero			# $a0 = $v0
	addi	$t0, $t0, -1			# $t0--
	j	ploop				# jump to ploop
	
epow:	add	$v0, $a0, $zero			# $v0 = $t0
	lw	$t0, 0($sp)			# retrieve $t0 value from the stack
	lw	$t1, 4($sp)			# retrieve $t1 value from the stack
	lw	$ra, 8($sp)			# retrieve $ra value from the stack
	addi	$sp, $sp, 12			# $sp += 12 (3 words forward)
	jr	$ra				# jump to $ra
##########################################################
