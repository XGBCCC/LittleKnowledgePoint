# 根据dsym+地址，查找崩溃堆栈
atos -o /Users/Eric/Desktop/crash/20170415.dSYM/Blibee.app.dSYM/Contents/Resources/DWarf/Blibee -arch arm64 0x1000FC718。

地址如何计算：
1. 崩溃的堆栈地址—Slide Address【苹果运行app的时候的内存偏移量】 = dsym真正需要的地址(可以计算出哪个方法崩溃了)
2. 可以直接使用app-计算器(编程计算模式)

