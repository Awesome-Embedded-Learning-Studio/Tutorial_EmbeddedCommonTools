#include <stdio.h>
#include "util.h"

void greet(const char *who)
{
    printf("hello, %s!\n", who);
}

const char *version(void)
{
    return "v0.4.0";
}
