//
//  VideoViewController.swift
//  Tv show app
//
//  Created by Yveslym on 1/28/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var playerView: UIView!
    //@IBOutlet weak var playerView: UIView!
    var tvShow: TVSHow!
     var player  = YTPlayerView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
       
        DispatchQueue.main.async {
        let manager = TVSHowManager()
            if let lastEpisode = manager.nextEpisode(tvShow){
                //if let lastEpisode.
            }

        manager.getVideos(withId: self.tvShow.id!) { (videos) in

            
            let player = YTPlayerView(frame: self.playerView.frame)
            player.load(withVideoId: (videos?.first?.key!)!)
            player.playVideo()
            self.playerView.addSubview(player)
            
        
        }
    }
}
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state.hashValue == 2{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}









