//
//  WJIntentRecognizerProtocol.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public struct WJIntent {
    
    public struct Intent {
        public let intent: String
        public let score: Double
        
        public init(intent: String, score: Double) {
            self.intent = intent
            self.score = score
        }
        
        public init?(json: [String: Any]) {
            guard let intent = json["intent"] as? String else { return nil }
            guard let score = json["score"] as? Double else { return nil }
            self.init(intent: intent, score: score)
        }
    }
    
    public let query: String
    
    public let topScoringIntent: Intent
    
    public let intents: [Intent]
    public init(query: String, topScoringIntent: Intent, intents: [Intent]) {
        self.query = query
        self.topScoringIntent = topScoringIntent
        self.intents = intents
    }
    
    public init?(json: [String: Any]) {
        guard let query = json["query"] as? String else { return nil }
        guard let topScoringIntentJSONDictionary = json["topScoringIntent"] as? [String: Any] else { return nil }
        guard let topScoringIntent = Intent(json: topScoringIntentJSONDictionary) else { return nil }
        guard let intentsJSONArray = json["intents"] as? [[String: Any]] else { return nil }
        
        let intents = intentsJSONArray.map({ Intent(json: $0) }).flatMap({ $0 })
        self.init(query: query, topScoringIntent: topScoringIntent, intents: intents)
    }
}

public protocol WJIntentRecognizerProtocol {
    
    func recognize(text: String, complation: @escaping (WJIntent?, NSError?) -> Void)
    
    func cancelAll()
}
