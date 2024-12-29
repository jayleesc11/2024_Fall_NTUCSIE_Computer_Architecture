.globl __start

.text
__start:
    # Read int n (in a0)
    li a0, 5
    ecall
    
    # Recurrence
    call T_recur
    
    # Output the result (in a1)
    li a0, 1
    ecall
    
    # Exit program(necessary)
    li a0, 10
    ecall
    
T_recur:
    addi sp, sp, -12
    sw ra, 4(sp)
    sw a0, 0(sp)
    addi t0, zero, 2        # t0 = 2
    bge a0, t0, n_else      # n >= 2
    beqz a0, n_zero
    li a1 1                 # T(1)=1
    addi sp, sp, 12
    ret
    
n_zero:
    li a1 0                 # T(0)=0
    addi sp, sp, 12
    ret
    
n_else:
    lw t1, 0(sp)            # load n
    addi a0, t1, -1
    call T_recur            # T(n-1)
    sw a1, 8(sp)            # store T(n-1)
    lw t1, 0(sp)            # load n
    addi a0, t1, -2
    call T_recur            # T(n-2)
    mv t3, a1
    lw a0, 0(sp)
    lw ra, 4(sp)
    lw t2, 8(sp)            # load T(n-1)
    addi sp, sp, 12
    add a1, t2, t2          # 2T(n-1)
    add a1, a1, t3          # 2T(n-1) + T(n-2)
    ret