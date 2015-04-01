CXX_FLAGS = -std=c99 -g -L. -I.

all: test

clean:
	rm libstr2double.a str2double.o test.o test

test: libstr2double.a
	gcc -o test $(CXX_FLAGS) test.c -lstr2double

libstr2double.a: str2double.o
	ar rcs libstr2double.a str2double.o

%.o: %.asm
	yasm -f elf64 -g dwarf2 -o $@ $^
