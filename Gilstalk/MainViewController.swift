//
//  MainViewController.swift
//  Gilstalk
//
//  Created by Chang ByoungGil on 2017. 6. 9..
//  Copyright © 2017년 Gil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // 변수 지정!
    var ref: DatabaseReference!
    var users: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle!
    
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out", signOutError)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        handle = Auth.auth().addStateDidChangeListener () {(auth, user) in
            if let user = auth.currentUser {
                self.emailLabel.text = user.email
            } else {
                self.emailLabel.text = "로그아웃 됨"
            }
        }
        configureDatabase()

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
    //UITableViewDataSource, UITableViewDelegate 추가시 넣어주어야 하는 코드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.userTableView .dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let userSnapshot: DataSnapshot! = self.users[indexPath.row]
        guard let user = userSnapshot.value as? [String:String] else { return cell }
        let text = user["email"] ?? "[email]"
        // (-> UITableViewCell) 은 항상 return 값이 있다는 뜻이고 UITableViewCell의 return 값을 받아주어야 하기 때문에 return UITableViewCell()을 씀.
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // -> Int 는 return 값이 항상 있다는 뜻 Int 숫자로 받아주어야 한다.
        return users.count
    }
    
    
    // observe를 어플이 꺼질때 자동해지 시켜줌.
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("users").removeObserver(withHandle: refHandle)
        }
    }
    
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("users")
            
            //특정 데이터 불러오기.
            //            .queryOrdered(byChild: "text")
            //            .queryEqual(toValue: " Ad")
            
            .observe(.childAdded, with: {
                //클로져. 함수는 함수인데 정의해 주는게 아니라 일회적으로 사용하는 함수.
                [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.users.append(snapshot)
                strongSelf.userTableView.insertRows(at: [IndexPath(row: strongSelf.users.count-1, section: 0)], with: .automatic)
            })
    }

}
