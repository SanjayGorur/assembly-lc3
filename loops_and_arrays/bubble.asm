;;===============================
;; Name: Carina Claassen
;;===============================
;; This program sorts an array in ascending order.


.orig x3000

    LD R1, LENGTH           ; R1 --> k = length


LOOP 
    ADD R1, R1, -1          ; k--
    BRz DONE                ; done if k == 0

    ;AND R3, R3, 0           ; R3 --> isSorted = 0
    AND R2, R2, 0        ; clear R2
    LD R2, LENGTH            ; R2 --> index = length - 1
    ADD R2, R2, -1


INNERLOOP
    LD R0, ARRAY            ; R0 --> address of ARRAY
    ADD R4, R0, R2          ; R4 --> address ARRAY[index]
    LDR R5, R4, 0           ; R5 --> valueN
    ADD R6, R4, -1          ; R6 --> address ARRAY[index - 1]
    LDR R7, R6, 0           ; R7 --> valueN-1

    NOT R0, R7              ; make valueN-1 negative
    ADD R0, R0, 1
    ADD R0, R0, R5          ; valueN - valueN-1
    BRn SWITCH              ; if < 0, switch values


CONTINUE
    ADD R2, R2, -1          ; index--
    LD R0, LENGTH           
    ADD R0, R0, -1          ; R0 --> length - 1
    AND R4, R4, 0           ; clear R4
    ADD R4, R4, R2          ; R4 --> -index
    NOT R4, R4
    ADD R4, R4, 1
    ADD R0, R0, R4          ; R0 --> length - 1 - index
    AND R6, R6, 0           ; clear R6
    ADD R6, R6, R1      ; R6 --> -k
    NOT R6, R6
    ADD R6, R6, 1 
    ADD R6, R6, R0          ; R7 --> length - 1 + index - k
    BRz LOOP                ; inner loop done if the above == 0

    BR INNERLOOP


SWITCH
    STR R5, R6, 0
    STR R7, R4, 0
    BR CONTINUE


DONE
    HALT



ARRAY   .fill x6000
LENGTH  .fill 7
.end

;; This array should be sorted when finished
.orig x6000
.fill 7
.fill 6
.fill 5
.fill 4
.fill 3
.fill 2
.fill 1
.end
