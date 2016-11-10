########## Begin of median function ##########
median:
     addi $sp, $sp, -4
	 sw $ra, 0($sp)
     jal sort
	 add $a1, $v0, $zero
     addi $t1, $zero, 1
	 andi $t0, $a1, 1
	 beq $t0, $t1, odd 
	 sra $t2, $a1, 1
	 addi $t2, $t2, -1
	 sll $t2, $t2, 2
	 add $t3, $a0, $t2
	 lw $t4, 0($t3)
	 ##beq $t0, $t1, odd
	 lw $t5, 4($t3)
	 add $t6, $t4, $t5
	 sra $t6, $t6, 1
	 add $v0, $t6, $zero
	 lw $ra, 0($sp)
	 addi $sp, $sp, 4
	 jr $ra
	 odd: sra $t2, $a1, 1
	      sll $t2, $t2, 2
	      add $t3, $a0, $t2
	      lw $t4, 0($t3)
	      add $v0, $t4, $zero
	      lw $ra, 0($sp)
	      addi $sp, $sp, 4
	      jr $ra
########## ENd of median function #########
########## End of median function ##########
########## Begin of sort function ##########
sort: addi $sp, $sp, -20
      sw $ra, 16($sp)
	  sw $s3, 12($sp)
	  sw $s2, 8($sp)
	  sw $s1, 4($sp)
	  sw $s0, 0($sp)

   move $s2, $a0
   move $s3, $a1
   move $s0, $zero
   for1tst: slt $t0, $s0, $s3
            beq $t0, $zero, exit1
			addi $s1, $s0, -1
   for2tst: slti $t0, $s1, 0
            bne $t0, $zero, exit2
			sll $t1, $s1, 2
			add $t2, $s2, $t1
			lw $t3, 0($t2)
			lw $t4, 4($t2)
			slt $t0, $t4, $t3
			beq $t0, $zero, exit2
			move $a0, $s2
			move $a1, $s1
			jal swap
			addi $s1, $s1, -1
			j for2tst
   exit2: addi $s0, $s0, 1
          j for1tst
   exit1: lw $s0,0($sp)
          lw $s1, 4($sp)
		  lw $s2,8($sp)
		  lw $s3,12($sp)
		  lw $ra, 16($sp)
		  addi $sp, $sp, 20
	jr $ra
########## End of sort function ##########
########## Begin of swap ##########
swap: sll $t7, $a1, 2
      add $t7, $a0, $t7
	  lw $t8,0($t7)
	  lw $t9,4($t7)
	  sw $t9,0($t7)
	  sw $t8,4($t7)
	  jr $ra
########## End of swap ##########