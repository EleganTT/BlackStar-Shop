//
//  ExtensionCALayer.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 19.06.2021.
//

import UIKit

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width - 20, height: 1)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: 1, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - 1, y: 0, width: 1, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}

extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }

    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }

        badgeLayer?.removeFromSuperlayer()
        
        // Initialize Badge
        if number > 0 {
            let badge = CAShapeLayer()
            let radius = CGFloat(7)
            let location = CGPoint(x: 20, y: 4)
            badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
            view.layer.addSublayer(badge)

            // Initialiaze Badge's label
            let label = CATextLayer()
            label.font = UIFont.boldSystemFont(ofSize: 12)
            label.string = "\(number)"
            label.alignmentMode = CATextLayerAlignmentMode.center
            label.fontSize = 11
            label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: location.y - 7), size: CGSize(width: 8, height: 16))
            label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
            label.backgroundColor = UIColor.clear.cgColor
            label.contentsScale = UIScreen.main.scale
            badge.addSublayer(label)

            // Save Badge as UIBarButtonItem property
            objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        

    }

    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }

    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }

}

extension UINavigationController {
    func addButton(color: UIColor) -> UIBarButtonItem {
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        rightBarButton.tintColor = color
        rightBarButton.setBackgroundImage(UIImage(systemName: "cart.fill", compatibleWith: .none), for: .normal)
        rightBarButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: rightBarButton)
    }
    
    @objc func buttonAction(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BasketVC") as! BasketViewController
        self.pushViewController(vc, animated: true)
    }
}
