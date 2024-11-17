.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    beq t1, a1, loop_end   # If all integers are traced, end loop
    slli t0, t1, 2         # Point to the address of next integer
    add t3, t0, a0         # Load next integer to t2
    lw t2, 0(t3)
    bge t2, x0, skip       # If t2 is larger than 0, skip next step
    sw x0, 0(t3)           # Store zero to the address of current integer

skip:
    addi t1, t1, 1         # Load the index of next integer to t1
    j loop_start

loop_end:
    jr ra
    

error:
    li a0, 36          
    j exit          
