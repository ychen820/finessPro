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
   
    @IBOutlet weak var hrLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var aLabel : UILabel!
    @IBOutlet weak var heartCircleView : UIView!
    @IBOutlet weak var graphView : UIView!
    var bltManager : BLTManager?
    var pulseTime : Timer?
    var heartRateNumber : Double?
    var animationCounter = Double(0)
    weak var ad = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        bltManager = BLTManager.shareInstance
        bltManager?.uiDelegate = self
        tabBarController?.tabBar.tintColor = UIColor.red
        heartCircleView.layer.cornerRadius = heartCircleView.frame.width/2
        heartCircleView.layer.borderColor = UIColor.red.cgColor
        heartCircleView.layer.borderWidth = 1
         // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchHeartRateData()
    }
    func didGetStep(_ step: String) {
    }

    func fetchHeartRateData(){
        let fetchRequest = Heartrate.fetchRequest() as! NSFetchRequest<Heartrate>
        let sortDesc = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDesc]
        ad?.persistentContainer.performBackgroundTask({ (backGroundContext) in
            do{
                let result = try backGroundContext.fetch(fetchRequest)
                for item in result{
                    if let timeDescri = item.timestamp?.description {
                   print("HeartRate:\(item.heartrate),timeStamp:\(timeDescri)")
                    }
                }
                let heartData = result.map{heartModel in Double(heartModel.heartrate)}
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                let heartLabel = result.map{heartModel in dateFormatter.string(from:heartModel.timestamp! as Date) }
                DispatchQueue.main.async {
                    let graphView = ScrollableGraphView(frame: self.graphView.frame)
                    graphView.smoothDarkSetup()
                    graphView.set(heartData, withLabels: heartLabel)
                    
                    self.view .addSubview(graphView)
                }
                

            }
            catch{
                let err = error
                fatalError("failed to fetch heartrate \(err) ")
            }
        })

//        do{
//            if let result = try ad?.persistentContainer.viewContext.fetch(fetchRequest){
//            for heartRate in result{
//                print("Heartrate:\(heartRate.heartrate) timeStamp:\(String(describing: heartRate.timestamp?.description))")
//            }
//            }
//         }
//        catch{
//            let err = error as NSError
//            fatalError("Unresolved error \(err), \(err.userInfo)")
//        }
    
        
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
