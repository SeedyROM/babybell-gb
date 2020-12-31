build: src/main.asm inc/hardware.inc
	mkdir -p build
	rgbasm -o build/main.o src/main.asm
	rgblink -o build/bbybell.gb build/main.o
	rgbfix -v -p 0 build/bbybell.gb

run: build
	bgb ./build/bbybell.gb