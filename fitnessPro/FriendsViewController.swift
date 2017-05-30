//
//  FriendsViewController.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/29/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import Firebase
class FriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableVIew: UITableView!
    var friendList:[UserModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVIew.tableFooterView = UIView(frame: CGRect.zero)
        navigationItem.title = "Friends"
        loadUserList()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    func loadUserList(){
       let usersRef = FirebaseManager.sharedInstance.userDatabaseRef
        usersRef.observeSingleEvent(of: .value, with: { (data) in
            for child in data.children{
                if let childSnap = child as? DataSnapshot{
                   let user = UserModel(withSnap: childSnap)
                   self.friendList.append(user)
                }
            }
          self.tableVIew.reloadData()
        })
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
        cell.nameLabel.text = friendList[indexPath.row].name!
        let fakeURL = URL(string: "http://randommm")
        cell.profileImage.sd_setImage(with: friendList[indexPath.row].photoURL ?? fakeURL! , placeholderImage: #imageLiteral(resourceName: "Circled User Male Filled-100"))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileView") as! ProfileViewController
        profileVC.currentUser = friendList[indexPath.row]
        navigationController?.pushViewController(profileVC, animated: true)
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
