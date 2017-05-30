//
//  ProfileViewController.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/27/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import CSStickyHeaderFlowLayout
import SDWebImage
import Firebase
class ProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var logout: UIBarButtonItem!
    var currentUser:UserModel?
    var dataArray = [[String:String]]()
    var follwed = false
    var followers = 0
    var totalSteps = 0
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
                statusBar.backgroundColor = UIColor.black
        collectionView.alwaysBounceVertical = true
        guard let layout = collectionView.collectionViewLayout as? CSStickyHeaderFlowLayout else { return }
        loadUserInformation()
        layout.parallaxHeaderReferenceSize = CGSize(width: self.view.frame.width, height: 300)
        layout.parallaxHeaderMinimumReferenceSize = CGSize(width: self.view.frame.width, height: 100)
        layout.itemSize = CGSize(width: view.frame.width, height: 83)
       let headerNib = UINib(nibName: "headerView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
               // Do any additional setup after loading the view.
    }
    func loadUserInformation(){
        if currentUser == nil{
            currentUser = UserModel()
            currentUser?.email = Auth.auth().currentUser?.email
            currentUser?.uid = Auth.auth().currentUser?.uid
            currentUser?.name = Auth.auth().currentUser?.displayName
            currentUser?.photoURL = Auth.auth().currentUser?.photoURL
            let totalStepRef = FirebaseManager.sharedInstance.userDatabaseRef.child((currentUser?.uid)!).child("totalStep")
            totalStepRef.observeSingleEvent(of: .value, with: { (data) in
                if let step = data.value as? Int{
                    self.currentUser?.totalStep = step
                    self.collectionView.reloadData()
                }
            })
        }
        else{
            logout.isEnabled = false
            logOutButton.alpha = 0
            let followingList = FirebaseManager.sharedInstance.followingRef.child((Auth.auth().currentUser?.uid)!).child((currentUser?.uid)!)
            followingList.observeSingleEvent(of: .value, with: { (data) in
                if let followed = data.value as? Bool{
                    if followed == true{
                        self.follwed = true
                    }
                }
                self.collectionView.reloadData()
            })
            
        }

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         loadRunningData()
    }
    func loadRunningData(){
        self.dataArray.removeAll()
        guard let user = currentUser else { return  }
        let stepsRef = FirebaseManager.sharedInstance.stepStatisticRef.child(user.uid!)
        stepsRef.observeSingleEvent(of: .value, with: { (result) in
            for child in result.children {
                if let childValue = child as? DataSnapshot{
                    let runningDict = [childValue.key:String(childValue.value as! Int)]
                    self.dataArray.append(runningDict)
                }
            }
            self.collectionView.reloadData()
        })
        let followerRef = FirebaseManager.sharedInstance.followerRef.child((currentUser?.uid)!)
        followerRef.observeSingleEvent(of: .value, with: { (data) in
            self.followers = Int(data.childrenCount)
            self.collectionView.reloadData()
        })
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader{
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionViewCell
            guard let user = self.currentUser else { return cell}
            if user.uid == Auth.auth().currentUser?.uid{
                cell.followButton.alpha = 0
            }
            else{
            if(follwed){
                cell.followButton.alpha = 1
                cell.followButton.isEnabled = false
            }
            else{
                cell.followButton.alpha = 1
                }
            }
            cell.followerLabel.text = String(followers)
            cell.followButton.addTarget(self, action: #selector(followAction), for: UIControlEvents.touchUpInside)
            cell.profileImage.sd_setImage(with: user.photoURL, placeholderImage: #imageLiteral(resourceName: "Circled User Male Filled-100"))
            cell.totalStepLabel.text = String(user.totalStep ?? 0)
            cell.nameLabel.text = user.name
            return cell
        }
        return UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    func followAction(){
        let followingList = FirebaseManager.sharedInstance.followingRef.child((Auth.auth().currentUser?.uid)!).child((currentUser?.uid)!)
        // Get my following lsit
        let follower = FirebaseManager.sharedInstance.followerRef.child((currentUser?.uid)!).child((Auth.auth().currentUser?.uid)!)
        // Get the following list of the user I wish to follow
        followingList.setValue(true)
        follower.setValue(true)
        let headerView = self.collectionView.visibleSupplementaryViews(ofKind: CSStickyHeaderParallaxHeader).first as! HeaderCollectionViewCell
        headerView.followButton.isEnabled = false
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.stepsLabel.text = dataArray[indexPath.row].values.first!
        cell.calorieLabel.text = String(Double(dataArray[indexPath.row].values.first!)!*0.04)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        guard let dateKey = dataArray[indexPath.row].keys.first else { return cell}
        let date = dateFormatter.date(from:dateKey)
        let monthFormat = DateFormatter()
        monthFormat.dateFormat = "MMM"
        let dayFormat = DateFormatter()
        dayFormat.dateFormat = "d"
        cell.monthLabel.text = monthFormat.string(from: date!)
        cell.dayLabel.text = dayFormat.string(from: date!)
        return cell
    }
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch  {
            print(error.localizedDescription)
        }
        dismiss(animated: true)
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
