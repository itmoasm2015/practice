all: vm/image.iso

OS=$(shell uname)

vm/image.iso: disc/p.com
ifeq ($(OS), Darwin)
	rm -f vm/image.iso
	hdiutil makehybrid -iso -joliet -o vm/image.iso disc/
else
	genisoimage -o $@ disc/
endif

disc/p.com: practice.asm
	yasm -f bin -o $@ $<
