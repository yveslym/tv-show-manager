//
//  favoriteTVTableViewCell.swift
//  Tv show app
//
//  Created by Yveslym on 2/18/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit

class favoriteTVTableViewCell: UITableViewCell {

    // - MARK: IBOUTLET
    

   // @IBOutlet weak var tvBackground: UIImageView!
    @IBOutlet weak var tvName: UILabel!
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var episodeDescription: UILabel!
   // @IBOutlet weak var tvNetwork: UILabel!
   // @IBOutlet weak var tvAiringDate: UILabel!
    @IBOutlet weak var tvPopularity: UILabel!
    @IBOutlet weak var tvPoster: UIImageView!
    @IBOutlet weak var tvRunTime: UILabel!
    @IBOutlet weak var tvAiringTimeLeft: UILabel!
     @IBOutlet weak var seasonName: UILabel!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    @IBOutlet weak var tvStatus: UILabel!
    //- MARK: IBACTION
    
    @IBAction func tvTrailer(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //tvPoster.roundCornersForAspectFit(radius: 10.0)
        //tvPoster.roundCornersForAspectFit2(radius: 5.0)
        spinner.frame = CGRect(x: 70.0, y: 6.0, width: 80.0, height: 80.0)
        spinner.center = CGPoint(x:  self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(spinner)
        spinner.startAnimating()
        spinner.alpha = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.isSelected{
        spinner.alpha = 1.0
        }
        else{
            spinner.alpha = 0.0
        }
        // Configure the view for the selected state
    }

}
