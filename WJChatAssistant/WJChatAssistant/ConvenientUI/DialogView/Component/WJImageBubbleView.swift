//
//  WJImageBubbleView.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit

class WJImageBubbleView: WJBubbleView {

    var image: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    private let imageView: UIImageView
    
    override init(frame: CGRect, position: Position = .left) {
        
        imageView = UIImageView()
        super.init(frame: frame, position: position)
        
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        updateImage()
    }
    
    /// 根据内容以及view的相关属性，计算合适的显示大小
    class func fitSize(withImage image: UIImage?,
                       position: Position,
                       constraintSize: CGSize? = nil,
                       cornerRadiu: CGFloat = 15,
                       hookWidth: CGFloat = 7.5) -> CGSize {
        let imgSize = image?.size ?? suggestedMinSize
        let maxSize = constraintSize ?? suggestedMaxSize
        
        return imgSize.scaleToFit(minSize: suggestedMinSize, maxSize: maxSize)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if isProcessing {
            return super.sizeThatFits(size)
        }
        
        let minSize = type(of: self).suggestedMinSize
        let imgSize = image?.size ?? minSize
        let maxSize = size
        
        return imgSize.scaleToFit(minSize: minSize, maxSize: maxSize)
    }
    
    private func updateImage() {
        guard let image = image, imageView.bounds.size > .zero else {
            return
        }

        let targetSize = imageView.bounds.size
        DispatchQueue.global().async { [weak self] in
            let scaledImage = image.scaleToFit(targetSize)
            DispatchQueue.main.async {
                self?.imageView.image = scaledImage
            }
        }
    }
}
