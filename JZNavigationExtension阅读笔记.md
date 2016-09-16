# JZNavigationExtension阅读笔记
####修改NavigationBar整体透明度
```
[[self.navigationController.navigationBar 
setAlpha:self.navigationController.navigationBar.alpha-0.1];]
```
####修改NavigationBar背景透明度
```
首先获取backgroundView
[self.navBackgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];]
然后对其alpha进行操作
```
####修改Navigationbar背景色
```
首先获取backgroundView
[self.navBackgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];]
然后对其color属性进行操作
```
####修改NavigationBar高度
```
UINavigationBar *bar = self.navigationController.navigationBar;
[self.navigationController.navigationBar setFrame:CGRectMake(bar.frame.origin.x, bar.frame.origin.y, bar.frame.size.width, bar.frame.size.height+10)];

//当然，你也可以修改backgroundView的高度来达到目的，但是只修改backgroundView的话，是不会改变title，barItem的位置的。
//但是直接修改bar的frame，同时会调整title的frame，相对布局
```

####修改不同页面的NavigationBar的背景色,透明度，在页面切换的时候如何实现过渡动画
1. 替换`[popViewControllerAnimated:]` 与 `[pushViewController:animated:]`方法
2. 然后再相应的替换方法中，对navigationBar进行截屏，并添加到navigationBar的superview的layer中
3. 然后在做动画之前，将navigationBar的alpha设为0.f
4. 这个时候再做动画的时候，显示的就是我们截图的navigationBar了，不会受到透明，过渡动画的影响
5. 然后在动画完成的时候，将我们截屏的layer移除，并将navigationBar的alpha改为1.0 即可

