//
//  QQMusicDataTool.swift
//  QQMusic
//
//  Created by lujun on 2022/1/27.
//

import UIKit

class QQMusicDataTool: NSObject {
    class func getMusicMs(finishedCallBack: @escaping ([QQMusicModel])->() ) {
        guard  let path =  Bundle.main.path(forResource: "Musics.plist", ofType: nil)
         else {
             finishedCallBack([QQMusicModel]())
             return
         }
        guard let arr = NSArray(contentsOfFile: path) else {
            finishedCallBack([QQMusicModel]())
            return
        }
        var models = [QQMusicModel]()
        for dict in arr {
            let model = QQMusicModel(dict: dict as! [String: Any])
            models.append(model)
        }
        finishedCallBack(models)
                
    }

    class func getLrcMs(lrcName: String?) -> [QQLrcModel]{
        if lrcName == nil {
            return [QQLrcModel]()
        }
        //获取文件的路径
       guard  let path = Bundle.main.path(forResource: lrcName, ofType: nil)
        else{
            return [QQLrcModel]()
        }
        var lrcContent = ""
        do {
            lrcContent = try String(contentsOfFile: path)
        }catch{
            debugPrint(error.localizedDescription)
            return [QQLrcModel]()
        }
//        debugPrint(lrcContent)
        let timeContentArray = lrcContent.components(separatedBy: "\n")
        var resultMs = [QQLrcModel]()
        for timeContentStr in timeContentArray {
            if timeContentStr.contains("[ti:") || timeContentStr.contains("[ar:")
                || timeContentStr.contains("[al:") {
                continue
            }
            //真正的数据
            //去除左中括号
            let resultLrcStr = timeContentStr.replacingOccurrences(of: "[", with: "")
//            debugPrint(resultLrcStr) //"00:00.91]简单爱"
            let timeAndContent = resultLrcStr.components(separatedBy: "]")
            if timeAndContent.count != 2 {
                continue
            }
            let time = timeAndContent[0]
            let content = timeAndContent[1]
            let lrcModel = QQLrcModel.init()
            resultMs.append(lrcModel)
            lrcModel.beginTime = QQTimeTool.getTimeInterval(formatTime: time)
            
            lrcModel.lrcContent = content
            
        }
        let count = resultMs.count
        for i in 0..<count {
            if i == count - 1 {
                continue
            }
            let lrcM = resultMs[i]
            let nextLrcM = resultMs[i + 1]
            lrcM.endTime = nextLrcM.beginTime
        }
//        debugPrint(resultMs)
//        resultMs
//        for item in resultMs {
//            debugPrint(item.beginTime)
//            debugPrint(item.endTime)
//            debugPrint(item.lrcContent)
//        }
//
        return resultMs
        
    }
    
    
    class func getCurrentLrcM(currentTime: TimeInterval,lrcMs:[QQLrcModel]) -> (row: Int,lrcM: QQLrcModel?){
        var index = 0
        for lrcM in lrcMs {
            if currentTime > lrcM.beginTime && currentTime <  lrcM.endTime {
                return (index,lrcM)
            }
            index += 1
        }
        
        return (0,nil)
    }
    
    
    
    
    

}
