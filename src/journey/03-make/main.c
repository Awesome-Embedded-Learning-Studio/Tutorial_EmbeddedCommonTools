/* 主线第 4 个历程 · 程序长大 —— 主角长成三个文件后的入口
 * 对应教程:tutorial/journey/03-make.md
 */
#include <stdio.h>
#include "util.h"

int main(void)
{
    greet("EmbedBox");
    printf("journey beat 03: %s\n", version());
    return 0;
}
