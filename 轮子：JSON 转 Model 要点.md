# JSON转Model要点
### 基础方法
1. 我们一般掉用都是直接使用`[[User alloc] initWithJson:json]`这样来获取到实例
2. 这里的JSON一般为Dictionary，String或者Data
3. 那么，首先，我们想到的是，获取到User的每个属性，然后跟Dictionary的key一一对应，然后进行相应的赋值即可
4. 通过`[class_copyPropertyList(cla,&propertyCount)]`来获取到类的所有属性
5. 拿到属性的名称`[property_getname(property)]`
7. 然后根据属性名称，获取到相应的set方法：`[NSSelectorFormString([NSString stringWithFormat@"set%@",setter])]`
8. 那么，我们现在有了class，set方法，是不是就可以使用`[((void (*)(id, SEL, id))(void *) objc_msgSend)((id)self, NSSelectorFromString(@"setUsername:"), @"shuaige");]`来直接掉用set方法赋值呢了
9. 那么，其实我们还差个value，value怎么获取呢？
10. 刚才，我们不是有属性名称了吗，直接从JSON中找到相应的名字，并获取到它的Value，不就有了。

### 查缺补漏
1. `[[User alloc] initWithJson:json]`：这个JSON不一定是Dictionary，我们要对其进行判断，并转换为NSDictionary
2. JSON里面Key的名字与property的名字不相同
	1. 看其他三方库的实现，基本都是遵循一个协议，然后里面有一个字段映射的方法，来解决
	2. so，我们也可以这么干，创建个协议，然后实现映射方法，当有字段名字不相同的时候，在里面做下映射关系
	3. 然后在掉用msgSend之前，查询，是否有字段名字映射，有的话则获取置换后的key，并拿到相应的值。
3. 关于NSInteger类型的赋值
	1. 首先我们知道NSDictionary里面不能放Int类型的value，只能放相应的id，NSObject类型。
	2. 所以，我们一般添加值的时候，都是用的@123这种
	3. 那么，NSDictionary解析后也一样，最重我们获取到的value，就变成了NSNumber类型
	4. 所以，这块，我们需要将NSNumber相应转换为NSIntege，Float等
	5. 那么，我们怎样获取这个属性应该是NSInterge，还是Float呢
		1. 刚才我们已经说到怎么获取property了
		2. 我们可以使用`objc_property_attribute_t *attrs = [property_copyAttributeList(property,&attrCount)]`来获取到属性的各种参数
		3. 遍历`[attrs]`，这个可以拿到属性的所有信息
		4. 然后我们根据attris[i]的name，来判断当前是属性的哪个信息,如果**name是T开头的则表示这个是类型信息，然后，取相应的`[attris[i].value]`获取type encoding就是类型信息了。这块，类型的对应信息，我们可以搜一下 type encoding，来进行匹配**
		5. 根据这个我们就能获取到相应的属性类型，然后通过：`[((void (*)(id, SEL, BOOL))(void *) objc_msgSend)(modelSelf, self.setter, number.boolValue);]`,这样来设置NSInterge，BOOL值
4. 如果用户自定义了setter方法呢？property (setter=setCustomUserName:) NSString *userName
	1. 上面说过我们可以使用`objc_property_attribute_t *attrs = [property_copyAttributeList(property,&attrCount)]`来获取到属性的各种参数
	2. 同样我们遍历attrs，如果找到name是S开头的，则表示这块存的是setter方法，然后通过：`[ NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value])]`来获取相应的方法名字
	3. 然后在msgSend调用的时候，使用刚才我们获取到的方法名即可
5. 如果我们的类里面有数组
	1. 还是根据`objc_property_attribute_t *attrs = [property_copyAttributeList(property,&attrCount)]`来获取到属性的各种参数
	2. 然后发现类型是数组
	3. 然后，此时，去找我们之前有木有定义过这个array里面是什么东西，是类还是什么
	4. 然后解析的时候，进行相应的二次解析即可
6. 如果我们的类里面有自定义的类
	1. 同样，还是根据`objc_property_attribute_t *attrs = [property_copyAttributeList(property,&attrCount)]`来获取到属性的各种参数
	2. 然后我们通过name是T的，来获取自定义类型，然后此处就不要掉用msgSend了
	3. 而是再通过调用`[initWithJSON]`来递归解析，里面内容


