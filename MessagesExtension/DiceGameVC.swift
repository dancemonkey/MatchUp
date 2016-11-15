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
  
  var messageDelegate: DiceGameDelegate? = nil
  var game: SCCGame? = nil
  var message: MSMessage? = nil
  
  let buttonAnimTiming: Double = 0.02
  
  var myWins: Int = 0
  var theirWins: Int = 0
  
  @IBOutlet var rollIndicator: [UIImageView]!
  @IBOutlet var targetRollIndicator: [UIImageView]!
  @IBOutlet var dieIndicator: [UIButton]!
  @IBOutlet weak var yourScoreLbl: UILabel!
  @IBOutlet weak var theirScoreLbl: UILabel!
  @IBOutlet weak var rollDiceBtn: UIButton!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    if game == nil {
      setupForNewGame()
    }
    
    if message != nil {
      parse(message: message!)
    }
    
  }
  
  func parse(message: MSMessage) {
    if let url = message.url {
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
          for item in queryItems {
            if item.name == "sccTotalScore" {
              game?.opponentScore = Int(item.value!)!
              theirScoreLbl.text = "\(game!.opponentScore)"
            }
            if item.name == "sccOppScore" {
              game?.score = Int(item.value!)!
              game?.totalScore = Int(item.value!)!
              yourScoreLbl.text = "\(game!.score)"
            }
            if item.name == "sccWinner" {
              rollDiceBtn.setTitle("START NEW GAME", for: .normal)
              if currentPlayerIsWinner() {
                yourScoreLbl.backgroundColor = UIColor.green
              } else {
                theirScoreLbl.backgroundColor = UIColor.green
              }
            }
            if item.name == "sccMyWins" {
              myWins = Int(item.value!)!
              game?.setMyWins(to: myWins)
            }
            if item.name == "sccOppWins" {
              theirWins = Int(item.value!)!
              game?.setOppWins(to: theirWins)
            }
            print("winning totals - mine: \(game?.myWins), theirs: \(game?.oppWins)")
          }
        }
      }
    }
  }
  
  func setupForNewGame() {
    game = SCCGame()
    game?.setMyWins(to: myWins)
    game?.setOppWins(to: theirWins)
    
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
    yourScoreLbl.text = "0"
    theirScoreLbl.text = "0"
    yourScoreLbl.backgroundColor = UIColor.clear
    theirScoreLbl.backgroundColor = UIColor.clear
  }
  
  func hideAllViews() {
    for subview in view.subviews {
      subview.isHidden = true
    }
  }
  
  func showAllViews() {
    for subview in view.subviews {
      subview.isHidden = false
    }
  }
  
  func currentPlayerIsWinner() -> Bool {
    return game!.score > game!.opponentScore
  }
  
  // MARK: - Game Buttons
  
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
    
    Utils.animateButton(sender, withTiming: buttonAnimTiming) {
      guard sender.titleLabel?.text == "SEND" else {
        guard sender.titleLabel?.text == "ROLL!" else {
          self.setupForNewGame()
          return
        }
        if let result = self.game?.roll() {
          self.setDieFaces(forRollResult: result)
          self.setRollIndicator(forRoll: (self.game?.totalRolls)!)
        }
        return
      }
      
      if let score = self.game?.score {
        self.endRound(withScore: score, totalScore: self.game!.totalScore, oppScore: self.game!.opponentScore)
      }
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
      yourScoreLbl.text = "\(game!.totalScore)"
      rollDiceBtn.setTitle("SEND", for: .normal)
    }
  }
  
  func endRound(withScore score: Int, totalScore: Int, oppScore: Int) {
    let winner: Bool
    if game!.gameIsOver(totalScore: game!.totalScore) {
      winner = true
      game!.incrementWins()
    } else {
      winner = false
    }
    messageDelegate?.composeMessage(fromGame: game!, hasWinner: winner)
  }
  
}
