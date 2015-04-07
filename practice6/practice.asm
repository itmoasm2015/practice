org 100h
section .text
    mov ax, 0xb800
    mov es, ax
    mov di, (160*12 + 2*35)
    mov si, hello
    mov cx, helloLen
    rep movsb
    ret
section .data
    COL equ 0xf0
    hello: db 'H', COL, 'e', COL, 'l', COL, 'l', COL, 'o', COL, ' ', COL, 'D', COL, 'O', COL, 'S', COL
    helloLen equ $-hello
