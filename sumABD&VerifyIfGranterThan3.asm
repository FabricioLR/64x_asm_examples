;--------------------------------------------------------------------------------
;build:
;
;	nasm -f win64 sumABD&VerifyIfGranterThan3.asm -o sumABD&VerifyIfGranterThan3.o
;	gcc sumABD&VerifyIfGranterThan3.o -o sumABD&VerifyIfGranterThan3
;--------------------------------------------------------------------------------

default rel

segment .data
    str1 db "primeiro", 0
    str2 db "segundo", 0
    str3 db "terceiro", 0

    str4 db "Digite o %s numero: ", 0
    str5 db "%d e maior ou igual que tres", 0
    str6 db "%d nao e maior que tres", 0
    input1 db "%d", 0

ordinal: dq str1, str2, str3

segment .text
global main 
extern printf
extern scanf
    
main:
    push rbp
    mov rbp, rsp
    sub rsp, 96

    mov dword[rbp + 4], 0
    mov dword[rbp + 28], 0
    jmp short loc1

loc1:
    cmp dword[rbp + 4], 2
    jle short loc2
    mov dword[rbp + 4], 0
    jmp short loc3

loc2:
    lea rdi, ordinal
    mov eax, dword[rbp + 4]
    movsxd rdx, eax
    mov rsi, [rdi + 8*rdx]
    mov rdx, rsi
    lea rax, str4
    mov rcx, rax
    call printf
    mov eax, dword[rbp + 4]
    movsxd rax, eax
    lea rax, [rbp + 16 + rax*4]
    mov rdx, rax
    lea rax, input1
    mov rcx, rax
    call scanf
    add dword[rbp + 4], 1
    jmp short loc1

loc3:
    cmp dword[rbp + 4], 2
    jle short loc4
    cmp dword[rbp + 28], 3
    jl short loc5
    mov eax, dword[rbp + 28]
    mov edx, eax
    lea rax, str5
    mov rcx, rax
    call printf
    jmp short locf

loc4:
    mov eax, dword[rbp + 4]
    movsxd rax, eax
    mov eax, [rbp + 16 + rax*4]
    add dword[rbp + 28], eax
    add dword[rbp + 4], 1
    jmp short loc3

loc5:
    mov eax, dword[rbp + 28]
    mov edx, eax
    lea rax, str6
    mov rcx, rax
    call printf
    jmp short locf

locf:
    nop
    add rsp, 96
    pop rbp
    retn
