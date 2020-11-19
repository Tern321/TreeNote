//
//  TestImageViewController.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 17.11.2020.
//

import UIKit

class TestImageViewController: UIViewController {

    @IBOutlet var imageViewA:UIImageView!
    @IBOutlet var imageViewB:UIImageView!
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageViewA.image = UIImage(named: "IMG_0003.JPG")
        imageViewA.image = UIImage(named: "IMG_0004.JPG")
        scrollView.contentSize = CGSize(width: 375, height: 1800)
    }
}
