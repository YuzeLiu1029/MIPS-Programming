########## Begin of palindrome function ##########
palindrome:
     add $t0, $zero, $zero                  #initialize $t0 to 0, prepare for the length of teh array
	 add $t1, $zero, $zero
	 add $t1, $a0, $t1
	 Loop1: lb  $t2, 0($t1)                  # $t2 get the value of string[$t0]
			beqz $t2, exit1                  # if($t2 = '\0'), then exit the loop, go to exit1
			addi $t0, $t0, 1                 # if($t2 != '\0'), then $t0 = $t0 + 1, go to Loop1
			addi $t1, $t1, 1
			j Loop1                         # The code above will get the length of the array and store it in $t0
	 exit1: add $t1, $zero, $zero           # initialize $t1 to 0 (i)
	        add $t2, $zero, $zero           # initialize $t2 to 0
			add $t3, $zero, $zero           # initialize $t3 to 0
			add $t4, $zero, $zero
			add $t5, $zero, $zero
			add $t2, $t2, $t0               # $t2 store the array length from $t0
			addi $t2, $t2, -1               # $t2 store the length - 1 (j)
			addi $t3, $t3, 1                # $t3 = 1 which is the flag value (return value)
			sra $t6, $t0, 1                 # $t6 store the length/2
			add $t4, $a0, $t4               # $t4 get the address of string[$t4]
			add $t5, $a0, $t2               # $t5 get the address of string[$t5]
			addi $t9, $zero, 32             # $t9 get the value 32
			addi $t2, $zero, -32            # $t2 get the value -32
	 Loop2: lb $t6, 0($t4)                  # $t6 = str[$t4]
			lb $t7, 0($t5)                  # $t7 = str[$t5]
			bne $t6, $t7, exit2             # if(array[i] != array[j]) exit2
		L1:	addi $t1, $t1, 1                # i = i + 1
			#addi $t2, $t2, -1              # j = j - 1
			slt $t7, $t1, $t6               # if(i < length/2), $t7 = 1
			beq $t7, $zero, exit3           # if ($t7 == 0), exit3
		    add $t4, $t4, 1                 # next byte
			add $t5, $t5, -1                # next byte
			j Loop2                         # if (i < length/2), go to loop2
	 exit2: sub $t8, $t6, $t7               # check if it is same character with uppercase and lowercase
	        beq $t8, $t9, L1                # if it is , then go back as they are same character
			beq $t8, $t2, L1
			addi $t3, $t3, -1               # not palindrome, flag is 0
	        add $v0, $t3, $zero             # retun 0
			jr $ra                          # return 
	 exit3: add $v0, $t3, $zero             # is palindrome, flag is 1
	        jr $ra                          # return 
########## End of palindrome function ###########