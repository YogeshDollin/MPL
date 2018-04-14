section .data
menumsg db 10,10,'menu for overlappedblock transfer',10
db 10,'1.block transfer without using string instruction'
db 10,'2.block transfer with using string instruction'
db 10,'3.exit'
db 10,'enter your choice::'
menumsg_len equ $-menumsg

wrchmsg db 10,10,'wrong choice entered plz try again ',10,10
wrchmsg_len equ $-wrchmsg

blk_bfrmsg db 10,'block contents before transfer::'
blk_bfrmsg_len equ $-blk_bfrmsg

blk_afrmsg db 10,'Block contents after transfer::'
blk_afrmsg_len equ $-blk_afrmsg

position db 10,'Enter postion to overlap::'
pos_len equ $-position

srcblk db 01h,02h,03h,00h,00h,00h,00h,00h

cnt equ 05
spacechar db 20h
lfmsg db 10,10

section .bss
	optionbuff resb 02
	dispbuff resw 02
	pos resb 00

%macro dispmsg 2
	mov rax,01
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro accept 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .text

global _start
_start:

	dispmsg blk_bfrmsg,blk_bfrmsg_len
	call dispblk_proc
menu:
	dispmsg menumsg, menumsg_len
	accept optionbuff,02
	cmp byte[optionbuff],'1'
	jne case2
	dispmsg position,pos_len
	accept optionbuff,02
	call packnum_proc
	call blkxferwo_proc
	jmp exit1

case2:
	cmp byte[optionbuff],'2'
	jne case3
	dispmsg position,pos_len
	accept optionbuff,02
	call packnum_proc
	call blkxferw_proc
	jmp exit1

case3:
	cmp byte[optionbuff],'3'
	je ext
	dispmsg wrchmsg,wrchmsg_len
	jmp menu

exit1:
	dispmsg blk_afrmsg,blk_afrmsg_len
	call dispblk_proc
	dispmsg lfmsg,2

ext:
	mov rax,60
	mov rbx,0
	syscall

dispblk_proc:
	mov rsi,srcblk
	mov rcx,cnt
	add rcx,[pos]

rdisp:
	push rcx
	mov bl,[rsi]
	push rsi
	call disp8_proc
	pop rsi
	inc rsi
	push rsi
	dispmsg spacechar,1
	pop rsi
	pop rcx
	loop rdisp
	ret

blkxferwo_proc:
	mov rsi,srcblk+4
	mov rdi,rsi
	add rdi,[pos]
	mov rcx,cnt

blkup1:
	mov al,[rsi]
	mov [rdi],al
	dec rsi
	dec rdi
	loop blkup1
	ret

blkxferw_proc:
	mov rsi,srcblk+4
	mov rdi,rsi
	add rdi,[pos]
	mov rcx,cnt
	std
	rep movsb
	ret

disp8_proc:
	mov al,2
	mov rdi,dispbuff

dup1:
	rol bl,4
	mov dl,bl
	and dl,0fh
	cmp dl,09h
	jbe dskip
	add dl,07h

dskip:
	add dl,30h
	mov [rdi],dl
	inc rdi
	loop dup1
	dispmsg dispbuff,2
	ret

packnum_proc:
	mov rsi,optionbuff
	mov bl,[rsi]
	cmp bl,39h
	jbe skip1
	sub bl,07h

skip1:
	sub bl,30h
	mov [pos],bl
	ret
