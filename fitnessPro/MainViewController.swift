//
//  MainViewController.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/21/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController,BLTManagerDelegate {
   
    @IBOutlet weak var hrLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    var bltManager : BLTManager?
    var pulseTime : Timer?
    var heartRateNumber : Double?
    var animationCounter = Double(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        bltManager = BLTManager.shareInstance
        bltManager?.uiDelegate = self
        
        tabBarController?.tabBar.tintColor = UIColor.red
         // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didGetStep(step: String) {
    }
    func didGetHeartRate(heartRate: String) {
        hrLabel.text = "\(heartRate) BPM"
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
