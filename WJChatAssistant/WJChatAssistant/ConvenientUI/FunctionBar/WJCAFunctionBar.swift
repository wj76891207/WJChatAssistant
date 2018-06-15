//
//  WJCAFunctionBar.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

class WJCATextInputView: UIView {
    
    fileprivate let textField = UITextField()
    private let bgLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.returnKeyType = .send
        
        bgLayer.backgroundColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        
        layer.addSublayer(bgLayer)
        addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = bounds.insetBy(dx: 10, dy: 0)
        bgLayer.frame = bounds.insetBy(dx: 0, dy: 6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}

public class WJCAFunctionBar: UIView {
    
    enum Status {
        case waiting
        case recording
        case typing
    }
    private var status: Status = .waiting {
        didSet {
            updateView(true)
        }
    }
    
    public let suggestHeight: CGFloat = 70
    
    public weak var delegate: WJCAFunctionBarDelegate? = nil
    public weak var datasource: WJCAFunctionBarDatasource? = nil
    
    private let recordBtnSize: CGFloat = 50
    private let typingBtnSize: CGFloat = 40
    private func barShowHeight() -> CGFloat { return (bounds.height*2/3).flat }
    
    private var parentViewController: UIViewController?
    
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
        addSubview(textInputView)

        setupConstraints()
        updateView(false)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let newPoint = self.convert(point, to: self)
        if newPoint.y < recordBtnSize/2 && !between(newPoint.x, recordBtn.frame.minX, recordBtn.frame.maxX) {
            return nil
        }
        return super.hitTest(point, with: event)
    }
        
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        var curResponder: UIResponder = self
        parentViewController = nil
        while let nextResponder = curResponder.next {
            if let viewController =  nextResponder as? UIViewController {
                parentViewController = viewController
                break
            }
            curResponder = nextResponder
        }
        }
    
    private func setupConstraints() {
        
        let barActualCenterY = ((suggestHeight+recordBtnSize/2)/2).flat
        
        typingBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: typingBtn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: typingBtn, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: barActualCenterY),
            NSLayoutConstraint(item: typingBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: typingBtnSize),
            NSLayoutConstraint(item: typingBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: typingBtnSize)
            ])
        
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: textInputView, attribute: .left, relatedBy: .equal, toItem: typingBtn, attribute: .right, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: textInputView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: (recordBtnSize/2).flat),
            NSLayoutConstraint(item: textInputView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: textInputView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: suggestHeight)
            ])
        
        recordBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: recordBtn, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: recordBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: recordBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: recordBtnSize),
            NSLayoutConstraint(item: recordBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: recordBtnSize)
            ])
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        topBorderLine.frame = CGRect(x: 0, y: (recordBtnSize/2).flat, width: bounds.width, height: CGFloat.piexlOne)
        bgLayer.frame = CGRect(x: 0, y: topBorderLine.frame.maxY, width: bounds.width, height: bounds.height-topBorderLine.frame.maxY)
    }
    
    @objc private func didClickTypingBtn(_ sender: UIButton) {
        if status == .waiting {
            delegate?.shouldStartTyping()
        }
        else {
            delegate?.shouldEndTyping()
        }
    }
    
    @objc private func didClickRecordBtn(_ sender: WJRecordButton) {
        if status == .waiting {
            delegate?.shouldStartRecording()
        }
        else {
            delegate?.shouldEndRecording()
        }
    }
    
    lazy var recordingController: WJCARecordingViewController = WJCARecordingViewController()
    
    private lazy var textInputView: WJCATextInputView = {
        let inputView = WJCATextInputView()
        inputView.textField.addTarget(self, action: #selector(confirmInputText(_:)), for: .editingDidEndOnExit)
        return inputView
    }()
}

extension WJCAFunctionBar {
    
    func updateView(_ animated: Bool) {
        let changeBlock = { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.textInputView.alpha = strongSelf.status == .typing ? 1.0 : 0.0
            strongSelf.textInputView.isUserInteractionEnabled = strongSelf.status == .typing ? true : false
            
            strongSelf.topBorderLine.opacity = strongSelf.status == .recording ? 0.0 : 1.0
            strongSelf.bgLayer.opacity = strongSelf.status == .recording ? 0.0 : 1.0
            
            strongSelf.recordBtn.isUserInteractionEnabled = strongSelf.status != .typing ? true : false
            strongSelf.recordBtn.alpha = strongSelf.status != .typing ? 1.0 : 0.0
            strongSelf.recordBtn.stauts = strongSelf.status == .recording ? .recording : .waiting
            
            strongSelf.typingBtn.alpha = strongSelf.status == .recording ? 0.0 : 1.0
            strongSelf.typingBtn.isUserInteractionEnabled = strongSelf.status == .recording ? false : true
            strongSelf.typingBtn.setImage(UIImage.init(named: strongSelf.status == .typing ? "_record" : "_keyboard",
                                                       in: Bundle(for: WJCAFunctionBar.self),
                                                       compatibleWith: nil), for: .normal)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                changeBlock()
            }
        } else {
            changeBlock()
        }
    }
}


// MARK: - Deal Recording
extension WJCAFunctionBar {
    
    func startRecording() {
        status = .recording
        showRecordingView()
    }
    
    func stopRecording() {
        status = .waiting
        hideRecordingView()
    }
    
    private func showRecordingView() {
        parentViewController?.view.insertSubview(recordingController.view, belowSubview: self)
        
        recordingController.cancelRecordHandler = { [weak self] in
            self?.delegate?.shouldCancelRecording()
        }
        recordingController.textContent = nil
        
        recordBtn.isUserInteractionEnabled = false
        recordingController.show {
            self.recordBtn.isUserInteractionEnabled = true
        }
    }
    
    private func hideRecordingView() {
        recordBtn.isUserInteractionEnabled = false
        recordingController.hide { [weak self] in
            self?.recordingController.view.removeFromSuperview()
            self?.recordBtn.isUserInteractionEnabled = true
        }
    }
    
}

// MARK: - Deal Typing
extension WJCAFunctionBar {
            
    func startTyping() {
        status = .typing
        showTypingView()
    }
    
    func stopTyping() {
        status = .waiting
        hideTypingView()
        }
        
    private func showTypingView() {
        textInputView.becomeFirstResponder()
    }
    
    private func hideTypingView() {
        textInputView.resignFirstResponder()
    }
    
    var gestureTargetViewController: UIViewController? {
        return parentViewController
        }
    
    @objc private func confirmInputText(_ sender: UITextField) {
        guard let content = sender.text else { return }
        
        delegate?.sendTypingContent(content)
        sender.text = nil
        status = .waiting
    }
}
