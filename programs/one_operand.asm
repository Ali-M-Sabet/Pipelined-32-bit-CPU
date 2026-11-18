# Hexadecimal values. Reset clears the registers before running.
# Expected OUT sequence: 6, FFFFFFEF, FFFFFFF0.

.ORG 0
A0 # Reset vector

.ORG A0
NOP
NOT R1 # R1=FFFFFFFF, N=1, Z=0; carry preserved
INC R1 # Wraps to zero: C=1, N=0, Z=1

IN R1 # R1=5; flags preserved
IN R2 # R2=10; flags preserved
NOT R2 # R2=FFFFFFEF; carry preserved
INC R1 # R1=6, C=0, N=0, Z=0
OUT R1 # 6
OUT R2 # FFFFFFEF

SETC # C=1; N and Z preserved
INC R2 # R2=FFFFFFF0, C=0, N=1, Z=0
OUT R2 # FFFFFFF0
HLT
