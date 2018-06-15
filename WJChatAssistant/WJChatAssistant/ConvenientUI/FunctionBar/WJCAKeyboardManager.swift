//
//  WJCAKeyboardManager.swift
//  WJChatAssistant
//
//  Created by wangjian on 11/06/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

protocol WJCAKeyboardManagerObserver: class {
    
    typealias KeyboardInfo = (begin: CGRect, end: CGRect, duration: TimeInterval, curve: UIViewAnimationOptions)
    
    var gestureTargetViewController: UIViewController? { get }
    
    func keyboardWillShow(_ info: KeyboardInfo)
    func keyboardWillHide(_ info: KeyboardInfo)
    func keyboardWillChangeFrame(_ info: KeyboardInfo)
}

extension WJCAKeyboardManagerObserver {
    
    // default do nothing
    func keyboardWillShow(_ info: KeyboardInfo) { }
    func keyboardWillHide(_ info: KeyboardInfo) { }
    func keyboardWillChangeFrame(_ info: KeyboardInfo) { }
}

class WJCAKeyboardManager {
    
    static let share = WJCAKeyboardManager()
    private var observers: [WJCAKeyboardManagerObserver] = []
    
    
    private lazy var hiddenKeyboardGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        gesture.isEnabled = false
        return gesture
    }()
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    func add(observer: WJCAKeyboardManagerObserver) {
        if observers.contains(where: { $0 === observer }) == false {
            observers.append(observer)
            observer.gestureTargetViewController?.view.addGestureRecognizer(hiddenKeyboardGesture)
        }
    }
    
    func remove(observer: WJCAKeyboardManagerObserver) {
        if let index = observers.index(where: { $0 === observer }) {
            observers.remove(at: index)
        }
        observer.gestureTargetViewController?.view.removeGestureRecognizer(hiddenKeyboardGesture)
    }
    
    @objc private func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        for item in observers {
            item.gestureTargetViewController?.view.endEditing(true)
        }
    }
    
    @objc private func keyboardWillShow(_ noti: Notification) {
        
        hiddenKeyboardGesture.isEnabled = true
        let keyboardInfo = getKeyboardInfo(noti)
        for item in observers {
            guard let viewController = item.gestureTargetViewController else { continue }
            guard viewController.isViewLoaded && viewController.view.window != nil else { continue }
            
            item.keyboardWillShow(keyboardInfo)
        }
    }
    
    @objc private func keyboardWillHide(_ noti: Notification) {
        hiddenKeyboardGesture.isEnabled = false
        let keyboardInfo = getKeyboardInfo(noti)
        for item in observers {
            item.keyboardWillHide(keyboardInfo)
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ noti: Notification) {
        let keyboardInfo = getKeyboardInfo(noti)
        for item in observers {
            item.keyboardWillChangeFrame(keyboardInfo)
        }
    }
    
    private func getKeyboardInfo(_ noti: Notification) -> WJCAKeyboardManagerObserver.KeyboardInfo {
        let begin = noti.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect ?? .zero
        let end = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let duration = noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
        let curve = noti.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationOptions ?? .curveEaseInOut
        
        return (begin, end, duration, curve)
    }
}
