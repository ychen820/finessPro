//
//  UIViewController+Alert.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/19/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//
import UIKit
typealias alertActionComplete = ((_ alertAction:UIAlertAction) -> Void)

extension UIViewController {
    func showAlert(_ message:String, title:String,comlete: alertActionComplete?) -> Void {
        let alertCon = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler:comlete)
        alertCon.addAction(alertAction)
        self.present(alertCon, animated: true, completion: nil)
    }
}
