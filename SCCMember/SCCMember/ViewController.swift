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
    @IBOutlet weak var studentFacebook: UITextField!
    @IBOutlet weak var studentEmail: UITextField!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentYearLabel: UILabel!
    @IBOutlet weak var studentEmailLabel: UILabel!
    @IBOutlet weak var studentFacebookLabel: UILabel!
    
    @IBOutlet weak var yearPicker: UIPickerView!
    
    @IBOutlet weak var memberLAbel: UILabel!
    
    let alert = UIAlertController(title: "Confirm", message: "Please Confirm to be a Swift Coding Club member", preferredStyle: UIAlertController.Style.alert)
    let alertSuccess = UIAlertController(title: "Confirm", message: "Please Confirm to be a Swift Coding Club member", preferredStyle: UIAlertController.Style.alert)
    let alertError = UIAlertController(title: "Confirm", message: "Please Confirm to be a Swift Coding Club member", preferredStyle: UIAlertController.Style.alert)
    
    
    let yearInText = ["Year 1","Year 2","Year 3","Year 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        myDb = Firestore.firestore()
//        customFont()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        btnAddAction()
        
        self.yearPicker.delegate = self
        self.yearPicker.dataSource = self

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
        // Put Input Variables here
        EZLoadingActivity.show("Loading...", disableUI: true)
        let chk = [studentId,studentName,studentFacebook,studentEmail]
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
            self.myDb.collection("Year_\(self.yearPicker.selectedRow(inComponent: 0) + 1)").document("\(self.studentId.text!)").setData(["StudentID": self.studentId.text!, "Name": self.studentName.text!,"FaceBook": self.studentFacebook.text!,"Email": self.studentEmail.text!])
            EZLoadingActivity.show("Loading...", disableUI: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                EZLoadingActivity.hide(true, animated: true)
            }
            for item in chk {
                item?.text = ""
            }
            self.yearPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    
    //create for response Iphone
    func customFont(){
        let arrayFont = [studentIdLabel,studentNameLabel,studentYearLabel,studentFacebookLabel,studentEmailLabel]
        let chk = [studentId,studentName,studentFacebook,studentEmail]
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

extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearInText.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearInText[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
    
}
