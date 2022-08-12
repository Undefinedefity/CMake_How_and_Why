add_library(hello_world hello_world.cpp)

#自己不使用hello_world.h，对外提供接口
target_include_directories(hello_world INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(hello)
add_subdirectory(world)

# 自己使用hello库，不对外提供
target_link_libraries(hello_world PRIVATE hello)
# 自己使用world库，不对外提供
target_link_libraries(hello_world PRIVATE world)