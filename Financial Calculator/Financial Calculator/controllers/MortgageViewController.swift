//
//  FourthViewController.swift
//  Financial Calculator
//
//  Created by Charitha Rajapakse on 2/18/20.
//  Copyright © 2020 Charitha Rajapakse. All rights reserved.
//
import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        loadDefaults()
         
    }
    
    @IBOutlet weak var loanAmountTF: UITextField! //P
    @IBOutlet weak var interestTF: UITextField! //i monthly interst
    @IBOutlet weak var paymentTF: UITextField! //M1
    @IBOutlet weak var noYearsTF: UITextField! //L in months
    var historyStringArray : [String] = []
    
    @IBOutlet weak var KeyBoard: KeyBoard!
    
   func assignDelegates() {
       loanAmountTF.delegate = self
       interestTF.delegate = self
       paymentTF.delegate = self
       noYearsTF.delegate = self
       
   }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        KeyBoard.activeTextField = textField
    }
    
    //clear all data
    @IBAction func clearAll(_ sender: UIBarButtonItem) {
        loanAmountTF.text = ""
        interestTF.text = ""
        paymentTF.text = ""
        noYearsTF.text = ""
    }
    
    @IBAction func calculateMortgage(_ sender: UIButton) {
        
        //saving user data
        let defaults = UserDefaults.standard
        defaults.set(loanAmountTF.text, forKey: "loan")
        defaults.set(interestTF.text, forKey: "interst")
        defaults.set(paymentTF.text, forKey: "pay")
        defaults.set(noYearsTF.text, forKey: "years")
        defaults.synchronize()
        
        
        let loanAmountVal :Double? = Double(loanAmountTF.text!)
        let interestVal :Double? = Double(interestTF.text!)
        let paymentVal :Double? = Double(paymentTF.text!)
        let noYearsVal :Double? = Double(noYearsTF.text!)
        let interestVal1 = (Double(interestVal ?? 0.0) / 100.0)
        
        //calculation payment and loan amount
        let upperFirst = ((((loanAmountVal) ?? 0.0) * ((interestVal ?? 0.0) / 100.0)) / 12.0)
        let upperSecond = ((1.0 + ((Double(((interestVal) ?? 0.0) / 100.0) / 12.0))))
        let upperThird = ((noYearsVal ?? 0.0) * (12.0))
        let upperPower = pow(upperSecond, upperThird)
        let upperFinal = upperFirst * upperPower
        let lowerFinal = upperPower - 1.0
        
        //calculations and TF view
         if (loanAmountVal == nil && interestVal != nil && paymentVal != nil && noYearsVal != nil) {
            let loanFinal = ((((paymentVal ?? 0.0) * lowerFinal) * 12.0) / (upperPower * (interestVal1)))
            let roundedeFinalLoanAmount = Double(round(100*loanFinal)/100)
            
            //check answer contains negative values
            if((String(roundedeFinalLoanAmount).contains("-"))){
                    negativeNummbersValidation()
            } else {
                loanAmountTF.text = String(roundedeFinalLoanAmount)
            }
            
        } else if (interestVal == nil && loanAmountVal != nil && paymentVal != nil && noYearsVal != nil) {
            let alert = UIAlertController(title: "Error!", message: "Cannot Calculate. Try another TextField", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if (paymentVal == nil && loanAmountVal != nil && interestVal != nil && noYearsVal != nil) {
            let finalPayment = upperFinal / lowerFinal
            let roundedeFinalPayment = Double(round(100*finalPayment)/100)
            
            //check answer contains negative values
            if((String(roundedeFinalPayment).contains("-"))){
                    negativeNummbersValidation()
            } else {
                paymentTF.text = String(roundedeFinalPayment)
            }
            
        } else if (noYearsVal == nil && loanAmountVal != nil && interestVal != nil && paymentVal != nil) {
            let alert = UIAlertController(title: "Error!", message: "Cannot Calculate. Try another TextField", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if (loanAmountVal != nil && interestVal != nil && paymentVal != nil && noYearsVal != nil){
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
        loanAmountTF.text = defaults.object(forKey: "loan") as? String
        interestTF.text = defaults.object(forKey: "interst") as? String
        paymentTF.text = defaults.object(forKey: "pay") as? String
        noYearsTF.text = defaults.object(forKey: "years") as? String
    }
    
    //check answer contains negative values
    func negativeNummbersValidation(){
        let alert = UIAlertController(title: "Error!", message: "Cannot be negative number. Check values again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

//button design
extension UIButton {
    open override func draw(_ rect: CGRect) {
        //provide custom style
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
