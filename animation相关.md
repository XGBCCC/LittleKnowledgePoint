# animation
##UIView animation
1. `[transitionWithView]`: 这个方法，是对View的内容进行替换的时候，使用的，例如，我们要给self.imageView更换图片，或者要给他添加子View
```Objective-C
[UIView transitionWithView:self.imageView duration:2 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.imageView.image = [UIImage imageNamed:@"IMG_7682"];
    } completion:nil];
```
2. `[transitionFromView]`:把fromView替换为toView(如果toview已经在superview上了，则只是把fromView从superview移除。但是如果toview没有在superview，则会把fromeView移除，并把toView放上去)，
```Objective-C
[UIView transitionFromView:self.imageView toView:self.colorView duration:2 options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
```

3. `[animateWithDuration]`:主要是修改layer的相关属性，例如：color，frame等
```Objective-C
[UIView animateWithDuration:2 animations:^{
        self.view.backgroundColor = [UIColor redColor];
    }];
```

