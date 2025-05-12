#Test 1: 0x40000000 << 2 --> 0x7FFFFFFF (saturation)
lui x1, 0x40000
addi x1, x1, 0
lui x2, 0x00000
addi x2, x2, 2
#kslraw x3, x1, x2
addi x10, x3, 0

#Test 2: 0x10101010 >> 3 --> 0x02020202
lui x1, 0x10101
addi x1, x1, 0x010
lui x2, 0x00000
addi x2, x2, -3
#kslraw x3, x1, x2
addi x10, x3, 0

#Test 3: 0x00000001 << 31 --> 0x7F7F7F7F
lui x1, 0x00000
addi x1, x1, 1
lui x2, 0x00000
addi x2, x2, 31
#kslraw x3, x1, x2
addi x10, x3, 0

#Test 4: 0xF0000000 >> 4 --> 0xFF000000
lui x1, 0xF0000
addi x1, x1, 0
lui x2, 0x00000
addi x2, x2, -4
#kslraw x3, x1, x2
addi x10, x3, 0
