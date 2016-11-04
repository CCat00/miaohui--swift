//
//  MHExtension.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor

extension UIColor {
    static func hexColor(hex: Int32) -> UIColor {
        let r = CGFloat((hex & 0xFF0000) >> 16)
        let g = CGFloat((hex & 0x00FF00) >> 8)
        let b = CGFloat((hex & 0x0000FF) >> 0)
        
        return UIColor.rgbColor(r: r, g: g, b: b)
    }
    
    static func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor.init(
            red: CGFloat(r/255.0),
            green: CGFloat(g/255.0),
            blue: CGFloat(b/255.0)
            , alpha: 1.0)
    }
}

// MARK: - UIView

extension UIView {
    
//    var selfX: CGFloat {
//        set {
//            self.frame.origin.x = newValue
//        }
//        get {
//            return self.frame.origin.x
//        }
//    }
//    
//    var selfY: CGFloat {
//        set {
//            self.frame.origin.y = newValue
//        }
//        get {
//            return self.frame.origin.y
//        }
//    }
//    
//    var selfW: CGFloat {
//        set {
//            self.frame.size.width = newValue
//        }
//        get {
//            return self.frame.size.width
//        }
//    }
//    
//    var selfH: CGFloat {
//        set {
//            self.frame.size.height = newValue
//        }
//        get {
//            return self.frame.size.height
//        }
//    }
//    
//    var selfR: CGFloat {
//        set {
//            selfX = newValue - selfW
//        }
//        get {
//            return selfX + selfW
//        }
//    }
//    
//    var selfB: CGFloat {
//        set {
//            selfY = newValue - selfH
//        }
//        get {
//            return selfY + selfH
//        }
//    }
//    
//    var selfCenter: CGPoint {
//        set {
//            self.frame.origin.x = newValue.x - selfW / 2.0
//            self.frame.origin.y = newValue.y - selfH / 2.0
//        }
//        get {
//            return CGPoint.init(x: selfX + selfW / 2.0, y: selfY + selfW / 2.0)
//        }
//    }
}

// MARK: - 

//@IBDesignable
extension UIView {
   @IBInspectable var cornerRadius: CGFloat {
        set {
            guard newValue > 0 else {
                return
            }
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            guard newValue > 0 else {
                return
            }
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor.init(cgColor: self.layer.borderColor!)
        }
    }
}

// MARK: - UIImage

extension UIImage {
    static func imageWithColor(color: UIColor) -> UIImage? {
        return self.imageWithColor(color: color, size: CGSize.init(width: 1, height: 1))
    }
        
    static func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        if size.width <= 0 || size.height <= 0 { return nil }
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - Storyboard
// http://swift.gg/2016/09/26/uistoryboard-safer-with-enums-protocol-extensions-and-generics/
extension UIStoryboard {
    enum Storyboard: String {
        case Main
    }

    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    //或者
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard
    {
        return UIStoryboard.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    //带上泛型
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable
    {
        let vc = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)
        
        guard vc is T else {
            fatalError("Couldn’t instantiate view controller with identifier \(T.storyboardIdentifier)")
        }
        
        return vc as! T
    }
}

//返回类名字符串

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}

