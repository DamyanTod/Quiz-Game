//
//  SecondViewController.swift
//  Famous Quote Quiz
//
//  Created by admin on 12/7/15.
//  Copyright © 2015 Oraganization. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var switches: [UISwitch]!

    private let model = DatabaseManager.sharedModel
    
    @IBAction func changedSwitch(sender: UISwitch) {
        
        setAllSwiches(sender, switches: switches)
        
    }

    private func setAllSwiches (sender : UISwitch , switches : [UISwitch]) {
        
        for switchMode in switches {
            if switchMode !== sender {
                if sender.on {
                    switchMode.setOn(false, animated: true)
                } else {
                    switchMode.setOn(true, animated: true)
                }
            }
        }
        model.mode = getMode()
    }
    
    private func getMode () -> String {
        var result = ""
        
        for switchMode in switches {
            if switchMode.on {
                if let idetifier = switchMode.restorationIdentifier {
                    result = idetifier
                }
            }
        }
        
        return result
    }
    
}


