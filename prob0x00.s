.data

sourceMat: .space 1600
destinationMat: .space 1600

m: .long 0
n: .long 0
p: .long 0
k: .long 0 

rowSize: .long 0
colSize: .long 0

i: .long 0
j: .long 0

textScanf: .asciz "%ld"
texPrintf: .asciz "%ld "
newLine: .asciz "\n"

.text

init_urmator_pas:

    popl %edi
    popl %esi

    movl $0, %ebx
    movl $0, %ecx
    addl $1, rowSize
    addl $1, colSize

    for_loop_i_pas:
    cmp %ebx, rowSize
    je for_loop_i_pas_exit
        mov $0, %ecx
        for_loop_j_pas:
        cmp %ecx, colSize
        je for_loop_j_pas_exit
        movl rowSize, %eax
        imull %ebx
        addl %ecx, %eax
        mov $0, (%esi,%eax,4)
        incl %ecx
        jmp for_loop_j_pas
        for_loop_j_pas_exit
    incl %ebx
    jmp for_loop_i_pas
    for_loop_i_pas_exit

    movl $1, %ebx
    movl $1, %ecx
    subl $1, rowSize
    subl $1, colSize

    for_loop_i_init:
    cmp %ebx, rowSize
    je for_loop_i_init_exit

        mov $1, %ecx
        for_loop_j_init:
        cmp %ecx, colSize
        je for_loop_j_exit

        movl %ebx, %eax
        imull rowSize
        addl %ecx, %eax

        mov  (%edi, %eax, 4), %edx
        mov %edx, (%esi, %eax, 4)

        incl %ecx
        jmp for_loop_j_init
        for_loop_j_init_exit
    incl %ebx
    jmp for_loop_i_init
    for_loop_i_init_exit:

    pushl %esi
    pushl %edi

ret

calcul_pas:
    
    popl %edi
    popl %esi

    movl $1 , %ebx
    for_loop_i:
        cmp %ebx, rowSize
        je for_loop_i_exit

        movl $1, %ecx
        for_loop_j:
        cmp  %ecx, colSize
        je for_loop_j_exit

            movl %ebx, %eax
            imul rowSize
            addl %ecx, %eax

            xor %edx, %edx

            pushl %ebx
            pushl %ecx

            
            movl $1, %ecx
            cmp %ecx, -4(%esi, %eax,4)
            jne next1
            incl %edx
            next1:

            cmp %ecx, 4(%esi, %eax,4)
            jne next2
            incl %edx
            next2:

            subl rowSize, %eax
            cmp %ecx, (%esi, %eax,4)
            jne next3
            incl %edx
            next3:

            addl rowSize, %eax
            addl rowSize, %eax
            cmp %ecx, (%esi, %eax,4)
            jne next4
            incl %edx
            next4:
            subl rowSize, %eax

            movl (%esi,%eax,4), %ebx
            cmp %ebx, %ecx
            je is_one
            // zero
            cmp %edx, val_three
            jne nnnext:

            movl $1, (%edi, %eax, 4)

            jmp for_end
            nnnext:

            movl $0, (%edi, %eax, 4)

            jmp for_end
            is_one:
            // one
            cmp %edx,val_two
            jge nnext1
            movl $0, (%edi, %eax, 4)
            jmp for_end
            nnext1:

            cmp %edx,val_four
            jge nnext2
            movl $1, (%edi, %eax, 4)
            jmp for_end
            nnext2:

            movl $0, (%edi, %eax, 4)

            for_end:
            popl %ecx
            popl %ebx
            incl %ecx
        jmp for_loop_j
        for_loop_j_exit:
    incl %ebx
    jmp for_loop_i
    for_loop_i_exit:
    
    pushl %esi
    pushl %edi

ret

afisare_matrice:

popl %esi

movl $1, %ebx
movl $1, %ecx

for_loop_i_print:
cmp %ebx, rowSize
je for_loop_i_print_exit
    mov $1, %ecx
    for_loop_j_print:
    cmp %ecx, colSize
    je for_loop_j_print_exit

    //cod de afisare
    mov %ebx, %eax
    imull rowSize
    addl %ecx, %eax

    pushl %eax
    pushl %ecx
    
    pushl (%esi, %eax, 4 )
    pushl $texPrintf

    call printf

    popl %edx
    popl %edx

    popl %ecx
    popl %eax

    pushl %eax
    pushl %ecx

    pushl $0

    call fflush

    popl %edx
    popl %ecx
    popl %eax

    incl %ecx
    jmp for_loop_j_print
    for_loop_j_print_exit:

// cod new line

pushl %ecx
pushl %eax
pushl $newLine

call printf

popl %edx
popl %eax
popl %ecx

incl %ebx
jmp for_loop_i_print
for_loop_i_print_exit:

pushl %esi

ret

.global main
main:

lea sourceMat, %esi
lea destinationMat, $edi

citire_input:

    pushl $m
    pushl $textScanf
    call scanf
    popl %edx
    popl %edx

    pushl $n
    pushl $textScanf
    call scanf
    popl %edx
    popl %edx

    pushl $p
    pushl $textScanf
    call scanf
    popl %edx
    popl %edx

    movl m, %eax
    addl 2, %eax
    movl %eax, rowSize

    movl n, %eax
    addl 2, %eax
    movl %eax, colSize

    movl $0, %ebx

    cels_input:
    cmp %ebx, p
    je cels_input_exit

    pushl $i
    pushl $textScanf
    call scanf
    popl %edx
    popl %edx

    pushl $j
    pushl $textScanf
    call scanf
    popl %edx
    popl %edx

    xorl %eax, %eax
    movl i, %eax
    incl %eax
    imul rowSize
    addl j, %eax
    incl %eax

    movl $1, (%esi, %eax, 4)

    incl %ebx

    jmp cels_input
    cels_input_exit:

    pushl $k
    pushl $textScanf
    call scanf
    popl %edx
    popl %edx

mov $0, %ebx
procesare_pasi:
    cmp %ebx, k
    je procesare_pasi_exit

    pushl %esi
    pushl %edi

    call calcul_pas

    popl %edx
    popl %edx

    pushl %esi
    pushl %edi

    call init_urmator_pas

    popl %edx
    popl %edx


jmp procesare_pasi
procesare_pasi_exit:

afisare_rezultat:

pushl %esi

call afisare_matrice

popl %esi

exit:
    mov $1 , %eax
    xor %ebx, %ebx
    int 0x80

