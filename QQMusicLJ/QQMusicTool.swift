//
//  QQMusicTool.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/27.
//

import UIKit
import AVFoundation
//负责单手歌曲的播放
class QQMusicTool : NSObject {
    
   override init(){
        super.init()
       let session = AVAudioSession.sharedInstance()
       do{
          try session.setCategory(.playback)
           try session.setActive(true, options: .init(rawValue: 0))
       }catch {
           
           debugPrint(error.localizedDescription)
          return
       }
       
    }
    
    var player: AVAudioPlayer?
    func playMusic(musicName: String) {
        guard  let url = Bundle.main.url(forResource: musicName, withExtension: nil) else {
            return
        }
        if player?.url == url {
            player?.play()
            return
        }
        do {
           player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
        }catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    func pasuseMusic(){
        player?.pause()
    }
    
    func seekToTime(costTime : TimeInterval){
        player?.currentTime  = costTime
    }
    
}

extension QQMusicTool : AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("播放完成")
        NotificationCenter.default.post(name: .musicEndChangeNotification, object: nil)
    }
}
