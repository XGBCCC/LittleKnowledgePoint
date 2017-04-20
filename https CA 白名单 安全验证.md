# https CA 白名单 安全验证
###主要问题：
1. 例如，我们将charles的证书安装到手机上，并进行信任。
2. 然后我们就可以通过charles来截取手机发的https请求。
3. 原因在于：我们信任了charles的证书，然后系统默认判断证书是否合法的时候，会查找我们的根证书，发现我们根证书信任这个了，然后就放行了。

###解决办法：
1. app内部导入个CA的根证书
2. 然后判断合法的时候，仅判断是否是这个CA下发的。这样，就不会去判断系统的其他证书了，然后就O了
3. 系统默认会判断CA，HostName，叶子证书信息的。

###具体代码
```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //先导入证书
    NSString * cerPath = @""; //证书的路径
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
    self.trustedCertificates = @[CFBridgingRelease(certificate)];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://fir.im"]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    [task resume];
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    //1)获取trust object
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    SecTrustResultType result;
    
    //注意：这里将之前导入的证书设置成下面验证的Trust Object的anchor certificate
    SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)self.trustedCertificates);
    
    //2)SecTrustEvaluate会查找前面SecTrustSetAnchorCertificates设置的证书或者系统默认提供的证书，对trust进行验证
    OSStatus status = SecTrustEvaluate(trust, &result);
    if (status == errSecSuccess &&
        (result == kSecTrustResultProceed ||
         result == kSecTrustResultUnspecified)) {
            
            //3)验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
            NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
            [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
            
        } else {
            
            //5)验证失败，取消这次验证流程
            [challenge.sender cancelAuthenticationChallenge:challenge];
            
        }
}
```


