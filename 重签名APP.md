# 重签名APP
## 首先看APP内是否有dylib文件，需要重签名，如果有，则需要使用yolo来进行操作
yolo 如何使用：
1.下载地址 https://github.com/zhengmin1989/iOS_ICE_AND_FIRE

2.对ipa中的dylib使用：./yololib pokemongo libFakeLocation.dylib

3.对dylib 执行 codesign：codesign -f -s "iPhone Distribution: 你的证书." ******.dylib

4.将dylib重新丢进app中，并进行压缩，改后缀为ipa

## 重签名ipa
### 使用sigh来重签名，sigh是fastlane的一部分
如何安装sigh：sudo gem install sigh
使用就非常简单了：
1、输入sigh resign，回车
2、把要签名的ipa文件拖到窗口上，回车
3、填写用来签名的证书，回车
4、把embedded.mobileprovision文件拖到窗口上，回车
5、好了，resign脚本会自动更改bundel id，签名并重新打包。



##参考学习
1.http://iosre.com/t/topic/2966
2.http://mp.weixin.qq.com/s?__biz=MzIwMTYzMzcwOQ==&mid=2650948432&idx=1&sn=125742722bbbce53774199a587688088&scene=0#wechat_redirect
3.http://mp.weixin.qq.com/s?__biz=MzIwMTYzMzcwOQ==&mid=2650948304&idx=1&sn=f76e7b765a7fcabcb71d37052b46e489&scene=21#wechat_redirect


