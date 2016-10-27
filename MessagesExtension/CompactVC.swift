//
//  CompactVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/25/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

class CompactVC: MSMessagesAppViewController {
  
  @IBOutlet weak var coinBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func coinPressed(sender: UIButton) {
    Utils.animateButton(sender, withTiming: 0.05) {
      self.performSegue(withIdentifier: "showCoinGame", sender: self)
    }
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
