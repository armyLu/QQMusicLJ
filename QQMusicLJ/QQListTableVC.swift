//
//  QQListTableVC.swift
//  QQMusic
//
//  Created by lujun on 2022/1/27.
//
import UIKit
class QQListTableVC: UITableViewController {
    var musicMs: [QQMusicModel] = [QQMusicModel]() {
        didSet {
           tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInit()
        QQMusicDataTool.getMusicMs { items in
            self.musicMs = items
            QQMusicOperationTool.sharedInstance.musicMs = items
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
         .lightContent
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicMs.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = QQMusicCell.cellWithTableView(tableView: tableView)
       // debugPrint("cell")
        cell.musicModel = musicMs[indexPath.row]
        cell.animation(type: .Scale)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = musicMs[indexPath.row]
        //使用单例 强制修改 对象地址
        QQMusicOperationTool.sharedInstance.playMusic(musicM: model)
        //跳转
        self.performSegue(withIdentifier: "list2Detail", sender: nil)
    }
}

extension QQListTableVC{
    func setUpInit(){
        setTableView()
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
//        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func setTableView() {
        let imageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.backgroundView = imageView
    }
}

