CFLAGS=-g
CXXFLAGS=-g -O3 -std=c++11

all: test


test: test.o strcmp.o
	g++ $(CXXFLAGS) -o $@ $^

%.o: %.asm
	yasm -f elf64 -g dwarf2 -o $@ $^
