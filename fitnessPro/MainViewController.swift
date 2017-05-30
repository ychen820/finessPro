//
//  MainViewController.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/21/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import Foundation
import CoreData
class MainViewController: UIViewController,BLTManagerDelegate {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var hrLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var aLabel : UILabel!
    @IBOutlet weak var heartCircleView : UIView!
    @IBOutlet weak var graphView : ScrollableGraphView!
    var bltManager : BLTManager?
    var pulseTime : Timer?
    var heartRateNumber : Double?
    var animationCounter = Double(0)
    weak var ad = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        bltManager = BLTManager.shareInstance
        bltManager?.uiDelegate = self
        heartCircleView.layer.cornerRadius = heartCircleView.frame.width/2
        heartCircleView.layer.borderColor = UIColor.red.cgColor
        heartCircleView.layer.borderWidth = 1
        graphView.smoothDarkSetup()
        graphView.set([0], withLabels: [""])
         // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         fetchHeartRateData()
        bltManager?.uiDelegate = self
        bltManager?.getSteps()
        
    }
    override func didSwitchScreen() {
  
       
    }
    func didGetStep(_ step: String) {
        print(step)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    func fetchHeartRateData(){
        let fetchRequest = CoreDataFilter.getFetchResult(fromDate: Date().startOfToday(), toDate: Date().endOfTheDay(), forEntity: "Heartrate") as! NSFetchRequest<Heartrate>
        
        let sortDesc = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDesc]
        ad?.persistentContainer.performBackgroundTask({ (backGroundContext) in
            do{
                let result = try backGroundContext.fetch(fetchRequest)
                for item in result{
                    if let timeDescri = item.timestamp?.description {
                 //  print("HeartRate:\(item.heartrate),timeStamp:\(timeDescri)")
                    }
                }
                let heartData = result.map{heartModel in Double(heartModel.heartrate)}
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                let heartLabel = result.map{heartModel in dateFormatter.string(from:heartModel.timestamp! as Date) }
                DispatchQueue.main.async {
                    self.graphView.set(heartData, withLabels: heartLabel)
                }
                

            }
            catch{
                let err = error
                fatalError("failed to fetch heartrate \(err) ")
            }
        })
        
        
    }
    func didGetHeartRate(_ heartRate: String) {
        
        guard let heartrateModel = NSEntityDescription.insertNewObject(forEntityName: "Heartrate", into: (ad?.persistentContainer.viewContext)!) as? Heartrate else{return}
        guard let intHeartrate = Int32(heartRate) else { return  }
        heartrateModel.heartrate = intHeartrate
        heartrateModel.timestamp = Date()
        ad?.saveContext()
        hrLabel.text = "\(heartRate)"
        heartRateNumber = Double(heartRate)
        
        animationCounter = 0
        heartImage.layer.removeAllAnimations()
        doHeartBeat()

    }
    @IBAction func tempButtonAction(_ sender: UIButton) {
        bltManager?.getTemp()
    }
    func didGetTemp(_ temp: String) {
        tempLabel.text = temp
    }
    
    func doHeartBeat() {
        let layer = heartImage.layer
        let pulseAnimation = CABasicAnimation(keyPath:"transform.scale")
        pulseAnimation.toValue = Float(1.1)
        pulseAnimation.fromValue = Float(1.0)
        pulseAnimation.duration = 60 / heartRateNumber! / 2
        pulseAnimation.repeatCount = 20
        pulseAnimation.autoreverses = true
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        layer.add(pulseAnimation, forKey: "scale")
//        animationCounter += 60 / heartRateNumber!
//        if animationCounter < (5 / (60/heartRateNumber!)) {
//        pulseTime = Timer.scheduledTimer(timeInterval: 60 / heartRateNumber! , target: self, selector: #selector(doHeartBeat), userInfo: nil, repeats: false)
//        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ddf")
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
