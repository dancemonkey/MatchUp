//
//  CoinFlipVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/26/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

enum GameState: String {
  case flip, pick, result, over
}

class CoinFlipVC: MSMessagesAppViewController {
  
  @IBOutlet weak var coinImg: UIImageView!
  @IBOutlet weak var resultsLbl: UILabel!
  
  var gameState: GameState! = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer(target: self, action: #selector(CoinFlipVC.composeMessage))
    coinImg.addGestureRecognizer(tap)
    
    gameState = nextGameState(from: gameState)
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    Utils.animateButton(sender, withTiming: 0.05) {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  func composeMessage() {
    let convo = activeConversation ?? MSConversation()
    
    gameState = nextGameState(from: gameState)
    
    let session = convo.selectedMessage?.session ?? MSSession()
    
    let layout = MSMessageTemplateLayout()
    layout.imageTitle = "COIN FLIP CHALLENGE!"
    layout.image = coinImg.image
    layout.caption = "Bob flipped a coin, call it!" // figure out how to get the name
    
    let message = MSMessage(session: session)
    message.layout = layout
    message.url = nil // deal with URL thing, Apple default?
    message.summaryText = "Coin flipped."
    
    convo.insert(message, completionHandler: { (error: Error?) in
      print(error)
    })
  }
  
  func nextGameState(from state: GameState?) -> GameState {
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
  
}
