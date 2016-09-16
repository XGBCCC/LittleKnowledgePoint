# Tip方案
1. UIViewController，在viewDidLoad的时候再加载数据，而不是在还没push出来的时候，就通过设置开始加载数据
2. 页面的加载不要再使用HUD这样的loading，该用使用EmptyDataSet来加载。可以在`[imageForEmptyDataSet]`这个回调中判断loading的状态，来显示不同的图片。
3. 业务逻辑方法的入参一定要简单，明了，方便日后的扩展
4. 业务逻辑一定要颗粒化，一个逻辑只负责一个事情
5. 部分业务可能需要几个业务逻辑去组合，这种东西，可以在拉一个逻辑方法，对其进行封装组合
6. 在设计中，页面icon等东西尽量统一，尤其是navigation，这块坑比较大

