# NSScanner

复制于：http://my.oschina.net/u/2312022/blog/380129

**摘要**

NSScanner是一个类，用于在字符串中扫描指定的字符，通常是将他们转换成数字和别的字符串。







      NSScanner是一个类，用于在字符串中扫描指定的字符，通常是将他们转换成数字和别的字符串。我们可以在创建NSScanner时指定它的string属性，然后scanner会按照我们的要求从头到尾扫描这个字符串的每个字符。

      创建一个NSScanner

      NSScanner是一个类族，通常我们可以使用scannerWithString或locallzedScannerWithString方法初始化一个scanner。这两个方法都返回一个scanner对象，并用我们传递的字符串参数初始化其string属性。刚创建的scanner对象指向字符串的开头。scanner方法开始扫描，比如有：scanInt、scanDouble、scanString:intoString。示例代码如下：

```
int val;
NSScanner *theScanner = [NSScanner scannerWithString:aString]; 
while([theScanner isAtEnd] == NO)
{
   [theScanner scanInt:&val];
}
```

以上例子会循环搜索字符串中的整型值，并赋值给val参数。isAtEnd方法会紧接上一次搜索到的字符位置继续搜索，看是否存在下一个整型值，直到扫描结束。扫描的核心是字符位置的移动，位置在不停的扫描中移动，直至扫描结束。

      Scanner的使用

      以字符串“132 panda lxl of apple”为例，在扫描完一个整数之后，scanner的位置将变成3，也即是数字后面的空格处。scanner在任何操作时会跳过空白字符之后才开始，当它找到一个可以扫描的字符时，它会用全部字符去和指定内容匹配，scanner默认情况下会忽略空白字符和换行符。

举个实际例子：132 fushi pingguo of apple

下面的代码可以找出苹果的数量(132)和名称(fushi)。

```
NSString *apple = @"132 fushi pingguo of apple";
NSString *separateString = @" of";//注意of前面有一个空格
NSScanner *aScanner = [NSScanner scannerWithString:apple];
NSInteger anInteger;
[aScanner scanInteger:&anInteger];//得到数量132
NSString *name;
[aScanner scanUpToString:separateString intoString:&name];//得到名称fushi pingguo
```

查找字符串separateString为"of"很重要，scanner默认会忽略空白字符，因此数字132后面的空格会被忽略。但是当scanner从空格后面的字符开始扫描时，所有的字符都会被加载到输出字符串中，一直到遇到搜索字符串"of"。

注意：如果搜索字符串是“of”，(前面没空格)，name的值应该是"fushipingguo "(最后面有个空格)；如果搜索字符串是" of"，(前面有空格)，则name的值为"fushi pingguo"(最后面无空格)。在扫描到指定字符串(搜索字符串)后，scanner的位置指向了该字符串的开始处。此时，如果我们想继续扫描该字符串之后的字符，则同上面一样，必须先扫描指定字符串(搜索字符串)。下面的代码演示了如何跳过搜索字符串并取得产品类型，代码如下：

```
[aScanner scanString:separateString intoString:NULL];
NSString *product;
product = [[aScanner string] substringFromIndex:[aScanner scanlocation]];
```

实例：

假设我们有如下字符串：

Product:Lxl Panda Peter;Cost:0.23 87

Product:Xiong Mao Bet;Cost:0.38 76

Product:San Di Sex;Cost:1.29 3

以下代码演示了读取产品名称和价格(float类型)的操作，跳过"Product:"和"Cost:"字串以及";"号。

```
NSString *Sumstring = @"Product:Lxl Panda Peter;Cost:0.23 87\n\
Product:Xiong Mao Bet;Cost:0.38 76\n\
Product:San Di Sex;Cost:1.29 3\n";
NSCharacterSet *semicolonSet;
NSScanner *theScanner;
NSString *PRODUCT =@"Product:";
NSString *COST = @"Cost:";
NSString *productNmae;
float productCost;
NSInteger productSold;
semicolonset = [NSCharacterSet charactSetWithCharactersInString:@";"];
theScanner = [NSScanner scannerWithString:Sumstring];
while([theScanner isAtEnd] == NO)
{
    if([theScanner scanString:PRODUCT intoString:NULL] &&
       [theScanner scanUpToCharactersFrom:semicolonSet intoString:&productNmae]&&
       [theScanner scanString:@";" intoString:NULL]&&
       [theScanner scanString:COST intoString:NULL]&&
       [theScanner scanFloat:&productCost]&&
       [theScanner scanInteger:&productSold])
    {
         NSLog(@"Sales of %@:$%1.2f",productNmae,productCost*productSold);
    }
}
```

实例结束

实例二

从字符串中提取数字

-(void)findNumFromStr

{

    NSString *originalString = @"a1b2c3d4e5f6g7h8i9j0";

    NSMutableString *numberString = [[NSMutableString alloc] init];

    NSString *tempStr;

    NSScanner *scanner = [NSString scannerWithString:originalString];

    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];

    while(![scanner isAtEnd])

    {

         [scanner scanUpToCharactersFromSet:numbers intoString:NULL];

         [scanner scanCharactersFromSet:numbers intoString:&tempStr];

         [numberString appendString:tempStr];

         tempStr = @"";

    }  

    int number = [numberString integerValue];

    return number;                  

}





