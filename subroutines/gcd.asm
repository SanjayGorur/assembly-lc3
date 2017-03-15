;;===============================
;; Name: Carina Claassen
;;===============================
  This program calculates the gcd (greatest common denominator) of two integers.


;@plugin filename=lc3_udiv vector=x80

.orig x3000
    LD R6, STACK

    ADD R6, R6, -2      ; make room for two arguments
    LD R1, A            ; R1 = A
    LD R2, B            ; R2 = B
    STR R1, R6, 0       ; store A as first argument
    STR R2, R6, 1       ; store B as second argument

    JSR GCD

    LDR R0, R6, 0       ; load answer
    ADD R6, R6, 2       ; restore R6
    ST R0, ANSWER       ; store answer

    HALT


A       .fill 20
B       .fill 16
ANSWER  .blkw 1
STACK   .fill xF000


GCD
    ADD R6, R6, -3      ; allocate return value, return address, and old frame pointer
    STR R7, R6, 1       ; store return value (R7) on stack
    STR R5, R6, 0       ; store frame pointer (R5) on stack as old frame pointer
    ADD R5, R6, -1      ; set R5 to point to one above the old frame pointer

    LDR R0, R5, 4       ; R0 = a
    LDR R1, R5, 5       ; R1 = b

    UDIV                ; R0 = a/b and R1 = a%b
    LDR R3, R5, 5       ; R3 = b

    ADD R1, R1, 0
    BRnp GCD_RECURSE    ; if R1 != 0, recurse

    STR R3, R5, 3       ; set return value to b
    BR TEARDOWN


GCD_RECURSE

    ADD R6, R6, -2
    STR R3, R6, 0       ; store b as first argument
    STR R1, R6, 1       ; store a%b from R1 as second argument

    JSR GCD
    LDR R0, R6, 0
    ADD R6, R6, 2
    STR R3, R5, 3       ; store result as return value


TEARDOWN
    ADD R6, R5, 3               ; Move down stack pointer to point to return value
    LDR R7, R5, 2               ; Restore return address
    LDR R5, R5, 1               ; Restore frame pointer
    RET 


.end
