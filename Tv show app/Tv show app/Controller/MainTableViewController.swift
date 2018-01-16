//
//  MainTableViewController.swift
//  Tv show app
//
//  Created by Yveslym on 1/15/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import FSPagerView


class MainTableViewController: UITableViewController, FSPagerViewDelegate, FSPagerViewDataSource {
    

    // Mark: Properties
    
//    var detailedPopularTV = [TVSHow]()
//    var detailedAiringTV = [TVSHow]()
//    var detailedTopRatedTV = [TVSHow]()
    
    var popularTV = [TVSHow](){
        didSet{
            DispatchQueue.main.async {
                self.popularView.reloadData()
            }
            
//            DispatchQueue.global().async {
//                self.getPopularTVDetails()
//            }
        }
    }
    // properties to hold top rated tvshow
    var topRatedTV = [TVSHow](){
        didSet{
            DispatchQueue.main.async {
                self.topRatedView.reloadData()
            }
            
            //let when = DispatchTime.now() + 10 // change 2 to desired number of seconds
            
//            DispatchQueue.global().asyncAfter(deadline: when) {
//                self.getTopRatedTVDetails()
//            }
        }
    }
    
    var airingTV = [TVSHow](){
        didSet{
            DispatchQueue.main.async {
                
                self.airingView.reloadData()
            }
            
//            let when = DispatchTime.now() + 15// change 2 to desired number of seconds
//            DispatchQueue.global().asyncAfter(deadline: when) {
//                 self.getAiringTVDetails()
//            }
        }
    }
    
    var topRatedImage = [UIImage]()
    var popularImage = [UIImage]()
    var airingImage = [UIImage]()
    // Mark: IBOutlets
   
    @IBOutlet weak var popularView: FSPagerView!{
        didSet {
            self.popularView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.popularView.tag = 1
        }
    }
    
   
    
    @IBOutlet weak var topRatedView: FSPagerView!{
        didSet {
            self.topRatedView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.topRatedView.tag = 2
        }
    }
    
    @IBOutlet weak var airingView: FSPagerView!{
        didSet {
            self.airingView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.airingView.tag = 3
        }
    }
    
    func getPopularTV(){
         let manager = TVSHowManager()
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
    
    //function toget top rated tv
    func getTopRated(){
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
    
    func getAiringToday(){
        
        let manager = TVSHowManager()
        manager.airingTodayTV{ (tvshow) in
            tvshow.forEach{
                do{
                    let data = try  Data(contentsOf: $0.imageURL!)
                    let image = UIImage(data: data)
                    self.airingImage.append(image!)
                }catch{
                    print("couldn't load image")
                }
            }
            
            self.airingTV = tvshow
        }
    
    }
    //download all popular tvshow detail on the background
//    func getPopularTVDetails(){
//         let manager = TVSHowManager()
//
//        self.popularTV.forEach{
//            manager.tvShowComplet(tvShow: $0, completionHandler: { (tvshow, seasons) in
//                var tv = tvshow
//                tv?.seasons = seasons!
//               // self.detailedPopularTV.append(tv!)
//            })
//        }
//    }
//
    //download all topRated tvshow detail
//    func getTopRatedTVDetails(){
//        let manager = TVSHowManager()
//        self.topRatedTV.forEach{
//            manager.tvShowComplet(tvShow: $0, completionHandler: { (tvshow, seasons) in
//                var tv = tvshow
//                tv?.seasons = seasons!
//                //self.detailedTopRatedTV.append(tv!)
//
//            })
//
//        }
//    }
    
//    //download all topRated tvshow detail
//    func getAiringTVDetails(){
//        let manager = TVSHowManager()
//        self.airingTV.forEach{
//            manager.tvShowComplet(tvShow: $0, completionHandler: { (tvshow, seasons) in
//                var tv = tvshow
//                tv?.seasons = seasons!
//               // self.detailedAiringTV.append(tv!)
//            })
//        }
//    }
//
   
    
    override func viewWillAppear(_ animated: Bool) {
       
        let dq = DispatchQueue(label: "yveslym", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        dq.async {
              self.getTopRated()
        }
        dq.async {
             self.getPopularTV()
        }
        dq.async {
            self.getAiringToday()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? TVShowDetailsTableViewController
        let pagerView = sender as! FSPagerView
        
        switch pagerView.tag {
        case 1:
            destination?.tvShow = self.popularTV[pagerView.currentIndex]
            destination?.posterImage = self.popularImage[pagerView.currentIndex]
        case 2:
            destination?.tvShow = self.topRatedTV[pagerView.currentIndex]
            destination?.posterImage = self.topRatedImage[pagerView.currentIndex]
        case 3:
            destination?.tvShow = self.airingTV[pagerView.currentIndex]
            destination?.posterImage = self.airingImage[pagerView.currentIndex]
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.airingView.dataSource = self
        self.airingView.delegate = self
        self.topRatedView.dataSource = self
        self.topRatedView.delegate = self
        self.popularView.dataSource = self
        self.popularView.delegate = self
       
        // configure popular view
        self.popularView.transformer = FSPagerViewTransformer(type: .overlap)
        popularView.itemSize = CGSize(width: 300, height: 300)
        popularView.isInfinite = true
        popularView.interitemSpacing = 10
        
        //configure topRated view
        self.topRatedView.transformer = FSPagerViewTransformer(type: .overlap)
        topRatedView.itemSize = CGSize(width: 200, height: 200)
        topRatedView.isInfinite = true
        topRatedView.interitemSpacing = 10
        
        //configure airing view
        self.airingView.transformer = FSPagerViewTransformer(type: .overlap)
        airingView.itemSize = CGSize(width: 200, height: 200)
        airingView.isInfinite = true
        airingView.interitemSpacing = 10
        
        
        
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
            return self.popularTV.count
        case 2:
            return self.topRatedTV.count
        case 3:
            return self.airingTV.count
        default:
            return 0
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        
        switch pagerView.tag{
        case 1:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cell.imageView?.image = self.popularImage[index]
            return cell
        case 2:
            let cells = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cells.imageView?.image = self.topRatedImage[index]
            return cells
        case 3:
            
            let cells = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cells.imageView?.image = self.airingImage[index]
            return cells
        default:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "popular", at: index)
            cell.imageView?.image = self.popularImage[index]
            return cell
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
         self.performSegue(withIdentifier: "tvshow", sender: pagerView)
        }
    }

    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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


