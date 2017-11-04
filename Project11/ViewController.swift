//
//  ViewController.swift
//  Project11
//
//  Created by Mac on 2017/11/4.
//  Copyright © 2017年 Sunny, Lee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  @IBOutlet weak var playbutton: UIButton!
  
  @IBOutlet weak var playbackSlider: UISlider!
  
  @IBOutlet weak var playTime: UILabel!
  
  
  
  //播放器相关
  var playerItem:AVPlayerItem?
  var player:AVPlayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //初始化播放器
    let url = URL(string: "https://archive.org/download/testmp3testfile/mpthreetest.mp3")
    playerItem = AVPlayerItem(url: url!)
    player = AVPlayer(playerItem: playerItem!)
    
    //设置进度条相关属性
    let duration : CMTime = playerItem!.asset.duration
    let seconds : Float64 = CMTimeGetSeconds(duration)
    playbackSlider!.minimumValue = 0
    playbackSlider!.maximumValue = Float(seconds)
    playbackSlider!.isContinuous = false
    
    //播放过程中动态改变进度条值和时间标签
    player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1),
                                    queue: DispatchQueue.main) { (CMTime) -> Void in
                                      if self.player!.currentItem?.status == .readyToPlay {
                                        //更新进度条进度值
                                        let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                                        self.playbackSlider!.value = Float(currentTime)
                                        
                                        //一个小算法，来实现00：00这种格式的播放时间
                                        let all:Int=Int(currentTime)
                                        let m:Int=all % 60
                                        let f:Int=Int(all/60)
                                        var time:String=""
                                        if f<10{
                                          time="0\(f):"
                                        }else {
                                          time="\(f)"
                                        }
                                        if m<10{
                                          time+="0\(m)"
                                        }else {
                                          time+="\(m)"
                                        }
                                        //更新播放时间
                                        self.playTime!.text=time
                                      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //页面显示时添加歌曲播放结束通知监听
  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying),
                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
  }
  //页面消失时取消歌曲播放结束通知监听
  override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self)
  }
  
  //歌曲播放完毕
  @objc func finishedPlaying(myNotification:NSNotification) {
    print("播放完毕!")
    let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
    stopedPlayerItem.seek(to: kCMTimeZero)
  }
  
  
  @IBAction func playbackSliderValueChanged(_ sender: UISlider) {
    let seconds : Int64 = Int64(playbackSlider.value)
    let targetTime:CMTime = CMTimeMake(seconds, 1)
    //播放器定位到对应的位置
    player!.seek(to: targetTime)
    //如果当前时暂停状态，则自动播放
    if player!.rate == 0
    {
      player?.play()
      playbutton.setTitle("暂停", for: .normal)
    }
  }
  
  @IBAction func playButtonTapped(_ sender: UIButton) {
    //根据rate属性判断当天是否在播放
    if player?.rate == 0 {
      player!.play()
      playbutton.setTitle("暂停", for: .normal)
    } else {
      player!.pause()
      playbutton.setTitle("播放", for: .normal)
    }
  }
  
}

