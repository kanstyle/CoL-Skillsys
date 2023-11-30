.thumb

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

.equ PetrifyID, SkillTester+4
.equ d100Result, 0x802a52c
.equ NextRN_N, 0x8000c80

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
push {r4-r7,lr}
mov r4, r0 @attacker
mov r5, r1 @defender
mov r6, r2 @battle buffer
mov r7, r3 @battle data
ldr     r0,[r2]           @r0 = battle buffer                @ 0802B40A 6800     
lsl     r0,r0,#0xD                @ 0802B40C 0340     
lsr     r0,r0,#0xD        @Without damage data                @ 0802B40E 0B40     
mov r1, #0xC0 @miss flag
lsl r1, #8 @0xC000
tst r0, r1
bne End
@if another skill already activated, don't do anything

@check if user has deadeye
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, PetrifyID
.short 0xf800
cmp r0, #0
beq End
@if user has deadeye, check for proc rate

ldr r2, [r6] @check whether to proc the skill based on whether or not it's a crit
mov r1, #1
tst r1, r2 @tests whether the first bit of the battle buffer is equal to 1, which means whether or not it's a crit
beq End

@ldrb r0, [r4, #0x15] @skill stat as activation rate @this would check skill activation rate, but we're checking crit instead
@mov r1, r4 @skill user
@blh d100Result
@cmp r0, #1
@bne End

@if we proc, set the offensive skill flag - and unset the miss flag.
ldr     r2,[r6]    
lsl     r1,r2,#0xD                @ 0802B42C 0351     
lsr     r1,r1,#0xD                @ 0802B42E 0B49     
mov     r0,#0x2          @miss flag     @ 0802B430 2002  
mvn  r0, r0
and     r1,r0            @unset it
mov     r0, #0x40
lsl     r0, #8           @0x4000, attacker skill activated
orr     r1, r0
ldr     r0,=#0xFFF80000                @ 0802B434 4804     
and     r0,r2                @ 0802B436 4010     
orr     r0,r1                @ 0802B438 4308     
str     r0,[r6]                @ 0802B43A 6018   
ldrb    r0, PetrifyID
strb    r0,[r6,#4] @save the thing

@and increase damage - this means it MUST go after the damage check...
mov r11, r11
ldrh r0, [r7, #6] @final mt
lsl r0, #0x10
asr r0, #0x10
ldrh r1, [r7, #8] @final def
lsl r1, #0x10
asr r1, #0x10
sub r0, r1 @calc damage

@check for crit
ldr     r2,[r6]
mov r1, #0x1
and r1, r2
cmp r1, #0
beq NoCrit

@mov r1, r0 @copy damage into r1
@ldr r0, =NextRN_N @load the NextRN_N function
@mov lr, r0
@mov r0, #21 @range of number to get - get 0-20
@.short 0xf800 @put result in r0

mov r1, r0 @copy damage into r1
push {r1}
mov r0,#20 @range of number to get - get 0-20
blh NextRN_N
pop {r1}
add r0, #1
add r1, r0 @then add to damage
mov r0, r1 @copy damage back into r0

NoCrit:
strh r0, [r7, #4]

End:
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
SkillTester:
@POIN SkillTester
@WORD PetrifyID
