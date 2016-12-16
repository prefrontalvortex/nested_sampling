cmake_minimum_required(VERSION 3.5)
project(nested)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES nested.c local_float.h lighthouse.c lighthouse.h)
add_executable(nested ${SOURCE_FILES})

set_target_properties( nested PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin/ )

target_link_libraries(nested m)