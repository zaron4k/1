format PE console
entry start

include 'D:\fasn\INCLUDE\win32a.inc'

section '.data' data readable writable
    msg1        db "Enter the start of the interval a: ", 0
    msg2        db "Enter the end of the interval b: ", 0
    result_msg  db "Sum of the series from %d to %d: %d", 10, 0
    input_fmt   db "%d", 0
    a           dd ?
    b           dd ?
    sum         dd 0

section '.code' code readable executable
start:
    ; Input the start of the interval
    push msg1
    call [printf]
    add esp, 4

    push a
    push input_fmt
    call [scanf]
    add esp, 8

    ; Input the end of the interval
    push msg2
    call [printf]
    add esp, 4

    push b
    push input_fmt
    call [scanf]
    add esp, 8

    ; Initialize the sum
    mov eax, 0        ; Sum = 0
    mov ecx, [a]      ; ECX = start of the interval (a)

sum_loop:
    cmp ecx, [b]      ; Check if we've reached the end of the interval
    jg print_result   ; If yes, move to printing the result

    add eax, ecx      ; Add current number (ecx) to sum
    inc ecx           ; Move to the next number
    jmp sum_loop      ; Repeat the loop

print_result:
    push [b]
    push [a]
    push eax          ; Push the result to the stack
    push result_msg
    call [printf]
    add esp, 16       ; Clean the stack

    call [getchar]
    call [getchar]

    push 0
    call [ExitProcess]

section '.idata' import data readable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', scanf, 'scanf', getchar, 'getchar'
