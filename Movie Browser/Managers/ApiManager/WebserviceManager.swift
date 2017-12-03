//
//  WebserviceManager.swift
//  WebserviceManager
//
//  Created by Mohseen Shaikh on 24/07/17.
//  Copyright © 2017 Reliance Jio Infocomm Limited. All rights reserved.
//

import UIKit

typealias dictionaryObject = [String: Any]

enum WebserviceHTTPMethod: String {
    case GET  =   "GET"
    case POST =   "POST"
}

enum HTTPHeaderKey: String {
    case HTTPHeaderKeyAccept                = "Accept"
    case HTTPHeaderKeyContenttype           = "Content-Type"
}


enum HTTPHeaderValue: String {
    case HTTPHeaderContentApplicationJSON               = "application/json"
    case HTTPHeaderContentApplicationFormURLEncoded     = "application/x-www-form-urlencoded"
}

struct WebserviceParameter {
    var url: String!
    var httpMethod : WebserviceHTTPMethod
    var body : dictionaryObject
    var headers : dictionaryObject

    init(httpMethod :WebserviceHTTPMethod) {
        self.httpMethod = httpMethod
        self.body = dictionaryObject()
        self.headers = dictionaryObject()
    }
}

//MARK:- Base Path urls
fileprivate let API_BASE_URL        = "https://api.themoviedb.org/3/"
fileprivate let IMAGE_BASE_URL      = "https://image.tmdb.org/t/p/w500/"

//MARK:- WebserviceManager
class WebserviceManager: NSObject {
    static let sharedInstance = WebserviceManager()
    
  func fetchDataFromServer(parameter: WebserviceParameter, completionHandler: @escaping (Data?, Error?)->Void)
    {
        let request = RequestManager.sharedInstance.createRequest(parameter: parameter)
        SessionManager.sharedInstance.processRequest(request: request) { (data, error) in
            completionHandler(data,error)
        }
    }
    
    
    //MARK:- Helper Methods
    func getPosterUrl(path : String) -> URL {
        return URL.init(string: "\(IMAGE_BASE_URL)\(path)")!
    }
    
    func getSearchMovieUrl() -> String {
        return "\(API_BASE_URL)search/movie"
    }
    
    func getMostPopularUrl() -> String
    {
        return "\(API_BASE_URL)movie/popular"
    }
    
    
}
