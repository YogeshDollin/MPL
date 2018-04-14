section .data
msg1 db 10,'count of positive and negative numbers :: ',10
msg1_len equ $-msg1

msg2 db 10,10,'count of positive numbers :: '
msg2_len equ $-msg2

msg3 db 10,10,'count of negative numbers ::'
msg3_len equ $-msg3

array db 65,54,33,68,7,34,64,35,98,51,61,67
arrcount equ 12
pcnt db 0
ncnt db 0

section .bss
dispbuff resb 2

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

		print msg1,msg1_len
		mov rsi,array
		mov rcx,arrcount

	label1:
			mov rdx,[rsi]
			bt rdx,7
			jnc pnext
			inc byte[ncnt]
			jmp pskip

	pnext:
			inc byte[pcnt]

	pskip:
			inc rsi
			loop label1

			print msg2,msg2_len
			mov bl,[pcnt]
			call display_proc

			print msg3,msg3_len
			mov bl,[ncnt]
			call display_proc

			mov rax,60
			mov rbx,0
			syscall


	display_proc:
				mov ecx,2
				mov rdi,dispbuff

			part1:
					rol bl,4
					mov al,bl
					and al,0fh
					cmp al,9h
					jbe part2
					add al,07h

			part2:
					add al,30h
					mov [edi],al
					inc edi
					loop part1

					print dispbuff,2
					ret

