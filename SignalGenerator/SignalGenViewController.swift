//
//  ViewController.swift
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/03/09.
//  Copyright © 2018 hasi6363. All rights reserved.
//

import UIKit

class SignalGenViewController: UITableViewController, UIGestureRecognizerDelegate
{
    var sg = SignalGenerator()

    @IBOutlet weak var freqTextField: UITextField!
    @IBOutlet weak var freqSlider: UISlider!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var freqStepper: UIStepper!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var volTextField: UITextField!
    @IBOutlet weak var volStepper: UIStepper!
    @IBOutlet weak var volSlider: UISlider!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignalGenViewController.dismissKeyboard(_:)))
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

    
    //freqTextField
    func convertToExp(frequency:Double) -> Double
    {
        // 2000 -> 3
        return log10(frequency / 2.0)
    }
    
    func convertToFrequency(exp:Double) ->Double
    {
        // 3 -> 2000
        return 2.0 * pow(10, exp)
    }
    
    func updateFrequency(frequency:Double)
    {
        sg.audioInfo.frequency = frequency
        freqTextField.text = Int(sg.audioInfo.frequency).description
        freqSlider.value = Float(convertToExp(frequency: sg.audioInfo.frequency))
        freqStepper.value = convertToExp(frequency: sg.audioInfo.frequency)
    }
    
    @IBAction func freqTextField_EditingDidBegin(_ sender: UITextField)
    {
        sender.text = Int(sender.text!)?.description
    }
    
    @IBAction func freqTextField_Update(_ sender: UITextField)
    {
        updateFrequency(frequency:  NSString(string: sender.text!).doubleValue)
    }
    @IBAction func freqSlider_ValueChanged(_ sender: UISlider)
    {
        //updateFrequency(frequency: Double(2.0 * pow(10,sender.value)))
        updateFrequency(frequency: convertToFrequency(exp: Double(sender.value)))
    }
    @IBAction func freqStepper_ValueChanged(_ sender: UIStepper)
    {
        updateFrequency(frequency: convertToFrequency(exp: sender.value))
    }
    
    // volTextField
    func convertToDb(value:Double)->Double
    {
        return log10(value) * 20.0
    }
    func convertToLinear(db:Double)->Double
    {
        return pow(10,db / 20.0);
    }
    func updateVolume(volume:Double)
    {
        sg.audioInfo.volume = volume
        volTextField.text = String(format:"%.2f",convertToDb(value: sg.audioInfo.volume))
        volSlider.value = Float(convertToDb(value: sg.audioInfo.volume))
        volStepper.value = Double(convertToDb(value: sg.audioInfo.volume))
    }
    @IBAction func volTextField_EditingDidBegin(_ sender: UITextField)
    {
        //sender.text = Int(sender.text!)?.description
        sender.text = String(format:"%.2f",Double(sender.text!)!)
    }
    @IBAction func volTextField_Update(_ sender: UITextField)
    {
        updateVolume(volume: NSString(string: sender.text!).doubleValue)
    }
    @IBAction func volSlider_ValueChanged(_ sender: UISlider) {
        updateVolume(volume: convertToLinear(db: Double(sender.value)))
    }
    @IBAction func volStepper_ValueChanged(_ sender: UIStepper) {
        updateVolume(volume:convertToLinear(db: Double(sender.value)))
    }
    @IBAction func playButton_TouchUpInside(_ sender: UIButton)
    {
        if(sg.isPlaying)
        {
            playButton.setTitle("Play", for:UIControlState.normal)
            sg.stop()
        }
        else
        {
            playButton.setTitle("Pause", for:UIControlState.normal);
            sg.start()
        }
    }
}

