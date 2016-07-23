### Layers
1. `[zPosition]`：修改值表示会让物体看起来变大或者变小，数值越大，绘制就越在上层
### UIViewController
1. 当一个ViewController刚被实例化的时候，它是没有view的。ViewController是个小且轻量的对象；View因为包含了界面元素，会占据内存，是相对重的对象。因此一个ViewController会把获得view的时间尽量推迟，也就是访问view属性的时候，才lazy initialize
2. 如果我们需要自定义ViewController的View的话，需要重写loadView方法［注意，此处不要掉用super］
3. ViewController默认的init方法，会自动掉用查找同名的nib，来进行加载，所有如果名字相同，我们可以直接使用：`[let vc = RootViewController()]` 就可以直接从nib来加载VC了
4. ViewController旋转后事件的掉用顺序
	1. willTransitionToTraitCollection:withTransitionCoordinator:
	2. viewWillTransitionToSize:withTransitionCoordinator:
	3. updateViewConstraints
	4. traitCollectionDidChange:
	5. viewWillLayoutSubviews
	6. viewDidLayoutSubviews
5. 布局代码哪里添加好？
	1. layout适合放在viewDidLoad
	2. 具体的frame尽量不要放在didLoad中，因为此时self.view还没有对应的尺寸
	3. 布局，约束也需要变的话，可以放在viewWillLayoutSubviews:里
6. UINavigation可以直接掉用hidesBarOnTap,hidesBarONSwipe等方法来设置bar自动隐藏
7. 有时我们会需要修改tableview的contentInset，设置一定量的偏移，但是这个时候，我们会发现右边的滚动条，却出卖了我们，这时，我们可以用这个属性`[scrollIndicatorInsets]`将其设置为痛contentInset一样即可，这样我们的滚动条就也OK了
8. tableViewCell，如何支持自定义的操作（例如，系统自带的支持delete），在`[editactionsForRowAtIndexPath]`代理中返回相应的`[TableViewRowAction]`即可
9. UITableView如何移动Cell
	1. [tableView setEditing:YES]
	2. tableView:canMoveRowAtIndexPath:  返回YES
	3. 限制不能移动到某些位置：tableView:targetIndexPathForMoveFromeRowIndexPath:toProposedIndexPath
	4. 移动后，更新相应的数据源：tableView:moveRowAtIndexPath:toIndexPath
10. 长按Cell，如何显示Copy
	1. 在 UIMenuController.sharedMenuController 添加相应的action 
	2. tableView:shouldShowMenuForRowAtIndexPath  返回YES
	3. tableView:canPerformAction:forRowAtIndexPath:withSender，返回相应UIMenuController.sharedMenuController中包含的selector
	4. tableView:performAction:forRowIndexPath:withSender 执行相应的action
11. Popover［iPad上的弹出］
	1. 默认情况下，我们弹出一个ViewController，然后我们点击页面的其它地方popover就会自动隐藏，这时，我们可以设置pop的passthroughViews，这些view点击的时候，不会隐藏popover。这里还有个小问题，一旦我们点击了工具栏的一个按钮，工具栏上的其他按钮同样会被自动添加的 passthrough view 中，用户还可以去点击不同的按钮，这里有个比较旁门左道的实现，停止 0.1s，用我们自己的设置去覆盖 runtime 进行的设置，如：
	![](http://7xwb99.com1.z0.glb.clouddn.com/2016-07-22-14691784188662.jpg)
	2. 默认的popover是弹出一小块，我们还可以设置popover出来的样式［例如全屏弹出,alter弹出］：首先设置vc.presentationController的delegate，然后实现adaptivePresentationStyleForPresentationController：返回你想要的样式即可


