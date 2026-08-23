# 主线第 5 个历程 · 工程化 —— 同一个程序,搬进 CMake 工程
# 对应教程:tutorial/journey/04-cmake.md
cmake_minimum_required(VERSION 3.16)

project(journey_box C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# util 从「几个文件」升格为库:接口(include)随库走,消费者自动可见
add_library(util STATIC src/util.c)
target_include_directories(util PUBLIC src)

add_executable(hello src/main.c)
target_link_libraries(hello PRIVATE util)
