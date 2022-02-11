//
//  CALayer+sz.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/28.
//

import UIKit


extension CALayer{
    func pauseAnimate(){
        let pauseTime: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pauseTime
    }
    func resumeAnimate(){
        let pausedTime: CFTimeInterval = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}
