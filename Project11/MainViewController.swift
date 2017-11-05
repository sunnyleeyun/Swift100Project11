//
//  MainViewController.swift
//  Project11
//
//  Created by Mac on 2017/11/5.
//  Copyright © 2017年 Sunny, Lee. All rights reserved.
//

import UIKit
import AVFoundation

var audioPlayer = AVAudioPlayer()
var songs:[String] = []
var thisSong = 0
var audioStuffed = false

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    gettingSongNames()
    
    audioPlayer.enableRate = true
    tableView.delegate = self
    tableView.dataSource = self
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return songs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
    cell.textLabel?.text = songs[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    do
    {
      let audioPath = Bundle.main.path(forResource: songs[indexPath.row], ofType: ".mp3")
      try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
      audioPlayer.play()
      thisSong = indexPath.row
      audioStuffed = true
      
      let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlayViewControllerID") as! PlayViewController
      
      self.navigationController?.pushViewController(secondViewController, animated: true)


    }
    catch
    {
      print ("ERROR")
    }
  }
  
  
  //FUNCTION THAT GETS THE NAME OF THE SONGS
  func gettingSongNames()
  {
    let folderURL = URL(fileURLWithPath:Bundle.main.resourcePath!)
    
    do
    {
      let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
      
      //loop through the found urls
      for song in songPath
      {
        var mySong = song.absoluteString
        
        if mySong.contains(".mp3")
        {
          let findString = mySong.components(separatedBy: "/")
          mySong = findString[findString.count-1]
          mySong = mySong.replacingOccurrences(of: "%20", with: " ")
          mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
          songs.append(mySong)
        }
        
      }
      
      tableView.reloadData()
    }
    catch
    {
      print ("ERROR")
    }
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
