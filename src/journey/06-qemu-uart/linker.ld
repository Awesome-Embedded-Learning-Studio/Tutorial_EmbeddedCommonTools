/* 主线拍 06 · 没有屏幕的机器 —— 程序的住址由这张纸决定
 * 对应教程:tutorial/journey/06-qemu-uart.md
 * 目标:QEMU mps2-an385 —— 代码区在 0x00000000,RAM 在 0x20000000
 */
ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 512K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 512K
}

_estack = ORIGIN(RAM) + LENGTH(RAM);   /* 栈从 RAM 顶端向下长 */

SECTIONS
{
    .isr_vector : {
        KEEP(*(.isr_vector))           /* 向量表必须是第一块 */
    } > FLASH

    .text : {
        *(.text*)
        *(.rodata*)
    } > FLASH

    _sidata = LOADADDR(.data);         /* .data:行李在 flash,人在 RAM */

    .data : {
        _sdata = .;
        *(.data*)
        _edata = .;
    } > RAM AT > FLASH

    .bss : {
        _sbss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM
}
