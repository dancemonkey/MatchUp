//
//  ExpandedVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/25/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

enum RPSChoice: String {
  case Rock, Paper, Scissors
}

class ExpandedVC: MSMessagesAppViewController {
  
  @IBOutlet weak var rollButton: UIButton!
  @IBOutlet weak var resultLbl: UILabel!
  
  @IBOutlet weak var flipBtn: UIButton!
  @IBOutlet weak var flipResultLbl: UILabel!
  
  @IBOutlet weak var rpsSgmt: UISegmentedControl!
  @IBOutlet weak var tossBtn: UIButton!
  
  var d6Die: Die? = nil
  var coin: Coin? = nil
  var rpsChoice: RPSChoice? = nil {
    didSet {
      tossBtn.setTitle(rpsChoice?.rawValue, for: .normal)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    d6Die = Die(sides: 20)
    coin = Coin()
    rpsSgmt.addTarget(self, action: #selector(ExpandedVC.rpsSelectionMade(sender:)), for: .valueChanged)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func rollPressed(sender: UIButton) {
    resultLbl.text = "Result: \(d6Die!.roll())"
  }
  
  @IBAction func flipPressed(sender: UIButton) {
    flipResultLbl.text = "Result: \(coin!.flip())"
  }
  
  func rpsSelectionMade(sender: UISegmentedControl) {
    rpsChoice = RPSChoice(rawValue: sender.titleForSegment(at: sender.selectedSegmentIndex)!)
    print(rpsChoice)
  }
  
  @IBAction func tossPressed(sender: UIButton) {
    guard let choice = rpsChoice else {
      return
      // Popup alert controller telling dummy to make a selection before trying to send
    }
    
    // handle sending RPS choice to next player here
    print("You chose and sent \(choice.rawValue) in your game of Rock Paper Scissors")
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
