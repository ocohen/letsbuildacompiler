;harness for win32
extern _ExitProcess@4, _GetStdHandle@4, _WriteConsoleA@20   ;win32 functions

STD_OUTPUT_HANDLE equ -11
NULL equ 0

section .text

numDigits:  ;(int toPrint)
    mov eax, [esp+4]
    mov ebx, 0
    mov ecx, 10
numDigitsLoop:
    mov edx, 0
    inc ebx
    div ecx
    cmp eax, 0
    jne numDigitsLoop
    mov eax, ebx
    ret 4

printResults: ;(int toPrint)
    push ebp
    mov ebp, esp
    push edi
    sub esp, 0x40   ;64 bytes of variables

    mov ecx, [ebp+8]
    cmp ecx, 0
    mov dword [esp+4], 0
    jge isPositive
        neg ecx
        mov dword [esp+4], 1
        mov [ebp+8], ecx
isPositive:
    push ecx    ;toPrint
    call numDigits
    mov ebx, eax    ;num digits to print
    mov [esp], ebx  ;store num digits
    
    cmp dword [esp+4], 0
    je loopInit    ;if toPrint < 0
        inc dword [esp]         ;add one for the -
        mov byte [esp+8], '-'
loopInit:
    mov edx, [esp]  ;num characters
    lea edi, [esp+8+edx]
    mov byte [edi],  0  ;output buffer is 0 terminated
    dec edi
    mov ecx, 10
    mov eax, [ebp+8]    ;toPrint
loop:
    cmp ebx, 0  
    je endLoop  ;if currentValue == 0 stop
    mov edx, 0
    div ecx
    add dl, '0'    ;remainder += '0'
    mov [edi], dl; output[numBytes--] = remainder
    dec ebx
    dec edi
    jmp loop
endLoop:
    
    push STD_OUTPUT_HANDLE ;get std out handle in eax
    call _GetStdHandle@4
    
    mov ebx, [esp]  ;num characters
    inc ebx         ;null terminator
    lea edi, [esp+8] ;buffer

    push NULL               ;call WriteConsoleA
    lea ecx, [ebp - 8]
    push ecx                ;we have lots of room for the buffer so just put on stack
    push ebx                ;chars to write
    push edi                ;buffer
    push eax
    call _WriteConsoleA@20
    
    add esp, 0x40
    pop edi
    leave
    ret 4
    

extern run; run will be the entry point of the actual program

global main
main:
    call run

    push eax
    call printResults

    push NULL               ;Exit
    call _ExitProcess@4

section .bss
    NumOfCharsWritten    resd 1
section .data
    msg db "hello world!"
    msgLen equ $ - msg
