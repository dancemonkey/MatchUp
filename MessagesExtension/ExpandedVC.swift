//
//  ExpandedVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/25/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

class ExpandedVC: MSMessagesAppViewController {
  
  @IBOutlet weak var rollButton: UIButton!
  @IBOutlet weak var resultLbl: UILabel!
  
  @IBOutlet weak var flipBtn: UIButton!
  @IBOutlet weak var flipResultLbl: UILabel!
  
  var d6Die: Die? = nil
  var coin: Coin? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    d6Die = Die(sides: 20)
    coin = Coin()
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
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
