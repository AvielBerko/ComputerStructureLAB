# Meir Klemfner(211954185), Aviel Berkowitz(211981105)
# Exercise 1, question 2

.data
msg_inp:.asciiz	"Enter 2-digit numbers, to end enter 0:\n"	# The message to print at the start
msg_sum:.asciiz	"Sum = "					# The message of the result


.text
	# Gets the input for first and last
	
	li	$v0,4						# $v0 = 4
	la	$a0,msg_inp					# $a0 = msg_inp
	syscall							# prints msg_inp
	li	$t0,0						# $t0(sum) = 0
loop:	li	$v0, 5						# $v0 = 5
	syscall							# reads an integer
	add	$t1,$v0,$zero					# $t1 = input
	beq	$t1,$zero,end					# if the input is 0 end
	slti	$t2,$t1,100					# $t2 = 1 if inupt is less than 100
	beq	$t2,0,loop					# if input is greater than 99 ignore and get another input.
	slti	$t2,$t1,-99					# $t2 = 1 if inupt is less than -99
	beq	$t2,1,loop					# if input is smaller than -99 ignore and get another input.
	add	$t0,$t0,$t1					# sum += input
	j 	loop						# gets a new input

end:	li	$v0,4						# $v0 = 4
	la	$a0,msg_sum					# $a0 = msg_sum
	syscall							# prints msg_sum
	li	$v0,1						# $v0 = 1
	add	$a0,$t0,$zero					# $a0 = sum
	syscall							# prints the sum