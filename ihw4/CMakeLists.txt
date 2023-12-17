cmake_minimum_required(VERSION 3.22)
project(leetcode)

set(CMAKE_CXX_STANDARD 17)

add_executable(leetcode main.cpp ConsoleIOController.h multithread.h multithread_alt.h multithread_omp.h uniform_random.h)
