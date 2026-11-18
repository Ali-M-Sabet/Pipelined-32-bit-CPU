# Hexadecimal values. Reset clears the registers before running.
# Expected OUT sequence: FFFFFFFF, 18, 5, 1F, 5.

.ORG 0
FF # Reset vector

.ORG FF
IN R1 # R1=5
IN R2 # R2=19
IN R3 # R3=FFFFFFFF
IN R4 # R4=FFFFF320
MOV R5,R3 # R5=FFFFFFFF; flags preserved
ADD R4,R1,R4 # R4=FFFFF325, C=0, N=1, Z=0
SUB R6,R5,R4 # R6=CDA, C=1 (no borrow), N=0, Z=0
AND R4,R7,R4 # R4=0, N=0, Z=1; carry preserved

# IADD sign-extends FFFF to -1. The next ADD uses the swapped value.
IADD R2,R2,FFFF # R2=18, C=1, N=0, Z=0
SWAP R2,R4 # R2=0, R4=18
ADD R2,R1,R2 # R2=5
ADD R6,R4,R2 # R6=1D
IADD R6,R6,2 # R6=1F
AND R3,R2,R6 # R3=5

OUT R5 # FFFFFFFF
OUT R4 # 18
OUT R2 # 5
OUT R6 # 1F
OUT R3 # 5
HLT
