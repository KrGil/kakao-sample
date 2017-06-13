//
//  ViewController.swift
//  Gilstalk
//
//  Created by Chang ByoungGil on 2017. 5. 26..
//  Copyright © 2017년 Gil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var chatTextView: UITextView!
    
    // 변수 지정!
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle!
    
    
    @IBAction func chatButtonPressed(_ sender: Any) {
        var mdata = [String : String]()
        mdata["text"] = chatTextView.text
        
        
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UITableViewDelegate 연결시 항상 해주어야 하는 작업. tableView와 위의 코드가 연결되어 있다는것을 알려줌.
        //TableView 우클릭 후 드래그로 상단의 노랜색 동그라미에 따로 연결시켜줄 수 있다.
//        chatTableView.delegate = self
//        chatTableView.dataSource = self
        configureDatabase()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //UITableViewDataSource, UITableViewDelegate 추가시 넣어주어야 하는 코드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chatTableView .dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:String] else { return cell }
        let text = message["text"] ?? "[text]"
        // (-> UITableViewCell) 은 항상 return 값이 있다는 뜻이고 UITableViewCell의 return 값을 받아주어야 하기 때문에 return UITableViewCell()을 씀.
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // -> Int 는 return 값이 항상 있다는 뜻 Int 숫자로 받아주어야 한다.
        return messages.count
    }
    
    
    // observe를 어플이 꺼질때 자동해지 시켜줌.
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("messages").removeObserver(withHandle: refHandle)
        }
    }
    
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages")
            
            //특정 데이터 불러오기.
//            .queryOrdered(byChild: "text")
//            .queryEqual(toValue: " Ad")
            
            .observe(.childAdded, with: {
                //클로져. 함수는 함수인데 정의해 주는게 아니라 일회적으로 사용하는 함수.
                [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.messages.append(snapshot)
                strongSelf.chatTableView.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }
    


}

