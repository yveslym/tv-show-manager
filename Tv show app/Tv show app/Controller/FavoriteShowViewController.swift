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
    
    // - MARK: IBOUTLET
    
    @IBOutlet weak var tableView: UITableView!
    // - MARK: PROPERTIES
    
    let defaults = UserDefaults.standard
    var favoriteTVID = UserDefaults.standard.array(forKey: "favoriteID")  as? [Int] ?? [Int]()
    
    var tvShow: [TVSHow] = []
    var tvShowImage:[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.dataSource = self
        tableView.delegate = self
        delegate = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if !favoriteTVID.isEmpty{
            let manager = TVSHowManager()
            let dg = DispatchGroup()
            
            favoriteTVID.forEach{
                dg.enter()
                manager.tvShowDetails(id: $0, completionHandler: { (tvshow) in
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
                dg.notify(queue: .main, execute: {
                    self.tableView.reloadData()
                })
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
        
        let tv = tvShow[indexPath.row]
        cell.tvName.text = tv.name
        //cell.tvPopularity.text = String(describing: tv.popularity!)
        cell.tvNetwork.text =  tv.network ?? (tv.genres?.first?.name)!
        cell.tvRunTime.text = String("\(tv.runTime?.first! ?? 0) min")
        cell.tvPopularity.text = String("Vote:  \( tv.voteAverage?.rounded() ?? 0.0)")
        cell.tvAiringDate.text = tv.lastAirDate
        cell.tvPoster.image = self.tvShowImage[indexPath.row]
        let day = Date.dayLeft(day: (tv.lastAirDate?.toDate())!).day
        cell.tvStatus.text = tv.status
        if day! > 0{
            cell.tvAiringTimeLeft.text = String("\(day ?? 0) days")
        }
        else if day! == 0{
              cell.tvAiringTimeLeft.text = " Airing Today"
        }
        else{
             cell.tvAiringTimeLeft.text = " Not published"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        self.delegate.TVShowDetailViewController(tvShow: self.tvShow[indexPath.row])
    }
    
}

















