makeall: clean test
	./test


test: test.o libhw.a
	g++ -Wall -msse -g -o $@ $^ 
	
test.o:
	g++ test.cpp -Wall -g -c -o $@

libhw.a: str2double.o
	ar rcs $@ $^

str2double.o: 
	yasm -felf64 -gdwarf2 str2double.asm -o $@

clean:
	rm -f test
	rm -f test.o
	rm -f libhw.a
	rm -f str2double.o

