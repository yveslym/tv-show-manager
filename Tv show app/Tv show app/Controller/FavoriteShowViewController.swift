//
//  FavoriteShowViewController.swift
//  Tv show app
//
//  Created by Yveslym on 2/16/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import KeychainSwift

class FavoriteShowViewController: UIViewController {
    
    weak var delegate: TVShowDelegate!
    private let refreshControl = UIRefreshControl()

    // - MARK: IBOUTLET
    
    @IBOutlet weak var previewPage: UIView!
    @IBOutlet weak var tableView: UITableView!
    // - MARK: PROPERTIES
     let defaults = UserDefaults(suiteName: "group.sharedTvID")
   
    
    var tvShow = [TVSHow]()
    var tvShowImage:[UIImage] = []
    
    @objc private func refresfavoriteTV(_ sender: Any) {
        // Fetch Weather Data
        
        self.tvShowImage = []
        self.tvShow = []
        
        self.getfavoriteTV {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                 self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refresfavoriteTV(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
       // refreshControl.attributedTitle = NSAttributedString(string: "Reload TV Show ...", attributes: attribute_set)


       tableView.dataSource = self
        tableView.delegate = self
        delegate = self
        
        
       
    }
    
    

    override func viewDidDisappear(_ animated: Bool) {
        ViewControllerUtils().hideActivityIndicator(uiView: self.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         let keychain = KeychainSwift()
        DispatchQueue.main.async {
            keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
            guard let email = keychain.get("email") else {return}
            
            let favoriteTVID = self.defaults?.array(forKey:email)  as? [Int] ?? [Int]()
            if favoriteTVID.count > 0 {
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
                }
            }
            else{
                self.previewPage.frame = self.view.frame
                self.previewPage.tag = 100
                self.view.addSubview(self.previewPage)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let keychain = KeychainSwift()
        
        let movie = CoreDataStack.instance.fetchRecordsForEntity(.FavoriteTV, inManagedObjectContext: CoreDataStack.instance.viewContext) as! [FavoriteTV]
        print(movie)
        
        keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
        guard let email = keychain.get("email") else {return}
        
        let favoriteTVID = defaults?.array(forKey:email)  as? [Int] ?? [Int]()
       
        if favoriteTVID.count > 0 {
            
            ViewControllerUtils().showActivityIndicator(uiView: view)
            
            DispatchQueue.main.async {
                if let viewWithTag = self.view.viewWithTag(100) {
                    viewWithTag.removeFromSuperview()
                }
                
            }
        
        self.getfavoriteTV {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                }
            }
        }
        
    }
    
    /// Method to get favorite tv
    func getfavoriteTV( completion: @escaping()->()){
        let keychain = KeychainSwift()
        keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
        
        guard let email = keychain.get("email") else {return}
         let defaults = UserDefaults(suiteName: "group.sharedTvID")
        
        let favoriteTVID = defaults?.array(forKey:email)  as? [Int] ?? [Int]()
        
        if !favoriteTVID.isEmpty{
            self.tvShow = []
            self.tvShowImage = []
            let manager = TVSHowManager()
            let dg = DispatchGroup()
            DispatchQueue.global().async {
            favoriteTVID.forEach{
                
                
                dg.enter()
                manager.tvShowComplet(tvShowId: $0, completionHandler: { (tv, seasons) in
                   
                    var tvshow = tv
                    tvshow?.seasons = seasons
                    self.tvShow.append(tvshow!)
                    do{
                        if tvshow?.imageURL != nil{
                            let data = try Data(contentsOf: (tvshow?.imageURL)!)
                            let image = UIImage(data: data)
                            self.tvShowImage.append(image!)
                        }
                        else{
                            let image = UIImage(named:"search")
                            self.tvShowImage.append(image!)
                        }
                    }catch{
                        let image = UIImage(named: "search")
                        self.tvShowImage.append(image!)
                    }
                    dg.leave()
                })
                dg.notify(queue: DispatchQueue.main, execute: {
                    
                    completion()
                    
                })
            }
        }
        }
        else{
            ViewControllerUtils().hideActivityIndicator(uiView: self.view)
        }
    }
    func fetchfavoriteTV(){
        self.getfavoriteTV {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension FavoriteShowViewController: UITableViewDelegate, UITableViewDataSource, TVShowDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShow.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! favoriteTVTableViewCell
        cell.tvPoster.roundCornersForAspectFit(radius: 5.0)
        let tv = tvShow[indexPath.row]
        cell.tvName.text = tv.name
       
        cell.tvRunTime.text = String("\(tv.runTime?.first! ?? 0) min")
        
        cell.tvPopularity.text = String("Vote:  \( tv.voteAverage?.rounded() ?? 0.0)")

        cell.tvPoster.image = self.tvShowImage[indexPath.row]
        
        let manager = TVSHowManager()
        let episode = manager.nextEpisode(tv.seasons!, lastAiringDate: (tv.lastAirDate)!)
        
        
        let day : Int?
        //let day = Date.dayLeft(day: (episode?.airedDate?.toDate())!).day
        (episode != nil) ? (day = Date.dayLeft(day: (episode?.airedDate?.toDate())!).day) : (day = -1)
        let serieStatus = tv.status?.components(separatedBy: " ").first
        if serieStatus == "Returning"{
            cell.tvStatus.text = serieStatus ?? ""}
           
        else{
            cell.tvStatus.text = serieStatus ?? ""
            cell.tvStatus.textColor = UIColor.red
        }
        
        
        let currentSeason = (episode != nil) ? (tv.seasons![(episode?.seasonNumber)! - 1] ) : (tv.seasons?.last)
        
        cell.seasonName.text = currentSeason?.name
//        if (lastEpisode?.first?.overview != "") { astEpisode?.first?.overview ! " There's no description for this episode yet" //lastEpisode?.first?.overview ?? " There's no description for this episode yet"
        
        
        if episode != nil{
            if (episode?.overview?.isEmpty)!{cell.episodeDescription.text = tv.overview}
            else{cell.episodeDescription.text = episode?.overview}
                
             cell.episodeName.text = episode?.name
        }
        else{
             cell.episodeName.text = tv.seasons?.last?.episodes?.last?.name
            cell.episodeDescription.text = tv.overview
        }
        
        
       
        
        
        if day! > 0{
            cell.tvAiringTimeLeft.text = String("\(day ?? 0) days")
        }
        else if day! == 0{
              cell.tvAiringTimeLeft.text = "Today"
            cell.tvAiringTimeLeft.textColor = UIColor.blue
        }
        else if day! == 1{
            cell.tvAiringTimeLeft.text = "Tomorow"
            //add bagde color as well
             cell.tvAiringTimeLeft.textColor = UIColor.cyan
        }
        else{
             cell.tvAiringTimeLeft.text = " Not published"
             cell.tvAiringTimeLeft.textColor = UIColor.brown
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        ViewControllerUtils().showActivityIndicator(uiView: self.view)
        self.delegate.TVShowDetailViewController(tvShow: self.tvShow[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tvshow"{
            let destination = segue.destination as! TVShowDetailsTableViewController
            let tvshowTVC = sender as! TVShowDetailsTableViewController
            destination.tvShow = tvshowTVC.tvShow
            destination.posterImage = tvshowTVC.posterImage
            destination.coverImage = tvshowTVC.coverImage
            destination.seasonImage = tvshowTVC.seasonImage
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let keychain = KeychainSwift()
            keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
            
            guard let email = keychain.get("email") else {return}
            var favoriteTV = defaults?.array(forKey:email)  as? [Int] ?? [Int]()
            
            if let index = favoriteTV.index(of: self.tvShow[indexPath.row].id!) {
                favoriteTV.remove(at: index)
                self.defaults?.set(favoriteTV, forKey: email)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
       
    }
    
}















