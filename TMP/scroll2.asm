;startup address
* = $0801

;create SYS line
.byte $0c,$08,$e2,$07,$9e,$20
.byte $32,$30,$36,$32,$00,$00
.byte $00

screen1 = $0400
;screen1 = $2000 

; set start of screen memory
; see https://www.c64-wiki.de/
; wiki/Bildschirmspeicher
        lda $d018
        and #%00001111
        ora #(screen1 / $0400) * 16
        sta $d018

        ; init sid max freq        
        lda #$ff
        sta $d40e
        sta $d40f
        lda #$80
        sta $d412   ; noise waveform

        lda #$be
        jsr clearcolorram
        
        sei 
        
mainlp  lda #$fc    ; wait for line $fc
wrst1   cmp $d012         
        bne wrst1

        jsr scroll       
        
        lda $dc01   ; spacebar pressed?
        cmp #$ff
        beq mainlp
        
        lda $d011   ; rest. scroll offs
        and #%11111000
        ora #%00000011
        sta $d011        

        lda $d018   ; restore original
                    ; screen mem if 
                    ; other was used
        and #%00001111
        ora #($0400 / $0400) * 16
        sta $d018

        cli 
        
        rts

; -------------------------------------
; Smooth scrolling
; -------------------------------------

scroll  ; change border colour to yellow
        ;lda #$7
        ;sta $d020         

        ; shift offset one pixel up
        lda $d011
        and #%111
        tax
        dex
        bmi scrovr  ; check overflow
        dec $d011
        jmp scrend
        
scrovr  lda $d011
        ora #%111
        sta $d011
        jsr shiftup
        jsr newline

scrend  ; change border colour to black
        ;lda #$0
        ;sta $d020         

        rts

newline ; fill last line with 
        ; random chars
        ldx #39
nllp    lda $d41b
        ror 
        lda #77
        adc #0
        sta screen1+(40*24),x
        dex
        bpl nllp
        rts

shiftup ; Shift the screen memory one 
        ; row up. We do this in blocks
        ; of 10*25 bytes.
        clc
        lda #0
slp1    tax
        lda screen1+40+000,x
        sta screen1+00+000,x
        lda screen1+41+000,x
        sta screen1+01+000,x
        lda screen1+42+000,x
        sta screen1+02+000,x
        lda screen1+43+000,x
        sta screen1+03+000,x
        lda screen1+44+000,x
        sta screen1+04+000,x
        lda screen1+45+000,x
        sta screen1+05+000,x
        lda screen1+46+000,x
        sta screen1+06+000,x
        lda screen1+47+000,x
        sta screen1+07+000,x
        lda screen1+48+000,x
        sta screen1+08+000,x
        lda screen1+49+000,x
        sta screen1+09+000,x
        txa 
        adc #10
        cmp #250
        bne slp1
        
        clc
        lda #0
slp2    tax
        lda screen1+40+250,x
        sta screen1+00+250,x
        lda screen1+41+250,x
        sta screen1+01+250,x
        lda screen1+42+250,x
        sta screen1+02+250,x
        lda screen1+43+250,x
        sta screen1+03+250,x
        lda screen1+44+250,x
        sta screen1+04+250,x
        lda screen1+45+250,x
        sta screen1+05+250,x
        lda screen1+46+250,x
        sta screen1+06+250,x
        lda screen1+47+250,x
        sta screen1+07+250,x
        lda screen1+48+250,x
        sta screen1+08+250,x
        lda screen1+49+250,x
        sta screen1+09+250,x
        txa 
        adc #10
        cmp #250
        bne slp2

        clc
        lda #0
slp3    tax
        lda screen1+40+500,x
        sta screen1+00+500,x
        lda screen1+41+500,x
        sta screen1+01+500,x
        lda screen1+42+500,x
        sta screen1+02+500,x
        lda screen1+43+500,x
        sta screen1+03+500,x
        lda screen1+44+500,x
        sta screen1+04+500,x
        lda screen1+45+500,x
        sta screen1+05+500,x
        lda screen1+46+500,x
        sta screen1+06+500,x
        lda screen1+47+500,x
        sta screen1+07+500,x
        lda screen1+48+500,x
        sta screen1+08+500,x
        lda screen1+49+500,x
        sta screen1+09+500,x
        txa 
        adc #10
        cmp #250
        bne slp3
        
        clc
        lda #0
slp4    tax
        lda screen1+40+750,x
        sta screen1+00+750,x
        lda screen1+41+750,x
        sta screen1+01+750,x
        lda screen1+42+750,x
        sta screen1+02+750,x
        lda screen1+43+750,x
        sta screen1+03+750,x
        lda screen1+44+750,x
        sta screen1+04+750,x
        lda screen1+45+750,x
        sta screen1+05+750,x
        lda screen1+46+750,x
        sta screen1+06+750,x
        lda screen1+47+750,x
        sta screen1+07+750,x
        lda screen1+48+750,x
        sta screen1+08+750,x
        lda screen1+49+750,x
        sta screen1+09+750,x
        txa 
        adc #10
        cmp #210      
        bne slp4
        rts

; -------------------------------------
; Misc routines
; -------------------------------------

clearcolorram
        ldx   #250
clrlp   dex ; Z flag set if last round
        sta   $d800+000,x
        sta   $d800+250,x
        sta   $d800+500,x
        sta   $d800+750,x
        bne   clrlp
        rts
