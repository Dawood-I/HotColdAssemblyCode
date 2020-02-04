# Computer Architecture Assignment 3
# Dawood Imran 100662594


# Variables
.data
	# String for printing code header, to skip a line, to prompt inputs.
	loadup: .asciiz "Hot or Cold\nDawood Imran 100662594\n\n"
	skipLine: .asciiz "\n"
	prompt: .asciiz "Max Range: "
	prompt2: .asciiz "Generator Seed: "
	prompt3: .asciiz "Guess Number: "
	prompt4: .asciiz "Very Hot"
	prompt5: .asciiz "Hot"
	prompt6: .asciiz "Cold"
	prompt7: .asciiz "Very Cold"
	perfect: .asciiz "Perfect"	

# Code
.text
.globl main

# Main function that prompts basic input and calls other methods
main:
	la $a0, loadup			# Header
	li $v0, 4				# Print string
	syscall
	        
    	la $a0, prompt       	# Max range input
		li $v0, 4             	# Print string
   	 syscall
         
    	li $v0,5             	# Reading int value into v0
	syscall
	move $s4, $v0 			# Storing max range from v0 into s4
	


	la $a0, prompt2        # Seed generator input									
	li $v0, 4    		   # Print string
	syscall				   # Gives us the random it would be better to grab the time instead of user input
         
	li $v0, 5              # Read int value into v0
	syscall  
	move $t3, $v0 		   # Storing seed value from v0 into t3

	jal rng 			   # Goes to label that gets the random number

	li.s $f9, 0.05		   # Loads float value 0.05 (5%) into f9
	mul.s $f8, $f10, $f9   # Multiplies random by 0.05 to get 5% stored in f8
	add.s $f7, $f8, $f10   # Random + 5% stored in f7 | adds 5% to random number and stores in f7
	sub.s $f6, $f10, $f8   # Random - 5% stored in f6 | subtracts 5% of random number from random number
	
	li.s $f9 0.25
	mul.s $f8, $f10, $f9   # Multiplies random by 0.25 to get 25% stored in f8
	add.s $f5, $f8, $f10   # Random + 25% stored in f5 | adds 25% to random number and stores in f7
	sub.s $f4, $f10, $f8   # Random - 25% stored in f4 | subtracts 25% of random number from random number
	
	li.s $f9 0.10
	mul.s $f8, $f10, $f9   # Multiplies random by 0.25 to get 10% stored in f8
	add.s $f3, $f8, $f10   # Random + 10% stored in f3 | adds 10% to random number and stores in f7
	sub.s $f2, $f10, $f8   # Random - 10% stored in f2 | subtracts 10% of random number from random number
	
	
test:
	jal inp			  	   # Jumps to inp label
	c.eq.s $f11, $f10 	   # Checks if = f11 = f10
	bc1t equal		  	   # If so calls equal label

	#else

	c.le.s $f11, $f5 	   # Checks to see if input is less than 125% random number
	bc1f verycold	 	   # Branch to cold label if 0
	bc1t true	 		   # Branch to true label if 1

	
equal:
	la $a0, skipLine	   # New line
	li $v0, 4			   # Print string
	syscall
	
	la $a0, perfect		   # Displays the value is correct
	li $v0, 4		  	   # Print String
	syscall
	jal fin			       # Goes to fin label that will exit program
	
	
true:
	la $a0, skipLine	  # New line
	li $v0, 4		      # Print string
	syscall

	c.le.s $f11, $f3	  # Checks if less than 110% random
	bc1f cold		 	  # If not then runs hot label
	bc1t next		 	  # If less then then runs cold label
	

next:
	la $a0, skipLine	  # New line
	li $v0, 4			  # Print string
	syscall

	c.le.s $f11, $f7	  # Checks if less than= 105% random
	bc1f hot			  # If not then runs hot label
	bc1t next1			  # If less then then runs cold label


next1:
	la $a0, skipLine	  # New line
	li $v0, 4		      # Print string
	syscall

	c.lt.s $f11, $f6	  # Checks if less than 95% random
	bc1f veryhot		  # If not then runs veryhot label
	bc1t next2		      # If less then then runs next2 label

next2:
	la $a0, skipLine	  # New line
	li $v0, 4		      # Print string
	syscall

	c.lt.s $f11, $f2	  # Checks if less than 90% random
	bc1f hot		      # If not then runs hot label
	bc1t next3		      # If so runs next3 label

next3:
	la $a0, skipLine	  # New line
	li $v0, 4		      # Print string
	syscall

	c.lt.s $f11, $f4	  # Checks if less than 75% random
	bc1f cold		      # If not then runs cold label
	bc1t verycold		  # If so runs very cold

veryhot:
	la $a0, prompt4		  # Displays the user is hot
	li $v0, 4			  # Print string
	syscall
	jal test			  # Returns back to test label
	
hot:
	la $a0, prompt5		  # Displays the user is hot
	li $v0, 4			  # Print string
	syscall
	jal test			  # Returns back to test label

	
cold:
	la $a0, prompt6		  # Prints cold prompt
	li $v0, 4
	syscall
	jal test		      # Reruns program so user can reguess

verycold:
	la $a0, prompt7		  # Prints verycold prompt
	li $v0, 4
	syscall
	jal test		      # Reruns program so user can reguess

	
inp:
	la $a0, skipLine	 	 # New line
	li $v0, 4            	 # Print string
	syscall
	la $a0, prompt3		 	 # User guesses a number
	li $v0, 4			 	 # Print string
	syscall
	li $v0, 5			 	 # Read integer provided by user
	syscall
	mtc1.d $v0, $f11	  	 # Moves int to float reg
	cvt.s.w $f11, $f11	  	 # Converts num to float
	jr $ra
	
fin:
	li $v0, 10		       	 # Exits the program
	syscall


