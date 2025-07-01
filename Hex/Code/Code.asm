     	lw $r1, grupo*0x0120+1($r31)              ;		r1 ← Mem[i + Número do Grupo * 0120,h]
        lw $r2, grupo*0x0120+2($r31)              ;		r2 ← Mem[i + Número do Grupo * 0120,h]  
        lw $r3, grupo*0x0120+3($r31)              ;		r3 ← Mem[i + Número do Grupo * 0120,h] 
        lw $r4, grupo*0x0120+4($r31)              ;		r4 ← Mem[i + Número do Grupo * 0120,h] 
        lw $r5, grupo*0x0120+5($r31)              ;		r5 ← Mem[i + Número do Grupo * 0120,h] 
        lw $r6, grupo*0x0120+6($r31)              ;		r6 ← Mem[i + Número do Grupo * 0120,h] 
        


        add $r10, $r2, $r3                     ;		r10 ← r2 + r3 = 5
        add $r11, $r4, $r5                     ;		r11 ← r4 + r5 = 9
        add $r12, $r2, $r5                     ;		r12 ← r2 + r5 = 7
        


        
        sw $r10, grupo*0x0120+1021($r31)         ;	MemDados[antepenultima posição RAM]   [r10]  
        sw $r11, grupo*0x0120+1022($r31)         ;	MemDados[penultima posição RAM]       [r11]
        sw $r12, grupo*0x0120+1023($r31)         ;	MemDados[ultima posição RAM]          [r12]

        mul $r13, $r10, $r11;



        lw $r7,  grupo*0x0120+1021($r31)         ;  r7 ←  MemDados[antepenultima posição RAM]
        lw $r8,  grupo*0x0120+1022($r31)         ;  r8 ←  MemDados[penultima posição RAM]
        lw $r9,  grupo*0x0120+1023($r31)         ;  r9 ←  MemDados[ultima posição RAM]
