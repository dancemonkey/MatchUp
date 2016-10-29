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

class CoinFlipVC: MSMessagesAppViewController {
  
  @IBOutlet weak var coinImg: UIImageView!
  @IBOutlet weak var resultsLbl: UILabel!
  @IBOutlet weak var cancelBtn: UIButton!
  @IBOutlet weak var headsImg: UIImageView!
  @IBOutlet weak var tailsImg: UIImageView!
  
  var gameState: CoinGameState! = nil
  var message: MSMessage? = nil
  var convo: MSConversation? = nil
  var pick: CoinFlipPick? = nil
  
  let subCaptionsForState = ["Call It!", "Opponent called it."]
  let resultsLblTextForState: [String] = ["Tap to flip the coin","Heads or Tails?"]
  let summaryTextForState: [String] = ["Coin flipped.", "Opponent called it."]
  
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
    case .over:
      setupOver()
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
    // SETUP UP TGR ON EACH IMAGE FOR SENDING A NEW MESSAGE BACK WITH CHOICE
    let headTap = UITapGestureRecognizer(target: self, action: #selector(CoinFlipVC.headsTapped))
    let tailTap = UITapGestureRecognizer(target: self, action: #selector(CoinFlipVC.tailsTapped))
    headsImg.addGestureRecognizer(headTap)
    tailsImg.addGestureRecognizer(tailTap)
    headsImg.isHidden = false
    tailsImg.isHidden = false
    resultsLbl.text = resultsLblTextForState[CoinGameStateIndex.pick.rawValue]
    resultsLbl.isHidden = false
  }
  
  func setupResult() {
    print("show flipper result of flip and winner")
  }
  
  func setupOver() {
    print("show picker result and offer chance to start new game")
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    
    guard presentationStyle == .compact else {
      requestPresentationStyle(.compact)
      performSegue(withIdentifier: "showMenuVC", sender: self)
      return
    }
    
    Utils.animateButton(sender, withTiming: 0.05) {
      self.dismiss(animated: true, completion: nil)
    }
    
  }
  
  func composeMessage(forState state: CoinGameState, index: Int) {
    
    let convo = activeConversation ?? MSConversation()
    let session = convo.selectedMessage?.session ?? MSSession()
    let layout = MSMessageTemplateLayout()
    layout.image = coinImg.image
    layout.caption = "COIN FLIP CHALLENGE!"
    layout.subcaption = subCaptionsForState[index]
    
    let message = MSMessage(session: session)
    message.layout = layout
    
    var components = URLComponents()
    let queryItem = URLQueryItem(name: "coinGameState", value: nextGameState(from: gameState).rawValue)
    components.queryItems = [queryItem]
    if gameState == .pick {
      let queryItem = URLQueryItem(name: "coinFlipChoice", value: self.pick!.rawValue)
      components.queryItems?.append(queryItem)
    }
    
    message.url = components.url
    message.summaryText = summaryTextForState[index]
    
    convo.insert(message, completionHandler: { (error: Error?) in
      self.requestPresentationStyle(.compact)
      print(error)
    })
    
  }
  
  func startGameTapped() {
    composeMessage(forState: self.gameState, index: CoinGameStateIndex.flip.rawValue)
  }
  
  func headsTapped() {
    print("heads tapped")
    self.pick = .heads
    composeMessage(forState: self.gameState, index: CoinGameStateIndex.pick.rawValue)
  }
  
  func tailsTapped() {
    print("tails tapped")
    self.pick = .tails
    composeMessage(forState: self.gameState, index: CoinGameStateIndex.pick.rawValue)
  }
  
  func nextGameState(from state: CoinGameState?) -> CoinGameState {
    guard state != nil else {
      return .flip
    }
    switch state! {
    case .flip:
      return .pick
    case .pick:
      return .result
    case .result:
      return .over
    default:
      return .flip
    }
  }
  
  override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
    super.didStartSending(message, conversation: conversation)
    self.gameState = self.nextGameState(from: self.gameState)
  }
  
}
