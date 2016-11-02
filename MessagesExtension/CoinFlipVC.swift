//
//  CoinFlipVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/26/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

enum CoinGameState: String {
  case flip, pick, result, over
}

enum CoinGameStateIndex: Int {
  case flip=0, pick, result, over
}

enum CoinFlipPick: String {
  case heads, tails
}

class CoinFlipVC: UIViewController {
  
  @IBOutlet weak var coinImg: UIImageView!
  @IBOutlet weak var resultsLbl: UILabel!
  @IBOutlet weak var cancelBtn: UIButton!
  @IBOutlet weak var headsImg: UIImageView!
  @IBOutlet weak var tailsImg: UIImageView!
  @IBOutlet weak var resultsBtn: UIButton!
  
  private var gameState: CoinGameState! = nil
  var message: MSMessage? = nil
  private var pick: CoinFlipPick? = nil
  private var result: Bool? = nil
  
  var delegate: CoinFlipDelegate! = nil
  
  let resultsLblTextForState: [String] = ["Tap to flip the coin","Heads or Tails?"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // HANDLE GAME STATE INFO AND INTERFACE/GAMEPLAY
    
    self.gameState = .flip
    
    self.parseMessage()
    
    switch gameState! {
    case .flip:
      setupFlip()
    case .pick:
      setupPick()
    case .result:
      setupResult()
    case .over():
      setupOver()
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func parseMessage() {
    print(self.message)
    if let msg = self.message, let url = msg.url {
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
          for item in queryItems {
            if let coinState = CoinGameState(rawValue: item.value!), item.name == CoinQueryItemName.coinGameState.rawValue {
              self.gameState = coinState
            }
            if let pick = CoinFlipPick(rawValue: item.value!), item.name == CoinQueryItemName.coinFlipChoice.rawValue {
              self.pick = pick
            }
            if item.name == CoinQueryItemName.coinFlipResult.rawValue {
              result = NSString(string: item.value!).boolValue
            }
          }
        }
      }
    }
  }
  
  func setupFlip() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(CoinFlipVC.startGameTapped))
    coinImg.addGestureRecognizer(tap)
    coinImg.isHidden = false
    resultsLbl.isHidden = false
    cancelBtn.isHidden = false
  }
  
  func setupPick() {
    let headTap = UITapGestureRecognizer(target: self, action: #selector(CoinFlipVC.headsTapped))
    let tailTap = UITapGestureRecognizer(target: self, action: #selector(CoinFlipVC.tailsTapped))
    headsImg.addGestureRecognizer(headTap)
    tailsImg.addGestureRecognizer(tailTap)
    headsImg.isHidden = false
    tailsImg.isHidden = false
    resultsLbl.text = resultsLblTextForState[CoinGameStateIndex.pick.rawValue]
    resultsLbl.isHidden = false
    
    // animate coin flipping while waiting for tap

  }
  
  func setupResult() {
    resultsBtn.isHidden = false
    coinImg.isHidden = false
    resultsLbl.isHidden = false
    resultsLbl.text = "Opponent called \((pick?.rawValue)!)"
  }
  
  func setupOver() {
    // MAY NEED THIS AFTER ALL
    print("show picker result and offer chance to start new game")
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    
    Utils.animateButton(sender, withTiming: 0.05) {
      self.dismiss(animated: true, completion: nil)
    }
    
  }
  
  func setViewForResult(result: String, pick: String) {
    coinImg.isHidden = false
    headsImg.isHidden = true
    tailsImg.isHidden = true
    resultsLbl.text = "Your call was \(pick)."
    coinImg.image = UIImage(named: result)
  }
  
  func startGameTapped() {
    // animate coin flip before calling delegate
    delegate.composeMessage(forState: self.gameState, index: CoinGameStateIndex.flip.rawValue, pick: nil, result: nil)
  }
  
  func headsTapped() {
    self.pick = .heads
    let result = coinToss(wonWithPick: self.pick!)
    setViewForResult(result: result.result.rawValue, pick: (self.pick?.rawValue)!)
    
    // instead of delay, show "send results" button
    Utils.delay(3.0) { 
      self.delegate.composeMessage(forState: self.gameState, index: CoinGameStateIndex.pick.rawValue, pick: self.pick, result: result.match)
    }
  }
  
  func tailsTapped() {
    self.pick = .tails
    let result = coinToss(wonWithPick: self.pick!)
    setViewForResult(result: result.result.rawValue, pick: (self.pick?.rawValue)!)
    
    // instead of delay, show "send results" button
    Utils.delay(3.0) {
      self.delegate.composeMessage(forState: self.gameState, index: CoinGameStateIndex.pick.rawValue, pick: self.pick, result: result.match)
    }
  }
  
  @IBAction func showResultTapped(sender: UIButton) {
    Utils.animateButton(sender, withTiming: 0.05) { 
      // show result of coin flip and call to flipper
    }
  }
  
  func coinToss(wonWithPick pick: CoinFlipPick) -> (match: Bool, result: FlipResult) {
    let coin = Coin()
    let result = coin.flip()
    return (match: result.rawValue == pick.rawValue, result: result)
  }
  
}
