//
//  BicepViewController.swift
//  FitMeApp
//
//  Created by Gm Dev SR on 5/1/23.
//

import UIKit
import AVKit
import AVFoundation

class BicepViewController: UIViewController {

    @IBAction func btnPlay(_ sender: Any) {
        let videoURL = Bundle.main.url(forResource: "Curl", withExtension: "mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true){
            playerViewController.player!.play()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
