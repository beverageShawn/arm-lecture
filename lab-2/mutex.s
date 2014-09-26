	.syntax unified
	.arch armv7-a
	.text

	.equ locked, 1
	.equ unlocked, 0

	.global lock_mutex
	.type lock_mutex, function
lock_mutex:
        @ INSERT CODE BELOW
	ldr r1, =locked			@initialize r1 as a note as locked
.try:
	ldrex r2, [r0] 				@ load value in the address of r0, 
						     		@ and initialize the exclusive monitor as exclusive state
	cmp r2, #0					@ check if the key value is 0 (unlocked) or not
								@ if the value is 1, means some had gotten the lock
								@ needless to do the following step, and go to branch
		strexeq r2, r1, [r0]	@ instruction-eq means if the pre-comparison result is passed
								@ to see other "accessed" exclusive monitors are "all" in exclusive state
								@ if yes, then claim the lock by store r1 (value 1) into address of r0
								@ also, set r2 = 0, means succeed, otherwise, fail, r2 = 1, cancle the store action
		cmpeq r2, #0			@ to see if we succeed to claim the lock
		bne .try				@ if the result is failed try again (spin)
		
        @ END CODE INSERT
	bx lr

	.size lock_mutex, .-lock_mutex

	.global unlock_mutex
	.type unlock_mutex, function
unlock_mutex:
	@ INSERT CODE BELOW
	ldr r1, =unlocked		@ initialize r2 as a note as unlocked
	str r1, [r0]					@ set the address of r0 as value of r1 (unlocked) to release the lock
	
        
        @ END CODE INSERT
	bx lr
	.size unlock_mutex, .-unlock_mutex

	.end
