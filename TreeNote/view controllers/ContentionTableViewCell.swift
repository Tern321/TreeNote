//
//  ContentionTableViewCell.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 28.10.2020.
//

import UIKit
@objc protocol ContentionTableViewCellDelegate
{
    func selectContention(_ :Contention)
    func moveToContention(_ :Contention)
}

class ContentionTableViewCell: UITableViewCell
{
    var _contention:Contention!
    weak var _delegate:ContentionTableViewCellDelegate!
    @IBOutlet var moveButton:UIButton!
    @IBOutlet var label:UILabel!
    @IBOutlet var intendantionView:UIView!
    public func setData(_ contention:Contention, _ delegate:ContentionTableViewCellDelegate, _ intendantion: Int, _ viewContentionId: String)
    {
        _contention = contention
        _delegate = delegate
        self.label.text = contention.text
        
        if ( contention.id == viewContentionId || contention.childs().count == 0 )
        {
            self.moveButton.alpha = 0
        }
        else
        {
            self.moveButton.alpha = 1
        }
        
        let crs = self.contentView.constraints
        if let cr:NSLayoutConstraint = crs.filter({ $0.identifier == "left" }).first
        {
            cr.constant = CGFloat( intendantion)
            self.layoutIfNeeded()
        }
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        // Initialization code
//    }
    
    func contention() -> Contention
    {
        return _contention
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        if selected
        {
            _delegate.selectContention(_contention)
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.red.cgColor
        }
        else
        {
            self.layer.borderWidth = 0.0
            self.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBAction func moveToContention()
    {
        _delegate.moveToContention(_contention)
    }
}
