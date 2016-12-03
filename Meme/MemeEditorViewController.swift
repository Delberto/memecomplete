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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    
//Esta variable guarda el status del campo de texto de arriba
     var currentTextField: UITextField!
     var showToolbar: UIToolbar!
     var showNavBar: UINavigationBar!
    
//Esta función oculta la status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let memeTextAttributes = [
            NSStrokeColorAttributeName:UIColor.blackColor(),
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -1.0]
        
        func configTextField(defaultText: String, textField: UITextField){
            textField.text = defaultText
            textField.defaultTextAttributes = memeTextAttributes
            textField.autocapitalizationType = .AllCharacters
            textField.textAlignment = .Center
            textField.delegate = self
            
        }
        configTextField("TOP", textField: textFieldTop)
        configTextField("BOTTOM", textField: textFieldBottom)
        
         actionButton.enabled = false
        
        
    }
    
 
   override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        takePhoto.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardNotificationsDown()
        
    }

    
    
    override func viewWillDisappear(animated: Bool) {
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    func presentViewController(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = source
        actionButton.enabled = true
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        presentViewController(UIImagePickerControllerSourceType.PhotoLibrary)
    }

    @IBAction func takePhoto (sender: AnyObject) {
        presentViewController(UIImagePickerControllerSourceType.Camera)
    }

    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)) , name: UIKeyboardWillShowNotification,  object: nil)
    }
    func unsubscribeToKeyBoardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if textFieldBottom.isFirstResponder(){
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    func subscribeToKeyboardNotificationsDown() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification,  object: nil)
    }
    
    func unsubscribeToKeyBoardNotificationsDown() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if textFieldBottom.isFirstResponder(){
        view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
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
   
   
//Esta función guarda el Meme
    private func save() {
        let memedImage = generateMemedImage()
        let meme = Meme (top: textFieldTop.text!, bottom: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        let sharedImage = UIApplication.sharedApplication().delegate
        let appDelegate = sharedImage as! AppDelegate
            appDelegate.memes.append(meme)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
//Esta función genera el meme construido
    func generateMemedImage() -> UIImage{
//Oculta la navBar y toolBar
        toolbar.hidden = true
        navbar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//Muestra toolBar y navBar 
        toolbar.hidden = false
         navbar.hidden = false
        
                return memedImage
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        
        let controller = UIActivityViewController(activityItems: [generateMemedImage()],  applicationActivities: nil)
            controller.completionWithItemsHandler = {
            activity, succes, returnedItems, error in
            if succes{
                self.save()
                controller.dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
        presentViewController(controller, animated: true, completion: nil)
    }
}





