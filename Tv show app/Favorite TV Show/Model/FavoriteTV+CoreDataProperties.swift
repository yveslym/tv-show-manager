//
//  FavoriteTV+CoreDataProperties.swift
//  Tv show app
//
//  Created by Yveslym on 5/31/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteTV {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTV> {
        return NSFetchRequest<FavoriteTV>(entityName: "FavoriteTV")
    }

    @NSManaged public var tvShowName: String?
    @NSManaged public var tvShowID: String?
    @NSManaged public var tvShowOverview: String?
    @NSManaged public var tvShowPosterLink: URL?
    @NSManaged public var tvShowLastAiringDate: String?
    @NSManaged public var seasonNumber: Int16
    @NSManaged public var seasonName: String?
    @NSManaged public var episodeName: String?
    @NSManaged public var episodeNumber: Int16
    @NSManaged public var episodePosterLink: URL?
    @NSManaged public var dayLeft: Int16

}
extension FavoriteTV{
    convenience init(context: NSManagedObjectContext,tvshow: TVSHow, airingEpisode: Episodes) {
        let context = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteTV", in: context) else { fatalError() }
        
         self.init(entity: entity, insertInto: context)
        
    
        self.tvShowID = String(tvshow.id!)
        self.tvShowName = tvshow.name
        self.tvShowOverview = tvshow.overview
        self.tvShowPosterLink = tvshow.imageURL
        self.tvShowLastAiringDate = tvshow.lastAirDate
        self.episodeNumber = Int16(airingEpisode.episodeNumber!)
        self.episodeName = airingEpisode.name
        self.tvShowPosterLink = tvshow.imageURL
        self.episodePosterLink =  airingEpisode.imageURL
        self.seasonName = tvshow.seasons?[airingEpisode.seasonNumber! - 1].name
        self.seasonNumber = Int16(airingEpisode.seasonNumber!)
        
    }
}















