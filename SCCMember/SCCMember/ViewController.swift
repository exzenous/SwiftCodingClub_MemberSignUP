//
//  ViewController.swift
//  SCCMember
//
//  Created by Prapawit Patthasirivichot on 11/8/2562 BE.
//  Copyright © 2562 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit
import Firebase
import EZLoadingActivity



class ViewController: UIViewController{
    
    var myDb: Firestore!
    
    @IBOutlet weak var studentId: UITextField!
    @IBOutlet weak var studentName: UITextField!
    @IBOutlet weak var studentYear: UITextField!
    @IBOutlet weak var studentFacebook: UITextField!
    
    
    
    let alert = UIAlertController(title: "Confirm", message: "Please Confirm to be a Swift Coding Club member", preferredStyle: UIAlertController.Style.alert)
    let alertSuccess = UIAlertController(title: "Confirm", message: "Please Confirm to be a Swift Coding Club member", preferredStyle: UIAlertController.Style.alert)
    let alertError = UIAlertController(title: "Confirm", message: "Please Confirm to be a Swift Coding Club member", preferredStyle: UIAlertController.Style.alert)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        myDb = Firestore.firestore()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        btnAddAction()
    }


    @IBAction func SignUp(_ sender: Any) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func btnAddAction(){
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            self.checkTf()
            }))
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func checkTf(){
        EZLoadingActivity.show("Loading...", disableUI: true)
        let chk = [studentId,studentName,studentYear,studentFacebook]
        var pass = true
        for item in chk {
            if (item?.text!.isEmpty)!{
                pass = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    EZLoadingActivity.hide(false, animated: true)
                }
                
                break
            }
        }
        if pass == true{
            self.myDb.collection("Year_\(self.studentYear.text!)").document("\(self.studentId.text!)").setData(["StudentID": self.studentId.text!, "Name": self.studentName.text!,"Year": self.studentYear.text!,"FaceBook": self.studentFacebook.text!])
            EZLoadingActivity.show("Loading...", disableUI: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                EZLoadingActivity.hide(true, animated: true)
            }
            for item in chk {
                item?.text = ""
            }
        }
    }
    
    
    
 
}

