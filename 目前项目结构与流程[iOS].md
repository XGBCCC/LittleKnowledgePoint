# 目前项目结构与流程[iOS]
下面是之前总结的iOS的项目流程

![项目流程](http://7xjcm6.com1.z0.glb.clouddn.com/%E9%A1%B9%E7%9B%AE%E6%B5%81%E7%A8%8B%E6%A1%86%E6%9E%B6.png)

主要结构还是MVCS
```M：Model层只是对数据的定义，只会提供一个Parse(将JSON转为实例)方法【此处的Model，不仅仅是数据的Model，也可以是ViewModel】。
V：View，只处理数据的显示逻辑
C：Controller，负责调用Service的方法，并作为View各种事件的代理。相当于一个中枢，进行事件操作，数据获取，分配。
S：Service层，负责业务逻辑，主要是会调用API，完成我们的业务逻辑
```
##注意事项
1. 整个在整个流程图中，我们发现，并没有Model的体现，原因如下：
	1. 考虑到代码,业务重用问题，公司的N个产品可能会重用某个业务逻辑，但是可能具体的需求又不同。
	2. 这时，我们就不能将Model进行嵌入到Service中，否则，对之后构造framework，给其他项目使用，就会有很大限制【可能A项目获取数据后，是直接显示的逻辑，B项目确实，需要将数据重组，然后再进行显示；这种情况，如果我们将Model嵌入Service中，就会给我们之后做成framework给其他项目组造成很多不便】
	3. 那，你的Model在哪里体现呢。我这边的做法是，这个Model，主要是只是为了方便赋值与获取。如果直接使用字典的话，Key管理不方便，且不容易记住，所以才有了这个Model。
	4. 这个Reformer到底是什么东西，这个Reformer,其实就是个Parse：将Service层返回的数据，通过转化，变为我们需要的数据，例如Model。【此处可参考：[iOS应用架构谈 网络层设计方案](http://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html)】



