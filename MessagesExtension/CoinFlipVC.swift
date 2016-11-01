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
  case flip, pick, result
}

enum CoinGameStateIndex: Int {
  case flip=0, pick, result
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
  
  var gameState: CoinGameState! = nil
  var message: MSMessage? = nil
  var pick: CoinFlipPick? = nil
  
  var delegate: CoinFlipDelegate! = nil
  
  let resultsLblTextForState: [String] = ["Tap to flip the coin","Heads or Tails?"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // HANDLE GAME STATE INFO AND INTERFACE/GAMEPLAY
    
    switch gameState! {
    case .flip:
      setupFlip()
    case .pick:
      setupPick()
    case .result:
      setupResult()
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
    let resultTap = UITapGestureRecognizer(target: self, action: #selector(CoinFlipVC.showResult))
    resultsBtn.addGestureRecognizer(resultTap)
    resultsLbl.isHidden = false
    resultsLbl.text = "Opponent called \((pick?.rawValue)!)"
  }
  
  func setupOver() {
    print("show picker result and offer chance to start new game")
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    
    Utils.animateButton(sender, withTiming: 0.05) {
      self.dismiss(animated: true, completion: nil)
    }
    
  }
  
  func startGameTapped() {
    // animate coin flip before calling delegate
    delegate.composeMessage(forState: self.gameState, index: CoinGameStateIndex.flip.rawValue, pick: nil)
  }
  
  func headsTapped() {
    self.pick = .heads
    delegate.composeMessage(forState: self.gameState, index: CoinGameStateIndex.pick.rawValue, pick: self.pick)
  }
  
  func tailsTapped() {
    self.pick = .tails
    delegate.composeMessage(forState: self.gameState, index: CoinGameStateIndex.pick.rawValue, pick: self.pick)
  }
  
  func showResult() {
    delegate.composeMessage(forState: self.gameState, index: CoinGameStateIndex.result.rawValue, pick: self.pick)
  }
  
}
