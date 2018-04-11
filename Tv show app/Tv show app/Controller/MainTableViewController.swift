//
//  MainTableViewController.swift
//  Tv show app
//
//  Created by Yveslym on 1/15/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import FSPagerView
import UserNotifications
import KeychainSwift
//mport NVActivityIndicatorView




class MainTableViewController: UITableViewController, FSPagerViewDelegate, FSPagerViewDataSource, TVShowDelegate {
    

    // Mark: Properties
    var blankView: UIView!
    var waitView: UIView!
    var waitView2: UIView!
    var waitView3: UIView!
   
    /// the activity indicator
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    weak var delegate: TVShowDelegate!
   
    private let refreshControls = UIRefreshControl()
    
    /// propertie to hold popular tv show
    var popularTV = [TVSHow]()
    // properties to hold top rated tvshow
    var topRatedTV = [TVSHow]()

    // properties to hold top airing tvshow
    var airingTV = [TVSHow]()

    // properties to hold top airing tvshow
    var discoverTV = [TVSHow]()

    var topRatedImage = [UIImage]()
    var popularImage = [UIImage]()
    var airingImage = [UIImage]()
    var discoverImage = [UIImage]()
    // Mark: IBOutlets
   
    @IBOutlet weak var popularView: FSPagerView!{
        didSet {
            self.popularView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.popularView.tag = 3
        }
    }
    
   
    @IBOutlet weak var discoverTVView: FSPagerView!{
        didSet {
            self.discoverTVView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.discoverTVView.tag = 2
        }
    }
    
    
    @IBOutlet weak var topRatedView: FSPagerView!{
        didSet {
            self.topRatedView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.topRatedView.tag = 4
        }
    }
    
    @IBOutlet weak var airingView: FSPagerView!{
        didSet {
            self.airingView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.airingView.tag = 1
        }
    }
    /// method to get popular tv show
    func getPopularTV(completion:@escaping()->()){
         let manager = TVSHowManager()
      DispatchQueue.global().async {
        manager.popularTV { (tvshow) in
             self.popularTV = tvshow!
            Helpers.downloadImage(tvShow: tvshow!, completion: { (images) in
                self.popularImage = images
                completion()
            })
            }
        }
    }
    
    
    
    //function toget top rated tv
    func getTopRated(completion:@escaping()->()){
        DispatchQueue.global().async {
         let manager = TVSHowManager()
            manager.bestRateTV { (tvshow) in
                self.topRatedTV = tvshow!
                Helpers.downloadImage(tvShow: tvshow!, completion: { (images) in
                    self.topRatedImage = images
                     completion()
                })
                
               
            }
    }
}
    /// method to get airing tv show
    func getAiringToday(completion:@escaping()->()){
        DispatchQueue.global().async {
            let manager = TVSHowManager()
            manager.airingTodayTV { (tvshow) in
                self.airingTV = tvshow
                Helpers.downloadImage(tvShow: tvshow, completion: { (images) in
                    self.airingImage = images
                     completion()
                })
            }
        }
}
    func getDiscoverTV(completion:@escaping()->()){
        DispatchQueue.global().async {
            let manager = TVSHowManager()
            manager.discoverShow { (tvshow) in
                self.discoverTV = tvshow
                Helpers.downloadImage(tvShow: tvshow, completion: { (images) in
                    self.discoverImage = images
                     completion()
                })
            }
        }
}
    
    
    
    @IBAction func settinhButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "", preferredStyle: .actionSheet)
        let logOut = UIAlertAction(title: "Logout", style: .default) { (logout) in
             KeychainSwift().set(false, forKey: "isLogin")
            NetworkAdapter.request(target: .logOut, success: { (response) in
                ViewControllerUtils().showActivityIndicator(uiView: alert.view)
                if response.response?.statusCode == 200{
                    
                    KeychainSwift().set(false, forKey: "isLogin")
                    let lginPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
                    self.present(lginPage, animated: true, completion: nil)
                    ViewControllerUtils().showActivityIndicator(uiView: alert.view)
                }
                else{
                    // a better implementation need to be done here
                    KeychainSwift().set(false, forKey: "isLogin")
                    let lginPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
                    self.present(lginPage, animated: true, completion: nil)
                    ViewControllerUtils().showActivityIndicator(uiView: alert.view)

                }
            }, error: { (error) in
                
            }, failure: { (error) in
                
            })
        }
        
        let about = UIAlertAction(title: "About Us", style: .default) { (about) in
            
        }
        let cancel =  UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(about)
        alert.addAction(logOut)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func refresfavoriteTV(_ sender: Any) {
        // Fetch Weather Data
        
       
        
//        self.getfavoriteTV {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                self.refreshControl.endRefreshing()
//            }
//        }
    }
    
    // - MARK: VIEW CONTROLLER LIFE CYCLE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tvshow"{
            let destination = segue.destination as! TVShowDetailsTableViewController
            let tvshowTVC = sender as! TVShowDetailsTableViewController
            destination.tvShow = tvshowTVC.tvShow
            destination.posterImage = tvshowTVC.posterImage
            destination.coverImage = tvshowTVC.coverImage
            destination.seasonImage = tvshowTVC.seasonImage
            DispatchQueue.main.async {
                 self.spinner.stopAnimating()
            }
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(rgb: 0x1A1E36)
        
        self.waitView = UIView(frame: self.view.frame)
        self.waitView2 =  UIView(frame: self.view.frame)
        self.waitView3 =  UIView(frame: self.view.frame)
        self.blankView = UIView(frame: self.view.frame)
        self.waitView.tag = 100
         self.waitView2.tag = 100
         self.waitView3.tag = 100
        self.blankView.tag = 100
        
        self.waitView.getRandomColor(alpha: CGFloat( 0.2))
        self.waitView2.getRandomColor(alpha: CGFloat( 0.2))
        self.waitView3.getRandomColor(alpha: CGFloat( 0.3))
        let bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "b1")
        self.blankView.addSubview(bg)
        
        self.delegate = self
        self.airingView.dataSource = self
        self.airingView.delegate = self
        self.topRatedView.dataSource = self
        self.topRatedView.delegate = self
        self.popularView.dataSource = self
        self.popularView.delegate = self
       
        // configure the spinner
        
               
        
        // configure airing view
        self.airingView.transformer = FSPagerViewTransformer(type: .linear)
        airingView.itemSize = CGSize(width: 280, height: 180)
        airingView.isInfinite = true
        airingView.interitemSpacing = 5
        
        //configure topRated view
        self.topRatedView.transformer = FSPagerViewTransformer(type: .linear)
        topRatedView.itemSize = CGSize(width: 150, height: 180)
        topRatedView.isInfinite = true
        topRatedView.interitemSpacing = 0
        
        //configure airing view
        self.popularView.transformer = FSPagerViewTransformer(type: .linear)
        popularView.itemSize = CGSize(width: 150, height: 180)
        popularView.isInfinite = true
        popularView.interitemSpacing = 5
        
        //configure discover view
        self.discoverTVView.transformer = FSPagerViewTransformer(type: .linear)
        discoverTVView.itemSize = CGSize(width: 150, height: 180)
        discoverTVView.isInfinite = true
        discoverTVView.interitemSpacing = 5
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
       
//        self.view.addSubview(self.waitView2)
//        self.view.addSubview(self.waitView3)
//        self.waitView.getRandomColor(alpha: CGFloat( 0.2))
//        self.waitView2.getRandomColor(alpha: CGFloat( 0.4))
//        self.waitView3.getRandomColor(alpha: CGFloat( 0.3))
        _ = DispatchQueue(label: "yveslym", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
       
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.view.addSubview(self.blankView)
                 ViewControllerUtils().showActivityIndicator(uiView: self.view)
                UIView.animate(withDuration: 3, animations: {
                    self.view.addSubview(self.waitView)
                })
            }
            
            self.getAiringToday {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 3, animations: {
                        self.view.addSubview(self.waitView3)
                    })
                }
               
                self.getDiscoverTV {
                   
                    DispatchQueue.main.async {
                        self.airingView.reloadData()
                        self.discoverTVView.reloadData()
                        
                        self.view.willRemoveSubview(self.waitView)
                        
                        self.view.willRemoveSubview(self.waitView3)
                        self.view.willRemoveSubview(self.blankView)
                        ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                    }
                    
                     self.getPopularTV {
                        DispatchQueue.main.async {
                            self.popularView.reloadData()
                            
                        }
                    self.getTopRated {
                            DispatchQueue.main.async {
                                
                                 self.topRatedView.reloadData()
                                
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        switch pagerView.tag{
        case 1:
            return self.airingTV.count
        case 2:
            return self.discoverTV.count
        case 3:
             return self.popularTV.count
        case 4:
             return self.topRatedTV.count
        default:
            return 0
        }
    }
    func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(title): \(timeElapsed) s.")
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let view = UIView()
        let title = UILabel()
        let year = UILabel()
        let stack = UIStackView()
       
        view.backgroundColor = UIColor.black
        view.alpha = 0.2
       view.frame = CGRect(x: 0, y: 0, width: pagerView.frame.width, height: pagerView.frame.height/3)
        view.center = pagerView.center
         stack.frame = view.frame
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.addSubview(year)
        stack.addSubview(title)
        view.addSubview(stack)
        
        
        /// add the tv show on the right cell base on the pagerview tag setup earlier
        switch pagerView.tag{
        case 1:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cell.imageView?.image = self.airingImage[index]
            cell.textLabel?.text = self.airingTV[index].name
            return cell
        case 2:
            let cells = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cells.imageView?.image = self.discoverImage[index]
            cells.textLabel?.text = self.discoverTV[index].name

            return cells
        case 3:
            
            let cells = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cells.imageView?.image = self.popularImage[index]
            cells.textLabel?.text = self.popularTV[index].name

            return cells
            
        case 4:
            
            let cells = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cells.imageView?.image = self.topRatedImage[index]
            cells.textLabel?.text = self.topRatedTV[index].name
            
            return cells
            
            
        default:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "popular", at: index)
            cell.imageView?.image = self.popularImage[index]
            return cell
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        view.endEditing(true)
        
        self.spinner.center = CGPoint(x:  pagerView.frame.size.width/2, y: pagerView.frame.size.height/2)
        self.spinner.alpha = 1.0
        self.spinner.startAnimating()
        pagerView.addSubview(spinner)
        
        switch pagerView.tag{
        case 1:
                self.delegate.TVShowDetailViewController(tvShow: self.airingTV[index])
        case 2:
                self.delegate.TVShowDetailViewController(tvShow: self.discoverTV[index])
        case 3:
                self.delegate.TVShowDetailViewController(tvShow: self.popularTV[index])
        case 4:
            self.delegate.TVShowDetailViewController(tvShow: self.topRatedTV[index])


        default:
            print("oups")
        }
    }
}

