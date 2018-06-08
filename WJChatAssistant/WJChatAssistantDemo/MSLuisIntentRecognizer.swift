//
//  MSLuisIntentRecognizer.swift
//  WJChatAssistantDemo
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import WJChatAssistant

class MSLuisIntentRecognizer: WJIntentRecognizerProtocol {

    static let share = MSLuisIntentRecognizer()
    
    
    func cancelAll() {
        
    }
    
    
    // FIXME: Use swift error handling
    func recognize(text: String, complation: @escaping (WJIntent?, NSError?) -> Void) {
        let appID = ""
        let rootURL = "https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/\(appID)"

        var urlComponent = URLComponents(string: rootURL)
        urlComponent?.queryItems = [
            URLQueryItem(name: "subscription-key", value: ""),
            URLQueryItem(name: "entities", value: "true"),
            URLQueryItem(name: "timezoneOffset", value: "0"),
            URLQueryItem(name: "verbose", value: "true"),
            URLQueryItem(name: "q", value: text),
        ]
        guard let url = urlComponent?.url else {
            return
        }

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {
            (data, response, error) in
            
            guard error == nil else {
                complation(nil, NSError(domain: "Request task fail", code: 0, userInfo: nil))
                return
            }
            
            guard let responseData = data else {
                complation(nil, NSError(domain: "No response data", code: 0, userInfo: nil))
                return
            }
            
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: AnyObject] else {
                    complation(nil, NSError(domain: "Invalid response data", code: 0, userInfo: nil))
                    return
                }
                
                print("data is: \(jsonData)")
                complation(WJIntent.init(json: jsonData), nil)
            } catch {
                complation(nil, NSError(domain: "Invalid response data", code: 0, userInfo: nil))
                return
            }
        }
        
        task.resume()
    }
}
