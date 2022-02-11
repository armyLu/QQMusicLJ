//
//  QQLrcLabel.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/28.
//

import UIKit

class QQLrcLabel: UILabel {

    
    var radio: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
   
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        UIColor(red: 41 / 255.0, green: 150 / 255.0, blue: 98 / 255.0, alpha: 1.0).set()
        let fillRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * radio, height: rect.size.height)
        UIRectFillUsingBlendMode(fillRect, .sourceIn)
    }

}
