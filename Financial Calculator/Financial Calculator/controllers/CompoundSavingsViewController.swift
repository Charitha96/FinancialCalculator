//
//  FirstViewController.swift
//  Financial Calculator
//
//  Created by Charitha Rajapakse on 2/18/20.
//  Copyright © 2020 Charitha Rajapakse. All rights reserved.
//

import UIKit

class CompoundSavingsViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        loadDefaults()
    }
    @IBOutlet weak var presentValueTF: UITextField!
    @IBOutlet weak var futureValueTF: UITextField!
    @IBOutlet weak var paymentTF: UITextField!
    @IBOutlet weak var interestTF: UITextField!
    @IBOutlet weak var paymentsPerYearTF: UITextField!
    @IBOutlet weak var calcBtn: UIButton!
    @IBOutlet weak var endToggle: UISwitch!
    
    @IBOutlet weak var KeyBoard: KeyBoard!
    
    //zero if end, 1 if begin
    var savingsEndorBegin = 0
    
    func assignDelegates() {
        presentValueTF.delegate = self
        futureValueTF.delegate = self
        paymentTF.delegate = self
        interestTF.delegate = self
        paymentsPerYearTF.delegate = self
    
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        KeyBoard.activeTextField = textField
    }
    
    @IBAction func clearAll(_ sender: UIBarButtonItem) {
        presentValueTF.text = ""
        futureValueTF.text = ""
        paymentTF.text = ""
        interestTF.text = ""
        paymentsPerYearTF.text = ""
        
    }
    
    //setting and or begining
    @IBAction func EndSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){ //begin1
            savingsEndorBegin = 1
        }
        else if (sender.isOn == false){
            
            savingsEndorBegin = 0
        }
    }
    
    @IBAction func calculateCOmpSavings(_ sender: UIButton) {
        
        //saving user data
        let defaults = UserDefaults.standard
        defaults.set(presentValueTF.text, forKey: "presentCS")
        defaults.set(futureValueTF.text, forKey: "futureCS")
        defaults.set(paymentTF.text, forKey: "paymentCS")
        defaults.set(interestTF.text, forKey: "interestCS")
        defaults.set(paymentsPerYearTF.text, forKey: "yearsCS")
        defaults.synchronize()
        
        let presentValue :Double? = Double(presentValueTF.text!)
        let futureValue :Double? = Double(futureValueTF.text!)
        let paymentValue :Double? = Double(paymentTF.text!)
        let interestValue :Double? = Double(interestTF.text!)
        let noPaymentPerYearValue :Double? = Double(paymentsPerYearTF.text!)
        

        let firstCal = ((1.0 + ((Double(((interestValue) ?? 0.0) / 100.0) / 12.0))))
        let firstCalSec = ((noPaymentPerYearValue ?? 0.0) * (12.0))
        let firstPowerCal =  ((presentValue ?? 0.0) * (pow(firstCal, firstCalSec)))
        
        let secondCalUppermiddle = ((pow(firstCal, firstCalSec)) - 1.0)
        let secondCalUpperFinal = ((paymentValue ?? 0.0) * secondCalUppermiddle)
        let secondLowerCal = ((Double(((interestValue) ?? 0.0) / 100.0)) / 12.0)
        let secondFinal = (secondCalUpperFinal / secondLowerCal)
        
        if (presentValue == nil && futureValue != nil && paymentValue != nil && interestValue != nil && noPaymentPerYearValue != nil) {
            
            if (savingsEndorBegin == 0) { //end
                let paymentUpperFirst = ((Double((futureValue) ?? 0.0)) - (secondFinal * firstCal))
                let paymentFinal = (paymentUpperFirst / (pow(firstCal, firstCalSec)))
                let roundedeFinalLoanAmount = Double(round(100*paymentFinal)/100)

                //check answer contains negative values
                if((String(roundedeFinalLoanAmount).contains("-"))){
                        negativeNummbersValidation()
                } else {
                    presentValueTF.text = String(roundedeFinalLoanAmount)
                }
                
            } else {
                
                let paymentUpperFirst = ((Double((futureValue) ?? 0.0)) - secondFinal)
                let paymentFinal = (paymentUpperFirst / (pow(firstCal, firstCalSec)))
                let roundedeFinalLoanAmount = Double(round(100*paymentFinal)/100)
                
                //check answer contains negative values
                if((String(roundedeFinalLoanAmount).contains("-"))){
                        negativeNummbersValidation()
                } else {
                    presentValueTF.text = String(roundedeFinalLoanAmount)
                }
                
            }
            
        } else if (futureValue == nil && presentValue != nil && paymentValue != nil && interestValue != nil && noPaymentPerYearValue != nil) {
            
            if (savingsEndorBegin == 0) {
                let begincalcFinal = (firstPowerCal + (secondFinal * firstCal))
                let roundedeFinalLoanAmount = Double(round(100*begincalcFinal)/100)
                
                //check answer contains negative values
                if((String(roundedeFinalLoanAmount).contains("-"))){
                        negativeNummbersValidation()
                } else {
                    futureValueTF.text = String(roundedeFinalLoanAmount)
                }
                
            } else {
                
                let futureValFinal = (firstPowerCal + secondFinal)
                let roundedeFinalLoanAmount = Double(round(100*futureValFinal)/100)
                                
                //check answer contains negative values
                if((String(roundedeFinalLoanAmount).contains("-"))){
                        negativeNummbersValidation()
                } else {
                    futureValueTF.text = String(roundedeFinalLoanAmount)
                }
                
                
            }
            
        } else if (paymentValue == nil && presentValue != nil && futureValue != nil && interestValue != nil && noPaymentPerYearValue != nil) {
            if (savingsEndorBegin == 0) {
                
                let payValUpper = (((Double((futureValue) ?? 0.0)) - firstPowerCal) * secondLowerCal)
                let payValLower = (((pow(firstCal, firstCalSec)) - 1.0) * firstCal)
                let finalPayVal = (payValUpper / payValLower)
                let roundedeFinalLoanAmount = Double(round(100*finalPayVal)/100)
                                
                //check answer contains negative values
                if((String(roundedeFinalLoanAmount).contains("-"))){
                        negativeNummbersValidation()
                } else {
                    paymentTF.text = String(roundedeFinalLoanAmount)
                }
                
            } else {
                let payValUpper = (((Double((futureValue) ?? 0.0)) - firstPowerCal) * secondLowerCal)
                let payValLower = ((pow(firstCal, firstCalSec)) - 1.0)
                let finalPayVal = (payValUpper / payValLower)
                let roundedeFinalLoanAmount = Double(round(100*finalPayVal)/100)
                                
                //check answer contains negative values
                if((String(roundedeFinalLoanAmount).contains("-"))){
                        negativeNummbersValidation()
                } else {
                    paymentTF.text = String(roundedeFinalLoanAmount)
                }
                
            }
            
            
        } else if (interestValue == nil && presentValue != nil && futureValue != nil && paymentValue != nil && noPaymentPerYearValue != nil) {
            let alert = UIAlertController(title: "Error!", message: "Cannot Calculate. Try another TextField", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if (noPaymentPerYearValue == nil && presentValue != nil && futureValue != nil && paymentValue != nil && interestValue != nil) {
            if (savingsEndorBegin == 0) {
                let upperYearFirst = (((Double((futureValue) ?? 0.0)) * ((Double(interestValue ?? 0.0)) / 100.0)) / 12.0)
                let upperYearSecond = (((paymentValue ?? 0.0) * firstCal))
                let upperAll = (upperYearFirst + upperYearSecond)
                let upperDownFirst = (((Double((presentValue) ?? 0.0)) * ((Double(interestValue ?? 0.0)) / 100.0)) / 12.0)
                let upperDownAll = (upperDownFirst + upperYearSecond)
                let upperAllLog = (log(upperAll / upperDownAll))
                let downYear = (12.0 * log(firstCal))
                let finalNoPaymentPerYear = (upperAllLog / downYear)
                let roundedeFinalLoanAmount = Double(round(100*finalNoPaymentPerYear)/100)

                //check answer contains negative values
                if((String(roundedeFinalLoanAmount).contains("-"))){
                        negativeNummbersValidation()
                } else {
                    paymentsPerYearTF.text = String(roundedeFinalLoanAmount)
                }
                
            } else {
                let upperYearFirst = ((paymentValue ?? 0.0) * 12.0)
                let upperYearSecond = (upperYearFirst + ((Double((futureValue) ?? 0.0)) * ((Double(interestValue ?? 0.0)) / 100.0)))
                let upperYearDownFirst = ((presentValue ?? 0.0) * ((Double(interestValue ?? 0.0)) / 100.0))
                let upperYearDownSecond = (upperYearDownFirst + upperYearFirst)
                let lowerCalc = ((12.0) * log(firstCal))
                let finalYearCalc = (log(upperYearSecond / upperYearDownSecond) / lowerCalc)
                let roundedeFinalLoanAmount = Double(round(100*finalYearCalc)/100)
                
                //check answer contains negative values
                if((String(roundedeFinalLoanAmount).contains("-"))){
                        negativeNummbersValidation()
                } else {
                    paymentsPerYearTF.text = String(roundedeFinalLoanAmount)
                }
                
            }
        }
            
        else if (presentValue != nil && futureValue != nil && paymentValue != nil && interestValue != nil && noPaymentPerYearValue != nil ){
            let alert = UIAlertController(title: "Error!", message: "Clear a Text Field Calculate", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Error!", message: "Fill Text Fields toCalculate", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    //loading saved data
    func loadDefaults() {
        let defaults = UserDefaults.standard
        presentValueTF.text = defaults.object(forKey: "presentCS") as? String
        futureValueTF.text = defaults.object(forKey: "futureCS") as? String
        paymentTF.text = defaults.object(forKey: "paymentCS") as? String
        interestTF.text = defaults.object(forKey: "interestCS") as? String
        paymentsPerYearTF.text = defaults.object(forKey: "yearsCS") as? String
    }
    
    //check answer contains negative values
    func negativeNummbersValidation(){
        let alert = UIAlertController(title: "Error!", message: "Cannot be negative number. Check values again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
