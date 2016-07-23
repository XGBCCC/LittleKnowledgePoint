# category相关
1. 我们给类新增category后，系统会自动在运行时，＋load方法前对其进行编译，并加载到类中。
2. 之所以在其他类中进行import,主要是为了方便方法的掉用
3. category的编译顺序应该是根据Build Phases里面的compile sources引用顺序来决定的
4. 如果在category中添加了＋load方法，则会原类中的load与category的load都会进行掉用
5. 先调用原类的load，再调用category的load
6. initialize 只执行 category的实现

![](http://7xwb99.com1.z0.glb.clouddn.com/2016-07-21-14691101802260.jpg)

