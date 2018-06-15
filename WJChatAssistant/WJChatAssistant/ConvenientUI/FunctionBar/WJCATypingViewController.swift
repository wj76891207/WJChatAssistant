//
//  WJCATypingViewController.swift
//  WJChatAssistant
//
//  Created by wangjian on 04/06/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit

class TypingBar: UIView {
    
    
    
    
}

class WJCATypingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameDidChange(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func keyboardFrameDidChange(_ noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        
        userInfo[UIKeyboardFrameEndUserInfoKey]
    }

}
