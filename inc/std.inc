; ---------------------------------------------------------------------------------------------------------
; Global procedures
; ---------------------------------------------------------------------------------------------------------

;
; Wait for a vblank
;
WaitForVBlank:                                  ; VBlank Check
        ld a, [rLY]                             ; Get the y position of VRAM
        cp 144                                  ; Check for V-BLANK
        jr c, WaitForVBlank            		; Run the check again

        xor a                                   ; ld a, 0; Set a to 0
        ld [rLCDC], a                           ; Turn off the LCD
	ret

;
; Copy data
; hl = destination
; de = source
; bc = size
;
MemCopy:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, MemCopy
	ret

;
; Load font data into VRAM at $9000
;
CopyFontIntoVRAM:
        ld hl, $9000                            ; Where to write our font
        ld de, FontTiles                        ; FontTile start in memory
        ld bc, FontTilesEnd - FontTiles         ; Font size in bytes
        call MemCopy
	ret

;
; Copy string into VRAM routine
; hl = location
; de = source string
;
CopyStringToVRAM:
	ld a, [de]
	inc de
	and a
	ret z
	ld [hli], a
	jr CopyStringToVRAM

;
; Initialize the game
;
InitScreen:
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

	ret


; ---------------------------------------------------------------------------------------------------------
; End global procedures
; ---------------------------------------------------------------------------------------------------------