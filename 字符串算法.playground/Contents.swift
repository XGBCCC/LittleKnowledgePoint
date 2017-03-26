//: Playground - noun: a place where people can play

import UIKit

//var str = "Hello, playground"
//
//let string = "abcabab"
//
//求一个字符串中连续出现次数最多的子串，请给出分析和代码
//解析：这里首先要搞清楚子串的概念，1个字符当然也算字串，注意看题目，是求连续 出现次数最多的子串。如果字符串是abcbcbcabc，这个连续出现次数最多的子串是bc，连续 出现次数为3次。如果类似于abcccabc，则连续出现次数最多的子串为c，次数也是3次。这个 题目可以首先逐个子串扫描来记录每个子串出现的次数。比如：abc这个字串，对应子串为 a/b/c/ab/bc/abc，各出现过一次，然后再逐渐缩小字符子串来得出正确的结果。
func test1(str:String)->String{
    var tt = [String]()
    for i in 0..<str.characters.count-1 {
        let endIndex = str.index(str.startIndex, offsetBy: i)
        tt.append(str.substring(from: endIndex))
    }
    
    var maxCount = 0
    var count = 0
    var subStr = ""
    for i in 0..<str.characters.count-1 {
        print("-----------")
        for j in i+1..<str.characters.count-1{
            if j-i > tt[j].characters.count {
                break
            }
            var startIndex = str.index(str.startIndex, offsetBy: i)
            var endIndex = str.index(str.startIndex, offsetBy: j-i)
            print(tt[i])
            print(tt[j])
            print("比较:\(tt[j].substring(with: str.startIndex..<endIndex))")
            
            if tt[i].substring(with: str.startIndex..<endIndex) == tt[j].substring(with: str.startIndex..<endIndex) {
                print("匹配")
                count += 1
                
                var k = j
                if k+(k-i)>=str.characters.count-1 {
                    if count>maxCount {
                        var subEndIndex = str.index(str.startIndex, offsetBy: j-i)
                        maxCount = count
                        subStr = tt[i].substring(with: tt[i].startIndex..<subEndIndex)
                        print("1--\(subStr)")
                        break
                    }
                }else{
                    
                    while k<str.characters.count-1 {
                        var subEndIndex = str.index(str.startIndex, offsetBy: j-i)
                        if tt[i].substring(with: startIndex..<subEndIndex) == tt[k].substring(with: str.startIndex..<subEndIndex) {
                            count += 1
                            if count>maxCount {
                                maxCount = count
                                subStr = tt[i].substring(with: tt[i].startIndex..<subEndIndex)
                                print(tt[k])
                                print("count:\(maxCount)--\(subStr)")
                            }
                        }
                        k = k+(j-i)
                        
                    }
                }
            }
        }
    }
    return subStr
}


//找出最长相同的子串
func test2(str:String){
    var tt = [String]()
    for i in 0..<str.characters.count{
        let endIndex = str.index(str.startIndex, offsetBy: i)
        tt.append(str.substring(from: endIndex))
    }
    
    var maxCount = 0
    var count = 0
    var subStr = ""
    for i in 0..<str.characters.count {
        for j in i+1..<str.characters.count{
            
            var startIndex = str.index(str.startIndex, offsetBy: i)
            var endIndex = str.index(str.startIndex, offsetBy: tt[j].characters.count)
            print(tt[i])
            print(tt[j])
            print("比较:\(tt[j].substring(with: str.startIndex..<endIndex))")
            
            if tt[i].substring(with: str.startIndex..<endIndex) == tt[j].substring(with: str.startIndex..<endIndex) {
                if tt[i].substring(with: tt[i].startIndex..<endIndex).characters.count > subStr.characters.count {
                    subStr = tt[i].substring(with: tt[i].startIndex..<endIndex)
                    print("结果:\(subStr)")
                }
                
            }
        }
    }
}



//转换字符串格式为原来字符串里的字符+该字符连续出现的个数，例如字符串 1233422222，转化为1121324125（1出现1次，2出现1次，3出现2次……）。
func tttt(str:String){
    var currentStr = ""
    var currentCount = 0
    var newString = ""
    for i in 0..<str.characters.count {
        let startIndex = str.index(str.startIndex, offsetBy: i)
        let endIndex = str.index(startIndex, offsetBy: 1)
        let temp = str.substring(with: startIndex..<endIndex)
        if currentStr == temp {
            currentCount += 1
            if i == str.characters.count - 1 {
                newString.append("\(currentCount)")
            }
        }else{
            if currentCount > 0 {
                newString.append("\(currentCount)")
            }
            currentStr = str.substring(with: startIndex..<endIndex)
            currentCount = 1
            newString.append("\(currentStr)")
        }
        
    }
    print(newString)
}

tttt(str: "1233422222")

//移动字符串内容，传入参数char *a和m，规则如下：将a中字符串的倒数m个字符移到字符串前面，其余依次像右移。例如：ABCDEFGHI,M=3,那么移到之后就是GHIABCDEF
func qqqq(str:[String],count:Int){
    var tt = str
    var count = count
    if tt.count>count {
        while count>0 {
            var tmp = tt[0]
            tt[0] = tt[tt.count-1];
            var i = str.count - 1
            while i>=1 {
                if i == 1 {
                    tt[i] = tmp
                    print(tt)
                }else{
                    tt[i] = tt[i-1]
                    print(tt)
                }
                i -= 1
            }
            count -= 1
            
        }
    }
    print(tt)
}
qqqq(str: ["A","B","C","D","E","F","G","H","I"], count: 3)
