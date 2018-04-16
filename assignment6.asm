section .data
msg1: db " Sorry, Processor is in the REAL mode",10
len1: equ $-msg1

msg2: db "Entered Protected Mode",10
len2: equ $-msg2

msg3:db 10," Content of GDTR:"
len3: equ $-msg3

msg4:db 10," Content of DTR"
len4: equ $-msg4

msg5:db 10," Content of LDTR"
len5: equ $-msg5

msg6:db 10," ::"
len6: equ $-msg6

;--------------------------------------------------------
section .bss

GDTR resw 3
LDTR resw 1
IDTR resw 3
MSW resw 1
result resb 4

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro


section .text

global _start
_start:
SMSW eax
BT eax,0
JC protmode
print msg1,len1

jmp exit
;----------
protmode:
	print msg2,len2
	SGDT [GDTR]
	SLDT [LDTR]
	SIDT [IDTR]
	;SMSW [MSW]
	
print msg3,len3
mov bx,[GDTR+4]
call disp
mov bx,[GDTR+2]
call disp
print msg6,len6
mov bx,[GDTR]
call disp

print msg4,len4
mov bx,[IDTR+4]
call disp
mov bx,[IDTR+2]
call disp
print msg6,len6
mov bx,[IDTR]
call disp

mov bx,[LDTR]
call disp

;mov bx,[MSW]
;call disp

exit:
	mov rax,60
	mov rbx,0
	syscall
disp:
	mov rdi,result
	mov rcx,4
l1:
	rol bx,4
	mov dl,bl
	and dl,0fh
	cmp dl,09h
	jbe l2
	add dl,07h
l2:
	add dl,30h
	mov[rdi],dl
	inc rdi
	loop l1

print result,4
ret
