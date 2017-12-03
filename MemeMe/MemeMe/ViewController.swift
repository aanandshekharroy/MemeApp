//
//  ViewController.swift
//  MemeMe
//
//  Created by Rashi Karanpuria on 29/11/17.
//  Copyright © 2017 Aanand. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBAction func pickButtonClicked(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate=self
        controller.sourceType = .photoLibrary
        self.present(controller, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
       bottomTextField.delegate = self
       topTextField.delegate = self
    }
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareButtonClicked(_ sender: Any) {
//        print("shared")
        let controller = UIActivityViewController(activityItems: [generateMemedImage()]
            , applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "Top" || textField.text == "Bottom"){
            textField.text=""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
//        shareButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
       shareButton.isHidden = true
        
       cameraButton.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        shareButton.isHidden = false
        cameraButton.isHidden = false
        return memedImage
    }
}

