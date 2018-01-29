//
//  TVShowDetailsTableViewController.swift
//  Tv show app
//
//  Created by Yveslym on 1/15/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import FSPagerView
import youtube_ios_player_helper


class TVShowDetailsTableViewController: UITableViewController, FSPagerViewDelegate, FSPagerViewDataSource,TVShowDelegate {
    
    @IBOutlet weak var filterImg: UIImageView!
    @IBOutlet weak var tvShowCoverImage: UIImageView!
    @IBOutlet weak var tvShowPosterImage: UIImageView!
    @IBOutlet weak var tvShowTitleLabel: UILabel!
    @IBOutlet weak var tvShowRunTime: UILabel!
    @IBOutlet weak var tvShowNetwork: UILabel!
    @IBOutlet weak var tvShowStatus: UILabel!
//    @IBOutlet weak var similarTVTitleLabel: UILabel!
//    @IBOutlet weak var seasonTitleLabel: UILabel!
    @IBOutlet weak var similarTVCell: UITableViewCell!
    @IBOutlet weak var overView: UITextView!
    
    
    // Mark: Properties
    
    var delegate: TVShowDelegate!
    var coverImage = UIImage()
    var posterImage = UIImage()
    var similarTVName = [String]()
    var tvShow = TVSHow(){
        didSet{
            
        }
    }

    var similarTV = [TVSHow](){
        didSet{
            
        }
    }
  
    var similarImage = [UIImage](){
        didSet{
//            DispatchQueue.main.async {
//                self.similarTVShowView.reloadData()
//            }
        }
    }
    var seasonImage = [UIImage](){
        didSet{
//            DispatchQueue.main.async {
//                self.tvShowSeasonsView.reloadData()
//            }
        }
    }
    
    
    
    // Mark: IBOUtlet
    
    
    @IBOutlet weak var tvShowSeasonsView: FSPagerView!{
        didSet {
            self.tvShowSeasonsView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.tvShowSeasonsView.tag = 1
        }
    }
    @IBOutlet weak var similarTVShowView: FSPagerView!{
    didSet {
    self.similarTVShowView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
    self.similarTVShowView.tag = 2
    }
}
    // Mark: - Methods
    
    
    
    
    // method to get similar tvshow and all images
    func getSimilarTV(){
        let manager = TVSHowManager()
        
        manager.similarTV(tvShowID: self.tvShow.id!) { (similar) in
            self.similarTV = similar!
            similar?.forEach{
                do{
                let data = try Data(contentsOf: $0.imageURL!)
                    let image = UIImage(data: data)
                    self.similarImage.append(image!)
                }catch{
                    let image = UIImage(named: "search")
                     self.similarImage.append(image!)
                }
            }
           
            DispatchQueue.main.async {
                self.similarTVShowView.reloadData()
            }
        }
        
    }
    
    
    // Mark: - IBAction
    
    @IBAction func closeViewController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainvc = storyboard.instantiateViewController(withIdentifier: "main") as! MainTableViewController
        self.present(mainvc, animated: true, completion: nil)
    }
    @IBAction func playTrailer(_ sender: Any) {
        
        let manager = TVSHowManager()
        manager.getVideos(withId: self.tvShow.id!) { (videos) in
            
        let videoView = UIAlertController()
//            videoView.view.frame = CGRect(x: Double(self.view.center.x), y: Double(self.view.center.y), width: Double(self.view.frame.width/0.9), height: Double(self.view.frame.height/0.6))
//    videoView.view.center = CGPoint(x: self.view.frame.size.width/2, y:  self.view.frame.size.height/2)
            
            let cancel = UIAlertAction(title: self.tvShow.name, style: .cancel, handler: nil)
            videoView.addAction(cancel)
            let playerView = YTPlayerView(frame: videoView.view.frame)
            playerView.load(withVideoId: (videos?.first?.key!)!)
            playerView.playVideo()
            self.present(videoView, animated: true, completion: nil)
            
            
//             let viewController = UIViewController()
//            let playerView = YTPlayerView(frame: viewController.view.frame)
//
//
//            playerView.load(withVideoId: (videos?.first?.key!)!)
//            playerView.playVideo()
//
//            self.navigationController?.viewControllers = [viewController]
//            //viewController.navigationItem
//
//            viewController.view.addSubview(playerView)
//            self.present(viewController, animated: true, completion: {
//                playerView.playVideo()
//
//            })
        }
       
    }
    
    // Mark: - Table view life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        // self.similarTVCell.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        
//        self.tvShowTitleLabel.text = tvShow.name
//        self.tvShowStatus.text = tvShow.status
//        self.tvShowNetwork.text = tvShow.network
//        self.overView.text = self.tvShow.overview
//
            self.tvShowPosterImage.image = self.posterImage
        
            delegate = self
            self.tvShowTitleLabel.text = self.tvShow.name
            self.tvShowStatus.text = self.tvShow.status
            self.tvShowNetwork.text = self.tvShow.network
            self.overView.text = self.tvShow.overview
            self.tvShowCoverImage.image = self.coverImage
            let runtime:Int = (self.tvShow.runTime?.first)!
            self.tvShowRunTime.text = String("\(runtime) min")
        
        

       
        
        DispatchQueue.global().async {
            let manager = TVSHowManager()
            manager.similarTV(tvShowID: self.tvShow.id!, completionHandler: { (tvshow) in
                
                self.similarTV = tvshow!
                
                self.similarTV.forEach{
                    do{
                        self.similarTVName.append($0.name!)
                        let data = try Data(contentsOf: $0.imageURL!)
                        let image = UIImage(data: data)
                        self.similarImage.append(image!)
                    }catch{
                        let image = UIImage(named: "search")
                        self.similarImage.append(image!)
                    }
                }
                
                DispatchQueue.main.async {
                    self.similarTVShowView.reloadData()
                    self.similarTVCell.isHidden = false
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configure season view
        self.tvShowSeasonsView.transformer = FSPagerViewTransformer(type: .overlap)
        tvShowSeasonsView.itemSize = CGSize(width: 200, height: 150)
        tvShowSeasonsView.interitemSpacing = 5
        
        //configure season view
        self.similarTVShowView.transformer = FSPagerViewTransformer(type: .overlap)
        similarTVShowView.itemSize = CGSize(width: 250, height: 200)
        similarTVShowView.isInfinite = true
        similarTVShowView.interitemSpacing = 5
        
        similarTVShowView.delegate = self
        similarTVShowView.dataSource = self
        tvShowSeasonsView.delegate = self
        tvShowSeasonsView.dataSource = self
    }

   
    // Mark: FSP Datasource
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        switch pagerView.tag{
        case 1:
            if self.tvShow.seasons == nil{return 0}
            else{return (self.tvShow.seasons?.count)!}
        case 2:
            return self.similarTV.count
        default:
            return 0
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        switch pagerView.tag{
        case 1:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cell.imageView?.image = self.seasonImage[index]
            
            
            return cell
            
        case 2:
             let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            
             cell.textLabel?.text =  self.similarTVName[index]
             cell.imageView?.image = self.similarImage[index]
             
//             if self.similarTV.indices.contains(index-1){
//             self.similarTVTitleLabel.text = self.similarTV[index-1].name
//             }else{
//                self.similarTVTitleLabel.text = self.similarTV[1].name
//             }
            return cell
        default:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cell.imageView?.image = self.similarImage[index]
            return cell
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.frame = CGRect(x: 20.0, y: 6.0, width: 40.0, height: 40.0)
        spinner.center = CGPoint(x:  pagerView.frame.size.width/2, y: pagerView.frame.size.height/2)
       
        pagerView.addSubview(spinner)
        switch pagerView.tag{
        case 2:
            spinner.startAnimating()
            delegate.TVShowDetailViewController(tvShow: similarTV[index])
        default: print("sorry pal")
        }
    }
    


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


