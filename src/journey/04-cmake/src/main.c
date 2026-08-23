/* 主线拍 04 · 工程化 —— 库与应用分离后的入口
 * 对应教程:tutorial/journey/04-cmake.md
 */
#include <stdio.h>
#include "util.h"

int main(void)
{
    greet("EmbedBox");
    printf("journey beat 04: %s\n", version());
    return 0;
}
