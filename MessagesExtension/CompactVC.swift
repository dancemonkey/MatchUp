//
//  CompactVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/25/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

class CompactVC: UIViewController {
  
  @IBOutlet weak var playBtn: UIButton!
  @IBOutlet weak var tutorialSwitch: UISwitch!
  
  var delegate: ExpandViewDelegate? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func playPressed(sender: UIButton) {
    Utils.animateButton(sender, withTiming: 0.05) {
      self.delegate?.expand(toPresentationStyle: .expanded, tutorial: self.tutorialSwitch.isOn)
    }
  }
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "showDiceGame" {
//      if let destVC = segue.destination as? DiceGameVC {
//        destVC.messageDelegate = self.parent! as? DiceGameDelegate
//        destVC.tutorialOn = tutorialSwitch.isOn
//        print("Switch is on = \(tutorialSwitch.isOn)")
//      }
//    }
//  }

}
