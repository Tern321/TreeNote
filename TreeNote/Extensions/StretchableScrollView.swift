//
//  StretchableScrollView.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 17.11.2020.
//

import UIKit

@objc protocol StretchableScrollViewProtocol
{
    func updateContentViewSize()
}

class StretchableScrollView: UIScrollView, StretchableScrollViewProtocol
{
    func updateContentViewSize()
    {
        var contentRect = CGRect.zero
        for view in self.subviews
        {
            let classNameString = NSStringFromClass(type(of: view))
            if !(classNameString == "resizeScrollViewContentSize" || classNameString == "_UIScrollViewScrollIndicator")
            {
                contentRect = contentRect.union(view.frame)
            }
        }
        if ( self.contentSize != contentRect.size)
        {
            self.contentSize = contentRect.size
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateContentViewSize()
        }
    }
}
