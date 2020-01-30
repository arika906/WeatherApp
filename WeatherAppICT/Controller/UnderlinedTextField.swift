//
//  UnderlinedTextField.swift
//  WeatherAppICT
//
//  Created by Md Zahidul Islam Mazumder on 30/1/20.
//  Copyright © 2020 Md Zahidul Islam Mazumder. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UnderlinedTextField : UITextField {
    static let kBottomBorderTag:Int = 33221
    
    var bottomBorder:UIView?
    var borderHeightConstraint:NSLayoutConstraint?
    
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0
    @IBInspectable var willShake:Bool = false
        {
        didSet{
            if willShake == true  {
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.1
                animation.repeatCount = 1
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
                self.layer.add(animation, forKey: "position")
            }
        }
    }
    
    @IBInspectable var haveBottomBorder:Bool {
        get {
            return bottomBorder != nil
        }
        set {
            if newValue == true {
                if haveBottomBorder { return }
                
                bottomBorder = UIView()
                bottomBorder?.translatesAutoresizingMaskIntoConstraints = false
                addSubview(bottomBorder!)
                
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[border]-0-|", options: .alignAllBottom, metrics: nil, views: ["border":bottomBorder!]))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[border]-0-|", options: .alignAllCenterX, metrics: nil, views: ["border":bottomBorder!]))
                
                borderHeightConstraint = NSLayoutConstraint(item: bottomBorder!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: bottomBorderHeight)
                bottomBorder?.addConstraint(borderHeightConstraint!)
            } else {
                bottomBorder?.removeFromSuperview()
                borderHeightConstraint = nil
            }
        }
    }
    
    @IBInspectable var bottomBorderColor:UIColor?           { didSet { updateBorderColor() }}
    @IBInspectable var selectedBottomBorderColor:UIColor?   { didSet { updateBorderColor() }}
    
    @IBInspectable var bottomBorderHeight:CGFloat = 1 {
        didSet {
            borderHeightConstraint?.constant = bottomBorderHeight
        }
    }
    
    // MARK: - Initializations
    
    func commonInit() {
        let have = haveBottomBorder
        haveBottomBorder = have
        addTarget(self, action: #selector(UnderlinedTextField.updateBorderColor), for: .editingDidBegin)
        addTarget(self, action: #selector(UnderlinedTextField.updateBorderColor), for: .editingDidEnd)
        addTarget(self, action: #selector(UnderlinedTextField.updateBorderColor), for: .editingDidEndOnExit)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Private Methods
    
    @objc func updateBorderColor() {
        var color:UIColor?
        if isEditing {
            color = selectedBottomBorderColor ?? bottomBorderColor
        } else {
            color = bottomBorderColor
        }
        
        bottomBorder?.backgroundColor = color ?? UIColor.clear
        setNeedsDisplay()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset))
    }
    
}
