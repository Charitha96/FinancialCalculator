//
//  ThirdViewController.swift
//  Financial Calculator
//
//  Created by Charitha Rajapakse on 2/18/20.
//  Copyright © 2020 Charitha Rajapakse. All rights reserved.
//
import UIKit


class LoansViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        loadDefaults()
    }
    @IBOutlet weak var principalAMountTF: UITextField!
    @IBOutlet weak var interstTF: UITextField!
    @IBOutlet weak var paymentsTF: UITextField!
    @IBOutlet weak var numberofPaymentTF: UITextField!
    
    @IBOutlet weak var KeyBoard: KeyBoard!
    
    func assignDelegates() {
        principalAMountTF.delegate = self
        interstTF.delegate = self
        paymentsTF.delegate = self
        numberofPaymentTF.delegate = self
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        KeyBoard.activeTextField = textField
    }
    
    @IBAction func clearAll(_ sender: UIBarButtonItem) {
        principalAMountTF.text = ""
        interstTF.text = ""
        paymentsTF.text = ""
        numberofPaymentTF.text = ""
    }
    
    
    @IBAction func loanCalculateBtn(_ sender: UIButton) {
        
        //saving user data
        let defaults = UserDefaults.standard
        defaults.set(principalAMountTF.text, forKey: "principalL")
        defaults.set(interstTF.text, forKey: "interstL")
        defaults.set(paymentsTF.text, forKey: "payL")
        defaults.set(numberofPaymentTF.text, forKey: "noPayL")
        defaults.synchronize()
        
        let principalAmountVal :Double? = Double(principalAMountTF.text!)
        let interestVal :Double? = Double(interstTF.text!)
        let paymentVal :Double? = Double(paymentsTF.text!)
        let noYearsVal :Double? = Double(numberofPaymentTF.text!)
        let interestVal1 = (Double(interestVal ?? 0.0) / 100.0)
        
        //calculation payment and loan amount
        let upperCalc = (((principalAmountVal) ?? 0.0) * (((interestVal ?? 0.0) / 100.0) / 12.0) )
        let lowerFirst = ((1.0 + (((Double((interestVal) ?? 0.0) / 100.0) / 12.0))))
        let lowerThird = (-((noYearsVal ?? 0.0) * (12.0)))
        let lowerPower = pow(lowerFirst, lowerThird)
        let lowerFinal = ((1.0 - lowerPower))
        let princiUpperFinal = ((((paymentVal) ?? 0.0) * lowerFinal) * 12.0)
        
        if (principalAmountVal == nil && interestVal != nil && paymentVal != nil && noYearsVal != nil) {
            let princiFinal = ((princiUpperFinal) / interestVal1)
            let roundedeFinalPrincipalAmount = Double(round(100*princiFinal)/100)
            
            //check answer contains negative values
            if((String(roundedeFinalPrincipalAmount).contains("-"))){
                    negativeNummbersValidation()
            } else {
                principalAMountTF.text = String(roundedeFinalPrincipalAmount)
            }
            
            
            
        } else if (interestVal == nil && principalAmountVal != nil && paymentVal != nil && noYearsVal != nil) {
            let alert = UIAlertController(title: "Error!", message: "Cannot Calculate. Try another TextField", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if (paymentVal == nil && principalAmountVal != nil && interestVal != nil && noYearsVal != nil) {
            let finalPayment = upperCalc / lowerFinal
            let roundedeFinalPayment = Double(round(100*finalPayment)/100)
            
            //check answer contains negative values
            if((String(roundedeFinalPayment).contains("-"))){
                    negativeNummbersValidation()
            } else {
                paymentsTF.text = String(roundedeFinalPayment)
            }
            
            
            
        } else if (noYearsVal == nil && principalAmountVal != nil && interestVal != nil && paymentVal != nil) {
            let noYearsUpperLog = log(1.0 / (1.0 - (upperCalc / (paymentVal ?? 0.0))))
            let noYearsDownLog = (12.0 * log((lowerFirst)))
            let finalCalcYears = (noYearsUpperLog / noYearsDownLog)
            let roundedYearsPayment = Double(round(100*finalCalcYears)/100)
            
            //check answer contains negative values
            if((String(roundedYearsPayment).contains("-"))){
                    negativeNummbersValidation()
            } else {
                numberofPaymentTF.text = String(roundedYearsPayment)
            }
            
            
        } else if (principalAmountVal != nil && interestVal != nil && paymentVal != nil && noYearsVal != nil){
            let alert = UIAlertController(title: "Error!", message: "Clear a Text Field Calculate", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Error!", message: "Fill Text Fields to Calculate", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //loading saved data
    func loadDefaults() {
        let defaults = UserDefaults.standard
        principalAMountTF.text = defaults.object(forKey: "principalL") as? String
        interstTF.text = defaults.object(forKey: "interstL") as? String
        paymentsTF.text = defaults.object(forKey: "payL") as? String
        numberofPaymentTF.text = defaults.object(forKey: "noPayL") as? String
    }
    
    //check answer contains negative values
    func negativeNummbersValidation(){
        let alert = UIAlertController(title: "Error!", message: "Cannot be negative number. Check values again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

