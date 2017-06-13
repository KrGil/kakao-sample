//
//  AuthViewController.swift
//  Gilstalk
//
//  Created by Chang ByoungGil on 2017. 6. 2..
//  Copyright © 2017년 Gil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    var isLogin: Bool?
    var ref: DatabaseReference!
    
    @IBAction func buttonPressed(_ sender: Any) {
//        if let email = emailTextField.text {}
        if isLogin! {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {_,error in
                if error == nil {
                    self.performSegue(withIdentifier: "ToMain", sender: sender)
                }
            })
        }else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {user,error in
                if error == nil {
                    self.performSegue(withIdentifier: "ToMain", sender: sender)
//                    let mdata = [
//                        user!.uid : ["email": user!.email]
//                        ]
                    //childByAutoId() 임의의 uid 생성
                    //setValue() 덮어씀.. 기존 uid까지 사라짐. mdata에 user!.uid는 빼고 child()에 변수를 집어넣음.
//                    self.ref.child("users").setValue(mdata)
                    
                    let mdata = ["email": user!.email]
                    // /\() 문자열 안에 특정한 변수 집어넣어주기.
                    self.ref.child("users/\(user!.uid)").setValue(mdata)

                }
            })
        }
            // ...
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
