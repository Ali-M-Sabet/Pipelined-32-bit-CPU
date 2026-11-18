# Hexadecimal values. Reset before running.
# Expected OUT sequence: 19, 1E, 19, 5, 10.

.ORG 0
300 # Reset vector

.ORG 300
IN R2 # R2=19
IN R3 # R3=FFFFFFFF
IN R4 # R4=FFFFF320
LDM R1,5

# PUSH writes at SP before decrementing; POP increments SP before reading.
PUSH R1 # M[FFF]=5, SP=FFE
PUSH R2 # M[FFE]=19, SP=FFD
POP R1 # R1=19, SP=FFE
POP R2 # R2=5, SP=FFF
ADD R5,R2,R1 # R5=1E; uses the preceding POP result

IN R5 # R5=10
STD R2,200(R5) # M[210]=5
STD R1,201(R5) # M[211]=19
LDD R3,201(R5) # R3=19
LDD R4,200(R5) # R4=5
ADD R5,R4,R3 # R5=1E; uses both loaded values

# A loaded value becomes the next load's base address, then an ADD operand.
IN R5 # R5=10
IN R2 # R2=19
STD R4,200(R2) # M[219]=5
LDD R3,201(R5) # R3=19
LDD R2,200(R3) # R2=5
ADD R2,R2,R3 # R2=1E

OUT R1 # 19
OUT R2 # 1E
OUT R3 # 19
OUT R4 # 5
OUT R5 # 10
HLT
