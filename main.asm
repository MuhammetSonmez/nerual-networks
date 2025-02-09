extern printf
extern exp
extern fabs
SECTION .data
    fmt_round db "rounded result: %d", 10, 0
    fmt_result db "result: [%lf]", 10, 0
    fmt_alert  db "rounded result: %d" , 10, "result: [%lf]", 10, 0
    x_input dq 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0
    y_output dq 0.0, 1.0, 1.0
    training_steps dq 300
    zero dq 0.0
SECTION .bss
    weight resq 3
    node_value resq 3
    predict resq 3
    error resq 3
    d_temp resq 3
    mult_temp resq 9
    diag_temp resq 3
    x_input_T resq 9
    my_input resq 3
    ask_result resq 1
SECTION .text
    global main
eexp:
    push rbp
    mov rbp, rsp
    cmp rdi, 0
    jne .use_terms
    mov rdi, 10
.use_terms:
    mov rcx, 1
    fld1
    fstp qword [rbp-16]
    fld1
    fstp qword [rbp-24]
.eexp_loop:
    cmp rcx, rdi
    jg .eexp_done
    fld qword [rbp-24]
    fild qword [rcx]
    fmulp st1, st0
    fstp qword [rbp-24]
    movsd qword [rbp-40], xmm0
    mov r8, rcx
    fld1
.power_loop:
    cmp r8, 0
    je .power_done
    fld qword [rbp-40]
    fmul st1, st0
    add r8, -1
    jmp .power_loop
.power_done:
    fld qword [rbp-24]
    fdivp st1, st0
    fld qword [rbp-16]
    faddp st1, st0
    fstp qword [rbp-16]
    inc rcx
    jmp .eexp_loop
.eexp_done:
    fld qword [rbp-16]
    mov rsp, rbp
    pop rbp
    ret
sigmoid:
    push rbp
    mov rbp, rsp
    movsd xmm1, xmm0
    movsd xmm0, qword [minus_one]
    mulsd xmm0, xmm1
    call exp
    movsd xmm1, qword [one]
    addsd xmm0, xmm1
    movsd xmm1, qword [one]
    divsd xmm1, xmm0
    movsd xmm0, xmm1
    mov rsp, rbp
    pop rbp
    ret
SECTION .data
one:       dq 1.0
minus_one: dq -1.0
SECTION .text
derivedSigmoid:
    push rbp
    mov rbp, rsp
    mov rsi, rdi
    xor rbx, rbx
.derivedSigmoid_loop:
    cmp rbx, 3
    jge .derivedSigmoid_done
    fld qword [rsi + rbx*8]
    fld st0
    fsubr qword [one]
    fmulp st1, st0
    fstp qword [d_temp + rbx*8]
    inc rbx
    jmp .derivedSigmoid_loop
.derivedSigmoid_done:
    mov rax, d_temp
    mov rsp, rbp
    pop rbp
    ret
getDim:
    push rbp
    mov rbp, rsp
    mov rax, 3
    mov rsp, rbp
    pop rbp
    ret
mean:
    push rbp
    mov rbp, rsp
    mov rsi, rdi
    fldz
    mov rcx, 3
    xor rbx, rbx
.mean_loop:
    cmp rbx, rcx
    jge .mean_divide
    fld qword [rsi + rbx*8]
    faddp st1, st0
    inc rbx
    jmp .mean_loop
.mean_divide:
    fld qword [three]
    fdivp st1, st0
    mov rsp, rbp
    pop rbp
    ret
three:    dq 3.0
multiply:
    push rbp
    mov rbp, rsp
    cmp rdx, 0
    je .case_3x3
    xor rbx, rbx
    fldz
.case_1_loop:
    cmp rbx, 3
    jge .case_1_done
    fld qword [rdi + rbx*8]
    fld qword [rsi + rbx*8]
    fmul st0, st1
    faddp st1, st0
    inc rbx
    jmp .case_1_loop
.case_1_done:
    fstp qword [r8]
    jmp .multiply_done
.case_3x3:
    xor rbx, rbx
.case_3x3_row:
    cmp rbx, 3
    jge .multiply_done
    fldz
    mov rcx, 3
    xor r8d, r8d
.case_3x3_inner:
    cmp r8, rcx
    jge .case_3x3_store
    mov r9, rbx
    imul r9, 3
    add r9, r8
    fld qword [rdi + r9*8]
    fld qword [rsi + r8*8]
    fmul st0, st1
    faddp st1, st0
    inc r8
    jmp .case_3x3_inner
.case_3x3_store:
    fstp qword [r8 + rbx*8]
    inc rbx
    jmp .case_3x3_row
.multiply_done:
    mov rsp, rbp
    pop rbp
    ret
add:
    push rbp
    mov rbp, rsp
    xor rbx, rbx
.add_loop:
    cmp rbx, 3
    jge .add_done
    fld qword [rdi + rbx*8]
    fld qword [rsi + rbx*8]
    faddp st1, st0
    fstp qword [rdx + rbx*8]
    inc rbx
    jmp .add_loop
.add_done:
    mov rsp, rbp
    pop rbp
    ret
getDiagonal:
    push rbp
    mov rbp, rsp
    mov rbx, 0
.diag_loop:
    cmp rbx, 3
    jge .diag_done
    mov r8, rbx
    imul r8, 3
    add r8, rbx
    fld qword [rdi + r8*8]
    fstp qword [rdx + rbx*8]
    inc rbx
    jmp .diag_loop
.diag_done:
    mov rsp, rbp
    pop rbp
    ret
addNumber:
    push rbp
    mov rbp, rsp
    xor rbx, rbx
.addNumber_loop:
    cmp rbx, 3
    jge .addNumber_done
    fld qword [rdi + rbx*8]
    movsd qword [rbp-8], xmm0
    fadd qword [rbp-8]
    fstp qword [rdx + rbx*8]
    inc rbx
    jmp .addNumber_loop
.addNumber_done:
    mov rsp, rbp
    pop rbp
    ret
generateI:
    push rbp
    mov rbp, rsp
    mov rsi, 0
.identity_row:
    cmp rsi, 3
    jge .id_done
    mov rbx, 0
.identity_col:
    cmp rbx, 3
    jge .next_row

    mov rax, rsi
    shl rax, 1
    add rax, rsi
    add rax, rbx
    shl rax, 3

    mov qword [rdi + rax], 0

    inc rbx
    jmp .identity_col

.next_row:
    inc rsi
    jmp .identity_row
.id_done:
    mov rsi, 0
.diag_set:
    cmp rsi, 3
    jge .genI_done

    mov rax, rsi
    shl rax, 1
    add rax, rsi
    add rax, rsi
    shl rax, 3

    mov qword [rdi + rax], one

    inc rsi
    jmp .diag_set

.genI_done:
    mov rsp, rbp
    pop rbp
    ret
divide:
    push rbp
    mov rbp, rsp
    xor rbx, rbx
.divide_loop:
    cmp rbx, 3
    jge .divide_done
    fld qword [rdi + rbx*8]
    movsd qword [rbp-8], xmm0
    fld qword [rbp-8]
    fdivp st1, st0
    fstp qword [rdx + rbx*8]
    inc rbx
    jmp .divide_loop
.divide_done:
    mov rsp, rbp
    pop rbp
    ret
negative:
    push rbp
    mov rbp, rsp
    xor rbx, rbx
.neg_loop:
    cmp rbx, 3
    jge .neg_done
    fld qword [rdi + rbx*8]
    fchs
    fstp qword [rdx + rbx*8]
    inc rbx
    jmp .neg_loop
.neg_done:
    mov rsp, rbp
    pop rbp
    ret
transpose:
    push rbp
    mov rbp, rsp
    cmp rdx, 0
    je .trans_3x1_to_1x3
    mov rcx, 3
    xor rbx, rbx
.trans_1x3_loop:
    cmp rbx, rcx
    jge .trans_done
    fld qword [rdi + rbx*8]
    fstp qword [r8 + rbx*8]
    inc rbx
    jmp .trans_1x3_loop
.trans_done:
    jmp .transpose_exit
.trans_3x1_to_1x3:
    mov rcx, 3
    xor rbx, rbx
.trans_3x1_loop:
    cmp rbx, rcx
    jge .transpose_exit
    fld qword [rdi + rbx*8]
    fstp qword [r8 + rbx*8]
    inc rbx
    jmp .trans_3x1_loop
.transpose_exit:
    mov rsp, rbp
    pop rbp
    ret
exp_matrix:
    push rbp
    mov rbp, rsp
    xor rbx, rbx
.exp_loop:
    cmp rbx, 3
    jge .exp_done
    fld qword [rdi + rbx*8]
    sub rsp, 8
    fst qword [rsp]
    call exp
    add rsp, 8
    fstp qword [rdx + rbx*8]
    inc rbx
    jmp .exp_loop
.exp_done:
    mov rsp, rbp
    pop rbp
    ret
training:
    push rbp
    mov rbp, rsp
    mov rbx, 0
.train_init:
    cmp rbx, 3
    jge .train_loop_start
    mov qword [weight + rbx*8], one
    inc rbx
    jmp .train_init
.train_loop_start:
    mov r8, [training_steps]
    xor r9, r9
.train_loop:
    cmp r9, r8
    jge .train_done
    mov rdi, x_input
    mov rsi, weight
    mov rdx, 0
    lea r8, [node_value]
    call multiply
    lea rdi, [node_value]
    lea rsi, [mult_temp]
    call negative
    lea rdi, [mult_temp]
    lea rsi, [predict]
    call exp_matrix
    movsd xmm0, qword [one]
    lea rdi, [predict]
    lea rdx, [predict]
    call addNumber
    movsd xmm0, qword [one]
    lea rdi, [predict]
    lea rdx, [predict]
    call divide
    lea rdi, [predict]
    mov rdx, 0
    lea r8, [mult_temp]
    call transpose
    mov rdi, r8
    call derivedSigmoid
    lea rdi, [predict]
    lea rdx, [mult_temp]
    call negative
    lea rdi, [y_output]
    mov rsi, rdx
    lea rdx, [error]
    call add
    lea rdi, [error]
    lea rsi, [d_temp]
    mov rdx, 1
    lea r8, [mult_temp]
    call multiply
    lea rdi, [mult_temp]
    lea rdx, [diag_temp]
    call getDiagonal
    lea rdi, [x_input]
    mov rdx, 0
    lea r8, [x_input_T]
    call transpose
    lea rdi, [x_input_T]
    lea rsi, [diag_temp]
    mov rdx, 0
    lea r8, [mult_temp]
    call multiply
    lea rdi, [weight]
    lea rsi, [mult_temp]
    lea rdx, [weight]
    call add
    lea rdi, [error]
    call mean
    fstp qword [rbp-8]
    movsd xmm0, qword [rbp-8]
    call fabs
    inc r9
    jmp .train_loop
.train_done:
    lea rax, [weight]
    mov rsp, rbp
    pop rbp
    ret
ask:
    push rbp
    mov rbp, rsp
    lea rdi, [my_input]
    lea rsi, [weight]
    mov rdx, 0x1
    lea r8, [mult_temp]
    call multiply
    lea rdi, [mult_temp]
    lea rdx, [mult_temp]
    call negative
    lea rdi, [mult_temp]
    lea rsi, [mult_temp]
    call exp_matrix
    movsd xmm0, qword [one]
    lea rdi, [mult_temp]
    lea rdx, [mult_temp]
    call addNumber
    movsd xmm0, qword [one]
    lea rdi, [mult_temp]
    lea rdx, [ask_result]
    call divide
    mov rsp, rbp
    pop rbp
    ret
main:
    push rbp
    mov rbp, rsp

    movsd xmm0, qword [one]
    mov rdi, 10
    call eexp
    fstp qword [rbp-8]

    mov rdi, [training_steps]
    call training

    movsd xmm0, qword [one]
    movsd qword [my_input], xmm0
    movsd xmm0, qword [zero]
    movsd qword [my_input+8], xmm0
    movsd qword [my_input+16], xmm0

    lea rdi, [my_input]
    lea rsi, [weight]
    call ask

    movsd xmm0, qword [ask_result]
    movsd qword [rbp-8], xmm0
    mov rsi, qword [rbp-8]

    mov rdi, fmt_round
    xor rax, rax
    call printf

    movsd xmm0, qword [ask_result]
    mov rdi, fmt_result
    movsd qword [rbp-8], xmm0
    mov rsi, qword [rbp-8]
    xor rax, rax
    call printf

    movsd xmm0, qword [ask_result]
    cvttsd2si rax, xmm0
    mov rdi, fmt_alert
    mov rsi, rax

    movsd xmm2, qword [ask_result]
    movsd qword [rbp-16], xmm2
    mov rdx, qword [rbp-16]

    xor rax, rax
    call printf

    mov rdi, 0
    call exit

extern exit
