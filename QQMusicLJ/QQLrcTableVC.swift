//
//  QQLrcTableVC.swift
//  QQMusicLJ
//
//  Created by lujun on 2022/1/28.
//

import UIKit

class QQLrcTableVC: UITableViewController {
    
    //提供给外界赋值的进度
    var progress: CGFloat = 0 {
        didSet{
            //拿到正在播放的cell
            let indexPath = IndexPath.init(row: scrollRow, section: 0)
            let cell =  tableView.cellForRow(at: indexPath) as? QQLrcTableCell
            
            cell?.progress = progress
            
            
        }
    }
    
    var scrollRow = -1 {
        didSet {
            if scrollRow == oldValue {return}
            
            let indexPaths = tableView.indexPathsForVisibleRows
            tableView.reloadRows(at: indexPaths!, with: .fade)
            
            let indexPath = IndexPath.init(row: scrollRow, section: 0)
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }

    var lrcMs: [QQLrcModel] = [QQLrcModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset = .init(top: self.tableView.height * 0.5, left: 0, bottom: self.tableView.height * 0.5, right: 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  QQLrcTableCell.cellWithTableView(tableView: tableView)
        let model = lrcMs[indexPath.row]
//        cell.lrcLabel.text = model.lrcContent
        cell.lrcContent = model.lrcContent
        
        if indexPath.row == scrollRow {
            cell.progress = progress
        }else{
            cell.progress = 0
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lrcMs.count
    }

}
