# JSON 相关
## JSON不支持NSDate，以及NSSet类型的数据
1.如果我们的Data，或者NSDictionary中有NSDate类型的话，使用NSJSONSerialization 来转换则会直接报错
2.如果我们使用SwiftyJOSN来进行转换这个，则会直接将这个vale返回nil

