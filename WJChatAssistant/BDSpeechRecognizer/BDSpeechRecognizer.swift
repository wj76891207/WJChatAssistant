//
//  BDSpeechRecognizer.swift
//  BDSpeechRecognizer
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public class WJBDSpeechManager: NSObject, BDSClientASRDelegate {
    
    static let share = WJBDSpeechManager()
    
    lazy var asrEventManager: BDSEventManager? = {
        let manager = BDSEventManager.createEventManager(withName: BDS_ASR_NAME)
        manager?.setDelegate(self)
        return manager
    }()
    
    func setupBDSClient(withAppID appID: String, appKey: String, secretKey: String) {
        
        //配置API_KEY 和 SECRET_KEY 和 APP_ID
        asrEventManager?.setParameter([appKey, secretKey], forKey: BDS_ASR_API_SECRET_KEYS)
        asrEventManager?.setParameter(appID, forKey: BDS_ASR_OFFLINE_APP_CODE)
        
        //设置ModelVAD，提供较好的抗噪能力，不过速度较慢
        let modelVADFilePath = Bundle(identifier: "www.wxchina.com.XtionChatBot")?.path(forResource: "bds_easr_basic_model", ofType: "dat")
        asrEventManager?.setParameter(modelVADFilePath, forKey: BDS_ASR_MODEL_VAD_DAT_FILE)
        asrEventManager?.setParameter(true, forKey: BDS_ASR_ENABLE_MODEL_VAD)
    }
    
    public func voiceRecognitionClientWorkStatus(_ workStatus: Int32, obj aObj: Any!) {
        let status = TBDVoiceRecognitionClientWorkStatus(rawValue: UInt32(workStatus))
        switch status {
        case EVoiceRecognitionClientWorkStatusStartWorkIng:
            break
        case EVoiceRecognitionClientWorkStatusStart:                  // 检测到用户开始说话
            break
        case EVoiceRecognitionClientWorkStatusEnd:                    // 检测到用户结束说话，并等待识别结果返回并结束录音
            break
        case EVoiceRecognitionClientWorkStatusCancel:                 // 用户取消
            break
        case EVoiceRecognitionClientWorkStatusError:                  // 发生错误
            break
        case EVoiceRecognitionClientWorkStatusRecorderEnd:            // 录音结束
            break
            
        // 文字转换结果回调
        case EVoiceRecognitionClientWorkStatusNewRecordData:          // 录音数据回调
            break
        case EVoiceRecognitionClientWorkStatusMeterLevel:             // 当前音量回调
            break
        case EVoiceRecognitionClientWorkStatusFlushData:              // 获取到部分数据回调
            break
        case EVoiceRecognitionClientWorkStatusFinish:                 // 语音识别功能完成，服务器返回正确结果
            break
            
        // CHUNK状态
        case EVoiceRecognitionClientWorkStatusChunkThirdData:         // CHUNK: 识别结果中的第三方数据
            break
        case EVoiceRecognitionClientWorkStatusChunkNlu:               // CHUNK: 识别结果中的语义结果
            break
        case EVoiceRecognitionClientWorkStatusChunkEnd:               // CHUNK: 识别过程结束
            break
            
        default:
            break
        }
    }
}

extension WJBDSpeechManager {
    
}
