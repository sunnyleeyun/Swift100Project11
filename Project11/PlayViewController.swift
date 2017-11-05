//
//  PlayViewController.swift
//  Project11
//
//  Created by Mac on 2017/11/5.
//  Copyright © 2017年 Sunny, Lee. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController {
  
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var Image: UIImageView!
  
  @IBOutlet weak var sliderOutlet: UISlider!
  @IBOutlet weak var speed: UILabel!
  @IBOutlet weak var playButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    playButton.layer.masksToBounds = true
    playButton.layer.cornerRadius = playButton.frame.width/2
    
    previousButton.layer.cornerRadius = 10
    previousButton.clipsToBounds = true
    
    nextButton.layer.cornerRadius = 10
    nextButton.clipsToBounds = true
    
    label.text = songs[thisSong]

    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func play(_ sender: UIButton) {
    if audioStuffed == true && audioPlayer.isPlaying == false
    {
      audioPlayer.play()
      playButton.setTitle("PAUSE", for: .normal)
    } else if audioStuffed == true && audioPlayer.isPlaying {
      audioPlayer.pause()
      playButton.setTitle("PLAY", for: .normal)
    }
  }
  
  
  
  @IBAction func previous(_ sender: UIButton) {
    if thisSong != 0 && audioStuffed == true
    {
      playThis(thisOne: songs[thisSong-1])
      thisSong -= 1
      label.text = songs[thisSong]
    }
    else
    {
      
    }
  }
  
  @IBAction func next(_ sender: UIButton) {
    if thisSong < songs.count-1 && audioStuffed == true
    {
      playThis(thisOne: songs[thisSong+1])
      thisSong += 1
      label.text = songs[thisSong]
    }
    else
    {
      
    }
  }
  
  func playThis(thisOne:String)
  {
    do
    {
      let audioPath = Bundle.main.path(forResource: thisOne, ofType: ".mp3")
      try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
      audioPlayer.play()
    }
    catch
    {
      print ("ERROR")
    }
  }
  
  @IBAction func slider(_ sender: Any) {
    speed.text = String(format: "%.2f", sliderOutlet.value)
    audioPlayer.rate = sliderOutlet.value
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
