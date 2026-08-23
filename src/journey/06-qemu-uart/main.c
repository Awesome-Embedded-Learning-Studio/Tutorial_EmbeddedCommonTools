/* 主线拍 06 · 没有屏幕的机器:串口是我们唯一的嘴
 * 对应教程:tutorial/journey/06-qemu-uart.md
 * 目标板:QEMU mps2-an385(Cortex-M3),UART0 = CMSDK APB UART
 */
#include <stdint.h>

#define UART0_BASE   0x40004000UL
#define UART_DATA    (*(volatile uint32_t *)(UART0_BASE + 0x00))
#define UART_STATE   (*(volatile uint32_t *)(UART0_BASE + 0x04))
#define UART_CTRL    (*(volatile uint32_t *)(UART0_BASE + 0x08))
#define UART_BAUDDIV (*(volatile uint32_t *)(UART0_BASE + 0x0C))

#define UART_STATE_TXBF (1u << 0)      /* 发送缓冲满:满了就等 */
#define UART_CTRL_TXEN  (1u << 0)      /* 打开发送 */

static void uart_init(void)
{
    UART_BAUDDIV = 16;                 /* QEMU 不仿真波特率时序;真板按 PCLK/baud 算 */
    UART_CTRL = UART_CTRL_TXEN;        /* 我们只需要说话,不需要听 */
}

static void uart_putc(char c)
{
    while (UART_STATE & UART_STATE_TXBF) { }
    UART_DATA = (uint32_t)c;
}

static void uart_puts(const char *s)
{
    while (*s) {
        if (*s == '\n')
            uart_putc('\r');           /* 串口世界的礼貌:\n 前面补一个 \r */
        uart_putc(*s++);
    }
}

int main(void)
{
    uart_init();
    uart_puts("hello, EmbedBox!\n");
    uart_puts("journey beat 06: no OS, just UART (v0.6.0)\n");
    for (;;) { }                       /* 裸机主循环:永远不许返回 */
}
