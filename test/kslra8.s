#Test 1 (0x10101010 << 3 = 0xF7F7F7F7)
lui x1, 0x10101
addi x1, x1, 0x010

lui x2, 0x00000
addi x2, x2, -3

#kslra8 x3, x1, x2
addi x10, x3, 0

#Test 2 (0x10101010 << -3 = 0x02020202)
