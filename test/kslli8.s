#Test 1 (0x10101010 << 3 = 0xF7F7F7F7)
lui x1, 0x10101
addi x1, x1, 0x010

kslli8 x3, x1, 0x011
addi x10, x3, 0

#Test 2 (0x10101010 << 2 = 0x40404040)
#Test 3 (0x80808080 << 2 = 0x80808080)
#Test 4 (0x90909090 << 1 = 0xA0A0A0A0)
