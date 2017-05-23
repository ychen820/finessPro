//
//  CustomPageViewController.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/22/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit

class CustomPageViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
  
var pageContainer = DAPagesContainer()
    override func viewDidLoad() {
        super.viewDidLoad()
        pageContainer.topBarHeight = 60
        pageContainer.willMove(toParentViewController: self)
        pageContainer.view.frame = self.view.bounds
        pageContainer.view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        view.addSubview(pageContainer.view)
        pageContainer.didMove(toParentViewController: self)
                var controllers = Array<Any>()
        
        guard let heartRateController = storyboard?.instantiateViewController(withIdentifier: "heartVC") else{
            return
        }
        
        guard let someOtherControler = storyboard?.instantiateViewController(withIdentifier: "secondView") else{
            return
        }
        
        someOtherControler.title = "SomeTitle"
        
        controllers.append(heartRateController)
        controllers.append(someOtherControler)
        
        pageContainer.viewControllers = controllers

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
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
