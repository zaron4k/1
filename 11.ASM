format PE console
entry start

; ��������� ���� � INCLUDE
include 'D:\fasn\INCLUDE\win32ax.inc'  ; ����������� ������� � ���������� �� ���������� ����

section '.data' data readable writeable
    prompt_x db "Enter the first number (x): ", 0       ; ��������� ��� ����� x
    prompt_y db "Enter the second number (y): ", 0     ; ��������� ��� ����� y
    format_input db "%d", 0                            ; ������ ����� ��� scanf
    format_output db "Result: %d", 10, 0               ; ������ ������ ��� printf
    x dd 0                                             ; ���������� ��� �������� x
    y dd 0                                             ; ���������� ��� �������� y
    result dd 0                                        ; ���������� ��� �������� ����������

section '.code' code readable executable
start:
    ; ����������� ���� ������� ����� (x)
    cinvoke printf, prompt_x                           ; ������� ��������� "Enter the first number (x): "
    lea eax, [x]                                       ; ��������� ����� ���������� x
    cinvoke scanf, format_input, eax                   ; ��������� �������� x

    ; ����������� ���� ������� ����� (y)
    cinvoke printf, prompt_y                           ; ������� ��������� "Enter the second number (y): "
    lea eax, [y]                                       ; ��������� ����� ���������� y
    cinvoke scanf, format_input, eax                   ; ��������� �������� y

    ; ��������� ������������ x * y � �������������� ��������
    mov ecx, [y]                                       ; ��������� �������� y � ������� ECX (������� �����)
    mov eax, 0                                         ; �������� ������� EAX (����������� ��� ����������)
    mov ebx, [x]                                       ; ��������� �������� x � ������� EBX

multiply_loop:
    add eax, ebx                                       ; ��������� x (EBX) � ���������� (EAX)
    loop multiply_loop                                 ; ��������� ECX �� 1 � ��������� ����, ���� ECX != 0

    mov [result], eax                                  ; ��������� ��������� � ���������� result

    ; ������� ���������
    cinvoke printf, format_output, eax                 ; ������� ��������� � �������

    ; �������� ������� ������� ����� �������
    cinvoke printf, "Press any key to exit...", 10, 0  ; ������� ��������� "Press any key to exit..."
    call [getch]                                       ; ���� ������� �������

    ; ���������� ���������
    push 0                                             ; ��� ���������� ���������
    call [ExitProcess]                                 ; �������� ������� ExitProcess

section '.idata' import data readable
    library kernel32, 'kernel32.dll', \
            msvcrt, 'msvcrt.dll'

    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', \
           scanf, 'scanf', \
           getch, '_getch'                             ; ����������� ������� printf, scanf � _getch�������� ������� _getch