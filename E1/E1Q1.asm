# Meir Klemfner(211954185), Aviel Berkowitz(211981105)
# Exercise 1, question 1

.data
arr1:	.space	4000				# = 1000 words
arr2:	.space	4000				# = 1000 words
first:	.word	0				# word = 4 bytes
last:	.word	0				# word = 4 bytes
msg_gf:	.asciiz	"Enter first location: "	# message to get the first value
msg_gl:	.asciiz "Enter last location: "		# message to get the last value
msg_sum:.asciiz	"Sum = "				# message to print the sum
msg_cnt:.asciiz	"\nCount = "			# message to print the count

.text
	# Initializes arr1
	
	la	$t0,arr1			# $t0 points to arr1
	li	$t1,10				# $t1 is the first value
loop1:	sw	$t1,0($t0)			# Stores the value in arr1
	addi	$t1,$t1,10			# $t1 += 10
	addi	$t0,$t0,4			# $t0 points to the next word
	bne 	$t1,510,loop1			# loop condition, while $t1 <= 500
	
	# Gets the input for first and last
	
	li	$v0,4				# $v0 = 4
	la	$a0,msg_gf			# $a0 = msg_gf
	syscall					# prints msg_gf
	li	$v0, 5				# $v0 = 5
	syscall					# reads an integer
	la	$t0,first			# $t0 points to first
	sw	$v0,0($t0)			# first = input
	li	$v0,4				# $v0 = 4
	la	$a0,msg_gl			# $a0 = msg_gl
	syscall					# prints msg_gl
	li	$v0, 5				# $v0 = 5
	syscall					# reads an integer
	la	$t1,last			# $t1 points to last
	sw	$v0,0($t1)			# last = input
	
	# Copies the words from arr1 to arr2 between first and last(also sums and counts the value)
	
	la	$t2,arr1			# $t2 points to arr1[0]
	lw	$t3,0($t0)			# $t3 = first
	# Moves $t2 to "first" element
	li	$t4,1				# $t4(iterator) = 1
loop2:	beq	$t4,$t3,e_loop2			# loop condition, while $t3 < $t4
	addi	$t2,$t2,4			# $t2++ (points to the next word)
	addi	$t4,$t4,1			# iterator++
	j loop2					# continues the loop
	
e_loop2:lw	$t4,0($t1)			# $t4 = last
	sub	$t3,$t4,$t3			# $t3(count) = last - first					# $t0 is a pointer to arr1
	addi	$t3,$t3,1			# $t3++ (number of elements = last - first + 1)			# $t1 is a pointer to arr2
	add	$t0,$t2,$zero			# $t0 points to arr1 + first					# $t2 is sum
	la	$t1,arr2			# $t1 points to arr2						# $t3 is count
	li	$t2,0				# $t2(sum) = 0							# $t4 is an iterator
	li	$t4,0				# $t4(iterator) = 0						# $t5 stores the current word to copy
	# Copies the elements from arr1 to arr2
loop3:	lw	$t5,0($t0)			# $t5 = arr1[first + iterator]
	sw	$t5,0($t1)			# stores $t5 in arr2
	addi	$t0,$t0,4			# $t0++ (points to the next word)
	addi	$t1,$t1,4			# $t1++ (points to the next word)
	add	$t2,$t2,$t5			# sum += arr1[first + iterator]
	addi	$t4,$t4,1			# iterator++
	bne	$t4,$t3,loop3			# loop condition, while $t4 < $t3
	
	# Prints the sum and the count
	
	li	$v0,4				# $v0 = 4
	la	$a0,msg_sum			# $a0 = msg_sum
	syscall					# prints msg_sum
	li	$v0,1				# $v0 = 1
	add	$a0,$t2,$zero			# $a0 = sum
	syscall					# prints the sum
	li	$v0,4				# $v0 = 4
	la	$a0,msg_cnt			# $a0 = msg_cnt
	syscall					# prints msg_cnt
	li	$v0,1				# $v0 = 1
	add	$a0,$t3,$zero			# $a0 = count
	syscall					# prints the count
