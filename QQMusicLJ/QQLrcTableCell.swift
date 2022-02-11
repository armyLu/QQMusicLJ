//
//  QQLrcTableCell.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/28.
//

import UIKit

class QQLrcTableCell: UITableViewCell {

    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    var progress: CGFloat = 0 {
        didSet {
            lrcLabel.radio = progress
        }
    }
    
    var lrcContent: String = "" {
        didSet {
            
            lrcLabel.text = lrcContent
        }
    }
    
    class func cellWithTableView(tableView: UITableView) -> QQLrcTableCell {
        let lrcCellID = "lrcCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: lrcCellID) as? QQLrcTableCell
        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: lrcCellID)
            cell = Bundle.main.loadNibNamed("QQLrcTableCell", owner: nil, options: nil)?.first as? QQLrcTableCell
           /* cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = .white
            cell?.textLabel?.font = .systemFont(ofSize: 17)*/
        }
        
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lrcLabel.textColor = .white
        lrcLabel.font = .systemFont(ofSize: 17)
        selectionStyle = .none
    }
}
