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
    NSString * cerPath = @""; //证书的路径 crt格式的
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
    self.trustedCertificates = @[CFBridgingRelease(certificate)];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://fir.im"]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    [task resume];
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    //客户端验证服务端提供的证书
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        
        
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        NSURLCredential *credential = nil;
        
        //将读取的证书设置为serverTrust的根证书
        NSString *hostName = challenge.protectionSpace.host;
        NSData *cerData = [[RNXNetworkHostAuthenticationManager sharedInstance] certificationDataWithHostName:hostName forAuthenticationType:RNXNetworkAuthenticationTypeForService];
        
        //如果发现本地证书，则验证。没有则使用系统默认的：NSURLSessionAuthChallengePerformDefaultHandling
        if(cerData){
            
            OSStatus err;
            SecTrustResultType trustResult = kSecTrustResultInvalid;
            
            //获取服务器的trust object
            SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
            //导入本地证书
            SecCertificateRef localSecCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
            err = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)@[(__bridge id)localSecCertificate]);
            
            if(err == noErr){
                err = SecTrustEvaluate(serverTrust, &trustResult);
            }
            
            if (err == errSecSuccess && trustResult == kSecTrustResultProceed){
                //认证成功，则创建一个凭证返回给服务器
                disposition = NSURLSessionAuthChallengeUseCredential;
                credential = [NSURLCredential credentialForTrust:serverTrust];
            }
            else{
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
            CFRelease(localSecCertificate);
            
        }
        //回调凭证，传递给服务器
        if(completionHandler){
            completionHandler(disposition, credential);
        }
    }
    //服务器要验证客户端的证书
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]){
        
        //获取p12的data
        NSString *hostName = challenge.protectionSpace.host;
        NSData *cerData = [[RNXNetworkHostAuthenticationManager sharedInstance] certificationDataWithHostName:hostName forAuthenticationType:RNXNetworkAuthenticationTypeForClientCertificate];
        NSString *password = [[RNXNetworkHostAuthenticationManager sharedInstance] passwordWithHostName:hostName];
        
        NSURLCredential *credential = [RNXCredentialUtil credentialWithP12Data:cerData andPassword:password];
        if (credential) {
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }else{
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
    
}

+ (NSURLCredential *)credentialWithP12Data:(NSData *)p12Data andPassword:(NSString *)password{
    
    CFDataRef inP12data = (__bridge CFDataRef)p12Data;
    
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    OSStatus status = extractIdentityAndTrust(inP12data, &myIdentity, &myTrust, password);
    
    if (status != errSecSuccess || myIdentity == nil) {
        NSLog(@"提取identity与trust失败：%@", @(status));
        return nil;
    }
    SecCertificateRef myCertificate;
    SecIdentityCopyCertificate(myIdentity, &myCertificate);
    
    const void *certs[] = { myCertificate };
    CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
    
    
    NSURLCredential *credential = [[NSURLCredential alloc] initWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistenceForSession];
    
    CFRelease(myCertificate);
    CFRelease(certsArray);
    
    return credential;
}

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust,NSString *password) {
    OSStatus securityError = errSecSuccess;
    
    CFStringRef pwd = (__bridge CFStringRef) password;
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { pwd };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef p12Items = (__bridge CFArrayRef)(CFBridgingRelease(CFArrayCreate(NULL, 0, 0, NULL)));
    securityError = SecPKCS12Import(inP12data, options, &p12Items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(p12Items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    }
    CFRelease(options);
    
    return securityError;
}




```


