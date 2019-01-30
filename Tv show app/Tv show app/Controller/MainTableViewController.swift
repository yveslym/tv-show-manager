//
//  MainTableViewController.swift
//  Tv show app
//
//  Created by Yveslym on 1/15/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import Foundation
import FSPagerView
import UserNotifications
import KeychainSwift
import ChameleonFramework
import AMScrollingNavbar





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
    
    
    
    //function to get top rated tv
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
                    return completion()
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
                   return completion()
                })
            }
        }
}
    
    
    
    @IBAction func settinhButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "", preferredStyle: .actionSheet)
        let logOut = UIAlertAction(title: "Logout", style: .default) { (logout) in
            ViewControllerUtils().showActivityIndicator(uiView: self.view)
            let keychain = KeychainSwift()
            
            keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
             keychain.set(false, forKey: "isLogin")
            NetworkAdapter.request(target: .logOut, success: { (response) in
                
                if response.response?.statusCode == 200{
                    
                    keychain.set(false, forKey: "isLogin")
                    let lginPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
                    self.present(lginPage, animated: true, completion: nil)
                    ViewControllerUtils().showActivityIndicator(uiView: self.view)
                }
                else{
                    // a better implementation need to be done here
                    keychain.set(false, forKey: "isLogin")
                    let lginPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
                    self.present(lginPage, animated: true, completion: nil)
                    ViewControllerUtils().showActivityIndicator(uiView: self.view)

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
    func setupBarColor(color: UIColor){
        //self.navigationController?.navigationBar.barTintColor = color
        
        

        self.tabBarController?.tabBar.tintColor = UIColor.flatWhite()
        self.tabBarController?.tabBar.barTintColor = color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupBarColor(color: UIColor.flatBlueColorDark())
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 5.0)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
    }
    
    func createGradient()-> UIColor{
        var colors = [UIColor]()
        for _ in 0 ... 2{
            colors.append(UIColor.randomFlat())
        }
        let gradient = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: colors)
        return gradient
    }
    func animateView(){
        self.waitView.backgroundColor = createGradient()
        self.waitView.alpha = 0.3
        
        let animation = {
            self.waitView.alpha = 1
        }
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: animation, completion: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let height: CGFloat = 200 //whatever height you want to add to the existing height
//        let bounds = self.navigationController!.navigationBar.bounds
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.waitView = UIView(frame: self.view.frame)
      

        self.blankView = UIView(frame: self.view.frame)
        self.waitView.tag = 100

        self.blankView.tag = 100

        self.blankView.backgroundColor = UIColor.flatWhite()
        
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
        airingView.itemSize = CGSize(width: 230, height: 200)
        airingView.isInfinite = true
        airingView.interitemSpacing = 0
        
        
        //configure topRated view
        self.topRatedView.transformer = FSPagerViewTransformer(type: .linear)
        topRatedView.itemSize = CGSize(width: 150, height: 150)
        topRatedView.isInfinite = true
        topRatedView.interitemSpacing = 5
        
        //configure airing view
        self.popularView.transformer = FSPagerViewTransformer(type: .linear)
        popularView.itemSize = CGSize(width: 150, height: 150)
        popularView.isInfinite = true
        popularView.interitemSpacing = 15
        
        //configure discover view
        self.discoverTVView.transformer = FSPagerViewTransformer(type: .linear)
        discoverTVView.itemSize = CGSize(width: 150, height: 150)
        discoverTVView.isInfinite = true
        discoverTVView.interitemSpacing = 25
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        _ = DispatchQueue(label: "yveslym", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
       
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                self.view.addSubview(self.blankView)
                self.view.addSubview(self.waitView)
                self.animateView()
                 ViewControllerUtils().showActivityIndicator(uiView: self.view)
                UIView.animate(withDuration: 3, animations: {
                    //self.view.addSubview(self.waitView)
                })
            }
            
            self.getAiringToday {
                DispatchQueue.main.async {
                    self.airingView.reloadData()
                    UIView.animate(withDuration: 3, animations: {
                       // self.view.addSubview(self.waitView3)
                    })
                }
               
                self.getDiscoverTV {
                   
                    DispatchQueue.main.async {

                        self.discoverTVView.reloadData()
                        
                       // self.view.willRemoveSubview(self.waitView)
                        
                        //self.view.willRemoveSubview(self.waitView3)
                        self.view.willRemoveSubview(self.blankView)
                        ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                         self.view.willRemoveSubview(self.waitView)
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
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
       
        pagerView.layer.shadowColor = UIColor.blue.cgColor
        pagerView.backgroundView?.layer.shadowColor = UIColor.blue.cgColor
    }
    
//
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        if(velocity.y>0) {
//            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
//            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//                self.navigationController?.setToolbarHidden(true, animated: true)
//                print("Hide")
//            }, completion: nil)
//
//        } else {
//            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                self.navigationController?.setToolbarHidden(false, animated: true)
//                print("Unhide")
//            }, completion: nil)
//        }
//    }
//
    
    
}

class TTNavigationBar: UINavigationBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
    
}

