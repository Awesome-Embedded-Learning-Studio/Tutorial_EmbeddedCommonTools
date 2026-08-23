/* 主线第 7 个历程 · 出生证明:向量表 + 复位流程
 * 对应教程:tutorial/journey/06-qemu-uart.md
 * 目标板:QEMU mps2-an385(Cortex-M3)
 */
#include <stdint.h>
#include <stddef.h>

/* gcc 会把「抄写循环」识别成 memcpy 调用、把「清零循环」识别成 memset 调用;
 * -nostdlib 的世界里没有 libc,所以裸机工程自带这两个最小实现。 */
void *memcpy(void *dst, const void *src, size_t n)
{
    unsigned char *d = dst;
    const unsigned char *s = src;
    while (n--) *d++ = *s++;
    return dst;
}

void *memset(void *dst, int c, size_t n)
{
    unsigned char *d = dst;
    while (n--) *d++ = (unsigned char)c;
    return dst;
}

/* 这些地址全部由链接脚本(linker.ld)定义 */
extern uint32_t _estack;   /* 初始栈顶 */
extern uint32_t _sidata;   /* .data 的行李在 flash 里的位置 */
extern uint32_t _sdata;    /* .data 在 RAM 里的家 */
extern uint32_t _edata;
extern uint32_t _sbss;     /* .bss 在 RAM 里的家 */
extern uint32_t _ebss;

int main(void);

void Reset_Handler(void)
{
    uint32_t *src = &_sidata;
    uint32_t *dst = &_sdata;
    while (dst < &_edata)              /* .data:把行李从 flash 搬进 RAM */
        *dst++ = *src++;

    for (dst = &_sbss; dst < &_ebss; dst++)   /* .bss:按合同清零 */
        *dst = 0;

    (void)main();
    for (;;) { }                       /* main 不该回来;回来了就原地罚站 */
}

/* Cortex-M 的向量表:第 0 项是初始栈顶,第 1 项是复位入口。
 * 硬件复位时自己读这张表,不需要咱们写一行汇编。 */
__attribute__((section(".isr_vector"), used))
const uintptr_t vector_table[] = {
    (uintptr_t)&_estack,
    (uintptr_t)Reset_Handler,
};
