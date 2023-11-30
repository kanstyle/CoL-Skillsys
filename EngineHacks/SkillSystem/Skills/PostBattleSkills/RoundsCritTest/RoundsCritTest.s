@used in post-battle skills to check battle rounds for crits by the attacker
@returns 1 in r0 if true, 0 in r0 if false

.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
@r0 is battle rounds data, which is at 0x203AAC0
push {r4, lr}
mov r4, r0 @rounds data in r4

RoundsLoop:
ldr r2, [r4]
mov r0, #0x0
tst r0, r2
beq End

@mov r1, #0
@tst r1,[r4] @tests whether the bit of the battle buffer at 0x8 is equal to 1, which means it's not a crit
@beq NextRound @if so, check the next round

ldr r2, [r4]
mov r0, #0x8 @Retaliation bit
tst r0, r2
beq NextRound

@mov r1, #1
@tst r1, [r4, #0x8] @tests whether the bit of the battle buffer at 0x8 is equal to 1, which means the defender is attacking
b@eq NextRound @if so, check the next round

b True @if it's NOT the defender, and NOT not a crit, exit loop and return true

NextRound:
ldr r0, r4 @0x203AAC0 + 0xE0, end of rounds data, aka "8th round"
add r0, #0xE0
add r4, #0x20 @increment the bit to check by #0x20, which is 32, so that it checks the next round
tst r0, r4 @check if the bit to check is greater than or equal to #0x203ABA0, and if not, go back to RoundsLoop
bge RoundsLoop

False:
mov r0, #0
pop {r4, pc}

True:
mov r0, #1
pop {r4, pc}

.ltorg 

RoundsCritTest:
@POIN RoundsCritTest