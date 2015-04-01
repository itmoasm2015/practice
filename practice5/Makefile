OBJS=$(T1) $(T2)
CXXFLAGS=-std=c++11

OS:=$(shell uname)

ifeq ($(OS), Darwin)
YASM_FLAGS=-f macho64
OBJS+=osx-wrapper.o
else
YASM_FLAGS=-f elf64 -g dwarf2
endif

.PHONY: all

all: test

test: test.o $(OBJS)
	g++ $(CXXFLAGS) -o $@ $^
	./test

test2: test2.o $(OBJS)
	g++ $(CXXFLAGS) -o $@ $^
	./test2

%.o: %.asm
	yasm $(YASM_FLAGS) -o $@ $<
