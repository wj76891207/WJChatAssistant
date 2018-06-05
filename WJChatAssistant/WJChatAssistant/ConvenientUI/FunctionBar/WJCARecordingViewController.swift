//
//  WJCARecordingViewController.swift
//  WJChatAssistant
//
//  Created by wangjian on 04/06/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit

class WJCARecordingViewController: UIViewController {
    
    private lazy var recordingView: WJRecordingView = {
        let recordingView = WJRecordingView()
        recordingView.alpha = 0
        recordingView.closeHandler = { [weak self] in
            self?.cancelRecordHandler?()
        }
        return recordingView
    }()
    
    var textContent: String? {
        get {
            return recordingView.content
        }
        set {
            recordingView.content = newValue
        }
    }
    
    func updateVoicePower(_ peakPower: Float?) {
        
        var amplitude = CGFloat(peakPower ?? 10)/100
        amplitude = min(1, amplitude)
//        let org = amplitude
//        let coefficient = pow(sin((CGFloat.pi/2) * (1 - (amplitude-0.5)/0.5)), 3)
//        amplitude = amplitude + 0.5 * coefficient

        recordingView.waveView.addWave(withAmplitude: amplitude, narrowExp: nil)
    }
    
    private lazy var blurBGView: UIView = {
        if UIAccessibilityIsReduceTransparencyEnabled() {
            let bgView = UIView()
            bgView.backgroundColor = UIColor.black
            return bgView
        }
        else {
            let bgView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            return bgView
        }
    }()
    
    private let recordingViewH: CGFloat = 200
    private var recordingViewFrame: CGRect {
        return view.bounds.insetBy(dx: (view.bounds.width*0.15).flat, dy: ((view.bounds.height-recordingViewH)/2).flat)
    }
    
    var cancelRecordHandler: (()->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(blurBGView)
        
        recordingView.frame = recordingViewFrame
        view.addSubview(recordingView)
        
        view.backgroundColor = UIColor.clear
        
        setupConstraint()
    }
    
    func setupConstraint() {
        
        blurBGView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: blurBGView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: blurBGView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: blurBGView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: blurBGView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
    }
    
    func addRecordButton(_ button: WJRecordButton, _ frame: CGRect) {
        view.addSubview(button)
        button.frame = frame
    }
    
    @objc private func didClickCloseButton(_ button: UIButton) {
        cancelRecord()
    }
    
    private func cancelRecord() {
        cancelRecordHandler?()
    }
    
    private let recordingViewAnimatedShowOffset: CGFloat = 100

    func show(_ complation: (()->Void)?) {
        recordingView.frame = recordingViewFrame.offsetBy(dx: 0, dy: recordingViewAnimatedShowOffset)

        recordingView.alpha = 0
        blurBGView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.recordingView.alpha = 1
            self.blurBGView.alpha = 1
            self.recordingView.frame = self.recordingViewFrame
        }) { isFinished in
            complation?()
        }
    }

    func hide(_ complation: (()->Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.recordingView.alpha = 0
            self.blurBGView.alpha = 0
            self.recordingView.frame = self.recordingView.frame.offsetBy(dx: 0, dy: self.recordingViewAnimatedShowOffset)
        }) { isFinished in
            complation?()
        }
    }
}
