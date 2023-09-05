//
//  ViewController.swift
//  Calculator
//
//  Created by Gm Dev SR on 2/22/23.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBAction func btnPlay(_ sender: Any) {
        let videoURL = Bundle.main.url(forResource: "Lunges", withExtension: "mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true){
            playerViewController.player!.play()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    }



