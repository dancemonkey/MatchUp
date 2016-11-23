//
//  DiceGameVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 11/5/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages
import AVFoundation

enum TargetIconTag: Int {
  case ship = 0, captain, crew
}

class DiceGameVC: UIViewController, AVAudioPlayerDelegate {
  
  var messageDelegate: DiceGameDelegate? = nil
  var game: SCCGame? = nil
  var message: MSMessage? = nil
  
  let buttonAnimTiming: Double = 0.02
  let targetSoundNames = ["ship","pirate","crew"]
  
  var myWins: Int = 0
  var theirWins: Int = 0
  
  var player: AVAudioPlayer? = nil
  
  var tutorialOn: Bool? = nil
  
  @IBOutlet var rollIndicator: [UIImageView]!
  @IBOutlet var targetRollIndicator: [UIImageView]!
  @IBOutlet var dieIndicator: [DieButton]!
  @IBOutlet weak var yourScoreLbl: UILabel!
  @IBOutlet weak var theirScoreLbl: UILabel!
  @IBOutlet weak var rollDiceBtn: UIButton!
  @IBOutlet weak var myWinsLbl: UILabel!
  @IBOutlet weak var oppWinsLbl: UILabel!
  @IBOutlet weak var scoreViewBackground: UIView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    if game == nil {
      setupForNewGame()
    }
    
    if message != nil {
      parse(message: message!)
    }
    
    if let tutorial = tutorialOn, tutorial == true {
      addTutorialView()
    }
    
  }
  
  func parse(message: MSMessage) {
    defer {
      setWinLabels()
    }
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
                theirScoreLbl.backgroundColor = UIColor.red
                play(sound: SoundFileName.lost_game.rawValue)
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
    
    setWinLabels()
  }
  
  func setWinLabels() {
    myWinsLbl.text = "Won - \(myWins)"
    oppWinsLbl.text = "Lost - \(theirWins)"
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
    
    if die?.value == 6 && game!.hasFoundShip() == false {
      play(sound: getRandomSound(forIndex: .ship))
    } else if die?.value == 5 && game!.hasFoundCaptain() == false {
      play(sound: getRandomSound(forIndex: .captain))
    } else if die?.value == 4 && game!.hasFoundCrew() == false {
      play(sound: getRandomSound(forIndex: .crew))
    }
    
    if (game!.hold(die: die!, atIndex: sender.tag)) {
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
    
    if let g = self.game, g.roundIsOver() == false {
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
    
    Utils.animateButton(sender, withTiming: buttonAnimTiming, completionClosure: {
      guard sender.titleLabel?.text == "SEND" else {
        guard sender.titleLabel?.text == "ROLL!" else {
          self.setupForNewGame()
          return
        }
        if let result = self.game?.roll() {
          self.animateRolls(withResult: result, withClosure: {
            // keeping this here in case I need a closure
          })
          Utils.delay(0.05, closure: {
            self.play(sound: SoundFileName.dice.rawValue)
            self.setRollIndicator(forRoll: (self.game?.totalRolls)!)
          })
        }
        return
      }
      
      if let score = self.game?.score {
        self.endRound(withScore: score, totalScore: self.game!.totalScore, oppScore: self.game!.opponentScore)
      }
    })
    
  }
  
  // MARK: Game Actions
  
  func setDieFace(forDie index: Int, result: Int) {
    dieIndicator[index].changeFace(toImage: UIImage(named: "\(result)")!)
  }
  
  func animateRolls(withResult result: [Int], withClosure closure: () -> ()) {
    for (index,_) in game!.currentDice.enumerated() {
      if game!.currentDice[index].frozen == false {
        let timing = Double(Die(sides: 5).roll())
        dieIndicator[index].animateRoll(forTime: timing/10, leftoverTime: 0.0, closure: {
          self.setDieFace(forDie: index, result: result[index])
        })
      }
    }
    closure()
  }
  
  func setRollIndicator(forRoll roll: Int) {
    rollIndicator[roll-1].image = UIImage(named: "FullRollInd")
    if game?.roundIsOver() == true {
      game?.endRound()
      roundEndFanfare()
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
  
  func play(sound: String) {
    do {
      let path = Bundle.main.path(forResource: sound, ofType: nil)!
      let url = URL(fileURLWithPath: path)
      player = try AVAudioPlayer(contentsOf: url)
      player?.prepareToPlay()
      player?.play()
    } catch {
      print(error)
    }
  }
  
  func getRandomSound(forIndex index: TargetIconTag) -> String {
    let die = Die(sides: 6)
    return targetSoundNames[index.rawValue] + "\(die.roll()).mp3"
  }
  
  func roundEndFanfare() {
    
    scoreViewBackground.backgroundColor = game!.score > 0 ? UIColor.green : UIColor.red
    
    var soundToPlay = game!.score > 0 ? SoundFileName.won_round.rawValue : SoundFileName.lost_round.rawValue
    if game!.gameIsOver(totalScore: game!.totalScore) {
      soundToPlay = SoundFileName.won_game.rawValue
    }
    play(sound: soundToPlay)
    
    UIView.animate(withDuration: 1.0, delay: 0.25, options: [.allowUserInteraction], animations: {
      self.scoreViewBackground.backgroundColor = UIColor.white
      }, completion: nil)
  }
  
  func addTutorialView() {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "TutorialVC") as? TutorialVC else {
      fatalError("No tutorial found")
    }
    addChildViewController(controller)
    controller.view.frame = view.bounds
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(controller.view)
    
    controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    controller.didMove(toParentViewController: self)

  }
  
}
