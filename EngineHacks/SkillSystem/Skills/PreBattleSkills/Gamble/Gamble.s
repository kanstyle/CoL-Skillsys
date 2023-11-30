.thumb
.equ GambleFlag, 0x203f101
push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

ldr r0, =GambleFlag
ldrb r0, [r0]
cmp r0, #5 @was gamble selected
bne End

ldr r0, =0x203a4ec @is attacker?
cmp r4, r0
bne End

@add crit, halve AS
mov r1, #0x5E
ldrh r0, [r4, r1] @AS
lsr r0, #1
strh r0, [r4,r1]

@subtract 20 from 0hit
mov r1, #0x60
ldrh r0, [r4, r1] @hit
sub r0, #20
strh r0, [r4,r1]

mov r1, #0x66
ldrh r0, [r4, r1] @get current crit, which doesn't include skill stat
mov r2, #0x15
ldrh r2, [r4, r2] @load skill stat into r2
lsl r2, #1 @multiply skill by 2
add r0, r2 @add it to crit
strh r0, [r4,r1]

End:
pop {r4-r7, r15}
.align
.ltorg
