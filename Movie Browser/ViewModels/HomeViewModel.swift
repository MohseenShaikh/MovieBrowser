//
//  HomeViewModel.swift
//  Movie Browser
//
//  Created by Mohseen Shaikh on 01/12/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

import Foundation

class HomeViewModel
{
    var movieCollection  : [Movie] = []
    {
        didSet {
            if let reload = self.reloadCollectionData {
                reload()
            }
        }
    }
    
    var reloadCollectionData : (() -> Void)? = nil
    
    var pageNo = 0
    var pageTotal = 0
    
    func fetchMostPopularMovies()
    {
        if pageTotal >= pageNo
        {
            pageNo = pageNo.advanced(by: 1)
            
            var param = WebserviceParameter.init(httpMethod: .GET)
            param.url = WebserviceManager.sharedInstance.getMostPopularUrl()
            param.body = ["api_key":"9755d2892a841d7bd030227d452f6f5e",
                          "language":"en-US",
                          "page":"\(pageNo)"]
            
            WebserviceManager.sharedInstance.fetchDataFromServer(parameter: param) { (data, error) in
                if(error != nil)
                {
                    print(error.debugDescription)
                    return
                }
                
                let decoder = JSONDecoder.init()
                do
                {
                    let responseObject = try decoder.decode(ServiceResponseVO.self, from: data!)
                    self.pageTotal = responseObject.total_pages
                    self.movieCollection.append(contentsOf: responseObject.results)
                }
                catch(let error1)
                {
                    print(error1.localizedDescription)
                }
            }
        }
    }
    
    func callServiceForKeyword(keyword : String)
    {
        if (pageTotal >= pageNo)
        {
            pageNo = pageNo.advanced(by: 1)
            var param = WebserviceParameter.init(httpMethod: .GET)
            param.url = WebserviceManager.sharedInstance.getSearchMovieUrl()
            param.body = ["api_key":"9755d2892a841d7bd030227d452f6f5e",
                          "language":"en-US",
                          "query":"\(keyword)",
                          "page":"\(pageNo)"]
            WebserviceManager.sharedInstance.fetchDataFromServer(parameter: param) { (data, error) in
                if(error != nil)
                {
                    print(error.debugDescription)
                    return
                }
                
                let decoder = JSONDecoder.init()
                do
                {
                    let responseObject = try decoder.decode(ServiceResponseVO.self, from: data!)
                    self.pageTotal = responseObject.total_pages
                    self.movieCollection.append(contentsOf: responseObject.results)
                }
                catch(let error1)
                {
                    print(error1.localizedDescription)
                }
            }
        }
    }
    
    //MARK:- Helper Methods
    func resetCounters()
    {
        pageNo      = 0
        pageTotal   = 0
        self.movieCollection = []
    }
    
    
    //MARK:- Sorting Methods
    func sortByMostPopular()  {
        
        let sortedArray = movieCollection.sorted { (movie1, movie2) -> Bool in
            return movie1.popularity > movie2.popularity
        }
        self.movieCollection = sortedArray
    }
    
    func sortByMostRated()  {
        
        let sortedArray = movieCollection.sorted { (movie1, movie2) -> Bool in
            return movie1.vote_average > movie2.vote_average
        }
        self.movieCollection = sortedArray
    }
    
}
