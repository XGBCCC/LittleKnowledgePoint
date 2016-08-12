# 点击拖拽View
```
#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) CGRect dragButtonLastFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dragButtonLastFrame = CGRectMake(0, 200, 100, 100);
    UIButton *dragButton = [[UIButton alloc] initWithFrame:self.dragButtonLastFrame];
    [dragButton setBackgroundColor:[UIColor redColor]];
    [dragButton addTarget:self action:@selector(dragButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dragButton];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragButtonPanGestureRecognizerAction:)];
    [dragButton addGestureRecognizer:panGestureRecognizer];
}

- (void)dragButtonPanGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer{
    UIView *dragView = panGestureRecognizer.view;
    CGPoint translation = [panGestureRecognizer translationInView:dragView];
    dragView.frame = CGRectOffset(self.dragButtonLastFrame, translation.x, translation.y);
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateFailed || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        CGFloat willMoveToX = 0;
        if (dragView.frame.origin.x > self.view.bounds.size.width/2) {
            willMoveToX = self.view.bounds.size.width-dragView.frame.size.width;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            dragView.frame = CGRectMake(willMoveToX, dragView.frame.origin.y, dragView.frame.size.width, dragView.frame.size.height);
        } completion:^(BOOL finished) {
            self.dragButtonLastFrame = dragView.frame;
        }];
        
    }
    
}

- (void)dragButtonClicked:(UIButton *)button{
    [button setBackgroundColor:[UIColor blueColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

```

