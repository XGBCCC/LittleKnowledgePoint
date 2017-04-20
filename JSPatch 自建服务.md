# JSPatch 自建服务
1. iOS层面
    1. 需要引入JSPatch的文件
        1. https://github.com/bang590/JSPatch
        2. JSPatch主目录肯定是需要的
        3. Loader目录，用于配合后台代码分发后的下载，解密等
        4. Extension（提供部分GCD，锁，C函数调用等功能），根据我们的需求，可自行接入【jspatch官方的SDK也默认没有接入】
            1. 扩展内部的具体内容 https://github.com/bang590/JSPatch/wiki/接入扩展
    2. 类名+方法名混淆
        1. 混淆JSPatch+Loader的相关内容
            1. 参考了：http://www.jianshu.com/p/6607fef31de0
            2. 汇总需要混淆哪些方法，类名
                1. 文件夹名字
                2. 类名+方法名
                3. 相关注释
                4. 方法名【是否只添加宏就可以，因为添加完宏，编译后class_dump的名字已经改了】
            3. JS的代码，貌似不需要进行混淆【苹果会不会扫描相关文件？】
                1. 如果混淆JS就简单的自己替换方法名？
        2. 具体混淆方法
            1. http://blog.csdn.net/yiyaaixuexi/article/details/29201699
            2. 大概为：采用宏替换关键方法名，然后打包的时候会自动替换，苹果审核的时候就扫描不到关键点了
                1. 简单来说，列出所有想要混淆的方法名
                2. 在build的时候，遍历，然后生成随机字符串，采用宏的方法，来做一一对应
                3. 在pch文件引用生成的宏文件
    3. 脚本下载
        1. 可直接使用JSPatch的Loader来做
            1. https://github.com/bang590/JSPatch/wiki/JSPatch-Loader-使用文档
                1. 基本做法：1.根据RSA进行解密文件，然后对比两个文件的MD5，相同则是我们下发的
                2. 然后再解析+加载相应的JS
        2. 检查是否有更新，需要我们服务器自己来进行支持
    4. 需要一套服务来检测JS的上传，更新，删除，客户端来进行响应的操作
        1. 可以简单一个API，获取最新版本等。。（我们现在RN不是有一套吗，可以按这个逻辑来做尝试）
2. 服务器层面
    1. 提供相应的接口来检测JS文件的更新
        1. 类似于我们RN现在使用的版本更新操作
    2. JS代码的下发
        1. 可参考：https://github.com/bang590/JSPatch/wiki/JSPatch-Loader-使用文档
            1. 内部有个简易的php上传
            2. 传输zip到服务器指定目录，提供给iOS下载
3. 安全部署
    1. 
4. 基本流程：
    1. https://www.ianisme.com/ios/2421.html
        1. 
        2. 但需要稍作改变
            1. 按JSPatch平台的做法，没有使用DES加密，直接使用https即可
            2. 只有首次加载某个版本包的时候检测MD5即可


