INCLUDE "./inc/hardware.inc"

SECTION "Header", ROM0[$100]
        di              ; Disable interrupts
        jp Start        ; Get out of dodge and into the code

REPT $150 - 104         ; Pad out the rest of the header
        db 0
ENDR 

SECTION "Babybell", ROM0

Start:
        
.waitForVBlank:                                 ; VBlank Check

        ld a, [rLY]                             ; Get the y position of VRAM
        cp 144                                  ; Check for V-BLANK
        jr c, .waitForVBlank                    ; Run the check again

        xor a                                   ; ld a, 0; Set a to 0
        ld [rLCDC], a                           ; Turn off the LCD 

;
; Copy from ROM to VRAM routine
; hl = offset
; de = source
; bc = size
;
        ; Load the font
        ld hl, $9000                            ; Where to write our font
        ld de, FontTiles                        ; FontTile start in memory
        ld bc, FontTilesEnd - FontTiles         ; Font size in bytes
.copyFont:
        ld a, [de]                              ; Grab one byte from the source
        ld [hli], a                             ; Store a in hl and post-increment
        inc de                                  ; Move to next byte
        dec bc                                  ; Decrement the bytes left
        ld a, b                                 ; Check if b is 0, flags don't update for register b
        or c                                    ; B != 0 || C != 0
        jr nz, .copyFont

;
; Copy string routine
; hl = location
; de = source string
;
        ld hl, $9800                            ; This will print the string at the top-left corner of the screen
        ld de, StartMenuString
.copyString
        ld a, [de]
        ld [hli], a
        inc de
        and a                                   ; Check if the byte we just copied is zero
        jr nz, .copyString                      ; Continue if it's not

        ; Init display registers
        ld a, %11100100
        ld [rBGP], a

        xor a ; ld a, 0
        ld [rSCY], a
        ld [rSCX], a

        ; Shut sound down
        ld [rNR52], a

        ; Turn screen on, display background
        ld a, %10000001
        ld [rLCDC], a

	ld hl, $9820
	ld de, NewGameString
	jp .copyString

; Lock up
.lockup
        jr .lockup

SECTION "Font", ROM0

FontTiles:
INCBIN "./assets/font.chr"
FontTilesEnd:

SECTION "Strings", ROM0

StartMenuString:
    db "Start", 0
NewGameString:
    db "New Game", 0
LoadSaveString:
    db "Load Save", 0