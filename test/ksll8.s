#Test 1 (0x10101010 << 3 = 0xF7F7F7F7)
lui x1, 0x10101
addi x1, x1, 0x010

lui x2, 0x00000
addi x2, x2, 3

ksll8 x3, x1, x2
addi x10, x3, 0


#Test 2 (0x10101010 << 2 = 0x40404040)
lui x1, 0x10101
addi x1, x1, 0x010

lui x2, 0x00000
addi x2, x2, 2

ksll8 x3, x1, x2
addi x10, x3, 0

#Test 3 (0x80808080 << 3 = 0x80808080)
lui x1, 0x80808
addi x1, x1, 0x080

lui x2, 0x00000
addi x2, x2, 2

ksll8 x3, x1, x2
addi x10, x3, 0

#Test 4 (0x90909090 << 1 = 0xA0A0A0A0)
lui x1, 0x90909
addi x1, x1, 0x090

lui x2, 0x00000
addi x2, x2, 1

ksll8 x3, x1, x2
addi x10, x3, 0
