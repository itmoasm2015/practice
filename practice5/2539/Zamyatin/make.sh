yasm -f elf64 -g dwarf2 -o double2str.o double2str.asm
g++ -std=c++11 -m64 -c test2.cpp
g++ -m64 -o test double2str.o test2.o
rm double2str.o
rm test2.o
./test
