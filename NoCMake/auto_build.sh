g++ -c hello.cpp -o hello.o
g++ -c world.cpp -o world.o
ar -crv libhello.a hello.o
ar -crv libworld.a world.o
g++ -c hello_world.cpp -L . -l hello -l world
ar -crv libhello_world.a hello_world.o
g++ -c main.cpp -L . -l hello_world
g++ hello.o hello_world.o main.o world.o -o main