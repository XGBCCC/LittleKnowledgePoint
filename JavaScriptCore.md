# JavaScriptCore
#####1.web页面javascript触发iOS操作
```
//获取到web页面的JS对象
JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//相当于声明一个方法“stat”相当于方法名，“^(NSString *event)”相当于，传递一个参数，`[这样H5页面直接调用stat这个js方法，就会触发我们这里的操作]`
    context[@"stat"] = ^(NSString *event){
        [StatisFrameworkManager event:event];
        DDLogInfo(@"UMAnalytics...%@",event);
    };
```

