format PE console
entry start

include 'D:\fasn\INCLUDE\win32a.inc'

section '.data' data readable writable
    arr dd -2, -5, 3, 7, -8, -9, 4, 6, -1, 0
    count dd 0
    result_msg db "Same sign neighbor pairs: %d", 10, 0

section '.code' code readable executable
start:
    xor ecx, ecx
    xor eax, eax           ; count

.loop:
    cmp ecx, 9
    jge .done

    mov ebx, [arr + ecx*4]
    mov edx, [arr + ecx*4 + 4]

    test ebx, ebx
    jz .skip
    test edx, edx
    jz .skip

    ; check sign
    mov esi, ebx
    imul esi, edx
    js .skip               ; if negative, signs differ

    inc eax

.skip:
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
