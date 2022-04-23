	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# random_in_range function
# Arguments: a0 = low, a1 = high
# Return value: $v0
#-------------------------------------------------------------------
random_in_range:
    # Add to stack
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $s0,0($sp)		# Save $s0
	addi $sp,$sp,-4		# Adjust stack pointer
	sw $s1,0($sp)		# Save $s1
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $ra,0($sp)		# Save $ra

    # Variable mapping:
    # s0 = range
    # s1 = rand_num
    
    # uint32_t range = high-low+1;
    sub $t0, $a1, $a0   # t0 = high - low
    addi $s0, $t0, 1    # range = high - low + 1

    # uint32_t rand_num = get_random();

    # Before calling get_random(), save $a0 = low onto the stack.
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $a0,0($sp)		# Save $s0

    jal get_random      # Call the get_random function

    # Pop $a0 = low from the stack
    lw $a0,0($sp)		# Restore $a0
	addi $sp,$sp,4		# Adjust stack pointer

    move $s1, $v0       # rand_num = get_random();

    # return (rand_num % range) + low
    divu $s1, $s0        # hi = rand_num % range
    mfhi $t0            # t0 = rand_num % range
    addu $v0, $t0, $a0   # Save (rand_num % range) + low in v0.

    # Pop from stack
    lw $ra,0($sp)		# Restore $ra
	addi $sp,$sp,4		# Adjust stack pointer
    lw $s1,0($sp)		# Restore $s1
	addi $sp,$sp,4		# Adjust stack pointer
	lw $s0,0($sp)		# Restore $s0
	addi $sp,$sp,4		# Adjust stack pointer

    # Return from function
    jr $ra

# get_random function
# Arguments: None
# Return value: $v0
#-------------------------------------------------------------------
get_random:
    # Add to stack
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $s0,0($sp)		# Save $s0
	addi $sp,$sp,-4		# Adjust stack pointer
	sw $s1,0($sp)		# Save $s1
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $s2,0($sp)		# Save $s2
	addi $sp,$sp,-4		# Adjust stack pointer
	sw $s3,0($sp)		# Save $s3
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $s4,0($sp)		# Save $s4

    # Initialize variables
    la $s0, m_z     # s0 = address of m_z
    la $s1, m_w     # s1 = address of m_w
    lw $s2, 0($s0)  # s2 = m_z
    lw $s3, 0($s1)  # s3 = m_w
    li $s4, 0       # s4 = result

    # m_z = 36969 * (m_z & 65535) + (m_z >> 16);
    li $t0, 65535       # t0 = 65535
    and $t0, $s2, $t0   # t0 = m_z & 65535
    li $t1, 36969       # t1 = 36969
    mul $t0, $t1, $t0   # t0 = 36969 * (m_z & 65535)
    srl $t1, $s2, 16    # t1 = m_z >> 16
    addu $s2, $t0, $t1   # m_z = 36969 * (m_z & 65535) + (m_z >> 16)
    sw $s2, 0($s0)      # Store m_z in memory

    # m_w = 36969 * (m_w & 65535) + (m_w >> 16);
    li $t0, 65535       # t0 = 65535
    and $t0, $s3, $t0   # t0 = m_w & 65535
    li $t1, 18000       # t1 = 18000
    mul $t0, $t1, $t0   # t0 = 18000 * (m_w & 65535)
    srl $t1, $s3, 16    # t1 = m_w >> 16
    addu $s3, $t0, $t1   # m_w = 18000 * (m_w & 65535) + (m_w >> 16)
    sw $s3, 0($s1)      # Store m_w in memory

    # result = (m_z << 16) + m_w
    sll $t0, $s2, 16    # t0 = m_z << 16
    addu $s4, $t0, $s3   # result = (m_z << 16) + m_w
    move $v0, $s4       # save result in v0

    # Pop from stack
    lw $s4,0($sp)		# Restore $s4
	addi $sp,$sp,4		# Adjust stack pointer
    lw $s3,0($sp)		# Restore $s3
	addi $sp,$sp,4		# Adjust stack pointer
	lw $s2,0($sp)		# Restore $s2
	addi $sp,$sp,4		# Adjust stack pointer
    lw $s1,0($sp)		# Restore $s1
	addi $sp,$sp,4		# Adjust stack pointer
	lw $s0,0($sp)		# Restore $s0
	addi $sp,$sp,4		# Adjust stack pointer

    # Return from function
    jr $ra              # Jump to address stored in $ra

# Main function
#-------------------------------------------------------------------
main:
	# Initialize variables
	# s0 = n1
	# s1 = n2
	# s2 = i
	li $s0, 0   # Set $s0, which represents n1, to 0.
	li $s1, 0   # Set $s1, which represents n2, to 0.
	li $s2, 0   # Set $s2, which represents i, to 0.

    # FOR LOOP
    FOR_START:
        li $t0, 10               # t0 = 10
        bge $s2, $t0, FOR_END    # exit for loop if i < 10 does not hold.

        # n1 = random_in_range(1, 10000)
        li $a0, 1           # low = 1
        li $a1, 10000       # high = 10000
        jal random_in_range # Call random_in_range(1, 10000)
        move $s0, $v0       # n1 = random_in_range(1, 10000)

        # n2 = random_in_range(1, 10000)
        li $a0, 1           # low = 1
        li $a1, 10000       # high = 10000
        jal random_in_range # Call random_in_range(1, 10000)
        move $s1, $v0       # n2 = random_in_range(1, 10000)

        # printf("\n G.C.D of %u and %u is %u.", n1, n2, gcd(n1,n2));
        
        # t0 = gcd(n1, n2)
        move $a0, $s0       # n1 = n1
        move $a1, $s1       # n2 = n2
        jal gcd             # call gcd function
        move $t0, $v0       # t0 = gcd(n1, n2)

        # Print "\n G.C.D of "
        la $a0, msg1	# Load msg1 for print
		li $v0, 4		# Select syscall for print_string
		syscall			# Print "\n G.C.D of "

        # Print n1
        move $a0, $s0	# Load n1 for print
		li $v0, 1		# Select syscall for print_int
		syscall			# Print n1

        # Print " and "
        la $a0, msg2	# Load msg2 for print
		li $v0, 4		# Select syscall for print_string
		syscall			# Print " and "
        
        # Print n2
        move $a0, $s1	# Load n2 for print
		li $v0, 1		# Select syscall for print_int
		syscall			# Print n2

        # Print " is "
        la $a0, msg3	# Load msg3 for print
		li $v0, 4		# Select syscall for print_string
		syscall			# Print " is "

        # Print gcd(n1, n2)
        move $a0, $t0	# Load gcd(n1, n2) for print
		li $v0, 1		# Select syscall for print_int
		syscall			# Print gcd(n1, n2)

        # Print "."
        la $a0, msg4	# Load msg4 for print
		li $v0, 4		# Select syscall for print_string
		syscall			# Print "."        

        addi $s2, $s2, 1    # i++
        j FOR_START
    FOR_END:

	li $v0, 10  # Sets $v0 to "10" to select exit syscall
	syscall     # Exit

# gcd function
# Arguments: a0 = n1, a1 = n2
# Return value: $v0
#-------------------------------------------------------------------
gcd:
    # Add to stack
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $ra,0($sp)		# Save $ra

    # if (n2 != 0)
    beq $a1, $zero, ELSE    # n2 == 0, jump to ELSE
    j IF                    # n2 != 0, jump to IF

    IF:
        move $t0, $a1       # t0 = n2
        divu $a0, $a1       # hi = n1 % n2

        # Populate variables for gcd(n2, n1 % n2)
        move $a0, $t0       # a0 = n1 = n2
        mfhi $a1            # a1 = hi = n1 % n2
        jal gcd             # Call gcd(n2, n1 % n2)

        # we're returning the result of the function call, so no need to set $v0 again.
        j ENDIF
    ELSE:
        move $v0, $a0       # save n1 as return value       
        j ENDIF
    ENDIF:

    # Pop from stack
    lw $ra,0($sp)		# Restore $ra
	addi $sp,$sp,4		# Adjust stack pointer

    # Return from function
    jr $ra

# Data section
#-------------------------------------------------------------------
	.data # Mark the start of the data section

	m_w: .word 50000    # Initialize m_w = 50000
    m_z: .word 60000    # Initialize m_z = 60000
    msg1: .asciiz "\n G.C.D of "
	msg2: .asciiz " and "
	msg3: .asciiz " is "
    msg4: .asciiz "."