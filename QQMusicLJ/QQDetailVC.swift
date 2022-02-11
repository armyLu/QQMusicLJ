//
//  QQDetailVC.swift
//  QQMusic
//
//  Created by lujun on 2022/1/27.
//

import UIKit

class QQDetailVC: UIViewController {
    //负责更新歌词的Link
    var updateLrcLink : CADisplayLink?
    //歌词视图
    lazy var lrcVC: QQLrcTableVC = {
        return .init()
    }()
    var timer: Timer?
    //背景图片
    @IBOutlet weak var playOrPauseBtn: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    //歌手名称
    @IBOutlet weak var singerNameLabel: UILabel!
    //歌曲名称
    @IBOutlet weak var songNameLabel: UILabel!
    //进度条
    @IBOutlet weak var progressSlider: UISlider!
    //中心图片
    @IBOutlet weak var foreImageView: UIImageView!
    //歌词滚动视图
    @IBOutlet weak var lrcScrollView: UIScrollView!
    //歌词
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    //当前时间
    @IBOutlet weak var costTimeLabel: UILabel!
    //总时间
    
    @IBOutlet weak var totalLabel: UILabel!
    //关闭
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
//        debugPrint(sender.value)
        
        
        
        
        
        
        
    }
    
    
    @IBAction func touchDown() {
        removeTimerer()
        
    }
    
    @IBAction func touchUp() {
        addTimerer()
        
        let value = progressSlider.value
        
        let musicMessageM = QQMusicOperationTool.sharedInstance.getMusicMessageModel()
        let totalTime = musicMessageM.totalTimerer
        let costTime = totalTime * TimeInterval(value)
        
        QQMusicOperationTool.sharedInstance.seekToTime(costTime1: costTime)
        
    }
    
    
    //点击手势
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        
        debugPrint("tap")

        let point = sender.location(in: sender.view)
        
        let x = point.x
        let value = x / (sender.view?.width)!
        progressSlider.value = Float(value)
        
        let musicMessageM = QQMusicOperationTool.sharedInstance.getMusicMessageModel()
        let tototalTime = musicMessageM.totalTimerer
        
        let costTime1 = tototalTime * TimeInterval(value)
        
        QQMusicOperationTool.sharedInstance.seekToTime(costTime1: costTime1)
        
        
        
    }
    
    
    @IBAction func playOrPause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if !sender.isSelected {
            QQMusicOperationTool.sharedInstance.playCurrentMusic()
          //  sender.setImage(UIImage(named: "player_btn_pause_normal"), for: .normal)
           // sender.setImage(UIImage(named: "player_btn_pause_highlight"), for: .normal)
            resumeAnimation()
        }else{
            QQMusicOperationTool.sharedInstance.pauseCurrentMusic()
           // sender.setImage(UIImage(named: "player_btn_play_normal"), for: .normal)
           // sender.setImage(UIImage(named: "player_btn_play_highlight"), for: .normal)
            pauseRotationAnimation()
            
        }
        
    }
    
    @IBAction func nextMusic(_ sender: Any) {
        QQMusicOperationTool.sharedInstance.nextMusic()
        setUpOnce()
    }
    @IBAction func preMusic(_ sender: Any) {
        QQMusicOperationTool.sharedInstance.preMusic()
        setUpOnce()
    }
    func setUpOnce(){
        let musicMessageM = QQMusicOperationTool.sharedInstance.getMusicMessageModel()
        guard let musicM = musicMessageM.musicM else {return}
        if musicM.icon != nil {
            backImageView.image = UIImage(named: musicM.icon!)
            foreImageView.image = UIImage(named: musicM.icon!)
            foreImageView.layer.borderColor = UIColor.systemGray5.cgColor
            foreImageView.layer.borderWidth = 10
        }
        songNameLabel.text = musicM.name
        singerNameLabel.text = musicM.singer
        totalLabel.text = QQTimeTool.getFormatTime(timeInteral: musicMessageM.totalTimerer)
        
        //歌词 解析
        let lrcMs = QQMusicDataTool.getLrcMs(lrcName: musicM.lrcname)
        lrcVC.lrcMs = lrcMs
        addRotationAnimation()
        if musicMessageM.isPlaying {
            resumeAnimation()
        }else{
            pauseRotationAnimation()
        }
    }
    @objc func setUpTimes(){
       let musicMessageM = QQMusicOperationTool.sharedInstance.getMusicMessageModel()
       
      // lrcLabel.text = musicMessageM.costTime / musicMessageM.totalTimerer
       progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTimerer)
       costTimeLabel.text = QQTimeTool.getFormatTime(timeInteral: musicMessageM.costTime)
        playOrPauseBtn.isSelected = !musicMessageM.isPlaying
    }
    //销毁通知
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
extension QQDetailVC {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLrcView()
        setUpLrcScollView()
        setSlider()
        let swi = UISwipeGestureRecognizer(target: self, action: #selector(close1))
        swi.direction = .down
        
        view.addGestureRecognizer(swi)
        
        NotificationCenter.default.addObserver(self, selector: #selector(nextMusic(_:)), name: .musicEndChangeNotification, object: nil)
        
    }
    @objc func close1(){
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpOnce()
        addTimerer()
        addLink()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimerer()
        removeLink()
    }
    func addTimerer(){
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(setUpTimes), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func removeTimerer(){
        timer?.invalidate()
        timer = nil
    }
    
    func addLink(){
        updateLrcLink = CADisplayLink(target: self, selector: #selector(updateLrc))
        updateLrcLink?.add(to: .current, forMode: .common)
        
    }
    
    func removeLink(){
        updateLrcLink?.invalidate()
        updateLrcLink = nil
    }
    
    func setSlider(){
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .highlighted)
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .selected)
    }
    
    func setUpForeImageView(){
        foreImageView.layer.cornerRadius = foreImageView.width * 0.5
        foreImageView.layer.masksToBounds = true
    }
    
    func addLrcView(){
       /* lrcView = UIView.init()
        lrcView?.backgroundColor = .clear
        lrcScrollView.addSubview(lrcView!)*/
        lrcVC.tableView.backgroundColor = .clear
        lrcScrollView.addSubview(lrcVC.tableView)
    }
    
    func setLrcViewFrame(){
      /*  lrcView?.frame = lrcScrollView.bounds
        lrcView?.x = lrcScrollView.width
        lrcScrollView.contentSize = CGSize(width: lrcScrollView.width * 2, height: 0)*/
        lrcVC.tableView.frame = lrcScrollView.bounds
        lrcVC.tableView.x = lrcScrollView.width
        lrcScrollView.contentSize = CGSize(width: lrcScrollView.width * 2, height: 0)
    }
    func setUpLrcScollView(){
        lrcScrollView.delegate = self
        lrcScrollView.isPagingEnabled = true
        lrcScrollView.showsVerticalScrollIndicator = false
        lrcScrollView.showsHorizontalScrollIndicator = false
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLrcViewFrame()
        setUpForeImageView()
    }
    
    
    @objc func updateLrc(){
        let musicMessageM = QQMusicOperationTool.sharedInstance.getMusicMessageModel()
        let time = musicMessageM.costTime
        let lrcMs = lrcVC.lrcMs
        let lrcM = QQMusicDataTool.getCurrentLrcM(currentTime: time, lrcMs: lrcMs).lrcM
        
        self.lrcLabel.text = lrcM?.lrcContent
        
        //滚动歌词
       
        //进度值
        if lrcM != nil {
            let time1 = (time - lrcM!.beginTime)
            let time2 = (lrcM!.endTime - lrcM!.beginTime)
            lrcLabel.radio = CGFloat(time1 / time2)
        }
        lrcVC.progress = lrcLabel.radio
        //滚到哪一行
        let row = QQMusicDataTool.getCurrentLrcM(currentTime: time, lrcMs: lrcMs).row
        lrcVC.scrollRow = row
        
       if  UIApplication.shared.applicationState == .background {
           QQMusicOperationTool.sharedInstance.setUpLockMessage()
        }
        
      
        
       
    }
}

extension QQDetailVC {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
}

extension QQDetailVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let radio = 1 - (x / scrollView.width)
        foreImageView.alpha =  radio
        lrcLabel.alpha = radio
    }
    
    func addRotationAnimation(){
        foreImageView.layer.removeAnimation(forKey: "rotation")
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 30
        animation.isRemovedOnCompletion = false
        animation.repeatCount = MAXFLOAT
        foreImageView.layer.add(animation, forKey: "rotation")
    
    }
    func pauseRotationAnimation(){
        foreImageView.layer.pauseAnimate()
    }
    
    func resumeAnimation(){
        foreImageView.layer.resumeAnimate()
    }
    
}

extension QQDetailVC{
    override func remoteControlReceived(with event: UIEvent?) {
    
        let type = event?.subtype
        switch type! {
        case .none:
            break
        case .motionShake:
            break
    
        case .remoteControlPlay:
            debugPrint("播放")
            QQMusicOperationTool.sharedInstance.playCurrentMusic()
            break
        case .remoteControlPause:
            QQMusicOperationTool.sharedInstance.pauseCurrentMusic()
            break
        case .remoteControlStop:
            
            break
        case .remoteControlTogglePlayPause:
            debugPrint("切换播放")
            break
        case .remoteControlNextTrack:
            QQMusicOperationTool.sharedInstance.nextMusic()
            break
        case .remoteControlPreviousTrack:
            QQMusicOperationTool.sharedInstance.preMusic()
            break
        case .remoteControlBeginSeekingBackward:
            break
        case .remoteControlEndSeekingBackward:
            break
        case .remoteControlBeginSeekingForward:
            break
        case .remoteControlEndSeekingForward:
            break
            
        @unknown default:
            break
        }
        
        setUpOnce()
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        QQMusicOperationTool.sharedInstance.nextMusic()
        setUpOnce()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        QQMusicOperationTool.sharedInstance.nextMusic()
        setUpOnce()
    }
}
