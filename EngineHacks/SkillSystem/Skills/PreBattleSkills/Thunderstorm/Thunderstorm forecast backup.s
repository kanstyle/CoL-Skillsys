@ when attacking at 1 range, gain 3 crit for every 1 more AS you have compared to your opponent
.thumb
.equ ItemTable, SkillTester+4
.equ ThunderstormID, ItemTable+4

.equ gBattleData, 0x203A4D4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@has Thunderstorm
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @Attacker data
ldr r1, ThunderstormID
.short 0xf800
cmp r0, #0
beq End

ldr     r0,=0x203a4ec @attacker
cmp     r4,r0
bne     End @skip if unit isn't the attacker

@make sure we're in combat (or combat prep)
ldrb	r3, =gBattleData
ldrb	r3, [r3]
cmp		r3, #4
beq		End

@check range
ldr r0,=#0x203A4D4 @battle stats
ldrb r0,[r0,#2] @range
cmp r0,#1
bne End

@do it normally

mov r1, #0x5e
ldsh r0, [r5,r1] @defender AS
ldsh r1, [r4,r1] @attacker AS
sub r1, r0 @attacker - defender @get AS differential

mov r2, #0x3 @put 3 in r2
mul r1, r2 @get crit bonus, 3 * differential

@crit
mov r3, #0x66
ldrh r0, [r4, r3]
add r0, r1
strh r0, [r4,r3]

@do it again with attacker and defender swapped

mov r1, #0x5e
ldsh r0, [r4,r1] @attacker AS
ldsh r1, [r5,r1] @defender AS
sub r1, r0 @attacker - defender @get AS differential

mov r2, #0x3 @put 3 in r2
mul r1, r2 @get crit bonus, 3 * differential

@crit
mov r3, #0x66
ldrh r0, [r5, r3]
add r0, r1
strh r0, [r5,r3]


End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@POIN ItemTable
@WORD ThunderstormID
