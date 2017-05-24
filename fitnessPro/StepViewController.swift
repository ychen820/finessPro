//
//  StepViewController.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/22/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import MKRingProgressView
class StepViewController: UIViewController,BLTManagerDelegate{
    var ringProgressView:MKRingProgressView! = nil
    var bltManager : BLTManager?
    @IBOutlet weak var progressView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ringProgressView = MKRingProgressView(frame: progressView.frame)
        ringProgressView.startColor = .red
        ringProgressView.endColor = .magenta
        ringProgressView.ringWidth = 25
        ringProgressView.progress = 0
        view.addSubview(ringProgressView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bltManager?.uiDelegate = self
        print(bltManager)
        bltManager?.getSteps()
        ringProgressView.progress = 0
        delay(1.0) {
            self.ringProgressView.progress = 1.5
        }

  
    }
    func didGetStep(_ step: String) {
    
            print(step)
        
    }
    func didGetHeartRate(_ heartRate: String) {
        
    }
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("will appeear")
    }
    @IBAction func buttonAction(_ sender: UIButton) {
        bltManager?.getSteps()
        
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
