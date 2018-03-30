//
//  SearchTVViewController.swift
//  Tv show app
//
//  Created by Yveslym on 2/18/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit

class SearchTVViewController: UIViewController, UISearchBarDelegate {
    
    var tvShow: [TVSHow] = []
    var tvShowImage: [UIImage] = []
    weak var delegate: TVShowDelegate!
    var cell : SearchCollectionViewCell!
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchbar.delegate = self
        self.hideKeyboardWhenTappedAround()
        delegate = self
        cell = SearchCollectionViewCell()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ViewControllerUtils().hideActivityIndicator(uiView: self.view)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        ViewControllerUtils().showActivityIndicator(uiView: self.view)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tvShow = []
        self.tvShowImage = []
        DispatchQueue.main.async {
             self.collectionView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = self.searchbar.text else {return}
        
        
        
        NetworkAdapter.request(target: .findTvShow(query: searchText, language: .english), success: { (response) in
            do{
            let tvshow = try response.map(to: [TVSHow].self, keyPath: "results")
            self.tvShow = tvshow
            tvshow.forEach{
                do{
                    if $0.imageURL != nil{
                        let data = try  Data(contentsOf: $0.imageURL!)
                        let image = UIImage(data: data)
                        self.tvShowImage.append(image!)
                    }else{
                        let image = UIImage(named:"search")
                        self.tvShowImage.append(image!)
                    }
                }catch{
                    print("couldn't load image")
                    let image = UIImage(named:"search")
                    self.tvShowImage.append(image!)
                }
            }
            }
            catch{
                
            }
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
            }
            
        }, error: { (error) in
            
        }, failure: { (error) in
            
        })
    }
}

extension SearchTVViewController: UICollectionViewDelegate, UICollectionViewDataSource, TVShowDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        
        cell.poster.image = self.tvShowImage[indexPath.row]
        cell.poster.roundCornersForAspectFit(radius: 5.0)
        cell.tvOverview.text = self.tvShow[indexPath.row].overview
        cell.tvAiringDate.text =  self.tvShow[indexPath.row].firstAirDate
        cell.tvShowName.text =  self.tvShow[indexPath.row].name
        let vote =  self.tvShow[indexPath.row].voteAverage?.rounded()
        cell.tvRated.text = "\(vote ?? 0)"
        self.cell = cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        DispatchQueue.main.async {
             ViewControllerUtils().showActivityIndicator(uiView: self.view)
        }
       
        self.delegate.TVShowDetailViewController(tvShow: tvShow[indexPath.row])
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















