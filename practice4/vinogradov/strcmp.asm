global pr_strcmp
section .text

; int pr_strcmp(char const *s1, char const *s2);
pr_strcmp:
.cmp_piece:
	movups xmm0, [rdi]	; get a piece of s1
	movups xmm1, [rsi]	; get a piece of s2
	pcmpistri xmm1, xmm0, 0x18 ; compare the pieces, position of first mismatching symbol goes to rcx
	jna .end
	add rdi, 16		; move to the next piece
	add rsi, 16
	jmp .cmp_piece
.end:
	;; a symbol mismatched or one of the strings ended
	jc .different
	xor rax, rax		; the strings are equal, return 0
	ret
	
.different:
	;; the strings are different, return the difference of first mismatching symbols
	xor rax, rax
	xor rdx, rdx
	mov al, [rdi+rcx]
	mov dl, [rsi+rcx]
	sub rax, rdx
	ret
	
