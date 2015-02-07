//
//  ViewController.swift
//  Calculator
//
//  Created by Luu Gia Thuy on 1/2/15.
//  Copyright (c) 2015 Luu Gia Thuy. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        let isFloatingPoint = digit == "."
        if userIsInTheMiddleOfTypingANumber {
            let userHasTypedAFloatingPoint = display.text!.rangeOfString(".") != nil
            if isFloatingPoint && userHasTypedAFloatingPoint {
                return
            }
            display.text = display.text! + digit
        } else {
            userIsInTheMiddleOfTypingANumber = true
            if isFloatingPoint {
                display.text = "0."
            } else {
                display.text = digit
            }
        }
    }
   
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            appendHistory(operation)
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingANumber {
            appendHistory(display.text!)
        }
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func reset() {
        displayValue = 0;
        brain.clearOps();
        history.text = "";
    }
    
    func appendHistory(text: String) {
        history.text = history.text! + " " + text;
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

