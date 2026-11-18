# Hexadecimal values. Reset before running.
# Expected OUT sequence: D0, 401, 80.

.ORG 0
10 # Reset vector

.ORG 2
900 # Software INT 0 vector; unused by this branch test

.ORG 900
IN R7 # R7=5
AND R0,R0,R0
OUT R3
RTI
ADD R1,R2,R3 # Must be flushed after RTI

.ORG 10
IN R1 # R1=30
IN R2 # R2=50
IN R3 # R3=100
IN R4 # R4=300
PUSH R4 # Save 300 on the stack
JMP 30
INC R1 # Must be flushed after JMP

# A taken JZ consumes the zero flag.
.ORG 30
AND R5,R1,R5 # R5=0, Z=1
JZ 50 # Taken; clears Z
SETC # Must be flushed

.ORG 50
JZ 30 # Not taken: the previous JZ cleared Z
NOT R5 # R5=FFFFFFFF, N=1, Z=0
SUB R7,R5,R5 # R7=0, N=0, Z=1
IN R1 # R1=60
JZ 60 # Taken; IN preserves Z
ADD R1,R2,R3 # Must be flushed

.ORG 60
IN R1 # R1=70
JZ 70 # Not taken
JMP 70
INC R1 # Must be flushed

# Stack operations preserve the flags produced by SUB.
.ORG 70
IADD R1,R1,10 # R1=80
SUB R7,R1,R1 # Z=1
PUSH R1
POP R1 # R1=80
JZ 80 # Taken
INC R1 # Must be flushed

.ORG 80
IN R6 # R6=700
JMP 700

# CALL must resume at INC R6 after the subroutine returns.
.ORG 700
ADD R7,R0,R1 # R7=80
POP R6 # Restore 300 from the stack
CALL 300
INC R6 # R6=401 after return
NOP
NOP
OUT R1 # D0
OUT R6 # 401
OUT R7 # 80
HLT

.ORG 300
ADD R6,R3,R6 # R6=400
ADD R1,R1,R2 # R1=D0
RET
ADD R1,R1,R1 # Must be flushed after RET

.ORG 500
NOP
NOP
