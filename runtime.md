# Runtime
1. 实例变量的内存布局在程序`[编译期间]`就已经确定了，新增或减少一个实例变量，就必须要`[重新编译]`程序代码，让编译器重新计算所有实例变量的内存布局
2. Cat对象->_firstName的实际作用
	1. 首先找到Cat对象所在的内存的起始地址
	2. 从某个全局记录表中，查询到`[实例变量_firstName]`对应的地址偏移量offset
	3. 通过`[偏移量offset+Cat对象的内存其实地址]`作为存取实例变量_firstName的所在内存地址
3. 为什么不能动态给现有的类添加属性
	1. 因为编译的时候已经确定实例变量的内存布局了
	2. 当我们新增属性的时候，就会导致访问错误，可能访问到其他属性
	3. 对于已生成，并注册的类我们使用`[class_addIvar]`的时候，直接会返回NO，添加失败
4. 只有在`[objc_allocateClassPair]`,`[objc_registerClassPair]`之间使用`[class_addIvar]`才可以正确添加属性
5. 使用`[@property]`的时候，编译器自动做如下事情：
	1. 属性对应的实例变量_name
	2. 实例变量的读取方法`[name]`实现
	3. 实例变量的修改方法`[setName:]`实现
	4. 使用`[self.name=@"haha"]`的时候，自动就发送KVO通知
	5. 使用`[_name＝@"haha"]`,不会出发KVO，因为KVO其实是将对象指向子类，并重写setter方法，来实现的
6. 使用@dynamic 可以告诉编译器不自动生成getter/setter,以及实例变量
7. @property修饰符
	1. nonatomic/atomic
		1. 系统默认是atomic，由编译器来完成原子性加锁操作，来同步属性变量的多线程访问，会降低性能。
		2. nonatomic,需要手动执行多线程的同步，不会由系统编译器提供原子性操作，是非线程安全的，单性能高，常见的多线程同步方法
			1. 锁：NSLock，NSRecursiveLock，NSConditionLock
			2. 信号：dispatch_semaphore_t
			3. GCD队列
	2. readwrite/readonly  属性的读写权限
	3. weak/strong/retain/copy/assion/unsafe_unretained
		1. weak:不会也不能持有指向的对象，即不会让指向的对象的retainCount＋＋
		2. strong/retain:二者是一样的对象所有权，即持有指向的对象，会让指向的对象的retainCount＋＋
			1. 持有传入的新对象,新对象retainCount++
			2. 释放已有的老对象，老对象retainCount--
		3. assign:一般用于基础数据类型变量(int,float,bool)
			1. 类似weak，但区别是，在指向的对象被废弃的时候，指针变量值不会自动赋值为nil
			2. 而weak的指针变量会自动赋值nil
		4. unsafe_unretaind:类似于assign，但是一般用于OC对象
			1. 同样喝assign在指向的对象被废弃掉时，指针变量不会自动赋值为nil
		5. copy：将传入的对象进行copy([对象 copy]),然后使用strong／retain强引用的方式来持有拷贝出来的新对象
			1. 新对象 ＝ [老对象 copy]; //和strong/retain不同的地方
			2. 持有传入的新对象,新对象retainCount++
			3. 释放已有的老对象,老对象retainCount--
8. 当我们同时重写getter和setter时，系统就不会自动给我们生成成员变量了。［只重写其中一个是没关系的］
	1. 同时重写的话，需要我们自己写：@synthesize name = _name
	2. 也可以使用```@implementation Father {NSString *_name;}```
9. 属性，如何对外只读，对内读写？
	1. .h文件这样声明(只读):`[@property (nonatomic, readonly, assign) BOOL isEnable;]`
	2. .m文件需要在此声明(读写)：`[@property (nonatomic, readwrite, assign) BOOL isEnable;]`
	3. 如果有子类继承父类，也要内部读写如何办？
		1. 用上面同样的方式，在子类的.m文件中，声明父类的匿名分类，然后将只读属性设置为读写。
10. 对象的读写`[_variable]`,`[self.variable]`
	1. _variable:
		1. 绕过了属性定义的`[内存管理]`修饰
		2. 绕过了属性定义的`[读写权限]`修饰
		3. 不会触发KVO通知
	2. self.variable
		1. 可以懒加载的属性
		2. 会出发KVO
		3. 设置新值的时候，会根据属性定义的`[内存管理]`对应的修饰规则
		4. 可以重写setter，getter方法，来完成断点调试
11. 何时使用`[_variable]`,`[self.variable]`
	1. 使用_variable 来读取实例变量，避免每次进入消息发送进入class结构体中查询SEL对应的IMP
	2. 使用self.variable 来些数据，可以遵循内存管理修饰＋KVO
	3. 在init＋dealoc中，总是应该使用_variable来读写
		1. 因为子类可能重写属性的setter于getter方法的实现［我们使用_variable可确保我们的值赋予的是正确的］
		2. 如果重写setter了，在掉用setter饿时候，会导致父类方法中的某一实例变量未能初始化，导致程序崩溃
		3. 又懒加载的，要一直使用self.属性名来读取
12. 如何判断两个对象的等同性
	1. 我们不能通过`[A对象 == B对象]`，因为这样直接比较的是对象的地址，而不是对象内部实例的值内容
	2. 等同性，我们需要重写`[isEqual]`方法来实现,方法内部，我们可以随意对比属性的值，来返回YES，NO
13. hash
	1. 之前有地方看过，重写hash，也可以达到isEqual＝YES的效果，其实并不能，还是最终根据isEqual方法来判断的.**但是有一点我们需要明白：hash值一样，则对象内容必然等同(与iSEqueal无关)：因为不管是string，int，他们都有固定的hash值，而我们的对象其实就是这些内容构造出来的**
	2. 但是系统中有不少地方是根据Hash来判断是否相等的，像NSSet里面不会存储重复的对象，这里面NSSet判断的其实就是Hash值，如果hash一样，则会只保存一个值
	3. hash属性的实现方式(一般是下面方式...)：
	
	```
	- (NSUInteger)hash {
    NSInteger ageHash = _age;
    NSUInteger nameHash = [_name hash];
    NSUInteger pidHash = [_pid hash];
  //如果有自定义类对象属性，需要再实现那个类对象的hash值方法
  	  return ageHash ^ nameHash ^ pidHash;
	}
	```
14. 等同性判断的执行深度
	1. 如果是数组
		1. 判断两数组的长度是否一致
		2. 对每个位置的对象进行判断
15. 容器内可变对象的等同性判断

	```
	-(void)test {

    NSMutableSet *set = [NSMutableSet new];

    NSMutableArray *array1 = [@[@"1", @"2"] mutableCopy];
    [set addObject:array1];
    NSLog(@"set = %@", set); //输出(1,2)

    NSMutableArray *array2 = [@[@"1", @"2"] mutableCopy];
    [set addObject:array2];
    NSLog(@"set = %@", set); //由于array2 的 hash[应该是里面的每个值的hash加起来，而相同的string，int默认的hash值是一样的] 与 array1 的hash一样，所以还是输出（1，2）

    NSMutableArray *array3 = [@[@"1"] mutableCopy];
    [set addObject:array3];
    NSLog(@"set = %@", set);//输出((1,2),(1)),因为array3 与array1，array2的hash不一样

    //【出现错误】此时如果修改Set容器中的可变对象，array3与array1此时等同了
    [array3 addObject:@"2"];
    NSLog(@"set = %@", set); //由于array3是可变的，而且array3已经加到了set中。所以，此时输出的就是((1,2),(1,2))

    //拷贝此时的Set对象
    NSSet *copySet = [set copy];
    NSLog(@"copySet = %@", copySet);//由于执行了copy操作，会将原set中的对象copy到新的对象中，此时会再次判断hash值。最后输出(1,2)
}
	```
16. 类簇相关
	1. 像NSArray，NSDictionary，NSMutableArray，NSMutableDictionary这些其实都是类簇（类簇，其实就相当于一个工厂方法）
	2. 在这些类在alloc，init，添加对象的时候，会分别获得不同的类型
	
	```
	NSLog(@"%@",[NSArray class]);  //NSArray
    NSLog(@"%@",[[NSArray alloc] class]); //_NSPlaceholderArray
    NSLog(@"%@",[[[NSArray alloc] init] class]); //__NSArray0
    NSLog(@"%@",[[[NSArray alloc] initWithObjects:@"1", nil] class]); //__NSArrayI
	```
	
	3. 所以我们不能使用如下这样的判断,

	```
	 NSArray *arr = @[@"1", @"2"];
	 BOOL ret = [arr class] == [NSArray class];  //输出NO  ，一个是__NSArrayI 一个是  NSArray
	```
	
	4. 那么如何判断Array，NSDictionary是否是同一个类？
		1. `[[arr isKindOfClass:[NSArray class]]]`  //判断正确，因为所有的NSArray下面相应的内部类，都是NSArray类簇类的子类
		2. `[isKindOfClass]`:判断是否是这个类，或其子类的实例
		3. `[isMemberOfClass]`：判断是否是这个类的实例

17. 我们不能给已经在运行时中注册的类新增属性，但是，可以使用关联对象来代替
	1. `[void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)]`
	2. `[id objc_getAssociatedObject(id object, const void *key)]`
	3. `[void objc_removeAssociatedObjects(id object)]`

		| 关联对象指定的内存策略 | 等效的@property修饰符 |
| :-: | :-: |
| `OBJC_ASSOCIATION_ASSIGN` | @property (atomic, assign) |
| `OBJC_ASSOCIATION_RETAIN_NONATOMIC` | @property (nonatimic , retain) |
| `OBJC_ASSOCIATION_COPY_NONATOMIC` | @property (nonatimic , copy) |
| `OBJC_ASSOCIATION_RETAIN` | @property (atomic , retain) |
| `OBJC_ASSOCIATION_COPY` | @property (atomic , copy) |

18. UIView不接受触摸事件的4种情况`[view.userInteractionEnable = NO]`,`[view.hideen = YES]`,`[view.alpha = 0.0~0.01]`,`[父view，或自己的frame是CGRectZero]`
19. `[UIView hitTest:WithEvent:]`源码的模拟实现

```
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 1. 判断自己是否能够接收触摸事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;

    // 2. 判断触摸点在不在自己范围内
    if (![self pointInside:point withEvent:event]) return nil;

    // 3. 从上到下遍历自己的所有子控件，看是否有子控件更适合响应此事件
    int count = self.subviews.count;

    for (int i = count - 1; i >= 0; i--) {//依次从最顶层开始取subview
        UIView *childView = self.subviews[i];

        // 将产生事件的坐标，转换成当前相对subview自己坐标原点的坐标
        CGPoint childPoint = [self convertPoint:point toView:childView];

        // 再让subview又去他的subviews中查找适合处理事件的view
        UIView *fitView = [childView hitTest:childPoint withEvent:event];

        // 如果childView的subviews存在能够处理事件的，就返回当前遍历的childView对象作为事件处理对象
        if (fitView) {
            return fitView;
        }
    }

    //4. 没有找到比自己更合适的view
    return self;
}
```

20. 系统会先调用`[hitTest]`方法，然后才调用`[touchBegin]`。 因为需要先确认是哪个View接受事件，然后才能相应识别touchBegin
21. 事件传递过程
	1. 首先从super view还是，然后传递给所有的subviews尝试响应
	2. 一个View调用hitTest开始尝试事件响应，而掉用pointInside看是否能够处理这个坐标的事件
	3. 如果可以处理，就判断是否还有subViews
		1. 如果没有，则自己作为事件响应者返回
		2. 如果有，继续交给subviews去尝试响应
	4. 如果不能处理，则交给同级的其他view尝试响应
	5. 最终如果没有找到事件响应者，那么会将root view 作为最终的事件响应者
		1. 从`[最底层]`的RootView一直到`[最顶层]`的View发送hitTest:withEvent:消息，依次询问是否能成功响应者
		2. 但是对于某个View的所有subviews的hitTest:withEvent:消息询问，却是从`[最上面]`的到`[最下面]`的subview依次询问
	6. 响应者链条：只有`[pointInside:withEvent:]`返回`[YES]`的view,才属于响应者链条
22. UI事件响应
	1. `[事件响应者]`:继承UIResponder的对象称之为响应者对象，能处理touchBegin等触摸事件
	2. `[响应者链]`：由很多`[事件响应者]`链接在一起组合起来的一个链条称之为响应者链。但是其中有一个View是第一之间响应者，其他的都是备用。
		1. 事件传递是从父View到子View来一一询问，当找到了最小的可接受事件的响应者后。响应链却是：从子view到父View依次去响应
		2. `[找到第一响应者的View——super view——rootView——控制器View——控制器——window]`
23. 重写`[pintInside:withEvent:]`返回NO，则表示不参与事件传递，即：直接不让自己成为响应者
24. 将UIView的点击事件传递给其他View，可以直接重写`[hitTest:withEvent:]`
25. 


