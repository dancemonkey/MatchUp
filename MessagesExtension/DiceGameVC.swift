//
//  DiceGameVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 11/5/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

class DiceGameVC: UIViewController {
  
  var delegate: ExpandViewDelegate? = nil
  var messageDelegate: DiceGameDelegate? = nil
  var game: SCCGame? = nil
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var playBtn: UIButton!
  @IBOutlet var rollIndicator: [UIImageView]!       // Switch based on which roll you're currently doing
  @IBOutlet var targetRollIndicator: [UIImageView]! // Ship, Cap, and Crew icons, indicate achievement
  @IBOutlet var dieIndicator: [UIButton]!           // Indicate held or "frozen" dice, and switch based on roll result
  @IBOutlet weak var turnScoreLbl: UILabel!
  @IBOutlet weak var totalScoreLbl: UILabel!
  @IBOutlet weak var rollDiceBtn: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    if delegate != nil, delegate?.getPresentationStyle() != .expanded {
      delegate!.expand(toPresentationStyle: .expanded)
    }
    
    if game == nil {
      setupForNewGame()
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if delegate?.getPresentationStyle() == .compact {
      hideAllViews()
    } else {
      showAllViews()
    }
  }
  
  func setupForNewGame() {
    game = SCCGame()
    rollDiceBtn.setTitle("PLAY!", for: .normal)
    for view in targetRollIndicator {
      view.alpha = 0.2
    }
    for view in rollIndicator {
      view.image = UIImage(named: "EmptyRollInd")
    }
    for view in dieIndicator {
      view.alpha = 1.0
    }
    for die in dieIndicator {
      die.setImage(UIImage(named: "1"), for: .normal)
    }
  }
  
  func hideAllViews() {
    for subview in view.subviews {
      subview.isHidden = true
    }
    playBtn.isHidden = false
    titleLbl.isHidden = false
  }
  
  func showAllViews() {
    for subview in view.subviews {
      subview.isHidden = false
    }
    playBtn.isHidden = true
    titleLbl.isHidden = true
  }
  
  // MARK: - Game Buttons
  
  @IBAction func playBtnTapped(sender: UIButton) {
    delegate?.expand(toPresentationStyle: .expanded)
  }
  
  @IBAction func dieButtonTapped(sender: UIButton) {
    
    let die = game?.currentDice[sender.tag]
    
    guard die?.frozen == false else {
      game?.unHold(die: die!)
      dieIndicator[sender.tag].alpha = 1.0
      return
    }
    
    if (game?.hold(die: die!, atIndex: sender.tag))! {
      dieIndicator[sender.tag].alpha = 0.2
    }
    
  }
  
  @IBAction func rollTapped(sender: UIButton) {
    
    guard sender.titleLabel?.text == "SEND" else {
      if let result = game?.roll() {
        setDieFaces(forRollResult: result)
        setRollIndicator(forRoll: (game?.totalRolls)!)
      }
      return
    }
    
    if let score = game?.score {
      endRound(withScore: score)
    }
    
  }
  
  // MARK: Game Actions
  
  func setDieFaces(forRollResult result: [Int]) {
    for (index, roll) in result.enumerated() {
      dieIndicator[index].setImage(UIImage(named: "\(roll)"), for: .normal)
    }
  }
  
  func setRollIndicator(forRoll roll: Int) {
    rollIndicator[roll-1].image = UIImage(named: "FullRollInd")
    if game?.roundIsOver() == true {
      game?.endRound()
      turnScoreLbl.text = "\(game!.score)"
      rollDiceBtn.setTitle("SEND", for: .normal)
    }
  }
  
  func endRound(withScore score: Int) {
    messageDelegate?.composeMessage(forScore: score)
    setupForNewGame()
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
