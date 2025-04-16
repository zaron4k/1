format PE console
entry start

include 'D:\fasn\INCLUDE\win32a.inc'

section '.data' data readable writable
    a            dd 0
    b            dd 0
    max_divisors dd 0
    result       dd 0
    temp         dd 0
    i            dd 0
    j            dd 0
    input_fmt    db "%d", 0
    prompt_a     db "Enter start of interval: ", 0
    prompt_b     db "Enter end of interval: ", 0
    message      db "Number with the most divisors: %d", 10, 0
    wait_message db "Press Enter to exit...", 10, 0

section '.code' code readable executable
start:
    ; Ввод начала интервала
    push prompt_a
    call [printf]
    add esp, 4

    push a
    push input_fmt
    call [scanf]
    add esp, 8

    ; Ввод конца интервала
    push prompt_b
    call [printf]
    add esp, 4

    push b
    push input_fmt
    call [scanf]
    add esp, 8

    mov ecx, [a]
    mov edx, [b]

find_max_divisors:
    cmp ecx, edx
    jg print_result

    mov ebx, ecx
    xor eax, eax
    mov esi, 1

count_divisors:
    cmp esi, ebx
    jg check_max_divisors

    mov edi, ebx
    xor edx, edx
    mov eax, edi
    div esi
    test edx, edx
    jnz next_divisor

    inc [temp]

next_divisor:
    inc esi
    jmp count_divisors

check_max_divisors:
    mov eax, [temp]
    cmp eax, [max_divisors]
    jl skip_update

    mov [max_divisors], eax
    mov [result], ebx

skip_update:
    mov [temp], 0
    inc ecx
    jmp find_max_divisors

print_result:
    lea eax, [message]
    push dword [result]
    push eax
    call [printf]
    add esp, 8

    lea eax, [wait_message]
    push eax
    call [printf]
    add esp, 4

    call [getchar]
    call [getchar]        ; Чтобы поймать Enter после ввода

exit_program:
    push 0
    call [ExitProcess]

section '.idata' import data readable
    library kernel32, 'kernel32.dll', \
            msvcrt,   'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', scanf, 'scanf', getchar, 'getchar'
