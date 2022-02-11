//
//  QQMusicModel.swift
//  QQMusic
//
//  Created by lujun on 2022/1/27.
//

import UIKit

class QQMusicModel: NSObject {
    /** 歌曲名称 */
      @objc var name: String?
    /** 歌曲文件名称 */
       @objc var filename: String?
    /** 歌词文件名称 */
       @objc var lrcname: String?
    /** 歌手名称 */
       @objc var singer: String?
    /** 歌手头像名称 */
       @objc var singerIcon: String?
    /** 专辑头像图片 */
       @objc var icon: String?
    override init() {
        
    }
    init(dict:[String: Any]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    class override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
