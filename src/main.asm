INCLUDE "./inc/hardware.inc"

SECTION "Header", ROM0[$100]
        di              ; Disable interrupts
        jp Start        ; Get out of dodge and into the code

REPT $150 - 104         ; Pad out the rest of the header
        db 0
ENDR 

SECTION "Babybell", ROM0

; Include our standard library methods
INCLUDE "./inc/std.inc"

; ---------------------------------------------------------------------------------------------------------
; Entrypoint
; ---------------------------------------------------------------------------------------------------------

Start:
	call WaitForVBlank			; Turn off the screen
	call CopyFontIntoVRAM			; Load the font

        ld hl, $9800                            ; Print some strings...
        ld de, StartMenuString
	call CopyStringToVRAM

	ld hl, $9820
	ld de, NewGameString
	call CopyStringToVRAM

	ld hl, $9840
	ld de, LoadSaveString
	call CopyStringToVRAM

	call InitScreen

	xor a
; Lock up
.lockup
	; inc a
	; ld [rSCY], a
	; ld [rSCX], a
        jr .lockup

; --------------------------------------------
; Graphics
; --------------------------------------------

INCLUDE "./assets/font.inc"
INCLUDE "./assets/world.inc"
INCLUDE "./assets/world.asm"

; --------------------------------------------
; Constants
; --------------------------------------------

SECTION "Strings", ROM0

StartMenuString:
    db "Start", 0
NewGameString:
    db "New Game", 0
LoadSaveString:
    db "Load Save", 0