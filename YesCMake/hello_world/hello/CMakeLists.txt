add_library(hello hello.cpp)

#对外提供hello.h头文件，自己不使用
target_include_directories(hello INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})