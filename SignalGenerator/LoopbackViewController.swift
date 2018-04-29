//
//  LoopbackViewController.swift
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/04/29.
//  Copyright © 2018 hasi6363. All rights reserved.
//

import UIKit

class LoopbackViewController: UITableViewController
{
    @IBOutlet weak var Button: UIButton!
    var lb = Loopback()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    @IBAction func StartButton_TouchUpInside(_ sender: UIButton)
    {
        if(lb.isPlaying)
        {
            lb.stop()
            Button.setTitle("Play", for:UIControlState.normal)

        }
        else
        {
            lb.start()
            Button.setTitle("Pause", for:UIControlState.normal)

        }
            }
}
