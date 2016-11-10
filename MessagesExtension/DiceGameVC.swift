//
//  DiceGameVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 11/5/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

enum TargetIconTag: Int {
  case ship = 0, captain, crew
}

class DiceGameVC: UIViewController {
  
  var delegate: ExpandViewDelegate? = nil
  var messageDelegate: DiceGameDelegate? = nil
  var game: SCCGame? = nil
  var message: MSMessage? = nil
  
  @IBOutlet var rollIndicator: [UIImageView]!       // Switch based on which roll you're currently doing
  @IBOutlet var targetRollIndicator: [UIImageView]! // Ship, Cap, and Crew icons, indicate achievement
  @IBOutlet var dieIndicator: [UIButton]!           // Indicate held or "frozen" dice, and switch based on roll result
  @IBOutlet weak var yourScoreLbl: UILabel!
  @IBOutlet weak var theirScoreLbl: UILabel!
  @IBOutlet weak var rollDiceBtn: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    if delegate != nil, delegate?.getPresentationStyle() != .expanded {
      delegate!.expand(toPresentationStyle: .expanded)
    }
    
    if game == nil {
      setupForNewGame()
    }
    
    if message != nil {
      parse(message: message!)
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
//    if delegate?.getPresentationStyle() == .compact {
//      hideAllViews()
//    } else {
//      showAllViews()
//    }
  }
  
  func parse(message: MSMessage) {
    if let url = message.url {
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
          for item in queryItems {
            if item.name == "sccScore" {
              game?.opponentScore = Int(item.value!)!
              theirScoreLbl.text = "\(game!.opponentScore)"
            }
          }
        }
      }
    }
  }
  
  func setupForNewGame() {
    game = SCCGame()
    rollDiceBtn.setTitle("ROLL!", for: .normal)
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
      die.setImage(UIImage(named: "3"), for: .normal)
    }
  }
  
  func hideAllViews() {
    for subview in view.subviews {
      subview.isHidden = true
    }
    
//    playBtn.isHidden = false
//    titleLbl.isHidden = false
  }
  
  func showAllViews() {
    for subview in view.subviews {
      subview.isHidden = false
    }
    
//    playBtn.isHidden = true
//    titleLbl.isHidden = true
  }
  
  // MARK: - Game Buttons
  
//  @IBAction func playBtnTapped(sender: UIButton) {
//    delegate?.expand(toPresentationStyle: .expanded)
//  }
  
  @IBAction func dieButtonTapped(sender: UIButton) {
    
    let die = game?.currentDice[sender.tag]
    
    guard die?.frozen == false else {
      if game!.canUnhold(die: die!) {
        dieIndicator[sender.tag].alpha = 1.0
      }
      return
    }
    
    if (game?.hold(die: die!, atIndex: sender.tag))! {
      dieIndicator[sender.tag].alpha = 0.2
    }
    
    checkTargetIndicators()
    
  }
  
  func checkTargetIndicators() {
    var ship: UIImageView!
    var captain: UIImageView!
    var crew: UIImageView!
    
    for icon in targetRollIndicator {
      if icon.tag == TargetIconTag.ship.rawValue {
        ship = icon
      } else if icon.tag == TargetIconTag.captain.rawValue {
        captain = icon
      } else if icon.tag == TargetIconTag.crew.rawValue {
        crew = icon
      }
    }
    
    if let g = self.game {
      if g.hasFoundShip() {
        ship.alpha = 1.0
      } else {
        ship.alpha = 0.2
      }
      if g.hasFoundCaptain() {
        captain.alpha = 1.0
      } else {
        captain.alpha = 0.2
      }
      if g.hasFoundCrew() {
        crew.alpha = 1.0
      } else {
        crew.alpha = 0.2
      }
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
      yourScoreLbl.text = "\(game!.score)"
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
