 #This Program is writte by Yuze Liu for Assignment 4
 # $s7 - save $ra
 # $a0 -  for the function parameter / syscall parameter
 # $v0 - function return value / syscall number

  .text
  .globl main
###Begin the main function######
main:
  addu $s7, $ra, $zero #Save $ra

  li $v0, 4
  la, $a0, ask_input_base
  syscall                 #Output the text, ask user input the base

  li $v0 , 5              #read an integer from the user
  syscall
  add $s1, $v0, $zero     #store the interger into $s1

  li $v0, 4
  la, $a0, ask_input_number
  syscall                 #Output the text, ask user input a number

  li $v0, 8               #read the string from the user
  la $a0, buffer
  li $a1, 20
  move $s2, $a0
  syscall
  #add $s2, $v0, $zero     #Store the string into $s2 

  add $a0, $s1, $zero     #$a0 store the base
  add $a1, $s2, $zero     #pass the parameter into the function

  jal convert

  add $s3, $v0, $zero

  li $v0, 4
  la, $a0, show_result
  syscall

  move $a0, $s3
  li $v0, 1
  syscall

addu $ra, $zero, $s7
jr $ra
add $zero, $zero, $zero
add $zero, $zero, $zero
###End the main function#######
###############################

###Begin of convert function###
# $a0 store the value of base
# $a1 store the string number
# $v0 return the convert value
convert:
add $t0, $zero, $zero        #initialize, count length of string
add $t8, $zero, $zero        #initialize, store length of the string
add $t9, $zero, $zero        # store the sum
add $t7, $zero, $a1          # store $a1 in $t7
getlen: add $t1, $zero, $zero
        lb $t1, 0($t7)
		addi $t2, $zero, 10
		beq $t1, $t2, exit
		addi $t0, $t0, 1
		addi $t7, $t7, 1
		j getlen
exit:   add $t8, $t0, $zero
add $t6, $t8, $zero              # $t6 = length of the string

loop1: add $t1, $zero, $zero
       lb $t1, 0($a1)            # $t1 store the char of the string 
	   addi $t2, $zero, 10       
	   beq $t1, $t2, exit1       # if it is the end of the string go to exit1
	   addi $t6, $t6, -1         # if not, $t6 store the position of the char
	   addi $t2, $zero, 1              # $t2 = 1
       addi $t3, $zero, 1              # $t3 = 1
	   slti $t4, $t1, 58         
	   beqz $t4, char            # if the char is a to z go to char
	   addi $t1, $t1, -48        # if not, minus 48, $t1 store the decimal value of teh char
	   add $t0, $t6, $zero
	   j power
	   char: addi $t1, $t1, -87  # $t1 store the decimal value of char
	         add $t0, $t6, $zero
	   power: beqz $t0, case1    # Initialize $t0 = len of char, if $t0 = 0, go to case 1
	          mul $t2, $t2, $a0  # the power of the current position
			  addi $t0, $t0, -1  # $t0 = $t0 -1
			  j power            # go to the power loop
	   case1: mul $t2, $t2, $t3  # $t2 = $t2 * 1, $t2 store the power of the current position
	   mul $t1, $t1, $t2         # $t1 stor the value of the character of the given base
	   add $t9, $t9, $t1         # sum = sum + new value
	   addi $a1, $a1, 1
	   j loop1
exit1: add $v0, $zero, $t9
       jr $ra 	   
####End of the convert function#####

####################################

.data
#Data segment starts here
buffer: .space 20
ask_input_base:
  .asciiz "Enter a base(between 2 and 36 in decimal) : "
ask_input_number:
  .asciiz "\nEnter a number in base : "
show_result:
  .asciiz "\nThe value in decimal is : "
