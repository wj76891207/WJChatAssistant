//
//  WJMarbleLoadingView.swift
//  WJChatAssistant
//
//  Created by wangjian on 31/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit

class WJMarbleLoadingView: UIView {

    private var marbleNumber: Int
    private var marbles: [CAShapeLayer] = []
    
    // the variable below in charge of the jumping frequency and speed
    private let jumpTime: TimeInterval = 0.25
    private let restTime: TimeInterval = 0.5
    private let jumpInterval: TimeInterval = 0.25/3
    
    private let marbleSize = CGSize(width: 7, height: 7)
    private var jumpingTimer: Timer?
    
    init(frame: CGRect, number: Int) {
        marbleNumber = number
        super.init(frame: frame)
        
        for _ in 0..<number {
            let marble = createAMarble()
            marbles.append(marble)
            layer.addSublayer(marble)
        }

        startJumping()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopJumping()
    }
    
    func startJumping() {
        
        let timeInterval = jumpTime + restTime + (Double(marbleNumber)-1)*jumpInterval
        jumpingTimer = Timer.init(timeInterval: timeInterval,
                                  target: self,
                                  selector: #selector(jumpTimingAction(_:)),
                                  userInfo: nil,
                                  repeats: true)
        RunLoop.main.add(jumpingTimer!, forMode: .commonModes)
        jumpingTimer?.fire()
    }
    
    func stopJumping() {
        jumpingTimer?.invalidate()
        jumpingTimer = nil
    }
    
    @objc private func jumpTimingAction(_ timer: Timer) {
        var delayTime: TimeInterval = 0
        for marble in marbles {
            DispatchQueue.main.asyncAfter(deadline: .now()+delayTime, execute: {
                let animation = CAKeyframeAnimation(keyPath: "position.y")
                animation.duration = self.jumpTime
                animation.values = [self.bounds.midY,
                                    self.bounds.midY/3,
                                    self.bounds.midY]
                animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                                             CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
                marble.add(animation, forKey: nil)
            })
            
            delayTime += jumpInterval
        }
    }
    
    override func tintColorDidChange() {
        for marble in marbles {
            marble.backgroundColor = tintColor.cgColor
        }
    }
    
    private func createAMarble() -> CAShapeLayer {
        let marble = CAShapeLayer()
        marble.frame = CGRect(x: 0, y: 0, width: marbleSize.width, height: marbleSize.height)
        marble.cornerRadius = marbleSize.width/2
        marble.backgroundColor = UIColor.init(red: 96/255.0, green: 143/255.0, blue: 233/255.0, alpha: 1).cgColor
        return marble
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arrangeMarbles()
    }
    
    private func arrangeMarbles() {
        let fitMargin = (bounds.width-CGFloat(marbleNumber)*marbleSize.width) / CGFloat(marbleNumber + 3)
        
        for i in 0..<marbles.count {
            marbles[i].position = CGPoint(x: 2*fitMargin+marbleSize.width/2+CGFloat(i)*(fitMargin+marbleSize.width), y: bounds.midY)
        }
    }
}
