global str2double

FLAG_SIGN        equ    1 << 0
FLAG_POINT       equ    1 << 1

section .text

str2double:
	xor rdx, rdx
	xor rcx, rcx
	xor r9, r9
	cvtsi2sd xmm0, r9 
	mov r9, 10
	cvtsi2sd xmm4, r9
.parse_string:
	cmp byte [rdi], 0
	je .div_number
	cmp byte [rdi], '-'
	jne .not_minus
	or rdx, FLAG_SIGN
	jmp .next_symbol
.not_minus:
	cmp byte [rdi], '.'
	jne .not_point
	or rdx, FLAG_POINT
	xor r8, r8
	xor r10, r10
	inc r10
	cvtsi2sd xmm3, r10
	jmp .next_symbol
.not_point:
	test rdx, FLAG_POINT
	jz .no_point_flag
	inc r8
	mulpd xmm3, xmm4
.no_point_flag:
	mov r9, 10
	cvtsi2sd xmm1, r9
	mov cl, [rdi]
	sub cl, '0'
	cvtsi2sd xmm2, rcx
	mulpd xmm0, xmm1
	addpd xmm0, xmm2 
.next_symbol:
	inc rdi
	jmp .parse_string

.div_number:
	divpd xmm0, xmm3
	test rdx, FLAG_SIGN
	jz .exit
	mov r9, -1
	cvtsi2sd xmm3, r9
	mulpd xmm0, xmm3
.exit:
	ret
