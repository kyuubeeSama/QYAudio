//
//  AudioView.swift
//  QYAudio
//
//  Created by liuqingyuan on 2020/5/12.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit

class AudioView: UIView {
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = (touches as NSSet).allObjects[0] as! UITouch
        let currentPoint = touch.location(in: self.superview)
        let previousPoint = touch.previousLocation(in: self.superview)
        var center = self.center
        center.x += currentPoint.x - previousPoint.x
        center.y += currentPoint.y - previousPoint.y
        self.center = center
        // TODO:四周超出屏幕检测
        if(self.frame.origin.x+self.frame.width>(self.superview?.frame.width)!){
//            右
            self.frame.origin.x = (self.superview?.frame.width)!-self.frame.width
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
