# 文件组成

```Bash
NoCmake/
├── main.cpp
│
├── hello.cpp
├── hello.h
│
├── hello_world.cpp
├── hello_world.h
│
├── world.cpp
└── world.h
```

其中四个`.cpp`文件是这样的，三个`.h`文件里面就是只有一个函数的声明，没有内容。

```C++
// hello.cpp
#include "hello.h"
#include <iostream>
void hello()
{
    std::cout << "hello, from hello.cpp\n";
}
```

```cpp
// world.cpp
#include "world.h"
#include <iostream>
void world()
{
    std::cout << "world, from world.cpp\n";
}
```

```cpp
// hello_world.cpp
#include "hello_world.h"
#include <iostream>
void hello_world()
{
    hello();
    world();
    std::cout << "hello world, from hello_world.cpp\n";
}
```


```cpp
// main.cpp
#include <stdio.h>
#include "hello_world.h"
int main()
{
    hello_world();
    return 0;
}
```

# 编译

首先，可以简单粗暴的用`g++`一股脑把所有内容都放进去编译直接生成可执行文件

```Bash
g++ hello.cpp world.cpp hello_world.cpp main.cpp -o main
```

如果想要一步一步来，则按以下步骤，储存在`auto_build_static.sh`脚本里面，如果不能通过`./auto_build_static.sh`运行则先运行`chmod +x auto_build_static.sh`

```Bash
g++ -c hello.cpp -o hello.o
g++ -c world.cpp -o world.o
ar -crv libhello.a hello.o
ar -crv libworld.a world.o
g++ -c hello_world.cpp -L . -l hello -l world
ar -crv libhello_world.a hello_world.o
# If you run this
g++ main.cpp -L . -l hello_world -l hello -l world -o main
# Then you don't need to run belows
# g++ -c main.cpp -L . -l hello_world
# g++ hello.o hello_world.o main.o world.o -o main
```

## Step by Step 用静态库

首先对`hello.cpp`和`world.cpp`进行编译汇编，生成`.o`目标文件

```Bash
g++ -c hello.cpp -o hello.o
g++ -c world.cpp -o world.o
```

接下来因为`hello_world.cpp`include了`hello.h`和`world.h`，用到了这两个库，我们需要用上面生成的这两个`.o`中间目标文件创建静态库（不探讨动态库的问题）

```Bash
ar -crv libhello.a hello.o
ar -crv libworld.a world.o
```

生成两个静态库文件`libhello.a`和`libworld.a`

接下来再用这两个静态库文件于`hello_world.cpp`一起进行编译

```Bash
g++ -c hello_world.cpp -L . -l hello -l world
# 或者
g++ -c hello_world.cpp -L . libhello.a libworld.a
```

- `-L`：表示要连接的库所在目录

- `-l`：指定链接时需要的动态库，编译器查找动态连接库时有隐含的命名规则，即在给出的名字前面加上`lib`，后面加上`.a`或`.so`来确定库的名称

这样就生成了`hello_world.o`

到这一步，有个直接便捷的方法，参考

同理，`main.cpp`里面需要用到`hello_world`库，所以还需要创建`hello_world`静态库

```Bash
ar -crv libhello_world.a hello_world.o
```

到这一步可以看下面【更简单直接的方法】，或者

然后使用库，生成`main.o`目标文件

```Bash
g++ -c main.cpp -L . -l hello_world
```

链接所有的目标文件，生成可执行文件`main`

```Bash
$ g++ main.o hello.o hello_world.o world.o -o main
$ ./main
hello, from hello.cpp
world, from world.cpp
hello world, from hello_world.cpp
```

### 更简单直接的方法

直接使用三个静态库，去编译

```Bash
$ g++ main.cpp -L . -l hello_world -l hello -l world -o main
$ ./main
hello, from hello.cpp
world, from world.cpp
hello world, from hello_world.cpp
```

## 用动态库

参考：[Linux C 动态链接库的生成与使用](https://fanjunyu.com/posts/62d7ab61/)

`auto_build_shared.sh`: 

```Bash
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
```

参数解释

- `-fPIC`: PIC 指 Position Independent Code，生成适合在共享库中使用的与位置无关的代码

- `-Wl,-rpath`: `-Wl`选项告诉编译器将后面的参数传递给链接器，将动态库的路径告诉可执行文件