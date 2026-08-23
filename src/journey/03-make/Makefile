# 主线第 4 个历程 · 程序长大 —— 最终 Makefile:变量 + 模式规则 + 头文件依赖
# 对应教程:tutorial/journey/03-make.md

CC      := gcc
CFLAGS  := -Wall -Wextra -g
TARGET  := hello
OBJS    := main.o util.o

.PHONY: all clean
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^

# 模式规则:任何 .o 都从同名 .c 编出来,并且都依赖头文件
%.o: %.c util.h
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(TARGET) $(OBJS)
