vm/image.iso: disc/p.com
	rm -f vm/image.iso
	hdiutil makehybrid -iso -joliet -o vm/image.iso disc/

disc/p.com: practice.asm
	yasm -f bin -o $@ $<
