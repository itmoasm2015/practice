global _str2double
global _double2str
extern str2double
extern double2str

section .text
    _str2double: jmp str2double
    _double2str: jmp double2str
