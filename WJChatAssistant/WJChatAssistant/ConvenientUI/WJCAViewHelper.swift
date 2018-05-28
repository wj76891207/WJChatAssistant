//
//  WJCAViewHelper.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

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
