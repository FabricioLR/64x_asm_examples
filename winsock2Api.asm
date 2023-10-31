;--------------------------------------------------------------------------------
;build:
;
;	nasm -f win64 winsock2Api.asm -o winsock2Api.o
;	gcc winsock2Api.o -o winsock2Api -lws2_32
;--------------------------------------------------------------------------------

default rel

segment .data
    str1 db "WSAStartup failed", 0
    str2 db "Create socket failed", 0
    str3 db "Bind failed", 0
    str4 db "Listen failed", 0
    str5 db "Client connected", 0xa, 0

    str6 db "Received: %s", 0
    str7 db "HTTP/1.1 200 OK", 0xd, 0xa, 0

;struc sockaddr
;    sa_family   resb 10
;    sa_data  resb 10
;endstruc

;segment .bss
;    server_addr resb sockaddr_size

segment .text
global main 
extern printf
extern exit
extern WSAStartup
extern socket
extern bind
extern htons
extern WSACleanup
extern closesocket
extern accept
extern recv
extern listen
extern send

main:
    push rbp
    mov rbp, rsp
    sub rsp, 128

    lea rax, [rbp + 160h + 448] ; WSADATA

    mov rdx, rax
    mov ecx, 202h

    call WSAStartup
    test eax, eax
    jz short loc1

    lea rax, str1
    mov rcx, rax
    call printf
    mov ecx, 0
    call exit

loc1:
    mov r8d, 0 ;Protocol
    mov edx, 1 ;Type
    mov ecx, 2 ;AFf

    call socket
    mov [rbp + 160h + 4], eax ;server
    cmp dword[rbp + 160h + 4], 0
    jns short loc2

    lea rax, str2
    mov rcx, rax
    call printf
    mov ecx, 0
    call exit

loc2:
    mov word[rbp + 160h + 32], 2 ; sin_family
    mov dword[rbp + 160h + 32 + 2 + 2], 0 ; sin_addr.s_addr
    mov ecx, 4000 ; server port
    call htons
    mov [rbp + 160h + 32 + 2], rax ; sin_port
    mov r8d, 10h ; sockaddr len
    lea rdx, [rbp + 160h + 32] ; sockaddr struct
    mov eax, [rbp + 160h + 4] ; server
    movsxd rcx, eax
    call bind
    test eax, eax
    jns short loc3

    lea rax, str3
    mov rcx, rax
    call printf
    mov ecx, 0
    call exit

loc3:
    mov edx, 10 ; backlog
    mov eax, [rbp + 160h + 4] ; server
    movsxd rcx, eax
    call listen
    test eax, eax
    jns short loc4

    lea rax, str4
    mov rcx, rax
    call printf
    mov ecx, 0
    call exit

loc4:
    jmp short loc5

    mov eax, [rbp + 160h + 4] ; server
    movsxd rcx, eax
    
loc5:
    mov dword[rbp + 160h + 12], 10h
    lea rax, [rbp + 160h + 12]
    mov r8, rax ; client sockaddr len
    lea rdx, [rbp + 160h + 48] ; client sockaddr
    mov eax, [rbp + 160h + 4] ; server 
    movsxd rcx, eax
    call accept
    mov [rbp + 160h + 8], eax ; client
    cmp dword[rbp + 160h + 8], 0
    js short loc6

    lea rax, str5
    mov rcx, rax
    call printf

    jmp loc6

loc6:
    mov r9d, 0 ; flags
    mov r8d, 1024 ; buf
    lea rdx, [rbp + 160h + 1488] ; buf len
    mov eax, [rbp + 160h + 8] ; client
    movsxd rcx, eax
    call recv
    test eax, eax
    jle short loc4

    lea rax, [rbp + 160h + 1488]
    mov rdx, rax
    lea rax, str6
    mov rcx, rax
    call printf

    mov r9d, 0 ; flags
    mov r8d, 19 ; len
    lea rdx, str7 
    mov eax, [rbp + 160h + 8]
    movsxd rcx, eax ; client 
    call send
    jmp loc4

