;;===============================
;; Name: Carina Claassen
;;===============================
   This function parses an int (either in decimal or hex) input as characters to the computer.

.orig x3000
    LD R6, STACK

    JSR PARSE_INT   ; call PARSE_INT with no arguments
    LDR R0, R6, 0   ; load return value
    ADD R6, R6, 1   ; pop return value of stack
    ST R0, ANSWER   ; store answer

    HALT


ANSWER              .blkw 1
STACK               .fill xF000


; ======================== PARSE_INT ========================

PARSE_INT

    ; Note: GETC stores in R0, so using it for other variables may overwrite those variables

    ADD R6, R6, -3      ; allocate return value, return address, and old frame pointer
    STR R7, R6, 1       ; store return address (R7) on stack
    STR R5, R6, 0       ; store frame pointer (R5) on stack as old frame pointer
    ADD R5, R6, -1      ; set R5 to point to one above the old frame pointer

    AND R1, R1, 0       ; R1 = result = 0
    AND R2, R2, 0       ; R2 = isHex = 0

    ADD R6, R6, -2      ; make room for two local variables on stack
    STR R1, R6, 1       ; store result on stack as first local variable

    GETC
    OUT
    ADD R2, R0, -15     ; subtract 120 from the character
    ADD R2, R2, -15
    ADD R2, R2, -15
    ADD R2, R2, -15
    ADD R2, R2, -15
    ADD R2, R2, -15
    ADD R2, R2, -15
    ADD R2, R2, -15     ; if R2 is 0, then isHex is true
    BRnp PI_NOTHEX

    ADD R2, R2, 1       ; set isHex = 1
    STR R2, R6, 0       ; store isHex on stack
    GETC
    OUT
    BR PI_LOOP


PI_NOTHEX

    AND R2, R2, 0
    STR R2, R6, 0       ; store isHex on stack as second local variable

    BRp PI_LOOP

PI_LOOP

    LDR R2, R6, 0       ; load isHex into R2
    BRp PI_AS_HEX       ; if parseHex, parse as hex. otherwise continue as decimal

    ADD R6, R6, -2      ; make space for two arguments
    STR R1, R6, 0       ; store result as first argument
    STR R0, R6, 1       ; store character in R0 as second argument
    LD R4, PARSE_DECIMAL_ADDR
    JSRR R4
    BR PI_CONTINUE


PI_AS_HEX
    ADD R6, R6, -2      ; make space for two arguments
    STR R1, R6, 0       ; store result as first argument
    STR R0, R6, 1       ; store character in R0 as second argument
    LD R4, PARSE_HEX_ADDR
    JSRR R4


PI_CONTINUE
    ADD R6, R6, 3
    LDR R1, R6, -3      ; load result into R1
    ADD R3, R1, 1
    Brz RETURN_INT      ; if -1, return current result without updating
    STR R1, R6, 1       ; update result on stack

    GETC
    OUT
    BR PI_LOOP


RETURN_INT
    LDR R1, R6, 1       ; restore result into R1
    STR R1, R5, 3       ; store answer as return value

TEARDOWN
    ADD R6, R5, 3       ; move down stack pointer to point to return value
    LDR R7, R5, 2       ; restore return address
    LDR R5, R5, 1       ; restore frame pointer
    RET                 ; return to caller


PARSE_DECIMAL_ADDR  .fill x5000     ; the address of the ParseDecimal function
PARSE_HEX_ADDR      .fill x6000     ; the address of the ParseHex function

.end


; =========================== MULT ==========================

.orig x4000
MULT

    ADD R6, R6, -3      ; allocate return value, return address, and old frame pointer
    STR R7, R6, 1       ; store return address (R7) on stack
    STR R5, R6, 0       ; store frame pointer (R5) on stack as old frame pointer
    ADD R5, R6, -1      ; set R5 to point to one above the old frame pointer

    AND R3, R3, 0       ; R3 = answer = 0
    LDR R1, R5, 4       ; R1 = a
    LDR R2, R5, 5       ; R2 = b
    BRz MULT_TEARDOWN

LOOP
    ADD R3, R3, R1      ; result += a
    ADD R2, R2, -1      ; b--
    BRp LOOP

MULT_TEARDOWN
    STR R3, R5, 3       ; store return value
    ADD R6, R5, 3       ; move down stack pointer to point to return value
    LDR R7, R5, 2       ; restore return address
    LDR R5, R5, 1       ; restore frame pointer
    RET                 ; return to caller

.end


; ====================== PARSE_DECIMAL ======================

.orig x5000
PARSE_DECIMAL

    ADD R6, R6, -3      ; allocate return value, return address, and old frame pointer
    STR R7, R6, 1       ; store return value (R7) on stack
    STR R5, R6, 0       ; store frame pointer (R5) on stack as old frame pointer
    ADD R5, R6, -1      ; set R5 to point to one above the old frame pointer

    LDR R1, R5, 4       ; R1 = acc
    LDR R2, R5, 5       ; R2 = c

    ADD R2, R2, -16     ; subtract 48 to convert character from ASCII to its number value
    ADD R2, R2, -16
    ADD R2, R2, -16

    BRn PD_SKIP         ; skip if c < 0
    ADD R3, R2, -9      ; c - 9
    BRp PD_SKIP         ; skip if c > 9

    ADD R6, R6, -2      
    STR R1, R6, 0       ; store acc as 1st arg
    AND R3, R3, 0
    ADD R3, R3, 10      ; store 10 as 2nd arg
    STR R3, R6, 1
    LD R4, PD_MULT_ADDR
    JSRR R4    

    LDR R4, R6, 0       ; load result
    LDR R2, R5, 5       ; retrieve c
    ADD R2, R2, -16     ; subtract 48 to convert character from ASCII to its number value
    ADD R2, R2, -16
    ADD R2, R2, -16
    ADD R4, R4, R2      ; result += c
    STR R4, R5, 3       ; store return value 
    BR PD_TEARDOWN

PD_SKIP
    AND R3, R3, 0
    ADD R3, R3, -1      ; R3 = -1
    STR R3, R5, 3       ; store return value

PD_TEARDOWN
    ADD R6, R5, 3       ; Move down stack pointer to point to return value
    LDR R7, R5, 2       ; Restore return address
    LDR R5, R5, 1       ; Restore frame pointer
    RET                 ; Return to caller (parent Sumtorial or Main)


PD_MULT_ADDR    .fill x4000         ; the address of the Mult function
.end


; ======================== PARSE_HEX ========================

.orig x6000
PARSE_HEX

    ADD R6, R6, -3      ; allocate return value, return address, and old frame pointer
    STR R7, R6, 1       ; store return value (R7) on stack
    STR R5, R6, 0       ; store frame pointer (R5) on stack as old frame pointer
    ADD R5, R6, -1      ; set R5 to point to one above the old frame pointer

    LDR R1, R5, 4       ; R1 = acc
    LDR R2, R5, 5       ; R2 = c

    ADD R2, R2, -16     ; subtract 48 to convert character from ASCII to its number value
    ADD R2, R2, -16
    ADD R2, R2, -16

    BRn PH_SKIP         ; skip if c < 0
    ADD R3, R2, -9      ; c - 9
    BRnz CALCULATE_NUM  ; skip if c > 9

    ADD R3, R3, -8      ; subtract 8 so that A == 0
    BRn PH_SKIP         ; skip if c < A
    ADD R3, R3, -5      ; c - 15
    BRp PH_SKIP         ; skip if c > F


CALCULATE_LETTER
    ADD R6, R6, -2      
    STR R1, R6, 0       ; store acc as 1st arg
    AND R3, R3, 0
    ADD R3, R3, 8       ; store 16 as 2nd arg
    ADD R3, R3, 8
    STR R3, R6, 1
    LD R4, PH_MULT_ADDR
    JSRR R4    

    LDR R4, R6, 0       ; load result
    LDR R2, R5, 5       ; retrieve c
    ADD R2, R2, -16     ; subtract 55 to convert character from ASCII to its number value
    ADD R2, R2, -16
    ADD R2, R2, -16
    ADD R2, R2, -7      ; 
    ADD R4, R4, R2      ; result += c
    STR R4, R5, 3       ; store return value 
    BR PH_TEARDOWN


CALCULATE_NUM
    ADD R6, R6, -2      
    STR R1, R6, 0       ; store acc as 1st arg
    AND R3, R3, 0
    ADD R3, R3, 8       ; store 16 as 2nd arg
    ADD R3, R3, 8
    STR R3, R6, 1
    LD R4, PH_MULT_ADDR
    JSRR R4    

    LDR R4, R6, 0       ; load result
    LDR R2, R5, 5       ; retrieve c
    ADD R2, R2, -16     ; subtract 48 to convert character from ASCII to its number value
    ADD R2, R2, -16
    ADD R2, R2, -16
    ADD R4, R4, R2      ; result += c
    STR R4, R5, 3       ; store return value 
    BR PH_TEARDOWN

PH_SKIP
    AND R3, R3, 0
    ADD R3, R3, -1      ; R3 = -1
    STR R3, R5, 3       ; store return value

PH_TEARDOWN
    ADD R6, R5, 3       ; Move down stack pointer to point to return value
    LDR R7, R5, 2       ; Restore return address
    LDR R5, R5, 1       ; Restore frame pointer
    RET                 ; Return to caller (parent Sumtorial or Main)




PH_MULT_ADDR    .fill x4000         ; the address of the Mult function
.end
