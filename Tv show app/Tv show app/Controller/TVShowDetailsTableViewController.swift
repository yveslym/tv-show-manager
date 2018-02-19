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
import MIBlurPopup
import  DOFavoriteButton


class TVShowDetailsTableViewController: UITableViewController, FSPagerViewDelegate, FSPagerViewDataSource,TVShowDelegate {
    
    @IBOutlet var tableview: UITableView!
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
    @IBOutlet weak var favoriteButton: UIButton!
    
    // Mark: Properties
    
    var delegate: TVShowDelegate!
    var coverImage = UIImage()
    var posterImage = UIImage()
    var similarTVName = [String]()
    let defaults = UserDefaults.standard
    var favoriteID = UserDefaults.standard.array(forKey: "favoriteID")  as? [Int] ?? [Int]()

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
    
    //@IBOutlet weak var favoriteButtom: DOFavoriteButton!
    
   
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
                    if $0.imageURL != nil{
                let data = try Data(contentsOf: $0.imageURL!)
                    let image = UIImage(data: data)
                    self.similarImage.append(image!)
                    }
                    else{
                        let image = UIImage(named:"search")
                        self.similarImage.append(image!)
                    }
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
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
       
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
                        
                        switch self.favoriteID.isEmpty{
                        case true:
                            self.favoriteID.append(self.tvShow.id!)
                            self.defaults.set(self.favoriteID, forKey: "favoriteID")
                            sender.imageView?.image = UIImage(named: "yellow-start")
                            
                        case false:
                            if let index = self.favoriteID.index(of:self.tvShow.id!) {
                                self.favoriteID.remove(at: index)
                                self.self.defaults.set(self.favoriteID, forKey: "favoriteID")
                                sender.imageView?.image = UIImage(named: "favorite")
                            }
                            else{
                                self.favoriteID.append(self.tvShow.id!)
                                self.defaults.set(self.favoriteID, forKey: "favoriteID")
                                sender.imageView?.image = UIImage(named: "yellow-start")
                            }
                            
                        }
                        
        },
completion: { Void in()  })
        
       
    }
    
    @IBAction func closeViewController(_ sender: UIButton) {

        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        if let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "home tab") {
           // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            present(vc3, animated: true, completion: nil)
        }

    }
    @IBAction func playTrailer(_ sender: Any) {
        self.performSegue(withIdentifier: "video", sender: self)
       
    }
    

    
    
    
    
    // Mark: - Table view life cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "video"{
        let videoVC = segue.destination as! VideoViewController
        videoVC.tvShow = self.tvShow
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favoriteID.index(of:tvShow.id!) != nil {
            
            self.favoriteButton.imageView?.image = UIImage(named: "yellow-start")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
//        self.tvShowTitleLabel.text = tvShow.name
//        self.tvShowStatus.text = tvShow.status
//        self.tvShowNetwork.text = tvShow.network
//        self.overView.text = self.tvShow.overview
//
            self.tvShowPosterImage.image = self.posterImage
            self.tvShowPosterImage.dropShadow()
            delegate = self
            self.tvShowTitleLabel.text = self.tvShow.name
            self.tvShowStatus.text = self.tvShow.status
            self.tvShowNetwork.text = self.tvShow.network
            self.overView.text = self.tvShow.overview
            self.tvShowCoverImage.image = self.coverImage
            let runtime:Int = (self.tvShow.runTime?.first) ?? 0
            self.tvShowRunTime.text = String("\(runtime) min")
        
        

       
        
        DispatchQueue.global().async {
            let manager = TVSHowManager()
            manager.similarTV(tvShowID: self.tvShow.id!, completionHandler: { (tvshow) in
                
                self.similarTV = tvshow!
                
                self.similarTV.forEach{
                    do{
                        if $0.imageURL != nil{
                        self.similarTVName.append($0.name!)
                        let data = try Data(contentsOf: $0.imageURL!)
                        let image = UIImage(data: data)
                        self.similarImage.append(image!)
                        }
                        else{
                            let image = UIImage(named: "search")
                             self.similarImage.append(image!)
                        }
                    }catch{
                        let image = UIImage(named: "search")
                        self.similarImage.append(image!)
                    }
                    if $0.name == nil{
                        self.similarTVName.append("")
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
        
        tvShowCoverImage.alpha = 0.5
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
        
        //favoriteButtom.addTarget(self, action: #selector(self.favoriteButtomTapped(_:)), for: .touchDown)
        //let starButton = DOFavoriteButton(frame: favoriteButtom.frame)
        //starButton.image = UIImage(named: "love")
        //starButton.addTarget(self, action: #selector(self.favoriteButtomTapped(_:)), for: .touchUpInside)
        //favoriteButtom = starButton
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
            
             //cell.textLabel?.text =  self.similarTVName[index]
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
            self.delegate.TVShowDetailViewController(tvShow: similarTV[pagerView.currentIndex])
        default: print("sorry pal")
        }
    }
}

