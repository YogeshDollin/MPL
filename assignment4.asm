section .data
nline db 10,10
nline_len: equ $-nline
msg db 10,10,"MIL Assignmnt Multiplication:"
db 10,"---"
msg_len equ $-msg
menu db 10,"---MENU---"
db 10,"1. successive addn method"
db 10,"2.shift and add method"
db 10,"3.exit"
db 10
db 10,"enter your choice:"
menu_len: equ $-menu
n1msg db 10,"enter Two digit hex no1:"
n1msg_len: equ $-n1msg
n2msg db 10,"enter Two digit hex no2:"
n2msg_len: equ $-n2msg
samsg db 10,13,"result by succesive addition is:"
samsg_len: equ $-samsg
shamsg db 10,13,"result by shift and addition is:"
shamsg_len: equ $-shamsg
emsg db 10,"you entered invalid data!!!!",10
emsg_len: equ $-emsg

section .bss
buf resb 3
buf_len: equ $-buf
no1 resb 1
no2 resb 1
ansl resb 1
ansh resb 1
ans resw 1
char_ans resb 4

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro exit 0
print nline,nline_len
mov rax,60
xor rdi,rdi
syscall
%endmacro

section .text
    global _start
_start:
	print msg,msg_len
	print n1msg,n1msg_len
	call accept_16
	mov [no1],bx
	print n2msg,n2msg_len
	call accept_16
	mov [no2],bx
Disp_Menu:
	print menu,menu_len
	read buf,2
	mov al,[buf]
c1: 	cmp al,'1'
	jne c2
	call SA
	jmp Disp_Menu
c2: 	cmp al,'2'
	jne c3
	call SHA
	jmp Disp_Menu
c3: 	cmp al,'3'
	jne err
	exit
err: print emsg,emsg_len
     jmp Disp_Menu
SA:
	mov rbx,[no1]
	mov rcx,[no2]
	xor rax,rax
	xor rdx,rdx
back:   add al,bl
        jnc next
      	inc rdx
next:	dec rcx
	jnz back
	mov [ansl],rax
	mov [ansh],rdx
	print samsg,samsg_len
	;mov ax,[ansh]
	;call display_16
	mov ax,[ansl]
	call display_16
   ret
SHA:
	mov rcx,08
	mov al,[no1]
	mov bl,[no2]
back1:
	shr bx,1
        jnc next1
        add [ans],ax
next1:	shl ax,1
	dec rcx
	jnz back1
	print shamsg,shamsg_len
	mov ax,[ans]
	call display_16
	;mov ax,[ans+0]
	;call  display_16
	ret
accept_16:
	read buf,buf_len
	xor bx,bx
	mov rcx,2
	mov rsi,buf
next_digit:
	shl bx,04
	mov al,[rsi]
	cmp al,"0"
	jb error
	cmp al,"9"
	jbe sub30
	cmp al,"A"
	jb error
	cmp al,"F"
	jbe sub37
        cmp al,"a"
	jb error
	cmp al,"f"
	jbe sub57
error: print emsg,emsg_len
	exit
sub57: sub al,20h
sub37: sub al,07h
sub30: sub al,30h
	add bx,ax
	inc rsi
	loop next_digit
	ret
display_16:
	mov rsi,char_ans+3
	mov rcx,4
cnt:	mov rdx,0
	mov rbx,16
	div rbx
	cmp dl,09h
	jbe add30
	add dl,07h
add30:
	add dl,30h
	mov [rsi],dl
	dec rsi
	dec rcx
	jnz cnt
	print char_ans,4
ret
