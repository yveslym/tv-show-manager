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


class MainTableViewController: UITableViewController, FSPagerViewDelegate, FSPagerViewDataSource, TVShowDelegate {
    

    // Mark: Properties
    
    var waitView: UIView!
    var waitView2: UIView!
    var waitView3: UIView!
    
    /// the activity indicator
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var delegate: TVShowDelegate!
    /// propertie to hold popular tv show
    var popularTV = [TVSHow](){
        didSet{
            DispatchQueue.main.async {
                self.popularView.reloadData()
            }
        }
    }
    // properties to hold top rated tvshow
    var topRatedTV = [TVSHow](){
        didSet{
            DispatchQueue.main.async {
                self.topRatedView.reloadData()
            }
        }
    }
    // properties to hold top airing tvshow
    var airingTV = [TVSHow](){
        didSet{
            DispatchQueue.main.async {
                
                self.airingView.reloadData()
            }
            
        }
    }
    
    // properties to hold top airing tvshow
    var discoverTV = [TVSHow](){
        didSet{
            DispatchQueue.main.async {
                
                self.discoverTVView.reloadData()
            }
            
        }
    }
    
    
    
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
    func getPopularTV(){
         let manager = TVSHowManager()
        DispatchQueue.global().async {
            
        
        manager.popularTV { (tvshow) in
                tvshow?.forEach{
                    do{
                        let data = try  Data(contentsOf: $0.imageURL!)
                        let image = UIImage(data: data)
                        self.popularImage.append(image!)
                    }catch{
                        print("couldn't load image")
                    }
                }
                self.popularTV = tvshow!
            }
        }
    }
    
    //function toget top rated tv
    func getTopRated(){
        DispatchQueue.global().async {
         let manager = TVSHowManager()
            manager.bestRateTV{ (tvshow) in
                tvshow?.forEach{
                    do{
                        let data = try  Data(contentsOf: $0.imageURL!)
                        let image = UIImage(data: data)
                        self.topRatedImage.append(image!)
                    }catch{
                        print("couldn't load image")
                    }
                }
               
                self.topRatedTV = tvshow!
        }
        }
    }
    /// method to get airing tv show
    func getAiringToday(){
        DispatchQueue.global().async {
        let manager = TVSHowManager()
        manager.airingTodayTV{ (tvshow) in
            tvshow.forEach{
                do{
                    if $0.imageURL != nil{
                    let data = try  Data(contentsOf: $0.imageURL!)
                    let image = UIImage(data: data)
                    self.airingImage.append(image!)
                    }else{
                        let image = UIImage(named:"search")
                        self.airingImage.append(image!)
                    }
                }catch{
                    print("couldn't load image")
                    let image = UIImage(named:"search")
                    self.airingImage.append(image!)
                }
            }
            self.airingTV = tvshow
        }
        }
    }
    
    func getDiscoverTV(){
        
        let manager = TVSHowManager()
        DispatchQueue.global().async {
        manager.discoverShow{ (tvshow) in
            tvshow.forEach{
                do{
                    if $0.imageURL != nil{
                        let data = try  Data(contentsOf: $0.imageURL!)
                        let image = UIImage(data: data)
                        self.discoverImage.append(image!)
                    }else{
                        let image = UIImage(named:"search")
                        self.discoverImage.append(image!)
                    }
                }catch{
                    print("couldn't load image")
                    let image = UIImage(named:"search")
                    self.discoverImage.append(image!)
                }
            }
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
                self.waitView.removeFromSuperview()
            }
            self.waitView2.removeFromSuperview()
             self.waitView3.removeFromSuperview()
            
            self.discoverTV = tvshow
        }
    }
}


   
    
    override func viewDidAppear(_ animated: Bool) {
       
        self.view.addSubview(self.waitView)
         self.view.addSubview(self.waitView2)
         self.view.addSubview(self.waitView3)
        self.waitView.getRandomColor(alpha: CGFloat( 0.2))
        self.waitView2.getRandomColor(alpha: CGFloat( 0.4))
        self.waitView3.getRandomColor(alpha: CGFloat( 0.3))
        let dq = DispatchQueue(label: "yveslym", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        dq.async {
              self.getTopRated()
        }
        dq.async {
             self.getPopularTV()
        }
        dq.async {
            self.getAiringToday()
        }
        dq.async {
            self.getDiscoverTV()
        }
       
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as? TVShowDetailsTableViewController
//        let pagerView = sender as! FSPagerView
//
//        switch pagerView.tag {
//        case 1:
//            destination?.tvShow = self.popularTV[pagerView.currentIndex]
//            destination?.posterImage = self.popularImage[pagerView.currentIndex]
//        case 2:
//            destination?.tvShow = self.topRatedTV[pagerView.currentIndex]
//            destination?.posterImage = self.topRatedImage[pagerView.currentIndex]
//        case 3:
//            destination?.tvShow = self.airingTV[pagerView.currentIndex]
//            destination?.posterImage = self.airingImage[pagerView.currentIndex]
//        default:
//            break
//        }
//    }
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.waitView = UIView(frame: self.view.frame)
        self.waitView2 =  UIView(frame: self.view.frame)
        self.waitView3 =  UIView(frame: self.view.frame)
        self.waitView.tag = 100
        self.waitView.getRandomColor(alpha: CGFloat( 0.2))
        self.waitView2.getRandomColor(alpha: CGFloat( 0.4))
        self.waitView3.getRandomColor(alpha: CGFloat( 0.3))
        
        
        self.delegate = self
        self.airingView.dataSource = self
        self.airingView.delegate = self
        self.topRatedView.dataSource = self
        self.topRatedView.delegate = self
        self.popularView.dataSource = self
        self.popularView.delegate = self
       
        // configure the spinner
        
        spinner.frame = CGRect(x: 20.0, y: 6.0, width: 40.0, height: 40.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
//        self.airingView.addSubview(spinner)
//        self.popularView.addSubview(spinner)
//        self.topRatedView.addSubview(spinner)
        
        // configure popular view
        self.airingView.transformer = FSPagerViewTransformer(type: .linear)
        airingView.itemSize = CGSize(width: 300, height: 180)
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

