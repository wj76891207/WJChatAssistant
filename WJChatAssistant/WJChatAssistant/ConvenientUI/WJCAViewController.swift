//
//  WJCAViewController.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public class WJCAViewController: UIViewController {
    
    public let chatAssistant = WJChatAssistant()
    public weak var delegate: WJCAViewControllerDelegate? = nil
    public weak var datasource: WJCAViewControllerDatasource? = nil
    
    private lazy var dialogView: WJCADialogView = {
        let view = WJCADialogView(frame: self.view.bounds)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var funtionBar: WJCAFunctionBar = {
        let bar = WJCAFunctionBar()
        bar.delegate = self
        bar.datasource = self
        return bar
    }()
    
    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        chatAssistant.delegate = self
        view.backgroundColor = .white
        
        
//        let testView = WJMarbleLoadingView(frame: CGRect.init(x: 100, y: 100, width: 60, height: 40), number: 3)
//        testView.layer.cornerRadius = 15
//        view.addSubview(testView)
        
        
//        let titles1 = ["YES", "NO"]
//        let titles2 = ["我比较短", "我是一个很长很长很长很长很长很长很长很长很长的按钮", "短", "一般般吧", "又是一个比较长的按钮噢噢噢噢", "uuuuu", "222222"]
//        let testTitles = [titles1, titles2]
//        
//        var curY: CGFloat = 100
//        for titles in testTitles {
//            let testOptionsView = WJButtonGroup(frame: CGRect(x: 30, y: curY, width: 300, height: 100))
//            testOptionsView.titles = titles
//            
//            testOptionsView.sizeToFit()
//            view.addSubview(testOptionsView)
//            
//            curY += testOptionsView.bounds.height + 20
//        }
        
        
        view.addSubview(dialogView)
    }
}

// MARK: - WJChatAssistantDelegate
extension WJCAViewController: WJChatAssistantDelegate {
    
}

// MARK: - WJCADialogViewDatasource
extension WJCAViewController: WJCADialogViewDataSource {
    
    var messages: [WJCADialogMessage] {
        return [
            {
                var msg = WJCADialogMessage()
                msg.content = "Hi，小璇"
                msg.speaker = .user
                return msg
            }(),
            {
                var msg = WJCADialogMessage()
                msg.content = "我在呢，有什么事吗？"
                msg.speaker = .bot
                return msg
            }(),
            {
                var msg = WJCADialogMessage()
                msg.content = "没什么事儿，就是想找你闲聊一下，你现在有时间么？"
                msg.speaker = .user
                return msg
            }(),
            {
                var msg = WJCADialogMessage()
                msg.content = ""
                msg.speaker = .bot
                msg.status = .processing
                return msg
            }(),
            {
                var msg = WJCADialogMessage()
                msg.contentType = .image
                msg.content = #imageLiteral(resourceName: "test_img1")
                msg.speaker = .bot
                return msg
            }(),
            {
                var msg = WJCADialogMessage()
                msg.contentType = .image
                msg.content = #imageLiteral(resourceName: "test_img2")
                msg.speaker = .user
                return msg
            }(),
            {
                var msg = WJCADialogMessage()
                msg.contentType = .options
                msg.content = {
                    var content = WJCADialogOptionMessageContent()
                    content.title = "我找到了以下选项"
                    content.options = ["我比较短", "我是一个很长很长很长很长很长很长很长很长很长的按钮", "短", "一般般吧", "又是一个比较长的按钮噢噢噢噢", "uuuuu", "222222"]
                    return content
                }()
                msg.speaker = .bot
                return msg
            }(),
            {
                var msg = WJCADialogMessage()
                msg.content = ""
                msg.speaker = .bot
                msg.status = .processing
                return msg
            }()
        ]
    }
    
    public func numberOfMessage(inDialogView dialogView: WJCADialogView) -> Int {
        return messages.count
    }
    
    public func dialogView(_ dialogView: WJCADialogView, messageAtIndex index: Int) -> WJCADialogMessage {
        return messages[index]
    }
}

// MARK: - WJCADialogViewDelagate
extension WJCAViewController: WJCADialogViewDelagate {
    
}

// MARK: - WJCAFunctionBarDatasource
extension WJCAViewController: WJCAFunctionBarDatasource {
    
    
}

// MARK: - WJCAFunctionBarDelegate
extension WJCAViewController: WJCAFunctionBarDelegate {
    
}
