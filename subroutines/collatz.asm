;;===============================
;; Name: Carina Claassen
;;===============================
  This is a recursive function with input n that returns n/2 if n is even and 3n+1 if n is odd. base case: return 0 when n is 1.


;@plugin filename=lc3_udiv vector=x80

.orig x3000
    LD R6, STACK

    ADD R6, R6, -1      ; make room for one argument
    LD R1, N            ; R1 = N
    STR R1, R6, 0       ; store N as argument

    JSR COLLATZ         ; call Collatz

    LDR R0, R6, 0       ; load answer
    ADD R6, R6, 2       ; restore R6
    ST R0, ANSWER       ; store answer

    HALT


N       .fill 8
ANSWER  .fill 0
STACK   .fill xF000


COLLATZ
    
    ADD R6, R6, -3      ; allocate return value, return address, and old frame pointer
    STR R7, R6, 1       ; store return value (R7) on stack
    STR R5, R6, 0       ; store frame pointer (R5) on stack as old frame pointer
    ADD R5, R6, -1      ; set R5 to point to one above the old frame pointer

    LDR R0, R5, 4       ; R0 = N

    ADD R1, R0, -1      ; if R0 - 1 == 0, return 0 on branch ONE
    BRz ONE

    AND R1, R1, 0
    ADD R1, R1, 2
    UDIV                ; R0 = n / 2, R1 = n % 2

    ADD R1, R1, 0   
    BRz EVEN            ; if number is even, branch to even. otherwise continue with odd

    LDR R0, R5, 4       ; load N into R0
    AND R2, R2, 0       ; clear R2 to hold var c
    ADD R2, R2, R0      ; m = N
    ADD R2, R2, R0      ; m = 2 * N
    ADD R2, R2, R0      ; m = 3 * N
    ADD R2, R2, 1       ; m = 3 * N - 1


    ADD R6, R6, -1
    STR R2, R6, 0       ; store m as argument

    JSR COLLATZ
    LDR R0, R6, 0       ; load return value c
    ADD R0, R0, 1       ; c + 1
    ADD R6, R6, 1
    STR R0, R5, 3       ; store c as return value

    BR TEARDOWN


EVEN
    ADD R6, R6, -1
    STR R0, R6, 0       ; store contents of R0 in argument

    JSR COLLATZ
    LDR R0, R6, 0       ; load return value c
    ADD R0, R0, 1       ; c + 1
    ADD R6, R6, 1
    STR R0, R5, 3       ; store c as return value

    BR TEARDOWN


ONE
    STR R1, R5, 3       ; set return value to 0


TEARDOWN
    ADD R6, R5, 3               ; Move down stack pointer to point to return value
    LDR R7, R5, 2               ; Restore return address
    LDR R5, R5, 1               ; Restore frame pointer
    RET 


.end
