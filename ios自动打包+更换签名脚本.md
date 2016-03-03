# iOS自动打包+更换签名脚本
---
前两天看到[@lzwjava](http://weibo.com/u/1695406573?topnav=1&wvr=6&topsug=1&is_all=1)写的[iOS 下如何自动化打包 App](http://www.reviewcode.cn/article.html?reviewId=11).就想自己实践下。

尤其是感谢[victorchee](http://victorchee.github.io)同学，他的这篇文章**[用命令行打AdHoc包](http://victorchee.github.io/blog/package-adHoc-ipa/)**，已经把自动打包所需要的脚本写的很详细了。我这边的脚本基本是按照他的脚本抄下来的。

下文，只是介绍了下基本流程，以及详细的脚本。

## 基本流程
### 1 设置打包需要的根证书，以及profile的UUID
根证书：只需要从钥匙串中找到相应的证书，将其常用名称copy出来即可[范例：iPhone Distribution: **** (****)]

profile的UUID：需要使用plistbuddy来解析profile文件，并获取其中的UUID
### 2 使用xcodebuild设置证书+签名信息，并进行build生成APP文件
xcodebuild 可以编译 Xcode 工程中包含的一个或多个 targets，或者编译 Xcode workspace 或 Xcode project 中包含的 scheme。

```
xcodebuild [-project projectname] [-target targetname ...] [-configuration configurationname]
                [-sdk [sdkfullpath | sdkname]] [buildaction ...] [setting=value ...]
                [-userdefault=value ...]
     xcodebuild [-project projectname] -scheme schemename [-destination destinationspecifier]
                [-destination-timeout value] [-configuration configurationname]
                [-sdk [sdkfullpath | sdkname]] [buildaction ...] [setting=value ...]
                [-userdefault=value ...]
     xcodebuild -workspace workspacename -scheme schemename [-destination destinationspecifier]
                [-destination-timeout value] [-configuration configurationname]
                [-sdk [sdkfullpath | sdkname]] [buildaction ...] [setting=value ...]
                [-userdefault=value ...]
     xcodebuild -version [-sdk [sdkfullpath | sdkname]] [infoitem]
     xcodebuild -showsdks
     xcodebuild -list [-project projectname | -workspace workspacename]
     xcodebuild -exportArchive -exportFormat format -archivePath xcarchivepath -exportPath destinationpath
                [-exportProvisioningProfile profilename] [-exportSigningIdentity identityname]
                [-exportInstallerIdentity identityname]
```

xcodebuild 详细使用可参考[xcodebuild 命令详解](http://liuwei.so/post/2015/01/12/xcodebuild-%E5%91%BD%E4%BB%A4%E8%AF%A6%E8%A7%A3.html)

### 3 使用xcrun进行签名，并导出ipa包


xcrun 详细使用可参考[xcrun 命令详解](http://liuwei.so/post/2015/01/09/xcrun-%E5%91%BD%E4%BB%A4%E8%AF%A6%E8%A7%A3.html)


---
##具体脚本
**下面脚本在我本地已经可以正常运行，如有同学使用，需要相应修改下部分参数名称，例如：路径，工程名等。（我下面省略了pod步骤，有同学需要，则相应增加即可。）**

```
# 设置 开发，或者发布的根证书全名
Code_Sign_Identity="iPhone Distribution: **** (****)"
# 获取 provision profile 文件的UUID 注意，修改后面的证书地址【这个文件，必须与你当前安装的证书一致，可以直接从xcode的证书目录copy到你当前的目录】
App_Profile_UUID=`/usr/libexec/plistbuddy -c Print:UUID /dev/stdin <<< \ \`security cms -D -i ./iOS_BaiCaiO_AdHoc.mobileprovision\`` 
echo $App_Profile_UUID

#一些路径的切换：切换到你的工程文件目录
cd .. && \
cd baicaio &&\

# 设置项目内的Build Version，增1 
Project_Plist=baicaio/Info.plist
Project_Build_Version=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${Project_Plist})
Fixed_Project_Build_Version=$(expr $Project_Build_Version + 1)
# 生成后，项目导出到哪里
Path="/Users/Eric/Desktop/baicaio"
# 项目名称，xworkspace会用到这个名字
Project_Name="baicaio"
# 工程文件名
Project_Path="$Project_Name.xcodeproj"
# 当前是发布，还是开发，或者是你自定义的
Configuration="AdHoc"
# 是什么平台，iOS的统一是iphonesos
SDK="iphoneos"
# xcode顶部菜单栏的Scheme名称，标明当前我要运行哪个scheme
Scheme="baicaio"

# 将文件的plist 的build版本号加一，并设置到plist文件中
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $Fixed_Project_Build_Version" ${Project_Plist} && \
# 运行前先clear下项目
xcodebuild clean -workspace $Project_Name.xcworkspace -scheme $Scheme -configuration $Configuration && \

# Pod 操作
# pod update

# 进行build，注意APP_PROFILE这个参数，是修改了工程文件buildsetting里面的Provisioning profile里面你设置的对应的configuration的证书为：$APP_PROFILE 才可以这么使用【注意我这个是xcworkspace的，如果有些同学是project文件，请直接使用-project $Project_path，相应进行修改】
xcodebuild -workspace $Project_Name.xcworkspace -scheme $Scheme -configuration $Configuration -sdk $SDK CODE_SIGN_IDENTITY="$Code_Sign_Identity" APP_PROFILE="$App_Profile_UUID" build && \

# 声明Build的目录，注意，我这个build文件在这里是因为我改了Xcode里面的Locations的Derived Data：点击advanced，设置Build Location设置为Custom：Relative to Workspace
Build_Directory="Build/Products"
# Build App文件
Build_Path="$Build_Directory/AdHoc-iphoneos/$Project_Name.app"
# app文件中Info.plist文件路径
App_Infoplist_Path=${Build_Path}/Info.plist
# 取版本号
Version=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${App_Infoplist_Path})
# 取build值
BuildVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${App_Infoplist_Path})
# 取displayName
DisplayName=$(/usr/libexec/PlistBuddy -c "print CFBundleName" ${App_Infoplist_Path})
# IPA名称
IPA_Name="${DisplayName}_${Version}(${BuildVersion})_$(date +"%Y%m%d")"
# 导出IPA文件
Export_Path="$Path/$IPA_Name.ipa"

#进行签名，打成ipa包，并导出
/usr/bin/xcrun -sdk $SDK PackageApplication -v "$Build_Path" -o "$Export_Path" && \

rm -rf $Build_Directory && \
# 将生成的文件，上传到fir分发网站 -T：后面的是api的token，验证你的身份。使用这个之前，必须先安装fir的命令行工具： $ sudo gem install fir-cli --no-ri --no-rdoc
fir p $Export_Path -T 234sdfasd9sdfo239s
```