;;===============================
;; Name: Carina Claassen
;;===============================
;; Write a program to print out a pyramid to the console.


.orig x3000


;-----initialize variables-----

    AND R1, R1, 0           ; R1 --> current
    ADD R1, R1, 1           ; current = 1

    LD R2, LEVELS           ; R2 --> levels

    AND R3, R3, 0           ; R3 --> spaces
    ADD R3, R3, R2          ; spaces += levels
    NOT R6, R1
    ADD R6, R6, 1
    ADD R3, R3, R6          ; spaces -= current

    AND R4, R4, 0           ; R4 --> stars
    ADD R4, R4, 1           ; stars = 1

    AND R5, R5, 0           ; R5 --> counter


;-----loop for line in pyramid-----

LOOP
    NOT R6, R1
    ADD R6, R6, 1
    ADD R6, R2, R6          ; R6 = levels - current
    BRn DONE                ; if negative, done


;-----inner loop for character in each line-----

SPACELOOP
    NOT R6, R3       
    ADD R6, R6, 1
    ADD R6, R5, R6          ; counter - spaces

    BRn PRINTSPACE          ; space if counter < spaces

    AND R5, R5, 0           ; counter = 0
    ADD R3, R3, -1          ; spaces--

STARLOOP
    NOT R6, R4
    ADD R6, R6, 1
    ADD R6, R5, R6          ; counter - stars

    BRn PRINTSTAR

    AND R0, R0, 0           ; clear R0
    ADD R0, R0, 10          ; ascii code for \n is 10
    OUT                     ; print \n

    AND R5, R5, 0           ; counter = 0
    ADD R4, R4, 2           ; stars += 2

    ADD R1, R1, 1           ; current++
    BR LOOP             ; loop again


;-----print spaces-----

PRINTSPACE
    AND R0, R0, 0           ; clear R0
    ADD R0, R0, 15          ; ascii code for space is 32
    ADD R0, R0, 15
    ADD R0, R0, 2
    OUT                     ; print space

    ADD R5, R5, 1
    BR SPACELOOP


;-----print stars-----

PRINTSTAR
    AND R0, R0, 0           ; clear R0
    ADD R0, R0, 15          ; ascii code for star is 42
    ADD R0, R0, 15
    ADD R0, R0, 12
    OUT                     ; print star

    ADD R5, R5, 1
    BR STARLOOP


;-----when loop is done-----

DONE
    HALT




LEVELS  .fill 10
.end
