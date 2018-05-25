//
//  WJSpeechRecognizerProtocol.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public struct WJSpeechRecordData {
    
    public let data: Data
    public let peakPower: Float
    public let averagePower: Float
    
    init(withData data: Data) {
        self.data = data
        peakPower = 0
        averagePower = 0
    }
}

public protocol WJSpeechRecognizerProtocol {
    
    typealias resultArrivalBlock = (_ result: WJSpeechRecordData) -> Void
    
    func startListen(_ partialResultArrival: @escaping resultArrivalBlock,
                     _ finalResultArrival: @escaping resultArrivalBlock,
                     _ errorOccur: @escaping (Error) -> Void)
    
    func stopListen()
    
    func cancelListen()
}
