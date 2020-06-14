//
//  SecondViewController.swift
//  Financial Calculator
//
//  Created by Charitha Rajapakse on 2/18/20.
//  Copyright © 2020 Charitha Rajapakse. All rights reserved.
//

import UIKit

class SavingsViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        loadDefaults()
    }

    @IBOutlet weak var futureValueTF: UITextField!
    @IBOutlet weak var principalAmountTF: UITextField!
    @IBOutlet weak var interstTF: UITextField!
    @IBOutlet weak var NoYearsTF: UITextField!
    
    @IBOutlet weak var keyBoard: KeyBoard!
    

    func assignDelegates() {
        futureValueTF.delegate = self
        principalAmountTF.delegate = self
        interstTF.delegate = self
        NoYearsTF.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyBoard.activeTextField = textField
    }
    
    @IBAction func calculateBtn(_ sender: UIButton) {
        
        //saving user data
        let defaults = UserDefaults.standard
        defaults.set(futureValueTF.text, forKey: "futureS")
        defaults.set(principalAmountTF.text, forKey: "principalS")
        defaults.set(interstTF.text, forKey: "painterestSy")
        defaults.set(NoYearsTF.text, forKey: "yearsS")
        defaults.synchronize()
        
        let futureVal :Double? = Double(futureValueTF.text!)
        let principalAmountVal :Double? = Double(principalAmountTF.text!)
        let interestVal :Double? = Double(interstTF.text!)
        let noYearsVal :Double? = Double(NoYearsTF.text!)
        
        //calculation payment and loan amount
        let lowerFirst = ((1.0 + (((Double((interestVal) ?? 0.0) / 100.0) / 12.0))))
        let lowerThird = (((noYearsVal ?? 0.0) * (12.0)))
        let lowerPower = pow(lowerFirst, lowerThird)
        let firstSet = ((futureVal ?? 0.0) / (principalAmountVal ?? 0.0))
 
        if (futureVal == nil && principalAmountVal != nil  && interestVal != nil && noYearsVal != nil) {
            let finalVal = ((principalAmountVal ?? 0.0) * lowerPower)
            let roundedeFinalFutureAmount = Double(round(100*finalVal)/100)
            //check answer contains negative values
            if((String(roundedeFinalFutureAmount).contains("-"))){
                negativeNummbersValidation()
            } else {
                futureValueTF.text = String(roundedeFinalFutureAmount)
            }
            
        } else if (principalAmountVal == nil && futureVal != nil && interestVal != nil && noYearsVal != nil) {
            let finalPrinciVal = ((futureVal ?? 0.0) / lowerPower)
            let roundedeFinalprincipalAmount = Double(round(100*finalPrinciVal)/100)
            //check answer contains negative values
            if((String(roundedeFinalprincipalAmount).contains("-"))){
                negativeNummbersValidation()
            } else {
                principalAmountTF.text = String(roundedeFinalprincipalAmount)
            }
                   
        } else if (interestVal == nil && futureVal != nil && principalAmountVal != nil && noYearsVal != nil) {
            
            let inversePower = (1.0 / (lowerThird))
            let finalinterestVal = ((12.0 * ((pow(firstSet, inversePower)) - 1 )) * 100.0)
            
            let roundedeFinalinterestAmount = Double(round(100*finalinterestVal)/100)
            //check answer contains negative values
            if((String(roundedeFinalinterestAmount).contains("-"))){
                negativeNummbersValidation()
            } else {
                interstTF.text = String(roundedeFinalinterestAmount)
            }
            
        } else if (noYearsVal == nil && futureVal != nil && principalAmountVal != nil && interestVal != nil) {
            let upperLog = (log(firstSet))
            let lowerLeg = (12.0 * (log(lowerFirst)))
            let finalYearsVal = ((upperLog) / (lowerLeg))
            let roundedeFinalNoYearsAmount = Double(round(100*finalYearsVal)/100)
            //check answer contains negative values
            if((String(roundedeFinalNoYearsAmount).contains("-"))){
                negativeNummbersValidation()
            } else {
                NoYearsTF.text = String(roundedeFinalNoYearsAmount)

            }
            
        } else if (futureVal != nil && principalAmountVal != nil && interestVal != nil && noYearsVal != nil){
            let alert = UIAlertController(title: "Error!", message: "Clear a Text Field Calculate", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Error!", message: "Fill Text Fields to Calculate", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func clearAllBtn(_ sender: UIBarButtonItem) {
        futureValueTF.text = ""
        principalAmountTF.text = ""
        interstTF.text = ""
        NoYearsTF.text = ""

    }
    
    //loading saved data
    func loadDefaults() {
        let defaults = UserDefaults.standard
        futureValueTF.text = defaults.object(forKey: "futureS") as? String
        principalAmountTF.text = defaults.object(forKey: "principalS") as? String
        interstTF.text = defaults.object(forKey: "painterestSy") as? String
        NoYearsTF.text = defaults.object(forKey: "yearsS") as? String
    }
    
    func negativeNummbersValidation(){
        let alert = UIAlertController(title: "Error!", message: "Cannot be negative number. Check values again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

