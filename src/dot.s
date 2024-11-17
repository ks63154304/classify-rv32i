.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    mv a5, t1 # Call booth_mul funtion to calculate i * stride0
    mv a6, a3
    mv t5, ra # Store caller ra to t5
    jal ra, booth_mul
    mv ra, t5
    slli t2, a6, 2 # Point to the address of the current integer in first input array

    mv a6, a4 # Call booth_mul funtion to calculate i * stride1
    mv t5, ra
    jal ra, booth_mul
    mv ra, t5
    slli t3, a6, 2 # Point to the address of the current integer in second input array

    add t2, t2, a0 # Load current integer of first input array to t2
    lw a5, 0(t2)

    add t3, t3, a1 # Load current integer of second input array to t3
    lw a6, 0(t3)

    mv t5, ra 
    jal ra, booth_mul # Call booth_mul funtion to calculate arr0[i * stride0] * arr1[i * stride1]
    mv ra, t5  

    add t0, t0, a6 # sum the 
    addi t1, t1, 1
    j loop_start

# Booth's Algorithm
# Args:
#   a5: multiplicand
#   a6: multiplier
# Returns:
#   a6: product

booth_mul:
    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw a5, 24(sp)

    ori s0, a5, 0
    beq s0, x0, skip_mul
    ori s0, a6, 0
    beq s0, x0, skip_mul

    li s0, 0
    li s1, 16
    slli s2, a5, 16
    li s4, 0xffff
    and a6, a6, s4

loop_mul:
    beq s1, x0, loop_mul_end
    andi s3, a6, 0x1
    xor s4, s3, s0
    beq s4, x0, skip_operation
    beq s0, x0, sub_multiplicand
    add a6, a6, s2
    j skip_operation

sub_multiplicand:
    sub a6, a6, s2

skip_operation:
    mv s0, s3
    addi s1, s1, -1
    srai a6, a6, 1
    j loop_mul

skip_mul:
    mv a6, s0

loop_mul_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw a5, 24(sp)
    addi sp, sp, 28
    jr ra


loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
