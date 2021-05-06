//
//  Service.swift
//  newsapp
//
//  Created by f4ni on 1.05.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService {
    static let instance = APIService()
    
    let headers: HTTPHeaders = [
        "Accept": "*/*",
        "User-Agent": "Mozilla/5.0"
    ]
    
    public func fetch<T: Codable> (_ method: HTTPMethod, url: String, requestModel: T?, model: T.Type, completion: @escaping (AFResult<Codable>) ->Void ){
        AF.request(url, method: method, parameters: APIService.toParameters(model: requestModel), encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String: AnyObject]):
                    do{
                        let responseJsonData = JSON(value)
                        let responseModel = try JSONDecoder().decode(model.self, from: responseJsonData.rawData())
                        completion(.success(responseModel))
                    }
                    catch let parsingError {
                        print("fetch success but: \(parsingError)")
                    }
             
                
                case .failure(let error):
                print("failure '\(url)': \(error)")
                completion(.failure(error))
                default:
                    fatalError("fatal error")
                }
            }
    }
    
    public func fetchNews(word q: String, page: Int, completion: @escaping(AFResult<Codable>) ->Void ){
        let ApiKey = "3b8121c77c934d6d861dab24c54657c8"
        let urlString = "https://newsapi.org/v2/everything?q=\(q)&page=\(page)&apiKey=\(ApiKey)"
        print(urlString)
        fetch(.get, url: urlString, requestModel: nil, model: NBundle.self) { (res) in
            completion(res)
        }
    }
    
    static func toParameters<T:Encodable>(model: T?) -> [String: AnyObject]? {
        if model == nil {
            return nil
        }
        
        let jsonData = modelToJson(model: model)
        let parameters = jsonToParameters(from: jsonData!)
        return parameters! as [String: AnyObject]
    }
    
    static func modelToJson<T:Encodable>(model: T)-> Data? {
        return try? JSONEncoder().encode(model.self)
    }
    
    static func jsonToParameters(from data: Data) ->[String: Any]? {
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}

class LocalService {
    
    static let instance = LocalService()
    
    func getFavoriteNews() -> [NewsViewModel]? {
        
        var obj: [NewsViewModel]?
        
        if let data = UserDefaults.standard.object(forKey: "readlist") as? [[String: Any]]{
            let responseJsonData = JSON(data)
            obj = try? JSONDecoder().decode([NewsViewModel].self, from: responseJsonData.rawData())
           
        }
        
        return obj
    }

    func removeNewsFromFavorites(news: NewsViewModel) {
        

        if let data = UserDefaults.standard.object(forKey: "readlist") {
            let responseJsonData = JSON(data)

            let obj = try? JSONDecoder().decode([NewsViewModel].self, from: responseJsonData.rawData())
            
            if nil != obj {
                var i = 0
                var tmp = [NewsViewModel]()
                for item in obj! {
                    if item.url != news.url  {
                        tmp.append(item)
                    }
                    i += 1;
                }
                self.updateFavoriteList(news: tmp)
            }
        }
        
        
    }
    
    func addNewstoFavorites(news: NewsViewModel) {
        var rlist = [[String: Any]]()
        if let data = UserDefaults.standard.object(forKey: "readlist") as? [[String: Any]] {
            rlist = data
        }
        let dict = try! news.asDictionary()
        
        var inarray = false

        for item in rlist {
            if item["url"] as? String ==  news.url?.absoluteString {
                inarray = true
            }
        }
        if !inarray {
            rlist.append(dict)
            UserDefaults.standard.set(rlist, forKey: "readlist");
        }
    }
    
    func updateFavoriteList(news: [NewsViewModel]) {
     
        let dict = try? news.asDictionary()
        UserDefaults.standard.set(dict, forKey: "readlist");
    }
}
