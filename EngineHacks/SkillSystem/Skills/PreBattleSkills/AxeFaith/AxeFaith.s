.thumb
.equ AxeFaithID, SkillTester+4

push {r4-r7, lr} 

@Check if unit has skill
ldr 	r0, SkillTester
mov 	lr, r0
mov 	r0, r4
ldr 	r1, AxeFaithID
.short	0xf800
cmp 	r0, #0
beq 	NoSkill

mov		r1,#0x15	@Position of unit skill
ldrb	r2,[r0,r1]  @Get unit's skill

add     r0,#0x66    @Move to the attacker's crit.
ldrh    r3,[r0]     @Load the attacker's crit into r3.
add     r3,r3,r2    @Add r2 to the attacker's crit.
strh    r3,[r0]     @Store attacker crit.

NoSkill:
pop {r4-r7} 
pop {r0}
bx r0

.align
SkillTester:
@POIN SkillTester
@WORD AxeFaithID




