    org 100h ; DOS кладет наш код начиная с адреса 100h.
section .text
    mov ax, 0xb800 ; Сегмент текстовой видеопамяти
    mov es, ax
    ; 25 строк по 80 символов
    ; Каждый символ - 2 байта (сам символ и цвет)
    ; Печатаем примерно посередине - 12 строка, 35 столбец
    mov di, (160*12 + 2*35)
    mov si, hello
    mov cx, helloLen
    rep movsb
    ret

section .data ; Не обязательно, в COM-файле нет секций.
    COL equ 0xf0 ; Цвет - фон f (ярко-белый), текст 0 (черный).
    hello: db 'H', COL, 'e', COL, 'l', COL, 'l', COL, 'o', COL, ' ', COL, 'D', COL, 'O', COL, 'S', COL
    helloLen equ $-hello
