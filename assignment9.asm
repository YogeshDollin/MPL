section .data
  msg : db "enter the number ",0x0A
  len : equ $-msg

section .bss 
  num    : resb 8
  num1   : resb 3
  count  : resb 2
 
%macro print 2
  mov rax, 1
  mov rdi, 1
  mov rsi, %1
  mov rdx, %2
  syscall
%endmacro
 
%macro read 2
  mov rax, 0
  mov rdi, 0
  mov rsi, %1
  mov rdx, %2
  syscall
%endmacro
 
section .txt
global _start
_start:
   print msg,len
   read num1,3
   call asciihex
   
   mov bx,cx
   mov byte[count],0

loop:
   push bx
   dec bx
   inc byte[count]
   cmp bx, 01H
   jne loop

   mov rax, 1
loop2:
   xor rbx, rbx
   pop bx
   mul bx
   dec byte[count]
   cmp byte[count],0
   jne loop2

   mov rbx, rax
   
   call hexascii
   print num, 8
   mov rax, 60
   mov rdi, 0
   syscall

asciihex:
    xor ebx,ebx
    xor ecx,ecx
    mov byte[count],2
    mov rsi, num1

    up1:
        rol rcx, 04
        mov bl, byte[rsi]
        cmp bl, 39H
        jbe next 
        sub bl, 07H
    next :
        sub bl, 30H
        add cl, bl	
	inc rsi
	dec byte[count]
	jnz up1
	ret

hexascii:
    	mov rsi, num
     	mov byte[count],8

     above1:
         	rol ebx, 04
        	mov dl, bl
        	and dl, 0FH
        	cmp dl, 09H
         	jbe next2
        	add dl,07
     next2:
        	add dl, 30H
        	mov byte[rsi],dl
        	inc rsi	
        	dec byte[count]
        	jnz above1
        	ret	
