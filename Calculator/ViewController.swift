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
   
    @IBAction func changeSign(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.rangeOfString("-") != nil {
                display.text = dropFirst(display.text!)
            } else {
                display.text = "-" + display.text!
            }
        } else {
            operate(sender)
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
        if displayValue != nil {
            displayValue = brain.pushOperand(displayValue!)
        }
    }
    
    @IBAction func reset() {
        displayValue = nil;
        brain.clearOps();
        history.text = "";
    }
    
    @IBAction func backspace() {
        if !userIsInTheMiddleOfTypingANumber {
            return
        }
        if countElements(display.text!) > 1 {
            display.text = dropLast(display.text!)
        } else {
            displayValue = nil
        }
    }
    
    private func appendHistory(text: String) {
        history.text = history.text! + " " + text;
    }
    
    var displayValue: Double? {
        get {
            if let number = NSNumberFormatter().numberFromString(display.text!) {
                return number.doubleValue
            }
            return nil
        }
        set {
            if newValue != nil {
                display.text = "\(newValue!)"
            } else {
                display.text = "0"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

