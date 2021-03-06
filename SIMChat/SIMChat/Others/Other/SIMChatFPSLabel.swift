//
//  SIMChatFPSLabel.swift
//  SIMChat
//
//  Created by sagesse on 2/1/16.
//  Copyright © 2016 Sagesse. All rights reserved.
//
//  Reference: ibireme/YYKit/YYFPSLabel
//

import UIKit

///
/// Show Screen FPS.
///
/// The maximum fps in OSX/iOS Simulator is 60.00.
/// The maximum fps on iPhone is 59.97.
/// The maxmium fps on iPad is 60.0.
///
public class SIMChatFPSLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        build()
    }
    deinit {
        SIMLog.trace()
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(55, 20)
    }
    public override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        if newWindow == nil {
            _link.invalidate()
        } else {
            _link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        }
    }
    
    @inline(__always) private func build() {
        SIMLog.trace()
        
        text = "calc..."
        font = UIFont.systemFontOfSize(14)
        textColor = UIColor.whiteColor()
        textAlignment = .Center
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    private dynamic func tack(link: CADisplayLink) {
        guard let lastTime = _lastTime else {
            _lastTime = link.timestamp
            return
        }
        _count += 1
        let delta = link.timestamp - lastTime
        guard delta >= 1 else {
            return
        }
        let fps = Double(_count) / delta + 0.03
        let progress = CGFloat(fps / 60)
        let color = UIColor(hue: 0.27 * (progress - 0.2), saturation: 1, brightness: 0.9, alpha: 1)
        
        let text = NSMutableAttributedString(string: "\(Int(fps)) FPS")
        text.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, text.length - 3))
        attributedText = text
        
        _count = 0
        _lastTime = link.timestamp
    }
    
    private var _count: Int = 0
    private var _lastTime: NSTimeInterval?
    
    private lazy var _link: CADisplayLink = {
        return CADisplayLink(target: self, selector: #selector(self.dynamicType.tack(_:)))
    }()
}
