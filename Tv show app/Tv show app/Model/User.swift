//
//  User.swift
//  Tv show app
//
//  Created by Yveslym on 3/30/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation

struct User: Decodable{
    
    static var currentUser  = User()
    
    var userName: String?
    var email: String?
    var password: String?
    var name: String?
    var token: String?
}
