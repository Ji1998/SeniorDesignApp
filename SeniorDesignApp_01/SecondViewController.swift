//
//  SecondViewController.swift
//  SeniorDesignApp_01
//
//  Created by Steven on 11/22/19.
//  Copyright © 2019 Steven. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase



class SecondViewController: UIViewController {
    
    @IBOutlet weak var gfSwitch: UISwitch!
    @IBOutlet weak var gfStepper: UIStepper!
    @IBOutlet weak var gfLabel: UILabel!
    
    @IBOutlet weak var BatteryLabel: UILabel!
  
    static var gfOn = false
    static var gfR = Double(0)
    
    var ref2 : DatabaseReference!
    var BatteryRef: DatabaseReference!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        gfLabel.text = String(format: "%.0f m", gfStepper.value)
        
        self.ref2 = Database.database().reference().child("Test").child("Battery").child("inventory").child("AppTest")
        _ = ref2.observe(DataEventType.value, with: { (snapshot) in
                  let battery = snapshot.value as? [String : AnyObject] ?? [:]
                  print(battery["data"] as! String)
            self.BatteryLabel.text = battery["data"] as! String + " %"
                
                  
              })
        
        
        
    }
    
    @IBAction func gfStepperAct(_ sender: Any) {
        
        let value = String(format: "%d m", Int(gfStepper.value))
        gfLabel.text = value
        
        SecondViewController.gfR = gfStepper.value
       
    }
    
    @IBAction func gfSwitchAct(_ sender: Any) {
        SecondViewController.gfOn = gfSwitch.isOn
        if gfSwitch.isOn {
            gfStepper.isEnabled = true
        } else {
            gfStepper.isEnabled = false
        }
        
    }
    
    
    
    
    


}
