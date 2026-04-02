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
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    
//Esta variable guarda el status del campo de texto de arriba
     var currentTextField: UITextField!
     var showToolbar: UIToolbar!
     var showNavBar: UINavigationBar!
    
//Esta función oculta la status bar
 /*   override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let memeTextAttributes = [
            NSAttributedString.Key.strokeColor:UIColor.black,
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -1.0] as [NSAttributedString.Key : Any]
        
        func configTextField(defaultText: String, textField: UITextField){
            textField.text = defaultText
            textField.defaultTextAttributes = memeTextAttributes
            textField.autocapitalizationType = .allCharacters
            textField.textAlignment = .center
            textField.delegate = self
            
        }
        configTextField(defaultText: "TOP", textField: textFieldTop)
        configTextField(defaultText: "BOTTOM", textField: textFieldBottom)
        
        actionButton.isEnabled = false
        
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       takePhoto.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardNotificationsDown()
        
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyBoardNotifications()
        self.unsubscribeToKeyBoardNotificationsDown()
    }
   
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
   
       func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
      
    {
        imagePickerView.image = image
        self.dismiss(animated: true, completion: nil)
    }
  
    func presentViewController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = source
        actionButton.isEnabled = true
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        presentViewController(source: UIImagePickerController.SourceType.photoLibrary)
    }

    @IBAction func takePhoto (sender: AnyObject) {
        presentViewController(source: UIImagePickerController.SourceType.camera)
    }

    
    func subscribeToKeyboardNotifications() {
     /*   NSNotificationCenter.defaultCenter.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)) , name: UIKeyboardWillShowNotification,  object: nil)*/
    }
    func unsubscribeToKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if textFieldBottom.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
        
    }
    func subscribeToKeyboardNotificationsDown() {
       /* NSNotificationCenter.defaultCenter.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification,  object: nil)*/
    }
    
    func unsubscribeToKeyBoardNotificationsDown() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if textFieldBottom.isFirstResponder{
            view.frame.origin.y += getKeyboardHeight(notification: notification)
        }
        
    }
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    func writeAtTheTop(sender: AnyObject) {
        let textFieldTop = UITextField()
        textFieldTop.delegate = self
        self.view.addSubview(textFieldTop)
       
    }
    
    func writeAtTheBottom(sender: AnyObject) {
        let textFieldBottom = UITextField()
        textFieldBottom.delegate = self
        self.view.addSubview(textFieldBottom)
        
    }
   
   
//Esta función guarda el Meme después de que ha sido modificado 
    private func save() {
        let memedImage = generateMemedImage()
        let meme = Meme (top: textFieldTop.text!, bottom: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        let sharedImage = UIApplication.shared.delegate
        let appDelegate = sharedImage as! AppDelegate
            appDelegate.memes.append(meme)
        
        dismiss(animated: true, completion: nil)
        
    }
//Esta función genera el meme construido
    func generateMemedImage() -> UIImage{
//Oculta la navBar y toolBar
        toolbar.isHidden = true
        navbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
//Muestra toolBar y navBar 
        toolbar.isHidden = false
        navbar.isHidden = false
        
                return memedImage
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        
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





