format PE console
entry start

include 'D:\fasn\INCLUDE\win32a.inc'

section '.data' data readable writable
    arr dd 5, 9, 3, 9, 1, 7, 9, 2, 4, 6
    result_msg db "Array after replacing max with min:", 10, 0
    format_str db "%d ", 0

section '.code' code readable executable
start:
    xor ecx, ecx
    mov eax, [arr]         ; assume first as max and min
    mov ebx, eax           ; min
    mov edx, eax           ; max

.find_min_max:
    cmp ecx, 10
    jge .replace
    mov esi, [arr + ecx*4]
    cmp esi, ebx
    jl .set_min
    cmp esi, edx
    jg .set_max
    jmp .next

.set_min:
    mov ebx, esi
    jmp .next

.set_max:
    mov edx, esi

.next:
    inc ecx
    jmp .find_min_max

.replace:
    xor ecx, ecx

.loop_replace:
    cmp ecx, 10
    jge .print

    mov esi, [arr + ecx*4]
    cmp esi, edx
    jne .no_replace
    mov [arr + ecx*4], ebx

.no_replace:
    inc ecx
    jmp .loop_replace

.print:
    push result_msg
    call [printf]
    add esp, 4

    xor ecx, ecx

.print_loop:
    cmp ecx, 10
    jge .exit
    push [arr + ecx*4]
    push format_str
    call [printf]
    add esp, 8
    inc ecx
    jmp .print_loop

.exit:
    call [getchar]
    call [getchar]
    push 0
    call [ExitProcess]

section '.idata' import data readable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', getchar, 'getchar'
