# iOS后台运行
1. 位置服务
2. beginBackgroundTask
3. backgroundFetch
    1. 可以自己设置最小间隔
    2. 但是具体运行时机不确定【苹果会根据用户打开app的频率等信息，自己来做判断】
    3. performFetchWithCompletionHandler：运行时间需要在30秒内完成
4. 静默推送
    1. 只有在app在前后台才能收到
    2. 苹果那边对静默推送有限制，不确定所有都可达


