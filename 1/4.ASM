format PE console
entry start

include 'D:\fasn\INCLUDE\win32a.inc'

section '.data' data readable writable
    a            dd 0               ; ������ ���������
    b            dd 0               ; ����� ���������
    prompt_a     db "Enter start of range: ", 0
    prompt_b     db "Enter end of range: ", 0
    input_fmt    db "%d", 0

    message      db "Prime numbers in range [%d, %d]: ", 10, 0
    format_str   db "%d ", 0
    newline      db 10, 0
    wait_message db "Press Enter to exit...", 10, 0

section '.code' code readable executable
start:
    ; ���� a
    push prompt_a
    call [printf]
    add esp, 4

    push a
    push input_fmt
    call [scanf]
    add esp, 8

    ; ���� b
    push prompt_b
    call [printf]
    add esp, 4

    push b
    push input_fmt
    call [scanf]
    add esp, 8

    ; ����� ���������
    lea eax, [message]
    push dword [b]
    push dword [a]
    push eax
    call [printf]
    add esp, 12

    mov ecx, [a]                ; ������ ���������
    mov edx, [b]                ; ����� ���������

find_primes:
    cmp ecx, edx
    jg print_newline

    mov ebx, ecx
    cmp ebx, 1
    jle next_number

    cmp ebx, 2
    je print_prime

    mov esi, 2

check_divisors:
    mov eax, ebx
    xor edx, edx
    div esi
    test edx, edx
    jz next_number

    mov eax, ebx
    mov edi, esi
    imul edi, edi
    cmp edi, ebx
    jge print_prime

    inc esi
    jmp check_divisors

print_prime:
    push ebx
    lea eax, [format_str]
    push eax
    call [printf]
    add esp, 8

next_number:
    inc ecx
    jmp find_primes

print_newline:
    lea eax, [newline]
    push eax
    call [printf]
    add esp, 4

    lea eax, [wait_message]
    push eax
    call [printf]
    add esp, 4

    call [getchar]
    call [getchar]      ; ����������� Enter ����� scanf

exit_program:
    push 0
    call [ExitProcess]

section '.idata' import data readable
    library kernel32, 'kernel32.dll', \
            msvcrt,   'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', scanf, 'scanf', getchar, 'getchar'
