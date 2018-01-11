//
//  NetworkAdapter.swift
//  Tv show app
//
//  Created by Yveslym on 1/11/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import Moya

struct NetworkAdapter{
    static let provider = MoyaProvider<TvShowApi>()
    
    static func request (target: TvShowApi, success successCallBack: @escaping(Response) -> Void, error errorCallBack: @escaping(Swift.Error)-> Void, failure falilureCallBack: @escaping(MoyaError)-> Void){
        provider.request(target){(result) in
            switch result{
                
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300{
                    successCallBack(response)
                }
                else{
                    fatalError("code error not api")
                }
            case .failure(let error):
                errorCallBack(error)
            }
        }
    }
}


