cmake_minimum_required(VERSION 3.15)

project(main)
add_subdirectory(hello_world)

aux_source_directory(. SRCS)
add_executable(${PROJECT_NAME} ${SRCS})


target_link_libraries(${PROJECT_NAME} PRIVATE hello_world) 