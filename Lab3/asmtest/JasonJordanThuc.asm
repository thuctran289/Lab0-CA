# Multiply 3*2, store result to s0
addi $a0, $zero, 3
addi $a1, $zero, 2
jal MULTIPLY
move $s0, $v1

# exit program
li $v0, 10
syscall


MULTIPLY:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	
	addi $t3, $zero, 1 # t3 is 1
	add $t1, $a1, $zero # t1 is a1
	
	add $v1, $v1, $zero # v0 = 0 
	
	jal MULT
	
	lw $ra, 8($sp)
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 12
	
	
	jr $ra

	
	MULT:
		add $v1, $v1, $a0 # v0 += a
		sub $t1, $t1, $t3 # b--
		slt $t2, $t1, $t3 # return t1 < 1 
		bne $t2, $zero, END # if t1 < 1, GOTO END, else, MULT
		j MULT
	
	END:
		jr $ra
	
	
