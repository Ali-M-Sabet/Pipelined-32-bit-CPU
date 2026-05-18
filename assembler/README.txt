File structure
assembler/
│
├── assembler.py          # Main assembler code
├── README.md             # How to use the assembler
├── test.asm              # Example assembly program
└── program.mem           # Generated output, created in this same/root folder

How to run
Open a terminal in the assembler folder, then run:

python assembler.py test.asm
This generates:

program.mem
To choose another output name:

python assembler.py test.asm -o my_program.mem
To also generate a binary debug file:

python assembler.py test.asm --bin
That creates:

program.mem
program.bin
To force the memory file to contain the full 4096 words:

python assembler.py test.asm --fill-to 4096