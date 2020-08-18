//
//  ViewController.swift
//  RetirementCalculator
//
//  Created by Macbook on 2020-08-02.
//  Copyright © 2020 Elliott. All rights reserved.
//

import UIKit
import AppCenterCrashes
import AppCenterAnalytics

class ViewController: UIViewController {
    @IBOutlet weak var monthlyInvestmenentTextField: UITextField!
    @IBOutlet weak var currentAgeTextField: UITextField!
    @IBOutlet weak var retirementAgeTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var savingsTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if MSCrashes.hasCrashedInLastSession() {
            let alert = UIAlertController(title: "Oops", message: "Sorry about that, an error occured", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "It's cool", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        MSAnalytics.trackEvent("navigate_to_calculator")
    }

    @IBAction func calculateButtonClicked(_ sender: Any) {
        //MSCrashes.generateTestCrash()
        guard let currentAge = Int(self.currentAgeTextField.text!) else { return }
        guard let plannedRetirementAge = Int(self.retirementAgeTextField.text!) else { return }
        guard let monthlyInvestement = Float(self.monthlyInvestmenentTextField.text!) else { return }
        guard let currentSavings = Float(self.savingsTextField.text!) else { return }
        guard let interestRate = Float(self.interestRateTextField.text!) else { return }

        let retirementAmount = calculateRetiementAmount(currentAge, plannedRetirementAge, monthlyInvestement, currentSavings, interestRate)

        self.resultLabel.text = "If you wanna save $\(monthlyInvestement) every monyj for \(plannedRetirementAge - currentAge) years, and invest that money plus your current investement of \(currentSavings) at a \(interestRate)% anual interst rate, you will have $\(retirementAmount) by the time you are \(plannedRetirementAge)"

        let propreties = ["current_age": String(currentAge),
                          "planned_retirement_age": String(plannedRetirementAge)]
        MSAnalytics.trackEvent("calculate_retirement_amount", withProperties: propreties)
    }

    func calculateRetiementAmount(_ currentAge: Int, _ retirementAge: Int, _ monthlyInvestement: Float, _ currentSavings: Float, _ interestRate: Float) -> Double {
        let monthsUntilRetirement = (retirementAge - currentAge) * 12
        var retirementAmount = Double(currentSavings) * pow(Double(1 + interestRate / 100), Double(monthsUntilRetirement))

        for i in 1...monthsUntilRetirement {
            let monthlyRate = interestRate / 100 / 12
            retirementAmount += Double(monthlyInvestement) * pow(Double(1 + monthlyRate), Double(i))
        }
        return retirementAmount
    }
}

