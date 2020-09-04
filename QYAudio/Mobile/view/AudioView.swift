//
//  AudioView.swift
//  QYAudio
//
//  Created by liuqingyuan on 2020/5/12.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit
import AVFoundation
class AudioView: UIView {
    
    lazy var player: AVPlayer = {
        let player = AVPlayer.init()
        return player
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.corner()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func corner(){
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
    }
    
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
        }else if(self.frame.origin.x<0){
            self.frame.origin.x = 0
        }else if(self.frame.origin.y<(top_height)){
            self.frame.origin.y = top_height
        }else if(self.frame.origin.y+self.frame.width>(self.superview?.frame.height)!){
            self.frame.origin.y = (self.superview?.frame.height)!-self.frame.height
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
