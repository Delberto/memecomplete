//
//  ViewController.swift
//  Meme
//
//  Created by Delberto Martinez on 13/05/16.
//  Copyright © 2016 Delberto Martinez. All rights reserved.
//

import UIKit

struct Meme {
    let top: String
    let bottom: String
    let originalImage: UIImage
    let memedImage: UIImage
    
}

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextInputTraits{

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var takePhoto: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBAction func cancelButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    
//currentTextField var to save the current status of the textFieldTop
     var currentTextField: UITextField!
     var showToolbar: UIToolbar!
     var showNavBar: UINavigationBar!
    
//This function hides the status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let memeTextAttributes = [
            NSStrokeColorAttributeName:UIColor.black,
            NSForegroundColorAttributeName:UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -1.0] as [String : Any]
        
        func configTextField(_ defaultText: String, textField: UITextField){
            textField.text = defaultText
            textField.defaultTextAttributes = memeTextAttributes
            textField.autocapitalizationType = .allCharacters
            textField.textAlignment = .center
            textField.delegate = self
            
        }
        configTextField("TOP", textField: textFieldTop)
        configTextField("BOTTOM", textField: textFieldBottom)
        
         actionButton.isEnabled = false
        
        
    }
    
 
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        takePhoto.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardNotificationsDown()
        
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyBoardNotifications()
        self.unsubscribeToKeyBoardNotificationsDown()
    }
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
   
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
      
    {
        imagePickerView.image = image
        self.dismiss(animated: true, completion: nil)
    }
  
    func presentViewController(_ source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = source
        actionButton.isEnabled = true
    }
    
    @IBAction func pickAnImage(_ sender: AnyObject) {
        presentViewController(UIImagePickerControllerSourceType.photoLibrary)
    }

    @IBAction func takePhoto (_ sender: AnyObject) {
        presentViewController(UIImagePickerControllerSourceType.camera)
    }

    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)) , name: NSNotification.Name.UIKeyboardWillShow,  object: nil)
    }
    func unsubscribeToKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if textFieldBottom.isFirstResponder{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    func subscribeToKeyboardNotificationsDown() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide,  object: nil)
    }
    
    func unsubscribeToKeyBoardNotificationsDown() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if textFieldBottom.isFirstResponder{
        view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    func writeAtTheTop(_ sender: AnyObject) {
        let textFieldTop = UITextField()
        textFieldTop.delegate = self
        self.view.addSubview(textFieldTop)
       
    }
    
    func writeAtTheBottom(_ sender: AnyObject) {
        let textFieldBottom = UITextField()
        textFieldBottom.delegate = self
        self.view.addSubview(textFieldBottom)
        
    }
   
   
//This function save the meme
    fileprivate func save() {
        let memedImage = generateMemedImage()
        let meme = Meme (top: textFieldTop.text!, bottom: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        let sharedImage = UIApplication.shared.delegate
        let appDelegate = sharedImage as! AppDelegate
            appDelegate.memes.append(meme)
        
        dismiss(animated: true, completion: nil)
        
    }
//This function generate the memedImage
    func generateMemedImage() -> UIImage{
//Hide the toolbar and navigationbar
        toolbar.isHidden = true
        navbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
//Show the toolbar and the navigationbar
         toolbar.isHidden = false
         navbar.isHidden = false
        
                return memedImage
    }
    
    @IBAction func shareButton(_ sender: AnyObject) {
        
        let controller = UIActivityViewController(activityItems: [generateMemedImage()],  applicationActivities: nil)
            controller.completionWithItemsHandler = {
            activity, succes, returnedItems, error in
            if succes{
                self.save()
                controller.dismiss(animated: true, completion: nil)
                
            }
        }
        present(controller, animated: true, completion: nil)
    }
}





