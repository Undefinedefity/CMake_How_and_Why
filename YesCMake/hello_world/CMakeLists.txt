add_library(hello_world hello_world.cpp)

target_include_directories(hello_world INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(hello)
add_subdirectory(world)

target_link_libraries(hello_world PUBLIC hello)
target_link_libraries(hello_world PUBLIC world)