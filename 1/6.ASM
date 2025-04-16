format PE console
entry start

include 'D:\fasn\INCLUDE\win32a.inc'

section '.data' data readable writable
    arr dd 1, 4, 3, 6, 5, 2, 7, 8, 9, 10
    result_msg db "Product of odd elements: %d", 10, 0
    product dd 1
    input_fmt db "%d", 0

section '.code' code readable executable
start:
    xor ecx, ecx
    mov eax, 1              ; initial product

.loop:
    cmp ecx, 10
    jge .done

    mov ebx, [arr + ecx*4]
    test ebx, 1             ; check if odd
    jz .next

    imul eax, ebx           ; multiply if odd

.next:
    inc ecx
    jmp .loop

.done:
    push eax
    push result_msg
    call [printf]
    add esp, 8

    call [getchar]
    call [getchar]
    push 0
    call [ExitProcess]

section '.idata' import data readable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', getchar, 'getchar'
