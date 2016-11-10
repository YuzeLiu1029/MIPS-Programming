# Program to read the header of a valid pgm file 
# CDA 3100 - Homework #4, problem #2
# For the following program, the main function and read_image is written by Dr.Liu
# The print_hist function and the histogram function is written by Yuze Liu
 
##########Begin of main function##########					
	.text
	.globl main
main:
	addu     $s7, $ra, $zero, # Save the ra
	
	la	$a0, file_prompt  #print out the prompt for file name
	li	$v0, 4		      #system call print_str
	syscall

	la	$a0, file_name	     #read in the file name
	addi	$a1, $zero, 256  #using systecall read_str
	li	$v0,  8              #We read the file name
	syscall

	#Note that the string includes 10 ('\n') at the  end
	#We need to get rid of that first
	la	$t1, file_name              #Address of the file name string
	addi	$t2, $zero, 10
length_loop:                        # of the string:
	lb      $t0, 0($t1)             # load the byte at addr B into $t0.
	beq	$t0, $t2, end_length_loop   # if $t3 == 10, branch out of loop.
	addu	$t1, $t1, 1
	b       length_loop             # and repeat the loop.
end_length_loop:
	
	sb	$zero, 0($t1)		#We change '\n' to 0
	la	$a0,  file_name		#Show the file name
	li	$v0, 4
	syscall
	
	la	$a0, newline		#Display a new line
	li	$v0, 4
	syscall

	la	$a0, row_prompt
	li	$v0, 4
	syscall

	addi	$v0, $zero, 5	# We need to read an integer
	syscall
	add	$s1, $v0, $zero		# We save the number of rows to s1

	la	$a0, column_prompt
	li	$v0, 4
	syscall

	addi	$v0, $zero, 5	# We need to read an integer
	syscall
	add	$s2, $v0, $zero		# We save the number of columns to s2


	# image *read_image(char *filename, int nrow, int ncol)
	#prepare parameters for the arguments
	la	$a0,  file_name  #The first argument
	add	$a1,  $s1, $zero #The second argument
	add	$a2,  $s2, $zero #The third argument
	jal	read_image

	#We save the returned values
	add	$s3, $v0, $zero		    # We save the address of the array
	beq	$v0, $zero, End_main	# If the address is zero, something is wrong
	
	#Call your function to compute histogram
	# int histogram(unsigned char *image, int nrow, int ncol, int *h)
	add	$a0,  $s3, $zero 	#The first argument, the address of the array
	add	$a1,  $s1, $zero 	#The second argument, the number of the roles
	add	$a2,  $s2, $zero 	#The third argument, the number of the columns
	la	$a3,  hist_array
	jal	histogram

	add $s5, $v0, $zero

	#Call your function to print the histogram
	# void print_hist(int *h)
	la	$a0, hist_array
	jal	print_hist
	
End_main:
	addu    $ra, $zero, $s7  #restore $ra since the function calls another function
	jr      $ra
	add	$zero, $zero, $zero
	add	$zero, $zero, $zero
	
########## End of main function #########

##############################################
	.data
#Data segment starts here
file_prompt:
	.asciiz "Please enter a valid file name: "
newline:
	.asciiz ".\n"
file_name:
	.space	256
row_prompt:
	.asciiz "Number of rows: "
column_prompt:	
	.asciiz "Number of columns: "
add_msg:	
	.asciiz "Image address:	"
	.align 2
hist_array:
	.word	0:256			# We define 256 words for the histogram
##############################################

##########Begin read_image Function##########	
###### unsignched char *read_image(char *fname, int nrow, int ncol)
##### $a0 (fname): The name of the pgm file name
##### $a1 (nrow):  The number of rows
##### $a2 (ncol):  The number of columns in the image
##### $v0:	   memory address of the image
	.text
	.globl read_image
read_image:
	addu	$sp, $sp, -28	#We allocate three words
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a2, 12($sp)
	sw	$ra, 16($sp)
	
	add	$a1, $zero, $zero #O_RDONLY is 0
	add	$a2, $zero, $zero #This parameter does not really matter
	li	$v0, 13		#System call open
	syscall
	
	add	$t1, $v0, $zero
	slt	$t9, $zero, $t1	 #if $t1 < 0, the file is invalid
	beq	$t9, $zero, file_invalid
	
	sw	$v0, 0($sp)	#This is the file descriptor
	#Here the file is opened
	# Read the values to 
	lw	$a0, 0($sp)	#File descriptor
	la	$a1, image
	sw	$a1, 20($sp)	# We save the address to the stack
	lw	$a2, 12($sp)
	lw	$t1, 8($sp)
	mul	$a2, $a2, $t1	# nrow x ncol = total number of pixels
	sw	$a2, 24($sp)
	
	li	$v0, 14
	syscall
	#The first pixel value
	la	$a0, first_value_msg
	li	$v0, 4
	syscall

	lw	$a1, 20($sp)
	lbu	$a0, 0($a1)
	li	$v0, 1
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	#The last pixel value
	la	$a0, last_value_msg
	li	$v0, 4
	syscall

	lw	$a1, 20($sp)
	lw	$a2, 24($sp)
	addu	$a1, $a1, $a2
	lbu	$a0, -1($a1)
	li	$v0, 1
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	lw	$a0, 0($sp)	#File descriptor
	li	$v0, 16		#System call close 
	syscall
	
	lw	$v0, 20($sp)	#Restore the return address
	j	return_main


file_invalid:
	addi	$v0, $zero, 4
	la	$a0, invalid_file_msg
	syscall
	
	add	$v0, $zero, $zero
return_main:
	lw	$ra, 16($sp)
	addu	$sp, $sp, 28	#We restore the stack pointer
	
	jr 	$ra
	add	$zero, $zero, $zero
	add	$zero, $zero, $zero
########## End read_image function ##########

#############################################
	.data
invalid_file_msg:
	.asciiz	"Can not open the file for reading.\n"
first_value_msg:
	.asciiz "First pixel value: "
last_value_msg:
	.asciiz	"Last pixel value: "
#############################################


########## Begin print_hist Function ##########	
	.text
# void print_hist(int *h)
# Print out the 256 counts in the array (the histogram)
# $a3 store the *h	
	.globl	print_hist
print_hist:
    #You need to implement your function here
	add $t9, $zero, $a0    #save $a0
	add $t8, $zero, $v0    #save $v0
	add $t0, $zero, $zero  # int i = 0
	add $t1, $zero, $a3    # $t1 store the address of the array to be printed
	print_loop: slti $t2, $t0, 256
	            beqz $t2, exitp

				addi $v0, $zero, 4  # print_string syscall
                la $a0, space       # load address of the string
                syscall

				move $a0, $t0
				li $v0, 1
				syscall

				addi $v0, $zero, 4  # print_string syscall
                la $a0, colon       # load address of the string
                syscall

				sll $t2, $t0, 2
				add $t2, $t2, $t1
				lw  $t3, 0($t2) 
				li $v0, 1
                move $a0, $t3
                syscall
				addi $t0, $t0, 1
				j print_loop
    exitp: add $a0, $t9, $zero
	       add $v0, $t8, $zero
	       jr $ra
	.data
colon:
	.asciiz	": "
space: 
    .asciiz "\n"	
########### End print_hist Function ##########


########### Begin histogram Function #########
	.text
	.globl histogram
# int histogram(unsigned char *image, int nrow, int ncol, int *h)
# Compute the histogram of the image and save the results in h
# $a0, char *image
# $a1, int nrow
# $a2, int ncol
# $a3, int *h
histogram:
	# You need to implement your function here
	add $t0, $zero, $zero  # int i
	add $t1, $zero, $zero  # int j
	add $t2, $zero, $zero  # int k
	add $t3, $zero, $zero  # unsigned char *p
	add $t5, $zero, $zero
	add $t6, $zero, $zero

	loop:  slti $t4, $t0, 256  # if i < 256, $t4 = 1;else, $t4 = 0
	       beqz $t4, exit      # if i >= 256, go to exit
		   add $t4, $zero, $zero
		   sll $t4, $t0, 2     # 4i
		   add $t4, $t4, $a3   # point to the address of h[i]
		   sw  $zero, 0($t4)   # h[i] = 0
		   addi, $t0, $t0, 1   # i = i + 1
		   j loop

    exit:  add $t0, $zero, $zero   # reinitialize i
	       add $t3, $zero, $a0     # $t3 store the address of the image

	loop1: slt $t4, $t0, $a1
	       beqz $t4, exit1          # if i >= nrow, go to exit1
		   loop2: slt $t4, $t1, $a2
		          beqz $t4, exit2   # if j >= ncol, go to exit2
				  lbu $t5, 0($t3)   # $t5 = p
				  sll $t5, $t5, 2   # $t5 = 4image[i], 4p
				  add $t5, $t5, $a3 # $t5 = &h[image[i]], &h[p]
				  lw $t6, 0($t5)    # $t6 = h[image[i]], h[p]
				  addi $t6, $t6, 1  # h[p]++
				  sw $t6, 0($t5)
				  addi $t3, $t3, 1  # p++
				  addi $t2, $t2, 1  # k++
				  addi $t1, $t1, 1  # j++
				  j loop2
		   exit2: addi $t0, $t0, 1  # i++
		          add $t1, $zero, $zero
		          j loop1		          
	exit1: add $v0, $zero, $t2
	       jr  $ra		   	
	.data
	.align 2
image:	.space  250000
########## End histogram Function ##########