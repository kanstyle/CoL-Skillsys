@ when attacking at 1 range, gain 3 crit for every 1 more AS you have compared to your opponent
.thumb
.equ ItemTable, SkillTester+4
.equ ThunderstormID, ItemTable+4

.equ gBattleData, 0x203A4D4

push {r4, r5, lr}

mov r4, r0
mov r5, r1

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, ThunderstormID
.short 0xF800
cmp r0, #0
beq End

ldr r0, =gBattleActor
mov r1, r4
cmp r0, r1
bne End

mov r2, #0x5E // battleSpeed
ldrh r0, [r4, r2]
ldrh r1, [r5, r2]
cmp r0, r1
ble End

sub r1, r0, r1
mov r0, #3
mul r1, r0
mov r2, #0x66 //battleCritRate
ldrh r0, [r4, r2]
add r0, r1
strh r0, [r4, r2]

End:
pop {r4, r5}
pop {r0}
bx r0

.align
.ltorg
SkillTester:
@Poin SkillTester
@POIN ItemTable
@WORD ThunderstormID
