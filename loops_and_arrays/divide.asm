;;===============================
;; Name: Carina Claassen
;;===============================
;; This program divides two non-negative numbers A and B.


.orig x3000

;-----initialize variables-----

    AND R3, R3, 0               ; R3 will store the quotient
    LD R1, A                    ; R1 will store A
    LD R2, B                    ; R2 will store B
    NOT R2, R2                  ; inverse B
    ADD R2, R2, 1               ; B is now negative

    BRz BZERO                   ; end if B == 0


;-----subtraction loop-----

SUBTRACT 
    ADD R1, R1, R2              ; A = A - B      
    
    BRn RETURN;                 ; if A < 0 we are done
    ADD R3, R3, 1               ; quotient++
    BR SUBTRACT                 ; loop again


;-----return quotient and remainder-----

RETURN 
    NOT R2, R2                  ; make B positive
    ADD R2, R2, 1   
    ADD R1, R1, R2              ; add positive B back to negative A
    ST R1, REMAINDER            ; A is the remainder now
    ST R3, QUOTIENT             ; set quotient variable
    HALT
    

;-----edge case if B == 0-----

BZERO 
    AND R0, R0, 0               ; clear R0
    ST R0, REMAINDER            ; set remainder to 0
    NOT R0, R0                  ; set R0 to -1
    ST R0, QUOTIENT             ; set quotient to -1
    HALT                        ; exit


A   .fill 1
B   .fill 2
QUOTIENT    .fill 2
REMAINDER   .fill 2
.end
