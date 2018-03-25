//
//  ViewController.swift
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/03/09.
//  Copyright © 2018 hasi6363. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIGestureRecognizerDelegate
{
    var sg = SignalGenerator()

    @IBOutlet weak var mTextField: UITextField!
    @IBOutlet weak var mSlider: UISlider!
    @IBOutlet weak var mButton: UIButton!
    @IBOutlet weak var Stepper: UIStepper!
    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        updateFrequency(frequency:440)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }

    func updateFrequency(frequency:Double)
    {
        sg.audioInfo.frequency = frequency
        mTextField.text = Int(sg.audioInfo.frequency).description
        mSlider.value = log10(Float(sg.audioInfo.frequency) / 2.0)
        //mSlider.value = Float(sg.mFrequency)
        Stepper.value = sg.audioInfo.frequency
    }

    @IBAction func TextField_EditingDidBegin(_ sender: UITextField)
    {
        sender.text = Int(sender.text!)?.description
    }

    @IBAction func TextField_EditingChanged(_ sender: UITextField)
    {
        
    }
    @IBAction func TextField_EditingDidEnd(_ sender: UITextField)
    {
        updateFrequency(frequency:  NSString(string: sender.text!).doubleValue)
    }
    @IBAction func TextField_DidEndOnExit(_ sender: UITextField)
    {
        updateFrequency(frequency:  NSString(string: sender.text!).doubleValue)
    }
    @IBAction func mSlider_ValueChanged(_ sender: UISlider)
    {
        //updateFrequency(frequency: Double(sender.value))
        updateFrequency(frequency: Double(2.0*pow(10,sender.value)))
    }

    @IBAction func Stepper_ValueChanged(_ sender: UIStepper)
    {
        if(sender.value - sg.audioInfo.frequency > 0)
        {
            updateFrequency(frequency: pow(10, log10(sg.audioInfo.frequency) + log10(2) / 3))
        }
        else
        {
            updateFrequency(frequency: pow(10, log10(sg.audioInfo.frequency) - log10(2) / 3))
        }
        
    }
    @IBAction func mButton_TouchUpInside(_ sender: UIButton)
    {
        if(sg.isPlaying)
        {
            mButton.setTitle("Play", for:UIControlState.normal)
            sg.stop()
        }
        else
        {
            mButton.setTitle("Pause", for:UIControlState.normal);
            sg.play()
        }
    }
}

