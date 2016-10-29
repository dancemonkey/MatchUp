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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showCoinGame" {
      if let destVC = segue.destination as? CoinFlipVC {
        destVC.gameState = .flip
        destVC.convo = self.activeConversation
        destVC.message = self.activeConversation?.selectedMessage
      }
    }
  }

}
