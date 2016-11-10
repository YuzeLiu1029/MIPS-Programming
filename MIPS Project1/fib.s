########## Begin of fib function #########
fib: addi $sp, $sp, -12
     sw $a0, 0($sp)
	 sw $s0, 4($sp)
	 sw $ra, 8($sp)
	 bgt $a0, 1, gen
	 move $v0, $a0
	 j rreg
	 gen: addi $a0, $a0, -1
	      jal fib
		  move $s0, $v0
		  addi $a0, $a0, -1
		  jal fib
		  add $v0, $v0, $s0
	 rreg: lw $a0, 0($sp)
	       lw $s0, 4($sp)
		   lw $ra, 8($sp)
		   addi $sp, $sp, 12
		   jr $ra      
########## End of fib function ##########