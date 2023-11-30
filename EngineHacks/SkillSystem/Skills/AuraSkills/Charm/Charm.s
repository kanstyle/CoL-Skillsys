@Spur Def: adjacent allies gain +4 defense in combat.
.equ AuraSkillCheck, SkillTester+4
.equ CharmID,SkillTester+8
.thumb
push {r4-r7,lr}
@goes in the battle loop.
@r0 is the attacker
@r1 is the defender
mov r4, r0
mov r5, r1

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, CharmID
.short 0xf800
cmp r0, #0
bne GrantBonus @if attacker has skill, grant effect

@if attacker doesn't have skill, check if in range of someone with skill
CheckSkill:
@now check for the skill
ldr r0, AuraSkillCheck
mov lr, r0
mov r0, r4 @attacker
ldr r1, CharmID
mov r2, #0 @can_trade
mov r3, #2 @range
.short 0xf800
cmp r0, #0
beq Done

GrantBonus:
mov r0, r4
add     r0,#0x68    @Move to the attacker's crit avoid.
ldrh    r3,[r0]     @Load the attacker's cravoid into r3.
add     r3,#100    @add 100 crit avoid.
strh    r3,[r0]     @Store crit avoid.

Done:
pop {r4-r7}
pop {r0}
bx r0
.align
.ltorg

SkillTester:
@WORD AuraSkillCheck
@WORD CharmID
