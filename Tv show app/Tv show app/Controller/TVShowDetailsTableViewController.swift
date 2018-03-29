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

struct ActivitySpinner{
     static let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    static func startSpinner(){
        spinner.startAnimating()
        spinner.alpha = 1.0
    }
    static func stopSpinner(){
        spinner.alpha = 0.0
    }
}


class TVShowDetailsTableViewController: UITableViewController, FSPagerViewDelegate, FSPagerViewDataSource,TVShowDelegate {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var filterImg: UIImageView!
    @IBOutlet weak var tvShowCoverImage: UIImageView!
    @IBOutlet weak var tvShowPosterImage: UIImageView!
    @IBOutlet weak var tvShowTitleLabel: UILabel!
    @IBOutlet weak var tvShowRunTime: UILabel!
    @IBOutlet weak var tvShowNetwork: UILabel!
    @IBOutlet weak var tvShowStatus: UILabel!
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
    var similarImage = [UIImage]()
    
    
    var tvShow = TVSHow(){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.similarTVShowView.reloadData()
                self.tvShowSeasonsView.reloadData()
                
            }
        }
    }
    var seasonImage = [UIImage](){
        didSet{
            DispatchQueue.main.async {
                if !self.seasonImage.isEmpty && self.tvShowSeasonsView != nil {
                      self.tvShowSeasonsView.reloadData()
                }
                
            }
        }
    }
    
    /// initialize similar tv show and reload the evrytime there is an new list of similar tv show
    var similarTV = [TVSHow](){
        didSet{
            DispatchQueue.main.async {
                self.similarTVShowView.reloadData()
            }
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
                            self.favoriteButton.isSelected = true
                            
                        case false:
                            if let index = self.favoriteID.index(of:self.tvShow.id!) {
                                self.favoriteID.remove(at: index)
                                self.self.defaults.set(self.favoriteID, forKey: "favoriteID")
                               self.favoriteButton.isSelected = false
                            }
                            else{
                                self.favoriteID.append(self.tvShow.id!)
                                self.defaults.set(self.favoriteID, forKey: "favoriteID")
                                self.favoriteButton.isSelected = true
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
//            present(vc3, animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
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
    
   
    
    override func reloadInputViews() {
        
        
        
        DispatchQueue.main.async {
            self.tvShowPosterImage.image = self.posterImage
            self.tvShowPosterImage.dropShadow(scale: true)
           
            self.tvShowTitleLabel.text = self.tvShow.name
            self.tvShowStatus.text = self.tvShow.status
            self.tvShowNetwork.text = self.tvShow.network ?? "\(self.tvShow.voteAverage ?? 0.0)"
            self.overView.text = self.tvShow.overview
            self.tvShowCoverImage.image = self.coverImage
            let runtime:Int = (self.tvShow.runTime?.first) ?? 0
            self.tvShowRunTime.text = String("\(runtime) min")
            ActivitySpinner.spinner.alpha = 0.0
            
            if self.favoriteID.index(of:self.tvShow.id!) != nil {
                
                let image = UIImage(named: "yellow-stars")
                self.favoriteButton.isSelected = true
                self.favoriteButton.setImage(image, for: .selected)
                
            }
            else{
                //let image = UIImage(named: "yellow-stars")
                 self.favoriteButton.isSelected = false
            }
            
            if self.tvShowSeasonsView != nil {
            self.tvShowSeasonsView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.reloadInputViews()
        self.getSimilarTV {
            DispatchQueue.main.async {
                self.similarTVShowView.reloadData()
                self.similarTVCell.isHidden = false
                ActivitySpinner.spinner.alpha = 0.0
            }
        }
    }
    
    func getSimilarTV(completion: @escaping()->()){
        DispatchQueue.global().async {
            let manager = TVSHowManager()
            manager.similarTV(tvShowID: self.tvShow.id!, completionHandler: { (tvshow) in
                self.similarTV = tvshow!
               self.similarImage = Helpers.downloadImage(tvShow: tvshow!)
                return completion()
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
        similarTVShowView.itemSize = CGSize(width: 150, height: 180)
        similarTVShowView.isInfinite = true
        similarTVShowView.interitemSpacing = 10
        
        similarTVShowView.delegate = self
        similarTVShowView.dataSource = self
        tvShowSeasonsView.delegate = self
        tvShowSeasonsView.dataSource = self
        
         delegate = self
        
        ActivitySpinner.spinner.frame = CGRect(x: 20.0, y: 6.0, width: 40.0, height: 40.0)
         ActivitySpinner.spinner.center = CGPoint(x:  self.similarTVShowView.frame.size.width/2, y: self.similarTVShowView.frame.size.height/2)
         ActivitySpinner.spinner.startAnimating()
         ActivitySpinner.spinner.alpha = 0.0
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
        
       
        pagerView.addSubview(ActivitySpinner.spinner)
        switch pagerView.tag{
        case 2:
            ActivitySpinner.spinner.alpha = 1.0
            let similartv = self.similarTV[index]
            self.delegate.TVShowDetail(tvShow: similartv, tvDetailViewController: self)
            self.delegate.tvShowSimilar(tvShow: similartv, TVShowController: self)
            
        default: print("sorry pal")
        }
    }
}

