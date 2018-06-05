//
//  WJCAViewHelper.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

let _blueColor = UIColor.init(red: 96/255.0, green: 143/255.0, blue: 233/255.0, alpha: 1)
private var _onePixel: CGFloat = -1
extension CGFloat {
    
    static var piexlOne: CGFloat {
        if _onePixel == -1 {
            _onePixel = 1/UIScreen.main.scale
        }
        return _onePixel
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return min + (max-min)*CGFloat(drand48())
    }
    
    var flat: CGFloat {
        return ceil(self * UIScreen.main.scale) / UIScreen.main.scale
    }
}


extension String {
    
    func size(widthConstrainedSize constraintSize: CGSize, font: UIFont) -> CGSize {
        let boundingBox = self.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.size
    }
}


extension UIEdgeInsets {
    var vertival: CGFloat {
        return top + bottom
    }
    
    var horizontal: CGFloat {
        return left + right
    }
}

extension CGRect {
    
    func interact(withEdgeInsets insets: UIEdgeInsets) -> CGRect {
        return CGRect(x: origin.x+insets.left,
                      y: origin.y+insets.top,
                      width: size.width-insets.horizontal,
                      height: size.height-insets.vertival)
    }
}

func between<T: Comparable>(_ value: T, _ minValue : T, _ maxValue : T) -> Bool {
    return value > minValue && value < maxValue
}

extension Comparable {
    
    func isBetween(_ minValue : Self, _ maxValue : Self) -> Bool {
        return between(self, minValue, maxValue)
    }
    
}

extension CGSize: Comparable {
    
    public static func <(lhs: CGSize, rhs: CGSize) -> Bool {
        return lhs.width < rhs.width && lhs.height < rhs.height
    }
    
}

extension CGSize {
    
    func scaleToFit(minSize: CGSize, maxSize: CGSize) -> CGSize {
        
        var fitSize: CGSize = self
        let zoomOutSacle = max(minSize.width/width, minSize.height/height)
        
        if zoomOutSacle > 1 {
            // 放大尺寸，但不能超过maxSize的限制
            fitSize.width = min(maxSize.width, zoomOutSacle*width).flat
            fitSize.height = min(maxSize.height, zoomOutSacle*height).flat
        }
        else
        {
            var zoomInSacle = max(width/maxSize.width, height/maxSize.height)
            if zoomInSacle > 1 {
                // 缩小尺寸，但不能小于minSize的限制
                let maxZoomInScale = min(width/minSize.width, height/minSize.height)
                zoomInSacle = min(zoomInSacle, maxZoomInScale)
                
                fitSize.width = min(maxSize.width, width/zoomInSacle).flat
                fitSize.height = min(maxSize.height, height/zoomInSacle).flat
            }
        }
        
        return fitSize
    }
}

extension UIImage {
    
    func scaleToFit(_ targetSize: CGSize) -> UIImage? {
        guard targetSize != size else { return self }
        
        let scaleW = size.width/targetSize.width
        let scaleH = size.height/targetSize.height
        let x, y, w, h: CGFloat
        if scaleW < scaleH {
            let scaleH = size.height/scaleW
            x = 0
            y = -((scaleH - targetSize.height)/2).flat
            w = targetSize.width
            h = scaleH.flat
        }
        else {
            let scaleW = size.width/scaleW
            x = -((scaleW - targetSize.width)/2).flat
            y = 0
            w = scaleW.flat
            h = targetSize.height
        }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, true, UIScreen.main.scale)
        self.draw(in: CGRect(x: x, y: y, width: w, height: h))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

