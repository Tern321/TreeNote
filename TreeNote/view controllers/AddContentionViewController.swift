//
//  AddContentionViewController.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 08.11.2020.
//

import UIKit

class AddContentionViewController: UIViewController {

    public var parentContentionId:String!
    @IBOutlet var textView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func save()
    {
        let contention = Contention(ModelController.shared.nextId(), self.textView.text, parentContentionId)
        ModelController.shared.addContention(contention)
        self.navigationController?.popViewController(animated: false)
    }


}
