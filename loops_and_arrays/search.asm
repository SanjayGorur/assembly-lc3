;;===============================
;; Name: Carina Claassen
;;===============================
;; This program searches for a certain value in an array.


.orig x3000

;-----initialize variables-----

    AND R0, R0, 0           ; R0 will be the counter
    LD R2, LENGTH           ; load length into R2
    ADD R0, R0, R2          ; intialize counter to length
    AND R1, R1, 0           ; R1 will hold the result
    LD R3, NUMBER           ; R3 will hold the number searched for


;-----loop-----

LOOP
    ADD R0, R0, -1          ; counter--
    BRn NOTFOUND            ; counter < 0 means number not found

    LD R6, ARRAY            ; store array memory address in R6
    ADD R6, R6, R0          ; add counter to memory address
    LDR R6, R6, 0           ; load value content into R6
    NOT R6, R6              ; get negative of value
    ADD R6, R6, 1
    ADD R7, R3, R6          ; zero if match

    BRz FOUND               ; match
    BR LOOP                 ; no match yet, loop again


;-----found-----

FOUND
    AND R4, R4, 0           ; clear R4
    ADD R4, R4, 1           ; set R4 to 1
    ST R4, RESULT           ; store 1 in result
    HALT


;-----not found-----

NOTFOUND
    AND R4, R4, 0           ; clear R4
    ST R4, RESULT           ; store 0 in result
    HALT



ARRAY   .fill x6000
LENGTH  .fill 20
NUMBER  .fill 15
RESULT  .fill 0
.end

.orig x6000
.fill 1
.fill 2
.fill 733
.fill 44
.fill 9
.fill 7
.fill 12
.fill 80
.fill 3
.fill 64
.fill 21
.fill 10
.fill 90
.fill 7
.fill 15
.fill 12
.fill 377
.fill 65
.fill 7
.fill 42
.end
