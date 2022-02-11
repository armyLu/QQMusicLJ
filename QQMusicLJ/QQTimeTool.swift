//
//  QQTimeTool.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/28.
//

import UIKit
class QQTimeTool: NSObject {
    class func getFormatTime(timeInteral: TimeInterval)-> String{
        let min = Int(timeInteral / 60)
        //  取模
        let sec = Int(timeInteral.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min,sec)
    }
    
    class func getTimeInterval(formatTime: String) -> TimeInterval{
        
        let minSec = formatTime.components(separatedBy: ":")
        if minSec.count != 2 {
            return 0
        }
        let min = TimeInterval(minSec[0]) ?? 0.0
        let sec = TimeInterval(minSec[1]) ?? 0.0
        
        return min * 60.0 + sec
        
    }
}
