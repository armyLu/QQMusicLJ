//
//  QQMusicCell.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/27.
//

import UIKit
class QQMusicCell: UITableViewCell {
    var musicModel: QQMusicModel? {
        didSet {
            iconImageView.image = UIImage(named: (musicModel?.singerIcon)!)
            singsongerLabel.text = musicModel?.name
            singerLabel.text = musicModel?.singer
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var singsongerLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    override  func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = iconImageView.width * 0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderWidth = 3
        iconImageView.layer.borderColor = UIColor(red: 255 / 255.0, green: 121 / 255.0, blue: 179 / 255.0, alpha: 1.0).cgColor
     }
    class func cellWithTableView(tableView: UITableView) -> QQMusicCell{
        let cellID = "music"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QQMusicCell
        if cell == nil {
//            debugPrint("test")
            //一定添加循环利用标识
            cell = Bundle.main.loadNibNamed("QQMusicCell", owner: nil, options: nil)?.first as? QQMusicCell
        }
        cell?.backgroundColor = .clear
        return cell!
    }
    func animation(type: AnimationType) {
        if type == .Rotation {
            //做动画
            self.layer.removeAnimation(forKey: "rotation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.values = [-1/6 * Double.pi,0,1/6 * Double.pi,0]
            animation.duration = 0.2
            animation.repeatCount = 3
            self.layer.add(animation, forKey: "rotation")
        }
        
        if type == .Scale {
            self.layer.removeAnimation(forKey: "scale")
            let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
            animation.values = [0.5,1,0.5,1]
            animation.duration = 0.2
            animation.repeatCount = 2
            self.layer.add(animation, forKey: "scale")
        }
    }
}
enum AnimationType {
    case Rotation
    case Transtion
    case Scale
}
