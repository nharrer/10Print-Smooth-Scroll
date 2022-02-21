;startup address
* = $0801

;create BASIC startup (SYS line)
!basic

; init sid max freq
      lda #$ff
      sta $d40e
      sta $d40f
      lda #$80
      sta $d412 ; noise waveform

loop  lda $d41b
      ror 
      lda #205
      adc #0
      jsr $ffd2
      ;inc $d020
      jmp loop
