//
//  QQMusicMessageModel.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/28.
//

import UIKit
class QQMusicMessageModel: NSObject {
    var musicM: QQMusicModel?
    var costTime: TimeInterval = 0
    //总时长
    var totalTimerer: TimeInterval = 0
    //播放状态
    var isPlaying  =  false
}
