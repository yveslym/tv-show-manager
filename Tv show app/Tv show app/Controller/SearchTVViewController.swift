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
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchbar.delegate = self
        self.hideKeyboardWhenTappedAround()
        delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = self.searchbar.text else {return}
        
        
        
        NetworkAdapter.request(target: .findTvShow(query: searchText, language: .english), success: { (response) in
            let tvshow = try! response.map(to: [TVSHow].self, keyPath: "results")
            
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
            
            DispatchQueue.main.async {
                self.tvShow = tvshow
                self.collectionView.reloadData()
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
        cell.poster.dropShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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















