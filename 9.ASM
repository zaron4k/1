format PE console
entry start

include 'D:\fasn\INCLUDE\win32a.inc'

section '.data' data readable writable
    arr dd 5, 3, 7, 9, 1, 4, 6, 2, 3, 8
    result_msg db "Duplicate element found: %d", 10, 0

section '.code' code readable executable
start:
    xor ecx, ecx

.outer_loop:
    cmp ecx, 9
    jge .not_found

    mov eax, [arr + ecx*4]
    mov esi, ecx
    inc esi

.inner_loop:
    cmp esi, 10
    jge .next_outer
    cmp eax, [arr + esi*4]
    je .found
    inc esi
    jmp .inner_loop

.next_outer:
    inc ecx
    jmp .outer_loop

.found:
    push eax
    push result_msg
    call [printf]
    add esp, 8
    jmp .exit

.not_found:
    ; optional: message if not found
    jmp .exit

.exit:
    call [getchar]
    call [getchar]
    push 0
    call [ExitProcess]

section '.idata' import data readable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', getchar, 'getchar'
