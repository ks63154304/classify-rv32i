# Assignment 2: Classify


## Part A

### Task 1: Relu
In `relu.s`, there is only one register be set value before `loop_start`. This means we only can use these register to count the step of the loop. Consequently, I use `t1` as the counter of the loop because the initial number of `t1` is 0. Then, `t1` can also be regarded as the index of the array to be modified.`index * 4 + start address` is the address of `array[index]`.
```
    slli t0, t1, 2         # Point to the address of next number
    add t3, t0, a0         # Load next number to t2
    lw t2, 0(t3)
```
As the above instruction show, `a0` is the Pointer to the array and `t1` is the index of the number currently  accessed in array. Pointing to address `t1 >> 2 + a0` can load the number of the index `t1` in array. `t1` will be incremented after every cycle until `t1` is equal to number of elements in array`a1`. After knowing how to load all intergers in array, checking whether these intergers are less than 0 is the last step of Task 1.

```
    lw t2, 0(t3)
    bge t2, x0, skip       # If t2 is larger than 0, skip next step
    sw x0, 0(t3)           # Store zero to the address of current number

skip:
    addi t1, t1, 1         # Load the index of next number to t1
```
If the integer is greater than 0, do nothing, or save 0 to the same address.

### Task 2: ArgMax
In `argmax.s`, like task 1, there are only three registers be set value before `loop_start`.`t0` and `t1` is the value and the index of the current largest integer, and `t2` is the index of the second number. For finding the maximum integer in array, we can compare `arr[0]` with `arr[1]` and save the larger one to register in the first iteration. In next iteration, compare the next integer `arr[2]` in array with the integer in register and also save the larger one to register. Repeat it until comparing all integer.Then, the lagerest integer is saved to register in the end. 

```
loop_start:
    beq t2, a1, loop_end # If all integers are traced, end loop
    slli t3, t2, 2
    add t3, t3, a0       # Load the second integer to t4
    lw t4, 0(t3)
    blt t4, t0, skip     # If the second integer is great than the current largest integer, save index and value of the second integer to register
    mv t1, t2           
    mv t0, t4

skip:
    addi t2, t2, 1       # Load next index of the second integer to t2
    j loop_start

loop_end:
    mv a0, t1
    jr ra
```

The method of tracing all element in array is same as task 1. Point to `t2 >> 2 + a0` and load the value of the interger in array to `t4`. Then, compare the value with the number in `t0`. If the value of `t4` is greater than value of `t0`, this represent that the second interger is the current largest integer. Save index and value of the second integer to `t1` and `t0`. Repeat these steps until all integers are traced.Then, move t1 to a0 to return the index of the largest integer in the array.

### Task 3.1: Dot Product
In `dot.s`, I need to implement matrix multiplication, but M extension instructions are not permitted.I have to implement multiple with the basic instruction. Therefore, I choose Booth's multiplication algorithm as the basis of my multiple instruction. 

### Task 3.2: Matrix Multiplication
In `matmul.s`, we only deal with the rest of outer loop between inner loop end and enter the next iteration of outer loop. the first instruction `addi s0, s0, 1` is incrementing `s0` beacause `s0` is outer loop counter. Then, the second and third instruction is incrementing `s3` with the column count on Matrix A. `s3` is the pointer of matrix A as the argument for `dot` funtion. When ending the inner loop every time, need to give a new address of matrix A to do the next `dot` funtion.The new address is the start address of the next row on matrix A. Hence, s3 should be replaced with the start address of the next row when inner loop end. 
```
inner_loop_end:
    addi s0, s0, 1 # incrementing outer loop counter
    slli t1 , a2, 2 # incrementing the column count on Matrix A to s3 
    add s3, s3, t1 
    j outer_loop_start
```