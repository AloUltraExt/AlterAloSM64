// assembler directives
.set noat      // allow manual use of $at
.set noreorder // don't insert nops after branches

#include "macros.inc"

.section .text, "ax"

glabel entry_point

entry_point:
    // Get main segment BSS address and size
    lui   $t0, %hi(_mainSegmentBssStart)
    addiu $t0, %lo(_mainSegmentBssStart)
    lui   $t1, %hi(_mainSegmentBssSize)
    addiu $t1, %lo(_mainSegmentBssSize)
.clear_bytes:
    // Clear BSS section in 8-byte chunks
    sw    $zero, ($t0)  // Clear first 4 bytes
    sw    $zero, 4($t0) // Clear next 4 bytes
    addi  $t0, $t0, 8   // Increment target address
    addi  $t1, $t1, -8  // Decrement remaining size
    bnez  $t1, .clear_bytes // Repeat until $t1 (remaining size) is 0
    nop
    // Set up idle thread stack and get init function address
    lui   $sp, %hi(gIdleThreadStack)
    addiu $sp, %lo(gIdleThreadStack)
    lui   $t2, %hi(main_func)
    addiu $t2, %lo(main_func)
    jr    $t2  // Jump to main_func
    nop
