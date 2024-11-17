# Assignment 2: Classify

## Part A

### Task 1:Relu
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

### Task 2:ArgMax
In `argmax.s`, like task 1, there are only three registers be set value before `loop_start`.`t0` and `t1` is the value and the index of the current largest integer, and `t2` is the index of the second number. For finding the maximum integer in array, 

The method of tracing all element in array is same as task 1. Point to `t2 >> 2 + a0` and load the value of the interger in array to `t4`. Then, compare the value with the number in `t0`. If the value of `t4` is greater than value of `t0`, this represent that the second interger is the current largest integer. Save index and value of the second integer to `t1` and `t0`. 

continue...