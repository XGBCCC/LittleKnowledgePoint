#### CollectionType
1. `[CollectionType]协议`: 如果我们可以自己创建个集合类，然后继承这个协议，实现3个方法(`[startIndex]`,`[endIndex]`,`[subscript]`)，然后系统就会自动提供给我们：`[for in]`,`[joinWithSeparator]`,`[map]`,`[filter]`等集合的相关方法

2. `[ArrayLiteralConvertible]协议`：这个协议里有个init方法，实现后，我们就可以使用这种方式来创建集合了`[let q:Queue = [1,2,3]]`
3. `[RangeReplaceableCollectionType]协议`：实现这个协议后，系统会提供我们：`[append,appendContentsof,removeAtIndex,insertAtIndex,removeAll]`等方法，这里，我们主要需要实现这两个方法`[reserveCapacity(直接return即可),replaceRange]`
4. `[mutating]`:是结构体上的可变方法所做的事情,它们其实接受一个隐式的 inout 的 self 作为参数,这 样它们就能够改变 self 所持有的值了
5. `[索引]`：通过实现`[CollectionType]`协议，我们有了map，for in等方法。实现`[ForwardIndexType]`我们就可以进行使用successor方法获取下一个对象 `[ArrayLiteralConvertible]`：实现这个协议，可以支持类似let q = [1,2,3]的快捷初始化方式。`[BidirectionalIndexType]`：实现这个协议，我们就可以支持reverse反向数组，并支持successor,predecesor
6. reverse,获取反向数组：其实并不是将数据反转了，只是将索引进行反转。提高程序性能

### if case
1. `[if case]`:可以用来匹配是否是我们想要的值或者范围
	1. 值`[if case a = s]`
	2. 范围：`[if case 0..<10 in j]`
	3. 重写 if case，只需要重写相应的 `[func ~=<T,U>(_:T,_:U)->Bool]`方法即可
	4. `[case let x?]`:这种，其实就是`[case let .Some(i)]`,可以直接拿到Int值，而不是Int？
	5. 注意：maybeInts.generate().next 这样的方法，拿到的是 `[Optional<Optional<Int>>]`这样的值，而不是我们想的 `[Optional<Int>]`

### map flatmap
1. `[map]`:map是对对象的按指定的必报进行一种转换
2. `[fileMap]`有两个重载
	1. `[func flatMap<S : SequenceType>(transform: (Self.Generator.Element) -> S) -> [S.Generator.Element]]`
		1. 如果flatMap里面的闭包返回的是个数组，则会掉用这个
		2. 这个方法会首先执行相应的map操作，然后再将map后的数据，一个个展开，进行组合
		3. 源码
		
		```swift
		extension Sequence {
    
		public func flatMap<S : Sequence>(@noescape transform: (${GElement}) throws-> S) rethrows -> [S.${GElement}] {
	  	  var result: [S.${GElement}] = []
	  	  for element in self {
	  	    result.append(contentsOf: try transform(element))
	  	  }
	  	  return result
	  	}
	  	
		}
		```
		
	2. `[func flatMap<T>(transform: (Self.Generator.Element) -> T?) -> [T]]`
		1. 如果flatMap里面的闭包，返回的是个Optional类型的，则来这个方法
		2. 掉用这个，flatMap会过滤掉所有nil的值，并将Optional转换为有值的类型
		3. 源码
		
		```swift
		extension Sequence {
		  public func flatMap<T>(@noescape transform: (${GElement}) throws -> T?) rethrows -> [T] {var result: [T] = []
		    for element in self {
		      if let newElement = try transform(element) {
		        result.append(newElement)
		      }
		    }
		    return result
		  }
  
  
		}
		```



