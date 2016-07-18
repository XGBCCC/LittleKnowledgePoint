# Block 相关
1. 语法
```Objective-C
int (^blk)(int) = ^ (int) (int value){
	return value+1
}
```
2. 为什么我们使用

```Objective-C
int val = 0
void (^blk)(void) = ^{val = 1}
```
会报错，提示：variable is not assignable(missing __block type specifier)
但是使用,下面这样，却不会报错？

```Objective-C
id array = [[NSMutableArray alloc] init];
void (^blk)(void) = ^{
	id obj = [[NSObject alloc] init];
	[array addObject:obj];
}
```
**因为是这样的，1.block默认是使用a=b这种复制来将变量传到block中，但是这个时候值类型的“=”其实是给了个新的地址，而引用类型，是直接给的地址。block截获的值其实是内存地址，如果我们直接更改了其内存地址，就会报错，但是如果对改只是内存地址进行一些操作，则不会有问题**

3. __block 为什么加了__block，就可以改变值了？
**如果我们用__block修饰变量，在block对其引用的时候，会同时将其指针传递到block中，这个时候，在block中，修改或访问成员，就会通过这个地址访问外界的变量。就会引用他的指针，这个时候，就可以在里面修改他的值了**

4. 三种block类型：
		_NSConcreteGlobalBlock 全局的静态 block，引用全局变量，或者不会访问任何外部变量。[单独的block，没有引用任何变量，就是全局静态的block]
		_NSConcreteStackBlock 保存在栈中的 block，当函数返回时会被销毁。[引用了局部变量的block，就是栈中的block。**但是，在ARC中，我们并不会直接接触到栈block**]
		_NSConcreteMallocBlock 保存在堆中的 block，当引用计数为 0 时会被销毁。[这个，其实是使用copy将StackBlock，copy到堆中，就是堆的block了。在ARC环境下，由于能有效管理声明周期了，所以都讲block用copy扔到了堆中]

5. isa 指针。类，其实就是结构体，他们里面有个字段，isa，其实就是指向了类相应的的结构体实例。类的结构体实例包含了：成员变量，方法名称，方法实现，属性，以及父类的指针

6. 在ARC无效的情况下， __block说明符被用来避免Block重的循环引用。因为使用__block后，变量不会被retain。 如果没有使用block，则会被retain

