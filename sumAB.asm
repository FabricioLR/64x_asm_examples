;--------------------------------------------------------------------------------
;build:
;
;	nasm -f win64 sumAB.asm -o sumAB.o
;	gcc sumAB.o -o sumAB
;--------------------------------------------------------------------------------

default rel

segment .data
	msg1 db "Digite o primeiro numero: ", 0
	msg2 db "Digite o segundo numero: ", 0
	inputint db "%d", 0
	outputint db "A: %d B: %d", 0xa, 0
	outputint2 db "O resultado de a + b e: %d"

segment .text
global main
extern printf
extern scanf

add:
	push rbp
	mov rbp, rsp
	mov [rbp + 30], ecx
	mov [rbp + 40], edx
	mov edx, [rbp + 30]
	mov eax, [rbp + 40]
	add eax, edx
	pop rbp
	retn

main:
	push rbp
	mov rbp, rsp
	sub rsp, 48

	lea rax, msg1
	mov rcx, rax
	call printf
	lea rax, [rbp + 10]
	mov rdx, rax
	lea rax, inputint
	mov rcx, rax
	call scanf
	lea rax, msg2
	mov rcx, rax
	call printf
	lea rax, [rbp + 20]
	mov rdx, rax
	lea rax, inputint
	mov rcx, rax
	call scanf
	mov edx, [rbp + 20]
	mov eax, [rbp + 10]
	mov r8d, edx
	mov edx, eax
	lea rax, outputint
	mov rcx, rax
	call printf
	mov edx, [rbp + 20]
	mov eax, [rbp + 10]
	mov ecx, eax
	call add
	mov [rbp + 50], eax
	mov eax, [rbp + 50]
	mov edx, eax
	lea rax, outputint2
	mov rcx, rax
	call printf

	nop
	add rsp, 48
	pop rbp
	retn