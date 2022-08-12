# If run these two commands
g++ -fPIC -shared hello.cpp -o libhello.so
g++ -fPIC -shared world.cpp -o libworld.so
# Then you do not need to run below four commands
# g++ -fPIC -c hello.cpp
# g++ -fPIC -c world.cpp
# g++ -shared -o libhello.so hello.o
# g++ -shared -o libworld.so world.o

g++ -fPIC -shared hello_world.cpp -o libhello_world.so
g++ main.cpp -L . -l hello_world -l hello -l world -o main -Wl,-rpath=.
