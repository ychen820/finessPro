//
//  BlackCustomNav.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/29/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit

class BlackCustomNav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationBar.barStyle = .blackOpaque
        navigationBar.isTranslucent = false
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
