# Runtime 消息转发流程

一直看别人文章写Runtime的消息转发机制，今天自己写代码试了下。

1. 创建`[User]`类，里面只有两个属性，`[userAge,userName]`
2. 但是我在ViewController中进行这样的调用：

    ```Objective-C
    //此处调用一个没有的User没有的printUserName的方法  走user的resolveInstanceMethod方法
    [user performSelector:@selector(printUserName:) withObject:nil afterDelay:0];
    //走user的forwardingTargetForSelector方法
    [user performSelector:@selector(printUserAge:) withObject:nil afterDelay:0];
    //走user的methodSignatureForSelector+forwardInvocation方法
    [user performSelector:@selector(printUserSex:) withObject:nil afterDelay:0];
    ```
    
3. 显然我们的`[User]`类中并没有相关的print方法
4. 那么，我们要保证  **1.在调用print方法的时候app不会崩溃  2.并且，在调用的时候，可以正确输出相关内容。这个时候，怎么办？**
5. 消息转发：简单来说，当我们用一个实例调用它并不存在的一个方法的时候，就会走消息转发流程。例如。我们调用`[User]`的`[printUserName]`方法。`[User]`中其实并不存在这个方法，这个时候，就会走消息转发了，消息转发具体涉及到下面几个方法：`[resolveInstanceMethod]`,`[forwardingTargetForSelector]`,`[methodSignatureForSelector]`,`[forwardInvocation]`
6. 这几个方法的流程大致如下图：![消息转发流程图](http://7xjcm6.com1.z0.glb.clouddn.com/%E6%B6%88%E6%81%AF%E8%BD%AC%E5%8F%91%E6%B5%81%E7%A8%8B%E5%9B%BE.png)
		
7. 我把`[User]`类的.m文件内容直接放在下面了，大家有兴趣的话可以看看
8. Demo地址：https://github.com/XGBCCC/RuntimeMessageForwardingDemo

```Objective-C
void printUserName(id self,SEL _cmd){
    User *user = self;
    NSLog(@"%@",user.userName);
}

//1.在此处动态添加方法，并返回YES。表明已经动态添加sel方法了，你可以正常调用了
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSString *selString = [NSString stringWithUTF8String:sel_getName(sel)];
    if ([selString rangeOfString:@"printUserName"].location != NSNotFound) {
        class_addMethod(self, sel, (IMP)printUserName, "v@:");
    }
    
    return YES;
}

//2.如果方法resolveInstanceMethod没有实现，则来到forwardingTargetForSelector，由转发给其他对象实现
- (id)forwardingTargetForSelector:(SEL)aSelector{
    UserHelp *userHelp = [UserHelp new];
    return userHelp;
}

//3.这个方法，会返回一个方法签名，如果这个签名为nil，则直接崩溃(unrecognized selector sent to instance)
//如果发现签名为nil,这里，我们可以自己注册方法签名，并返回【如果，这里有返回方法签名，则系统会调用forwardInvocation方法】
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    //发现自己实现这个方法
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (!sig) {
        //OK，你没有实现这个方法，拿不到方法签名，那我手动给你个方法签名，并返回
        sig = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return sig;
}

//4.这块是消息转发的最终目的地，如果methodSignatureForSelector有返回，则会走这个方法，在这个方法里，我们可以判断是否可以执行，并交由可以执行的对象去执行。如果没有对象可执行，这一步也不会报错【只要不invokeWithTarget】
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //获取到调用信息的selector
    SEL aSelector = [anInvocation selector];
    //如果可以调用，则进行调用
    if ([self respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:self];
    }
    //如果不能调用，则把消息吞掉，不做任何处理
    
}
```

