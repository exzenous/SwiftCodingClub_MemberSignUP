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
    @IBOutlet weak var studentEmail: UITextField!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentYearLabel: UILabel!
    @IBOutlet weak var studentEmailLabel: UILabel!
    @IBOutlet weak var studentFacebookLabel: UILabel!
    
    @IBOutlet weak var memberLAbel: UILabel!
    
    let alert = UIAlertController(title: "Confirm", message: "Please Confirm to be a Swift Coding Club member", preferredStyle: UIAlertController.Style.alert)
    let alertSuccess = UIAlertController(title: "Confirm", message: "Please Confirm to be a Swift Coding Club member", preferredStyle: UIAlertController.Style.alert)
    let alertError = UIAlertController(title: "Confirm", message: "Please Confirm to be a Swift Coding Club member", preferredStyle: UIAlertController.Style.alert)
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        myDb = Firestore.firestore()
//        customFont()
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
            self.view.frame.origin.y -= keyboardFrame.height - keyboardFrame.height/4
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
        let chk = [studentId,studentName,studentYear,studentFacebook,studentEmail]
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
            self.myDb.collection("Year_\(self.studentYear.text!)").document("\(self.studentId.text!)").setData(["StudentID": self.studentId.text!, "Name": self.studentName.text!,"Year": self.studentYear.text!,"FaceBook": self.studentFacebook.text!,"Email": self.studentEmail.text!])
            EZLoadingActivity.show("Loading...", disableUI: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                EZLoadingActivity.hide(true, animated: true)
            }
            for item in chk {
                item?.text = ""
            }
        }
    }
    
    
    //create for response Iphone
    func customFont(){
        let arrayFont = [studentIdLabel,studentNameLabel,studentYearLabel,studentFacebookLabel,studentEmailLabel]
        let chk = [studentId,studentName,studentYear,studentFacebook,studentEmail]
        for i in arrayFont{
            i?.adjustsFontSizeToFitWidth = true
            i?.font = i?.font.withSize(self.view.frame.width * 0.05)
        }
        for i in chk{
            i?.adjustsFontSizeToFitWidth = true
            i?.font = i?.font?.withSize(self.view.frame.width * 0.03)
        }
        memberLAbel.font = memberLAbel.font.withSize(self.view.frame.width * 0.15)
        
    }
    
    
 
}

