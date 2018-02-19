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
    
    @IBOutlet weak var tvName: UILabel!
    @IBOutlet weak var tvNetwork: UILabel!
    @IBOutlet weak var tvAiringDate: UILabel!
    @IBOutlet weak var tvPopularity: UILabel!
    @IBOutlet weak var tvPoster: UIImageView!
    @IBOutlet weak var tvRunTime: UILabel!
    @IBOutlet weak var tvAiringTimeLeft: UILabel!
    
    @IBOutlet weak var tvStatus: UILabel!
    //- MARK: IBACTION
    
    @IBAction func tvTrailer(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.frame = CGRect(x: 20.0, y: 6.0, width: 40.0, height: 40.0)
        spinner.center = CGPoint(x:  self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(spinner)
        if self.isSelected{
            spinner.startAnimating()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}
