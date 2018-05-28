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
        let view = WJCADialogView()
        view.delegate = self
        view.datasource = self
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
        
        let bubbleView = WJBubbleView(frame: CGRect.init(x: 40, y: 100, width: 200, height: 40), position: .left)
        bubbleView.backgroundColor = UIColor.blue
        view.addSubview(bubbleView)
        
//        let bubbleView1 = WJBubbleView(frame: CGRect.init(x: 40, y: 150, width: 200, height: 40), position: .center)
//        bubbleView1.backgroundColor = UIColor.gray
//        view.addSubview(bubbleView1)
//        
//        let bubbleView2 = WJBubbleView(frame: CGRect.init(x: 40, y: 200, width: 200, height: 40), position: .right)
//        bubbleView2.backgroundColor = UIColor.red
//        view.addSubview(bubbleView2)
    }
}

// MARK: - WJChatAssistantDelegate
extension WJCAViewController: WJChatAssistantDelegate {
    
}

// MARK: - WJCADialogViewDatasource
extension WJCAViewController: WJCADialogViewDatasource {
    
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
