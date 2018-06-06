//
//  WJCAFunctionBar.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public class WJCAFunctionBar: UIView {
    
    public let suggestHeight: CGFloat = 70
    
    public weak var delegate: WJCAFunctionBarDelegate? = nil
    public weak var datasource: WJCAFunctionBarDatasource? = nil
    
    private let recordBtnSize: CGFloat = 60
    private let typingBtnSize: CGFloat = 40
    private func barShowHeight() -> CGFloat { return (bounds.height*2/3).flat }
    
    private lazy var typingBtn: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage.init(named: "_keyboard", in: Bundle(for: WJCAFunctionBar.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(didClickTypingBtn(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var recordBtn: WJRecordButton = {
        let button = WJRecordButton(frame: .zero)
        button.addTarget(self, action: #selector(didClickRecordBtn(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var topBorderLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = _blueColor.cgColor
        return layer
    }()
    
    private lazy var bgLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    
    private lazy var contentWindow: UIWindow = {
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        return window
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor.clear
        
        layer.addSublayer(bgLayer)
        layer.addSublayer(topBorderLine)
        
        addSubview(typingBtn)
        addSubview(recordBtn)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if typingBtn.superview == self {
            typingBtn.frame = CGRect(x: 20, y: ((suggestHeight+recordBtnSize/2-typingBtnSize)/2).flat, width: typingBtnSize, height: typingBtnSize)
        }
        if recordBtn.superview == self {
            recordBtn.frame = CGRect(x: ((bounds.width-recordBtnSize)/2).flat, y: 0, width: recordBtnSize, height: recordBtnSize)
        }
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        topBorderLine.frame = CGRect(x: 0, y: (recordBtnSize/2).flat, width: bounds.width, height: CGFloat.piexlOne)
        bgLayer.frame = CGRect(x: 0, y: topBorderLine.frame.maxY, width: bounds.width, height: bounds.height-topBorderLine.frame.maxY)
    }
    
    @objc private func didClickTypingBtn(_ sender: UIButton) {
    
    }
    
    @objc private func didClickRecordBtn(_ sender: WJRecordButton) {
        if sender.stauts == .waiting {
            delegate?.shouldStartRecording()
        }
        else {
            delegate?.shouldEndRecording()
        }
    }
    
    func startRecording() {
        showRecordingView()
        // 由于按钮被移动到了新的view上，立刻加上的动画会被清除，所以暂时先延迟一点执行
        // FIXME: 不能这么做，有bug
        DispatchQueue.main.asyncAfter(deadline: .now()+0.02, execute: {
            self.recordBtn.stauts = .recording
        })
    }
    
    func stopRecording() {
        recordBtn.stauts = .waiting
        hideRecordingView()
    }
    
    private var previousKeyWindow: UIWindow? = nil
    lazy var recordingController: WJCARecordingViewController = WJCARecordingViewController()
    private func showRecordingView() {
        
        previousKeyWindow = UIApplication.shared.keyWindow
        let recordBtnFrame = convert(recordBtn.frame, to: previousKeyWindow)
        
        recordingController.cancelRecordHandler = { [weak self] in
            self?.delegate?.shouldCancelRecording()
        }
        recordingController.textContent = nil
        contentWindow.rootViewController = recordingController
        contentWindow.makeKeyAndVisible()
        
        recordingController.addRecordButton(recordBtn, recordBtnFrame)
        recordBtn.isUserInteractionEnabled = false
        recordingController.show {
            self.recordBtn.isUserInteractionEnabled = true
        }
    }
    
    private func hideRecordingView() {
        let hideHandler = {
            self.addSubview(self.recordBtn)
            
            self.contentWindow.isHidden = true
            self.contentWindow.rootViewController = nil
            self.previousKeyWindow = nil
        }
        
        recordBtn.isUserInteractionEnabled = false
        recordingController.hide {
            hideHandler()
            self.recordBtn.isUserInteractionEnabled = true
        }
    }
}
