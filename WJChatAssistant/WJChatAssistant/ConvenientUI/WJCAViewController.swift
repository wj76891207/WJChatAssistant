//
//  WJCAViewController.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

open class WJCAViewController: UIViewController {
    
    public let chatAssistant = WJChatAssistant.default
    public weak var delegate: WJCAViewControllerDelegate? = nil
    public weak var datasource: WJCAViewControllerDatasource? = nil
    
    private var messages: [WJCADialogMessage] = [
//    {
//        var msg = WJCADialogMessage()
//        msg.content = "Hi，小璇"
//        msg.speaker = .user
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.content = "我在呢，有什么事吗？"
//        msg.speaker = .bot
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.content = "没什么事儿，就是想找你闲聊一下，你现在有时间么？"
//        msg.speaker = .user
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.content = ""
//        msg.speaker = .bot
//        msg.status = .processing
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.contentType = .image
//        msg.content = #imageLiteral(resourceName: "test_img1")
//        msg.speaker = .bot
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.contentType = .image
//        msg.content = #imageLiteral(resourceName: "test_img2")
//        msg.speaker = .user
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.contentType = .options
//        msg.content = {
//            var content = WJCADialogOptionMessageContent()
//            content.title = "我可以这样做么"
//            content.options = ["是", "否"]
//            return content
//        }()
//        msg.speaker = .bot
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.contentType = .optionsList
//        msg.content = {
//            var content = WJCADialogOptionMessageContent()
//            content.title = "我找到了以下选项"
//            content.options = ["我比较短", "我是一个很长很长很长很长很长很长很长很长很长的按钮", "短", "一般般吧", "又是一个比较长的按钮噢噢噢噢", "uuuuu", "222222"]
//            return content
//        }()
//        msg.speaker = .bot
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.content = ""
//        msg.speaker = .bot
//        msg.status = .processing
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.contentType = .optionsList
//        msg.content = {
//            var content = WJCADialogOptionMessageContent()
//            content.title = "我找到了以下选项"
//            content.options = ["我比较短", "我是一个很长很长很长很长很长很长很长很长很长的按钮", "短", "一般般吧", "又是一个比较长的按钮噢噢噢噢", "uuuuu", "222222"]
//            return content
//        }()
//        msg.speaker = .bot
//        return msg
//        }(),
//    {
//        var msg = WJCADialogMessage()
//        msg.contentType = .optionsList
//        msg.content = {
//            var content = WJCADialogOptionMessageContent()
//            content.title = "我找到了以下选项"
//            content.options = ["我比较短", "uuuuu", "222222"]
//            return content
//        }()
//        msg.speaker = .user
//        return msg
//        }()
    ]
    
    private lazy var dialogView: WJCADialogView = {
        let dialogView = WJCADialogView(frame: .zero)
        dialogView.delegate = self
        dialogView.dataSource = self
        return dialogView
    }()
    
    private lazy var funtionBar: WJCAFunctionBar = {
        let bar = WJCAFunctionBar.init(frame: .zero)
        
        bar.delegate = self
        bar.datasource = self
        return bar
    }()
    
    private var speechRecognitionResult: WJSpeechRecognitionResult? = nil
    
    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        chatAssistant.delegate = self
        view.backgroundColor = .white
        
        view.addSubview(dialogView)
        view.addSubview(funtionBar)
        
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        funtionBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: dialogView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: dialogView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: dialogView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: dialogView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        let constraintTarget: Any
        if #available(iOS 11.0, *) {
            constraintTarget = view.safeAreaLayoutGuide
        }
        else {
            constraintTarget = view
        }
        view.addConstraint(NSLayoutConstraint(item: funtionBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: funtionBar, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: funtionBar, attribute: .top, relatedBy: .equal, toItem: constraintTarget, attribute: .bottom, multiplier: 1.0, constant: -funtionBar.suggestHeight))
        view.addConstraint(NSLayoutConstraint(item: funtionBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        var contentInset = UIEdgeInsets(top: 0, left: 0, bottom: funtionBar.suggestHeight, right: 0)
        if #available(iOS 11.0, *) {
            contentInset.bottom += view.safeAreaInsets.bottom
        }
        dialogView.contentInset = contentInset
    }
}

// MARK: - WJChatAssistantDelegate
extension WJCAViewController: WJChatAssistantDelegate {
    
    public func wjChatAssistantSpeechRecognizeComplate(_ isSuceessful: Bool, _ error: NSError?) {
        funtionBar.stopRecording()
        
        if let speechRecognitionResult = speechRecognitionResult, isSuceessful {
            var msg = WJCADialogMessage()
            msg.content = speechRecognitionResult.bestTranscription
            msg.speaker = .user
            messages.append(msg)
            
            dialogView.appendMsg()
            
            
            var msg1 = WJCADialogMessage()
            msg1.content = WJCADialogOptionMessageContent()
            msg1.speaker = .bot
            msg1.contentType = .optionsList
            msg1.status = .processing
            messages.append(msg1)
            dialogView.appendMsg()
            
            chatAssistant.intentRecognizer?.recognize(text: speechRecognitionResult.bestTranscription) {
                (intent, error) in
                guard let intent = intent else { return }
                
                let index = self.messages.count-1
                let isIntentClear = intent.topScoringIntent.score >= 0.85
                var msg = WJCADialogMessage()
                msg.speaker = self.messages[index].speaker
                if isIntentClear {
                    msg.contentType = .options
                    msg.content = WJCADialogOptionMessageContent(title: "👌，没问题。", options: [intent.topScoringIntent.intent])
                }
                else {
                    msg.contentType = .optionsList
                    let top5 = Array(intent.intents.prefix(5))
                    msg.content = WJCADialogOptionMessageContent(title: "你是想：", options: top5.map({ (intent) -> String in
                        return intent.intent
                    }))
                }
                self.messages[index] = msg
                
                DispatchQueue.main.async {
                self.dialogView.updateMsg(at: index)
                }
            }
        }
    }
    
    public func wjChatAssistantUpdateVoicePower(_ averagePower: Float?, peakPower: Float?) {
        funtionBar.recordingController.updateVoicePower(peakPower)
    }
    
    public func wjChatAssistantUpdateSpeechRecognizeResult(_ result: WJSpeechRecognitionResult) {
        funtionBar.recordingController.textContent = result.bestTranscription
        speechRecognitionResult = result
    }
    
    
}

// MARK: - WJCADialogViewDatasource
extension WJCAViewController: WJCADialogViewDataSource {
    
    public func numberOfMessage(inDialogView dialogView: WJCADialogView) -> Int {
        return messages.count
    }
    
    public func dialogView(_ dialogView: WJCADialogView, messageAtIndex index: Int) -> WJCADialogMessage {
        return messages[index]
    }
}

// MARK: - WJCADialogViewDelagate
extension WJCAViewController: WJCADialogViewDelagate {
    
    public func didSelectOption(inMessage msgIndex: Int, at optionIndex: Int) {
        guard let content = messages[msgIndex].content as? WJCADialogOptionMessageContent else {
            return
        }
        delegate?.needExcusIntent(content.options[optionIndex])
    }
}

// MARK: - WJCAFunctionBarDatasource
extension WJCAViewController: WJCAFunctionBarDatasource {
    
    
}

// MARK: - WJCAFunctionBarDelegate
extension WJCAViewController: WJCAFunctionBarDelegate {
    
    public func shouldStartRecording() {
        speechRecognitionResult = nil
        funtionBar.startRecording()
        if !isSimulator() {
        chatAssistant.startListen()
    }
    }
    
    public func shouldCancelRecording() {
        chatAssistant.cancelListen()
        funtionBar.stopRecording()
    }
    
    public func shouldEndRecording() {
        
        if isSimulator() {
            let msg = messages.count > 1 ? "你好" : "我要上班打卡"
            speechRecognitionResult = WJSpeechRecognitionResult(bestTranscription: msg, transcriptions: ["你好"], isFinal: true)
            wjChatAssistantSpeechRecognizeComplate(true, nil)
        } else {
            chatAssistant.stopListen()
        }
    }
    
    public func shouldStartTyping() {
        
    }
    
    public func shouldCancelTyping() {
        
    }
    
    public func shouldEndTyping() {
        
    }
    
    
}

func isSimulator() -> Bool {
    var isSim = false
    #if arch(i386) || arch(x86_64)
        isSim = true
    #endif
    return isSim
}

