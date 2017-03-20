###目录
* [**概念**](#概念)
* [**命中测试**](#命中测试)
* [**事件响应链条**](#事件响应链条)
* [**功能**](#功能)
* [**总结**](#总结)


###<a name="概念"></a>概念

当你设计你的应用程序,很可能你想动态响应事件。例如,触摸屏幕上可以发生在许多不同的对象,你必须决定你想要哪一个对象响应给定的事件,了解对象接收事件。当一个用户生成的事件发生时,UIKit创建一个事件对象包含所需的信息来处理事件。然后它将事件对象活动应用程序的事件队列。触摸事件,对象是一组接触UIEvent打包在一个对象中。运动事件,事件对象的不同取决于你使用哪个框架和什么类型的运动事件感兴趣。沿着特定的事件传播路径,直到交付给一个对象,可以处理它。UIApplication第一,单例对象需要一个事件从队列的顶部和分派处理。通常情况下,它将事件发送给应用程序的关键的窗口对象,它将事件传递给一个初始对象处理。最初的对象取决于类型的事件。触摸事件。触摸事件,窗口对象首先尝试交付事件的观点发生联系。这一观点被称为击中测试视图。发现击中测试视图的过程叫做击中测试,在击中测试返回视图描述发生了联系。运动和远程控制事件。这些事件,窗口对象发送shaking-motion或远程控制事件的第一反应处理。响应者链中所描述的第一个反应是由应答器对象。这些事件路径的终极目标是找到一个对象,可以处理和响应事件。因此,UIKit首先将事件发送给最适合的对象处理事件。触摸事件,对象是击中测试视图,和其他活动,对象是第一响应者。[你也可以看看官方文档](https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html#//apple_ref/doc/uid/TP40009541-CH4-SW2)


###<a name="命中测试"></a>命中测试
响应者链条其实主要分两大块，第一块就是 **命中测试**,系统通过hitTest 来获取到我们点击到的view。 

* hitTest 点击测试，系统用来测试命中view 的函数
* point 是 hitTest的核心，用来测试触摸点是否命中self

下面用个例子来分析一下点击测试的原理,我们用一个父类RootView 来重写  hitTest 和 point 两个方法，然后新建五个基于RootView 的view。为了更好的效果，我把window 的这几个方法也充重写了，这里就不重复了。

```
class RootView:UIView {

//点击测试
override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

print(self)
let view = super.hitTest(point, with: event)
return view
}

//hitTest 核心，用来测试触摸点是否命中self
override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

let pointFromSelf = convert(point, from: self)
if self.bounds.contains(pointFromSelf) {
return true
}
return false
}
}

class SuperViewOther: RootView {
}

class SuperOtherSubView: RootView {
}

class SuperView: RootView {
}

class BView: RootView {
}

class CView: RootView {
}

```

层级和颜色如下

```
self.view.addSubview(superView)             //red
self.view.addSubview(superViewOther)        //black
superView.addSubview(cView)                 //yellow
superView.addSubview(bView)                 //blue
superViewOther.addSubview(superOtherSubView)//white
```

运行效果如下
![视图分布.png](http://upload-images.jianshu.io/upload_images/1891685-c0e252da0b461c13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 点击黄色的cView 视图

```
<ResponderSwift.MyWindow: 0x7f987d704a50; baseClass = UIWindow; frame = (0 0; 414 736); gestureRecognizers = <NSArray: 0x60800004fe10>; layer = <UIWindowLayer: 0x60800003d6e0>>
<ResponderSwift.SuperViewOther: 0x7f987d40c030; frame = (50 300; 200 200); layer = <CALayer: 0x60000003fa00>>
<ResponderSwift.SuperView: 0x7f987d40ca70; frame = (50 50; 200 200); layer = <CALayer: 0x60000003fa80>>
<ResponderSwift.BView: 0x7f987d40d040; frame = (50 50; 50 50); alpha = 0.5; layer = <CALayer: 0x60000003fac0>>
<ResponderSwift.CView: 0x7f987d40d610; frame = (90 50; 50 50); alpha = 0.5; layer = <CALayer: 0x60000003fb60>>
```

**分析：** self.view 有两个字视图，其中SuperViewOther 后加入在栈顶，hitTest优先测试栈顶的视图，用point测试，发现不在范围内，point函数返回false,hisTest 返回nil;然后测试到SuperView 视图，point 检测到在范围内就检查它的所以子视图，依然是栈顶的bView到cView,最后point到在cView 中，且它无子视图，故返回cView,如下图。
![CView视图.png](http://upload-images.jianshu.io/upload_images/1891685-ef04a1993d18e9dc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 点击红色的superView

```
<ResponderSwift.MyWindow: 0x7f987d704a50; baseClass = UIWindow; frame = (0 0; 414 736); gestureRecognizers = <NSArray: 0x60800004fe10>; layer = <UIWindowLayer: 0x60800003d6e0>>
<ResponderSwift.SuperViewOther: 0x7f987d40c030; frame = (50 300; 200 200); layer = <CALayer: 0x60000003fa00>>
<ResponderSwift.SuperView: 0x7f987d40ca70; frame = (50 50; 200 200); layer = <CALayer: 0x60000003fa80>>
<ResponderSwift.BView: 0x7f987d40d040; frame = (50 50; 50 50); alpha = 0.5; layer = <CALayer: 0x60000003fac0>>
<ResponderSwift.CView: 0x7f987d40d610; frame = (90 50; 50 50); alpha = 0.5; layer = <CALayer: 0x60000003fb60>>
```

**分析** self.view 有两个字视图，其中SuperViewOther 后加入在栈顶，hitTest优先测试栈顶的视图，用point测试，发现不在范围内，point函数返回false,hisTest 返回nil;然后测试到SuperView 视图，point 检测到在范围内就检查它的所以子视图，依然是栈顶的bView到cView,发现所有的子视图都没能命中，故返回到它的父视图，最后返回父视图，如下图。

![SuperView 视图.png](http://upload-images.jianshu.io/upload_images/1891685-11fb826358f8db95.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**总结** 这里就简单的介绍这两种情况，得到的结论是 **hitTest 返回 最后一个能被测试中的视图**。


###<a name="事件响应链条"></a>事件响应链条


其实这跟视图的命中息息相关，但又不能混为一谈。我么可以写个函数来把它全部打印出来(在RootView 和window 的重写类中都都加上下面的代码)

```
//开始点击回调，这里用来打印出整条 响应者链条
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
print("响应者链条从这里开始，第一个为第一响应者 \n\(self)")
var next = self.next
while next != nil {
print(next!)
next = next?.next
}
}
```

再次拿刚刚的第一个例子来说明

* 点击黄色的cView 视图

```
<ResponderSwift.MyWindow: 0x7f896a4087d0; baseClass = UIWindow; frame = (0 0; 414 736); gestureRecognizers = <NSArray: 0x608000057490>; layer = <UIWindowLayer: 0x60000003b800>>
<ResponderSwift.SuperViewOther: 0x7f896a603930; frame = (50 300; 200 200); layer = <CALayer: 0x60800003a240>>
<ResponderSwift.SuperView: 0x7f896a4091b0; frame = (50 50; 200 200); layer = <CALayer: 0x60000003ba20>>
<ResponderSwift.BView: 0x7f896a605c00; frame = (50 50; 50 50); alpha = 0.5; layer = <CALayer: 0x60800003a100>>
<ResponderSwift.CView: 0x7f896a606220; frame = (90 50; 50 50); alpha = 0.5; layer = <CALayer: 0x60800003a1e0>>
响应者链条从这里开始，第一个为第一响应者 
<ResponderSwift.CView: 0x7f896a606220; frame = (90 50; 50 50); alpha = 0.5; layer = <CALayer: 0x60800003a1e0>>
<ResponderSwift.SuperView: 0x7f896a4091b0; frame = (50 50; 200 200); layer = <CALayer: 0x60000003ba20>>
<UIView: 0x7f896d20b020; frame = (0 0; 414 736); autoresize = W+H; layer = <CALayer: 0x60000003b860>>
<ResponderSwift.ViewController: 0x7f896a604b20>
<ResponderSwift.MyWindow: 0x7f896a4087d0; baseClass = UIWindow; frame = (0 0; 414 736); gestureRecognizers = <NSArray: 0x608000057490>; layer = <UIWindowLayer: 0x60000003b800>>
<UIApplication: 0x7f896d200370>
<ResponderSwift.AppDelegate: 0x600000039c20>
```

**总结：**你会发现 响应者链条基本就是点击测试 调用的反序，只是多了UIApplication 和 AppDelegate而已。

###<a name="功能"></a>功能

说了这么多，响应者链可以用来干嘛？非常的多，我这里可以举几个例子

* 按钮响应区域扩大 （重写hitTest 或者point 都可）
* 屏蔽子视图
* 指定视图响应
* 屏蔽指定视图
* ..... 等等

###<a name="总结"></a>总结
响应者链日常开发中经常用到，属于必需要掌握掌握的一个技巧，本文用swift讲解，[GitHub地址](https://github.com/developeryh/ResponderChain.git)。
