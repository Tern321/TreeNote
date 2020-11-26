//
//  AddContentionViewController.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 08.11.2020.
//

import UIKit

class AddContentionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var contention:Contention!
    public var parentContentionId:String!
    @IBOutlet var textView:UITextView!
    var imagePicker: UIImagePickerController!
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var scrollView:UIScrollView!
    
    var contentionCreated:Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let contention = self.contention
        {
            contentionCreated = false
            self.textView.text = contention.text
        }
        else
        {
            self.contention = Contention(ModelController.shared.nextId(), self.textView.text, parentContentionId)
        }
        
        self.textView.becomeFirstResponder()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction(sender:)))
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraAction(sender:)))
        //        let galeryButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(galeryAction(sender:)))
        
        navigationItem.rightBarButtonItems = [ saveButton,cameraButton]
        scrollView.contentSize = CGSize(width: 1200, height: 1200)
        
        if let image = contention.image()
        {
            self.imageView.image = image
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func saveAction(sender: UIBarButtonItem)
    {
        if contentionCreated
        {
            ModelController.shared.addContention(self.contention)
        }
        contention.text = self.textView.text
        ModelController.shared.saveData()
        if let image = imageView.image
        {
            ModelController.shared.saveImage(image, forContention: contention)
        }
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func cameraAction(sender: UIBarButtonItem)
    {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
        imageView.layer.masksToBounds = true;
    }
    
    @objc func galeryAction(sender: UIBarButtonItem)
    {
        //        self.textView.endEditing(true)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.textView.endEditing(true)
    }
    
}
