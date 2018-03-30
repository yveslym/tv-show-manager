//
//  FavoriteShowViewController.swift
//  Tv show app
//
//  Created by Yveslym on 2/16/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit

class FavoriteShowViewController: UIViewController {
    
    weak var delegate: TVShowDelegate!
    private let refreshControl = UIRefreshControl()

    // - MARK: IBOUTLET
    
    @IBOutlet weak var tableView: UITableView!
    // - MARK: PROPERTIES
     let defaults = UserDefaults.standard
   
    
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
    override func viewDidAppear(_ animated: Bool) {
        self.getfavoriteTV {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    /// Method to get favorite tv
    func getfavoriteTV( completion: @escaping()->()){
        let favoriteTVID = UserDefaults.standard.array(forKey: "favoriteID")  as? [Int] ?? [Int]()
        
        if !favoriteTVID.isEmpty{
            self.tvShow = []
            self.tvShowImage = []
            let manager = TVSHowManager()
            let dg = DispatchGroup()
           // let dq = DispatchQueue(label: "yveslym", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
            
          //  DispatchQueue.global().async {
                
            
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
        //cell.tvPopularity.text = String(describing: tv.popularity!)
        cell.tvRunTime.text = String("\(tv.runTime?.first! ?? 0) min")
        cell.tvPopularity.text = String("Vote:  \( tv.voteAverage?.rounded() ?? 0.0)")
//        cell.tvAiringDate.text = tv.lastAirDate
        cell.tvPoster.image = self.tvShowImage[indexPath.row]
        let day = Date.dayLeft(day: (tv.lastAirDate?.toDate())!).day
        cell.tvStatus.text = tv.status?.components(separatedBy: " ").first
        
        let lastEpisode = tv.seasons?.last?.episodes?.filter{$0.airedDate == tv.lastAirDate}
        let currentSeasonNumber = lastEpisode?.first?.seasonNumber
        let currentSeason = tv.seasons?.filter{$0.seasonNumber == currentSeasonNumber}.first
        
        cell.seasonName.text = currentSeason?.name
        cell.episodeDescription.text = lastEpisode?.first?.overview
        cell.episodeName.text = lastEpisode?.first?.name
        
        
        if day! > 0{
            cell.tvAiringTimeLeft.text = String("\(day ?? 0) days")
        }
        else if day! == 0{
              cell.tvAiringTimeLeft.text = "Today"
        }
        else if day! == 1{
            cell.tvAiringTimeLeft.text = "Tomorow"
            //add bagde color as well
        }
        else{
             cell.tvAiringTimeLeft.text = " Not published"
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
    
}

















