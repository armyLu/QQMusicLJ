//
//  QQMusicOperationTool.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/27.
//

import UIKit
import MediaPlayer
class QQMusicOperationTool {
    var lastRow = 0
    var artwork: MPMediaItemArtwork?
    private var musicModel = QQMusicMessageModel.init()
    func getMusicMessageModel() -> QQMusicMessageModel {
        musicModel.musicM = musicMs[currentPlayIndex]
        musicModel.costTime = (tool.player?.currentTime) ?? 0
        musicModel.totalTimerer = (tool.player?.duration) ?? 0
        musicModel.isPlaying = (tool.player?.isPlaying) ?? false
        return musicModel
    }
    //单例
    var currentPlayIndex = -1 {
        didSet {
            if currentPlayIndex < 0 {
                currentPlayIndex = (musicMs.count - 1)
            }
            if currentPlayIndex > (musicMs.count - 1){
                currentPlayIndex = 0
            }
        }
    }
    static let sharedInstance = QQMusicOperationTool.init()
    private  init() {}
    let tool: QQMusicTool = QQMusicTool.init()
    var musicMs: [QQMusicModel] = [QQMusicModel]()
    func playMusic(musicM: QQMusicModel){
        tool.playMusic(musicName: musicM.filename!)
        currentPlayIndex = musicMs.firstIndex(of: musicM)!
    }
    func nextMusic(){
        currentPlayIndex += 1
        let model = musicMs[currentPlayIndex]
        playMusic(musicM: model)
    }
    func preMusic(){
        currentPlayIndex -= 1
        let model = musicMs[currentPlayIndex]
        playMusic(musicM: model)
    }
    func pauseCurrentMusic(){
        tool.pasuseMusic()
    }
    func playCurrentMusic(){
        let model = musicMs[currentPlayIndex]
        playMusic(musicM: model)
    }
    
    func setUpLockMessage(){
        let musicMessageM = getMusicMessageModel()
        //获取锁屏中心
        let center1 = MPNowPlayingInfoCenter.default()
        
        let musicName = musicMessageM.musicM?.name ?? ""
        let singerName = musicMessageM.musicM?.singer ?? ""
        let costTime = musicMessageM.costTime
        let totalTime = musicMessageM.totalTimerer
        
        let imageName = musicMessageM.musicM?.icon ?? ""
        
        let lrcFileName = musicMessageM.musicM?.lrcname
        let lrcMs = QQMusicDataTool.getLrcMs(lrcName: lrcFileName)
        let lrcRow = QQMusicDataTool.getCurrentLrcM(currentTime: musicMessageM.costTime, lrcMs: lrcMs)
        let lrcM = lrcRow.lrcM
        guard let image = UIImage(named: imageName) else {return }
        var resultImage: UIImage?
        if lastRow  != lrcRow.row {
            lastRow = lrcRow.row
             resultImage = QQImageTool.getNewImage(sourceImage: image, str: lrcM?.lrcContent)
            
        }
        if resultImage != nil {
            
            artwork =  MPMediaItemArtwork.init(boundsSize: CGSize(width: 200, height: 200), requestHandler: { size  in
                     
                    return resultImage!
                 })
        }
        
        let dic: NSMutableDictionary = [
            MPMediaItemPropertyAlbumTitle : musicName,
            MPMediaItemPropertyArtist : singerName,
            MPMediaItemPropertyPlaybackDuration : totalTime,
            MPNowPlayingInfoPropertyElapsedPlaybackTime : costTime
        ]
        
        if artwork != nil {
            dic.setValue(artwork!, forKey: MPMediaItemPropertyArtwork)
        }
        
        center1.nowPlayingInfo = dic as? [String : AnyObject]
        
        //接收远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
    }
    
    
    func seekToTime(costTime1: TimeInterval){
//         debugPrint("seekToTime方法未实现")
        tool.seekToTime(costTime: costTime1)
    }
    
}

//MPMediaItemPropertyAlbumTitle
// MPMediaItemPropertyAlbumTrackCount
// MPMediaItemPropertyAlbumTrackNumber
// MPMediaItemPropertyArtist
// MPMediaItemPropertyArtwork
// MPMediaItemPropertyComposer
// MPMediaItemPropertyDiscCount
// MPMediaItemPropertyDiscNumber
// MPMediaItemPropertyGenre
// MPMediaItemPropertyPersistentID
// MPMediaItemPropertyPlaybackDuration
// MPMediaItemPropertyTitle
