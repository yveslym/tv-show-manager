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
import KeychainSwift

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
    @NSManaged public var isAiring: Bool
     @NSManaged public var email: String
    
}
extension FavoriteTV{
    convenience init(context: NSManagedObjectContext,tvshow: TVSHow) {
        let context = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: Entity.FavoriteTV.rawValue, in: context) else { fatalError() }
        
         self.init(entity: entity, insertInto: context)
    
        let manager = TVSHowManager()
        let airingEpisode = manager.nextEpisode(tvshow.seasons!, lastAiringDate: tvshow.lastAirDate!)
        self.tvShowID = String(tvshow.id!)
        self.tvShowName = tvshow.name
        self.tvShowOverview = tvshow.overview
        self.tvShowPosterLink = tvshow.imageURL
        self.tvShowLastAiringDate = tvshow.lastAirDate
        self.episodeNumber = Int16(airingEpisode?.episodeNumber! ?? 0)
        self.episodeName = airingEpisode?.name
        self.tvShowPosterLink = tvshow.imageURL
        self.episodePosterLink =  airingEpisode?.imageURL
        self.seasonName = tvshow.seasons?.filter{return $0.seasonNumber == airingEpisode?.seasonNumber}.first?.name
        self.seasonNumber = Int16(airingEpisode?.seasonNumber! ?? 0)
        let numberOfDay =  Date.dayLeft(day: (airingEpisode?.airedDate?.toDate())!).day
        self.dayLeft = Int16(numberOfDay!)
        self.isAiring = (dayLeft >= 0)
        let keychain = KeychainSwift()
       keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
        email = keychain.get("email")! 
        
    }
}















