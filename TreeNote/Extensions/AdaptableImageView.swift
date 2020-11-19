//
//  AdaptableImageView.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 17.11.2020.
//

import UIKit

class AdaptableImageView: UIImageView {
    
    var heightConstraint:NSLayoutConstraint?
    
    override var frame: CGRect
    {
        didSet {
            updateSuperviewContentSize()
        }
    }
    override var image:UIImage?
    {
        didSet {
            updateSuperviewContentSize()
        }
    }
    
    func updateSuperviewContentSize()
    {
        if let superview = self.superview
        {
            if let stretchableScrollViewProtocol:StretchableScrollViewProtocol = superview as? StretchableScrollViewProtocol
            {
                stretchableScrollViewProtocol.updateContentViewSize()
            }
        }
    }
    
    override var bounds: CGRect {
        didSet {
            if let image = self.image
            {
                let expectedHeight = image.size.height / image.size.width * bounds.size.width
                
                if let heightConstraint = self.heightConstraint
                {
                    self.removeConstraint(heightConstraint)
                }
                
                self.heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: expectedHeight)
                self.addConstraint(self.heightConstraint!)
                
                updateSuperviewContentSize()
            }
        }
    }
}
