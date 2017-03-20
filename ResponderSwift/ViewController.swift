//
//  ViewController.swift
//  ResponderSwift
//
//  Created by MasterFly on 2017/3/1.
//  Copyright © 2017年 MasterFly. All rights reserved.
//

import UIKit
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
    
    //开始点击回调，这里用来打印出整条 响应者链条
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("响应者链条从这里开始，第一个为第一响应者 \n\(self)")
        var next = self.next
        while next != nil {
            print(next!)
            next = next?.next
        }
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


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        let superViewOther = SuperViewOther.init(frame: CGRect.init(x: 50, y: 300, width: 200, height: 200))
        superViewOther.backgroundColor = UIColor.black
        
        let superOtherSubView = SuperOtherSubView.init(frame: CGRect.init(x: 50, y: 50, width: 100, height: 100))
        superOtherSubView.backgroundColor = UIColor.white
        
        
        let superView = SuperView.init(frame: CGRect.init(x: 50, y: 50, width: 200, height: 200))
        superView.backgroundColor = UIColor.red
        
        
        let bView = BView.init(frame: CGRect.init(x: 50, y: 50, width: 50, height: 50))
        bView.backgroundColor = UIColor.blue
        bView.alpha = 0.5

        
        let cView = CView.init(frame: CGRect.init(x: 90, y: 50, width: 50, height: 50))
        cView.backgroundColor = UIColor.yellow
        cView.alpha = 0.5
        
        self.view.addSubview(superView)             //red
        self.view.addSubview(superViewOther)        //black

        superView.addSubview(cView)                 //yellow
        superView.addSubview(bView)                 //blue

        superViewOther.addSubview(superOtherSubView)//white

        
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

