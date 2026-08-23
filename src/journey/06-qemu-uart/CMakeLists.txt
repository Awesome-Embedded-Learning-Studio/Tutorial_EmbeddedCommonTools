# 主线第 7 个历程 · 没有屏幕的机器 —— 裸机构建交给 CMake 收编
# 对应教程:tutorial/journey/06-qemu-uart.md
# 配合 arm-none-eabi.cmake(工具链文件)使用,见上文件头的用法
cmake_minimum_required(VERSION 3.16)

project(journey_baremetal C)

add_executable(hello.elf startup.c main.c)
target_compile_options(hello.elf PRIVATE
    -mcpu=cortex-m3 -mthumb -Wall -Wextra -g -O2)
target_link_options(hello.elf PRIVATE
    -mcpu=cortex-m3 -mthumb -nostdlib -T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld)
