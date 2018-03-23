//
//  ViewController.swift
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/03/09.
//  Copyright © 2018 hasi6363. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //var mIsPlaying:Bool = false
    var sg = SignalGenerator()
    
    @IBOutlet weak var mOutlet_Label: UILabel!
    @IBOutlet weak var mOutlet_Slider: UISlider!
    @IBOutlet weak var mOutlet_Button: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //mIsPlaying = false;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Action_SliderValueChanged(_ sender: UISlider)
    {
        sg.mFrequency = 2 * pow(10, sender.value)
        mOutlet_Label.text = sg.mFrequency.description
    }
    @IBAction func Action_ButtonTouchUp(_ sender: UIButton)
    {
        
        if(sg.mIsPlaying)
        {
            mOutlet_Button.setTitle("Play", for:UIControlState.normal)
            //sg.mIsPlaying = false;
            sg.stop()
        }
        else
        {
            mOutlet_Button.setTitle("Pause", for:UIControlState.normal);
            //mIsPlaying = true
            sg.play()
        }
    }
}

