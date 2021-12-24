//
//  RestConnection.swift
//  WeatherApp
//
//  Created by Mithun on 08/04/20.
//  Copyright © 2020 Mithun. All rights reserved.
//
import UIKit

class RestConnection: NSObject {
    static let connectionManger = RestConnection()
    
    
    func  restConnection(url: String, successBlock onSuccess: @escaping(([String: Any]?)-> Void), failureBlock onFailure: @escaping((String)->Void)){
        let url = URL.init(string: url)
        var request = URLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let dataFromAPI = data else{return}
            do {
                let json = try JSONSerialization.jsonObject(with: dataFromAPI, options: [])
                onSuccess(json as? [String : Any])
            } catch {
                print(error)
                onFailure(error.localizedDescription)
            }
        }.resume()
    }
}
