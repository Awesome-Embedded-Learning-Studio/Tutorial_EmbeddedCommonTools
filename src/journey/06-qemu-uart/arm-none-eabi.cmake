# 主线第 7 个历程 · 没有屏幕的机器 —— 工具链文件:CMake 的「这单活用哪套工具」
# 对应教程:tutorial/journey/06-qemu-uart.md
# 用法:cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=arm-none-eabi.cmake
set(CMAKE_SYSTEM_NAME Generic)      # 裸机:没有操作系统
set(CMAKE_SYSTEM_PROCESSOR arm)     # 目标机是 ARM
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
# 裸机上链不出可执行文件,探测编译器时只编译、不链接
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
