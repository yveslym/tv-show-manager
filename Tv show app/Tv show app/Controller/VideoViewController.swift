//
//  VideoViewController.swift
//  Tv show app
//
//  Created by Yveslym on 1/28/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import YoutubeKit

class VideoViewController: UIViewController, YTPlayerViewDelegate {

    private var player2: YTSwiftyPlayer!
    @IBOutlet weak var playerView: UIView!
    //@IBOutlet weak var playerView: UIView!
    var tvShow: TVSHow!
     var player  = YTPlayerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        addswipe()
    }

    func addswipe(){
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(dismiss(_:)))
        self.view.addGestureRecognizer(swipe)
    }
    @objc func dismiss(_ swiper: UISwipeGestureRecognizer){

       let direction = swiper.direction
        if direction == .right{
            self.navigationController?.popViewController(animated: true)
            //self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
       
        DispatchQueue.main.async {
        let manager = TVSHowManager()

            self.player2 = YTSwiftyPlayer(
                frame: CGRect(x: 0, y: 0, width: 640, height: 480),
                playerVars: [.videoID("videoID-abcde")])

            let tv_id = self.tvShow.id!
            if let lastEpisode = manager.nextEpisode(self.tvShow){
                let episodeNumber = lastEpisode.episodeNumber!
                let seasonNumber = lastEpisode.seasonNumber!

                let request = SearchListRequest.init(part: [Part.SearchList.id, .snippet], filter: nil, channelID: nil, channelType: nil, eventType: nil, maxResults: 5, onBehalfOfContentOwner: nil, order: nil, pageToken: nil, publishedAfter: nil, publishedBefore: nil, searchQuery: "\(self.tvShow.name!) season \(seasonNumber) episode \(episodeNumber) trailer", regionCode: nil, safeSearch: SearchSafeMode.moderate, topicID: nil, resourceType: nil, videoCaption: nil, videoCategoryID: nil, videoDefinition: nil, videoDimension: nil, videoDuration: nil, videoEmbeddable: nil, videoLicense: nil, videoSyndicated: nil, videoType: nil)

                ApiSession.shared.send(request, closure: { (result) in
                    print(result)
                    let videoId = result.value?.items.first?.id.videoID

                     self.player = YTPlayerView(frame: self.playerView.frame)
                    self.player.delegate = self
                    self.player.load(withVideoId: videoId!)
                    self.player.playVideo()
                    self.playerView.addSubview(self.player)

                })
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
    }
}
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state.hashValue == 2{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
         self.navigationController?.popToRootViewController(animated: true)
    }

}









