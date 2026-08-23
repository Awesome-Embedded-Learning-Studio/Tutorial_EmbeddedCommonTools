/* 拍 02 的病号:越界读一颗,答案就歪了
 * 对应教程:tutorial/journey/02-gdb.md
 */
#include <stdio.h>

static int scale(int v, int factor)
{
    return v * factor;
}

int main(void)
{
    int data[4] = {1, 2, 3, 4};
    int total = 0;

    for (int i = 0; i <= 4; i++) {   /* 病根:<=,data[4] 不是我们的 */
        total += scale(data[i], 2);
    }
    printf("total = %d\n", total);
    return 0;
}
