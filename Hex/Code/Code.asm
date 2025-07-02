                                                ;		Code presents data hazzard
Main:	ori $r30, 32($r0)                   	;		r30 ← 32 (vector size)							
		ori $r10, 0($r0)                        ;		r10 ← 0	
		ori $r31, 0($r0)                        ;		r31	← 0	(auxiliary counter to sweep vector)	
        add $r18, $r30, $r0                 	;       only to verify if ori $r30, 32($r0) works
Loop:	lw $r1, grupo*0x0125($r31)          	;		r1 ← Mem[i + Número do Grupo * 0250h] 
		addi $r31, 1($r31)                      ;		i = i + 1  
		add $r10, $r1, $r10                     ;		r10 ← r1 + r10 (cumulative sum of nth vector value)
		bne $r31, $r30, Loop                    ;   	if r31 != r30 then PC ← Loop Address
		sw $r10, grupo*0x0125+1023($r15)        ;		MemDados[ultima posição RAM] ←  [r10]
												;
												;		Code solves data hazzard by adding bubbles
		ori $r31, 0($r0)                        ;		r10 ← 0	
		ori $r10, 0($r0)                        ;		r31	← 0	(auxiliary counter to sweep vector)	
        ori $r13, 0x00FF($r0)               	;       r13 ← 0x00FF (constant to multiply vector sum)
Loop1: 	lw $r1, grupo*0x0125($r31)              ;       r1 ← Mem[i + Número do Grupo * 0250h] 
		addi $r31, 1($r31)                      ;		i = i + 1  
		                                        ;		NOP as bubble
		                                        ;		NOP as bubble
		add $r10, $r1, $r10                     ;		r10 ← r1 + r10 (cumulative sum of nth vector value)
                                                ;		NOP as bubble
		                                        ;		NOP as bubble
		bne $r31, $r30, Loop1                   ;		if r31 != r30 then PC ← Loop1 Address
       	mul $r20, $r10, $r13                    ;      	r20 ← sum * 0x00FF
                                                ;       NOP as bubble
                                                ;      	NOP as bubble
		sw $r20, grupo*0x0125+1023($r15)        ;		MemDados[ultima posição RAM] ←  [r10]
		                                        ;
		jmp Main                                ;		PC ← Main Address
