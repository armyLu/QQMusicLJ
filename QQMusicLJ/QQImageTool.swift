//
//  QQImageTool.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/28.
//

import UIKit

class QQImageTool: NSObject {

    
    class func getNewImage(sourceImage: UIImage? ,
                           str: String?
    ) -> UIImage? {
        
        guard let image  = sourceImage else {return nil}
        guard let resultStr = str else { return image }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let textRet = CGRect(x: 0, y: 20, width: image.size.width, height: 40)
        let par =  NSMutableParagraphStyle.init()
        par.alignment = .center
        
        let textDict = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 36),
            NSAttributedString.Key.foregroundColor : UIColor.yellow,
            NSAttributedString.Key.paragraphStyle : par
        ]
        ( resultStr as NSString).draw(in: textRet, withAttributes: textDict)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage
        
        
        
    }
    
    
}
