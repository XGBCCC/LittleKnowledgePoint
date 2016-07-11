# __weak与__strong
为了防止循环引用，我们一般都会声明一个__weak,在可能的循环引用的地方使用声明为weak的变量
例如：
```Objective-C
__weak __typeof(self) weakSelf = self;
dispatch_async(queue,^{
	TypeOfSelf *strongSelf = weakSelf;
	if(!strongSelf)
		return
})
```
为什么要外面声明weak,里面还要strong引用呢
因为：
1. 声明weak，是因为weak，不就造成强引用，当引用weak的对上释放的时候，weak就会自动释放掉，而不会造成循环引用
2. 里面又使用strong，是为了，强引用weak，防止在block内的生命周期内引用被释放
3. 为什么要判断!strongSelf，如果外面的weak被释放掉后，我们的strong肯定也是nil，so，需要进行判断


