cmake_minimum_required(VERSION 3.6)
project(nested)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES nested.c local_float.h)
add_executable(nested ${SOURCE_FILES})

target_link_libraries(nested m)