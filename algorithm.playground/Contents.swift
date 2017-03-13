//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//从字符串haystack中找到needle第一次出现的位置
func strStr(haystack:String,_ needle:String) ->Int {
    var hChars = [Character](haystack.characters)
    var nChars = [Character](needle.characters)
    
    guard hChars.count >= nChars.count else {
        return -1
    }
    if nChars.count == 0 {
        return 0
    }
    
    for i in 0...(hChars.count-nChars.count) {
        guard hChars[i] == nChars[0] else {
            continue
        }
        for j in 0..<nChars.count {
            guard hChars[i+j] == nChars[j] else {
                break
            }
            
            if j == nChars.count - 1 {
                return i
            }
        }
    }
    return -1
}

let startIndex = strStr(haystack: "liu mao mao", "mao mao")

//堆栈实现
//class Stack{
//    var stack:[AnyObject]
//
//    init() {
//        stack = [AnyObject]()
//    }
//
//    func push(object:AnyObject){
//        stack.append(object)
//    }
//    func pop()->AnyObject?{
//        return stack.removeLast()
//    }
//    func isEmpty()->Bool{
//        return stack.isEmpty
//    }
//    func peek()->AnyObject?{
//        return stack.last
//    }
//
//}
//给一个整形数组和一个目标值，判断数组中是否有两个数字之和等于目标值 ->(最简单 就是通过双层循环，来比对相加的结果O（n^2）)

//指定的值，减去当前的值，然后得到的值就是我们需要的值，如果集合里面有，则表示有（时间复杂度 O(n) ）[注意，此处用的是set，而不是数组，set的事件复杂度是O(1)]
func twoSum(nums:[Int],sum:Int) -> Bool {
    var set = Set<Int>()
    for i in nums {
        if set.contains(sum-i) {
            return true;
        }
        set.insert(i)
    }
    return false
}
let have = twoSum(nums: [1,3,4,3], sum: 7)

//找到这两个数的和等于target，并返回index
func twoSum(nums:[Int],_ target:Int) -> [Int]{
    var res = [Int]()
    var dict = [Int:Int]()
    for i in 0..<nums.count {
        guard let lastIndex = dict[target - nums[i]] else {
            dict[nums[i]] = i
            continue
        }
        res.append(lastIndex)
        res.append(i)
        break
    }
    return res
}

//字符串反转
private func _swap(chars:inout [Character], _ p:Int, _ q:Int){
    let temp = chars[p]
    chars[p] = chars[q]
    chars[q] = temp
}

//"the key is blue"  -> "blue is key the"  [最粗浅的，可能是：分割为数组，然后倒叙拼接]

func reverseWords(s:String) -> String{
    var chars = [Character](s.characters)
    _reverse(chars:&chars,0,chars.count-1)
    
    var start = 0
    for i in 0..<chars.count{
        if i == chars.count - 1 || chars[i+1] == " "{
            _reverse(chars: &chars, start, i)
            start = i+2
        }
    }
    return String(chars)
}

private func _reverse(chars : inout [Character],_ start:Int,_ end:Int){
    var start = start
    var end = end
    while start < end {
        _swap(chars: &chars , start, end)
        start += 1
        end -= 1
    }
}


//节点
class ListNode{
    var val:Int
    var next:ListNode?
    
    init(_ val : Int) {
        self.val = val
        self.next = nil
    }
}
//链表
class List{
    var head:ListNode?
    var tail:ListNode?
    
    func appendToTail(val:Int) {
        if tail == nil {
            tail = ListNode(val)
            head = tail
        }else{
            tail?.next = ListNode(val)
            tail = tail?.next
        }
    }
    
    func appendToHead(val:Int){
        if head == nil {
            head = ListNode(val)
            tail = head
        }else{
            let tmpHead = head
            head = ListNode(val)
            head?.next = tmpHead
            
        }
    }
}

//给一个链表和一个值x，要求只保留链表中所有小于x的值，原链表的节点顺序不能变。
//例：1->5->3->2->4->2，给定x = 3。则我们要返回 1->2->2
func getLeftList(head:ListNode?, _ x:Int) -> ListNode? {
    let dummy = ListNode(0)
    var pre = dummy
    var node = head
    while node != nil {
        if node!.val < x {
            print(pre)
            pre.next = node
            //此处正解，上面那一行将dummy增加了next，然后重新给pre赋值为当前的node，然后再下一个循环中，就可以在此设置他的next，同时，dummy已经引用了pre，so，dummy的next，next就能一直设置下去了
            pre = node!
        }
        node = node?.next
    }
    return dummy.next
}

//给一个链表和一个值x，要求将链表中所有小于x的值放到左边，所有大于等于x的值放到右边。原链表的节点顺序不能变。例：1->5->3->2->4->2，给定x = 3。则我们要返回 1->2->2->3->5->4
func partition(head:ListNode?,_ x:Int) ->ListNode?{
    let leftNode = ListNode(0)
    var leftNodeTmp = leftNode
    let rightNode = ListNode(0)
    var rightNodeTmp = rightNode
    
    var node = head
    while node != nil {
        if node!.val < x{
            leftNodeTmp.next = node
            leftNodeTmp = node!
        }else{
            rightNodeTmp.next = node
            rightNodeTmp = node!
        }
        node = node?.next
    }
    rightNodeTmp.next = nil
    leftNodeTmp.next = rightNode.next
    return leftNode.next
}

//快行指针，就是两个指针访问链表，一个在前一个在后，或者一个移动快另一个移动慢(所以如何检测一个链表中是否有环？用两个指针同时访问链表，其中一个的速度是另一个的2倍，如果他们相等了，那么这个链表就有环了)
//因为如果有循环，fastNode会一直在那走，所以，一定会有===的情况产生
func hasCycle(head:ListNode?) -> Bool {
    var slowNode = head
    var fastNode = head
    while fastNode != nil && fastNode?.next != nil {
        slowNode = slowNode!.next
        fastNode = fastNode!.next!.next
        
        if slowNode === fastNode {
            return true
        }
    }
    return false
}

//删除链表中倒数第n个节点。例：1->2->3->4->5，n = 2。返回1->2->3->5。
//注意：给定n的长度小于等于链表的长度。(思路：既然是倒数N个，那么让两个循环一起走，但是一个是从0开始，一个是从N开始，这样，当另外一个走到最后的时候，前面那个刚好就是倒数第N个，然后移除这个元素，并将前后进行对接)
func removeNthFormEnd(head:ListNode?, _ n :Int) -> ListNode?  {
    guard let head = head else {
        return nil
    }
    let dummy = ListNode(0)
    dummy.next = head
    var dummyLeft:ListNode? = dummy
    var dummyRight:ListNode? = dummy
    
    for _ in 0..<n{
        if dummyRight == nil{
            break
        }
        dummyRight = dummyRight?.next
    }
    while dummyRight != nil && dummyRight?.next != nil {
        dummyLeft = dummyLeft?.next
        dummyRight = dummyRight?.next
    }
    dummyLeft?.next = dummyLeft?.next?.next
    return dummy.next
}


public class Stack{
    public var isEmpty:Bool {
        return stack.isEmpty
    }
    public var size:Int {
        return stack.count
    }
    public var peek:AnyObject? {
        return stack.last
    }
    
    private var stack:[AnyObject]
    
    public init() {
        stack = [AnyObject]()
    }
    
    public func push(_ obj:AnyObject){
        stack.append(obj)
    }
    public func pop() -> AnyObject? {
        return stack.removeLast()
    }
}

public class Queue{
    public var isEmpty:Bool {
        return queue.isEmpty
    }
    public var size:Int {
        return queue.count
    }
    public var peek:AnyObject? {
        return queue.last
    }
    
    private var queue:[AnyObject]
    
    public init(){
        queue = [AnyObject]()
    }
    
    public func enqueue(_ obj:AnyObject){
        queue.append(obj)
    }
    
    public func dequeue() -> AnyObject? {
        return queue.removeFirst()
    }
}

//> Given an absolute path for a file (Unix-style), simplify it.
//For example,
//**path** = "/home/", => "/home"
//**path** = "/a/./b/../../c/", => "/c"
func simplifyPath(path:String) -> String {
    let paths = path.components(separatedBy: "/")
    let stack = Stack()
    for path in paths {
        if path == "." {
            continue
        }else if path == ".." {
            stack.pop()
        }else{
            stack.push(path as AnyObject)
        }
    }
    var res = ""
    while let str = stack.pop() as? String {
        res += "/"
        res += str
    }
    return res.isEmpty ? "/" :res
}

//用两个栈实现队列[主要思想是两个，一个负责添加，一个负责删除]：因为，先进先出，所以pop永远是pop->StackB 的，然后当stackB，pop完了后，再从stackA中pop-push插入，添加永远是在stackA里面添加
class MyQueue{
    var stackA:Stack
    var stackB:Stack
    
    public var size:Int {
        return stackA.size+stackB.size
    }
    
    public func enqueue(object:AnyObject){
        
        _shift()
        stackA.push(object)
    }
    public func dequeue() -> AnyObject? {
        _shift()
        return stackB.pop()
    }
    
    // 因为，先进先出，所以pop永远是pop->StackB 的，然后当stackB，pop完了后，再从stackA中pop-push插入，添加永远是在stackA里面添加
    private func _shift(){
        if stackB.isEmpty {
            while let item = stackA.pop() {
                stackB.push(item)
            }
        }
    }
    
    init(){
        stackA = Stack()
        stackB = Stack()
    }
}
//用两个队列实现栈【主要思想：栈，先进先出，队列，先进后出，所以ququeA，负责添加+移除（queueA永远只保留一个，保证移除的事最近的一个，如果push到A里面多个了，则在pop的时候，需要A里面的都转到B里。然后A就可以正常的移除最近的一个了。这个时候，A就空了，如果再移除，就需要将A，B数据进行置换，然后继续上面的流程即可）】
class MyStack{
    var queueA:Queue
    var queueB:Queue
    
    init(){
        queueA = Queue()
        queueB = Queue()
    }
    
    func push(object:AnyObject){
        queueA.enqueue(object)
    }
    func pop() -> AnyObject? {
        _shift()
        let popObject = queueA.dequeue()
        _swap()
        return popObject
    }
    
    private func _shift(){
        while queueA.size != 1 {
            queueB.enqueue(queueA.dequeue()!)
        }
    }
    
    private func _swap(){
        let temp = queueB
        queueB = queueA
        queueA = temp
    }
}


//二叉树
public class TreeNode{
    public var val:Int
    public var left:TreeNode?
    public var right:TreeNode?
    public init(_ val:Int){
        self.val = val
        self.left = nil
        self.right = nil
    }
}
//计算二叉树的最大深度
func maxDepth(root:TreeNode?) -> Int {
    guard root != nil else {
        return 0
    }
    return max(maxDepth(root: root?.left),maxDepth(root: root?.right))+1
}

//二叉查找树：左节点小于根节点，右节点大于根节点
//如何判断是否是二叉查找树
func isValidBST(root:TreeNode?) -> Bool {
    return _helper(node:root,nil,nil)
}
private func _helper(node:TreeNode?, _ min:Int?, _ max:Int?) -> Bool {
    guard let node = node else {
        return true
    }
    
    if min != nil && node.val <= min!{
        return false
    }
    
    if max != nil && node.val >= max!{
        return false
    }
    
    return _helper(node: node.left, min, node.val) && _helper(node:node.right,node.val,max)
}

//常见的树便利方法：前序，中序，后序

//用栈实现前序遍历
func preorderTraversal(root:TreeNode?) -> [Int]{
    var nums = [Int]()
    guard let root = root else {
        return nums
    }
    nums.append(root.val)
    nums.append(contentsOf:preorderTraversal(root: root.left))
    nums.append(contentsOf:preorderTraversal(root: root.right))
    
    return nums
}

// 用栈实现的前序遍历
func preorderTraversal1(root: TreeNode?) -> [Int] {
    var res = [Int]()
    var stack = [TreeNode]()
    var node = root
    
    while !stack.isEmpty || node != nil {
        if node != nil {
            res.append(node!.val)
            stack.append(node!)
            node = node!.left
        } else {
            node = stack.removeLast().right
        }
    }
    
    return res
}

//层次遍历（广度优先遍历）
func cengCiTraversal(root:TreeNode?) -> [[Int]] {
    var nums = [[Int]]()
    
    if let root = root {
        var tmpNums = [Int]()
        tmpNums.append(root.val)
        nums.append(tmpNums)
        
        var parentNodes = [root]
        while let childNodes = meiCengTraversal(nodes: parentNodes){
            var linshiNums = [Int]()
            for childNode in childNodes {
                linshiNums.append(childNode.val)
            }
            nums.append(linshiNums)
            parentNodes = childNodes
        }
        
    }
    return nums
}

func meiCengTraversal(nodes:[TreeNode]) -> [TreeNode]?{
    
    var childNode = [TreeNode]()
    for node in nodes {
        if node.left != nil {
            childNode.append(node.left!)
        }
        if node.right != nil {
            childNode.append(node.right!)
        }
    }
    return childNode.count>0 ? childNode : nil
}


func leveOrder(root:TreeNode?) -> [[Int]] {
    var res = [[Int]]()
    var queue = [TreeNode]()
    
    if let root = root {
        queue.append(root)
    }
    
    while queue.count > 0 {
        let size = queue.count
        var level = [Int]()
        
        for _ in 1...size{
            let node = queue[0]
            queue.remove(at: 0)
            
            level.append(node.val)
            
            if let left = node.left {
                queue.append(left)
            }
            if let right = node.right {
                queue.append(right)
            }
        }
        res.append(level)
    }
    return res
    
}


let treeNode1 = TreeNode(1)
let treeNode2 = TreeNode(2)
let treeNode3 = TreeNode(3)
let treeNode4 = TreeNode(4)
let treeNode5 = TreeNode(5)
let treeNode6 = TreeNode(6)
treeNode1.left = treeNode2
treeNode2.right = treeNode3
treeNode1.right = treeNode4
treeNode4.left = treeNode5
treeNode4.right = treeNode6
let t = preorderTraversal(root: treeNode1)
let b = preorderTraversal1(root: treeNode1)
let q = cengCiTraversal(root:treeNode1)



//归并排序
func merge(array:inout [Int], _ helper:inout [Int], _ low:Int, _ middle:Int, _ high:Int){
    for i in low...high {
        helper[i] = array[i]
    }
    
    var helperLeft = low
    var helperRight = middle+1
    var current = low
    
    while helperLeft <= middle && helperRight <= high{
        if helper[helperLeft] <= helper[helperRight] {
            array[current] = helper[helperLeft]
            helperLeft += 1
        }else{
            array[current] = helper[helperRight]
            helperRight += 1
        }
        current += 1
    }
    
    guard middle-helperLeft >= 0 else {
        return
    }
    
    for i in 0...middle - helperLeft {
        array[current+i] = helper[helperLeft+i]
    }
    
}

func mergeSort(array:inout [Int],_ helper:inout [Int], _ low:Int,_ high:Int){
    guard low < high else {
        return
    }
    
    let middle = (high-low)/2+low
    mergeSort(array: &array, &helper, low, middle)
    mergeSort(array: &array, &helper, middle+1, high)
    merge(array: &array, &helper, low, middle, high)
}

func mergeSort(array:[Int]) -> [Int]{
    var helper = Array(repeating: 0, count: array.count)
    var array = array
    mergeSort(array: &array, &helper, 0, array.count-1)
    return array
}



func mergeArray(array:inout [Int],_ helper:inout [Int],_ low:Int,_ middle:Int,_ high:Int){
    for i in low...high {
        helper[i] = array[i]
    }
    
    var indexLeft = low
    var indexRight = middle+1
    var currentIndex = low
    
    while indexLeft <= middle+1 && indexRight <= high {
        if(helper[indexLeft] <= helper[indexRight]){
            array[currentIndex] = helper[indexLeft]
            indexLeft += 1
        }else{
            array[currentIndex] = helper[indexRight]
            indexRight += 1
        }
        currentIndex += 1
    }
    
    while indexLeft <= middle+1 {
        array[currentIndex] = array[indexLeft]
        indexLeft += 1
        currentIndex += 1
    }
}

func splitArrayToOrderAndMerge(array:inout [Int],_ helper:inout [Int],_ low:Int,_ high:Int){
    guard low < high else {
        return
    }
    
    let middle = (high-low)/2+low
    splitArrayToOrderAndMerge(array: &array, &helper, low, middle)
    splitArrayToOrderAndMerge(array: &array, &helper, middle+1, high)
    mergeArray(array: &array, &helper, low, middle, high)
}

func sort(array:[Int])->[Int]{
    var array = array
    var helper = Array(repeating: 0, count: array.count)
    splitArrayToOrderAndMerge(array: &array, &helper, 0, array.count-1)
    return array
}

let jj = mergeSort(array: [1,2,3,4,5,6])
let qq = sort(array: [1,2,3,4,5,6])



public class MeetingTime{
    public var start:Int
    public var end:Int
    public init(_ start:Int,_ end:Int){
        self.start = start
        self.end = end
    }
}

//已知有很多会议，如果有这些会议时间有重叠，则将它们合并。
//比如有一个会议的时间为3点到5点，另一个会议时间为4点到6点，那么合并之后的会议时间为3点到6点
func merge(meetingTimes:[MeetingTime]) -> [MeetingTime]{
    guard meetingTimes.count>0 else {
        return meetingTimes
    }

    var intervals = meetingTimes.sorted {
        if $0.start != $1.start{
            return $0.start < $1.start
        }else{
            return $0.end < $1.end
        }
    }
    var res = [MeetingTime]()
    res.append(intervals[0])
    for i in 1..<intervals.count{
        let last = res[res.count - 1]
        if(intervals[i].start<=last.end){
            last.end = max(intervals[i].end,last.end)
        }else{
            res.append(intervals[i])
        }
    }
    return res
}

//二分搜索【有序数组】
func binarySearch(nums:[Int],target:Int) -> Bool {
    var middle = 0
    var left = 0
    var right = nums.count - 1
    while left <= right {
        middle = (right - middle)/2 + left
        if nums[middle] == target{
            return true
        }else if nums[middle]>target {
            right = middle - 1
        }else{
            left = middle + 1
        }
    }
    return false
}

//一个有序数组可能在某个位置被旋转。给定一个目标值，查找并返回这个元素在数组中的位置，如果不存在，返回-1。假设数组中没有重复值。
//举个例子：[0, 1, 2, 4, 5, 6, 7]在4这个数字位置上被旋转后变为[4, 5, 6, 7, 0, 1, 2]。搜索4返回0。搜索8则返回-1。
func search(nums:[Int],target:Int) -> Int {
    var left = 0
    var right = nums.count - 1
    var mid = 0
    
    while left <= right {
        mid = (right - left)/2 + left
        
        if target == nums[mid] {
            return mid
        }else if(target > nums[mid]){
            if target < nums[right] {
                left = mid + 1
            }else{
                right = mid - 1
            }
        }else if(target < nums[mid]){
            if target > nums[left]{
                right = mid - 1
            }else{
                left = mid + 1
            }
        }
    }
    return -1
}


//斐波那契
func fib(count:Int) ->[Int]?{
    var fibArray = [Int]()
    if count == 0 {
        return nil
    }else if count == 1 {
        return [1]
    }else if(count == 2){
        return [1,1]
    }else{
        fibArray.append(1)
        fibArray.append(1)
        for i in 3...count {
            fibArray.append(fibArray[i-1]+fibArray[i-2])
        }
    }
    return fibArray
}

