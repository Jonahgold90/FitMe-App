//
//  AbdomenViewController.swift
//  FitMeApp
//
//  Created by Gm Dev SR on 4/26/23.
//

import AVKit
import AVFoundation
import UIKit
//var videoView: UIView?
//let player = AVPlayer(url: URL(fileURLWithPath: (Bundle.main.path(forResource: "Pushup", ofType: "mp4"))!))
//
//let layer = AVPlayerLayer(player: player)


class AbdomenViewController: UIViewController {
    
    
    @IBOutlet var scrollView: UIStackView!
    
    
    @IBAction func btnPlay(_ sender: Any) {
        let videoURL = Bundle.main.url(forResource: "Pushup", withExtension: "mp4")
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
    //    override func viewDidAppear(_ animated: Bool) {
    //           super.viewDidAppear(animated)
    //
    //           // play the video
    //           player.play()
    //
    //           // create the video view
    //           videoView = UIView(frame: layer.frame)
    //           videoView?.translatesAutoresizingMaskIntoConstraints = false
    //           scrollView.addSubview(videoView!)
    //
    //           // add the layer to the video view
    //           videoView?.layer.addSublayer(layer)
    //
    //           // center the video view in the scroll view
    //           NSLayoutConstraint.activate([
    //               videoView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
    //               videoView!.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
    //           ])
    //       }
    //
    //       override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //           super.viewWillTransition(to: size, with: coordinator)
    //
    //           // set the video layer position on rotation
    //           guard let videoView = videoView else { return }
    //           let deviceType = UIDevice.current.userInterfaceIdiom
    //           switch deviceType {
    //           case .phone:
    //               print("Case: iPhone")
    //               print(scrollView.frame.width)
    //               print(scrollView.frame.height)
    //               videoView.frame = CGRect(x: (scrollView.frame.width - 400) / 2, y: 400, width: 400, height: 400)
    //           case .pad:
    //               videoView.frame = CGRect(x: 100, y: 200, width: 600, height: 600)
    //           default:
    //               videoView.frame = CGRect(x: (scrollView.frame.width - 400) / 2, y: 400, width: 400, height: 400)
    //           }
    //       }
    //   }

