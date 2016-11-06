//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Drew Lanning on 10/25/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import Messages

enum CoinQueryItemName: String {
  case coinGameState, coinFlipChoice, coinFlipResult
}

class MessagesViewController: MSMessagesAppViewController {
  
  let subCaptionsForState = ["Call It!", "Opponent called it.", "See results."]
  let summaryTextForState: [String] = ["","Coin flipped.", "Opponent called it.", "See results"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func presentVC(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
    var controller: UIViewController
    controller = instantiateCompactVC()
    
    if let message = conversation.selectedMessage, let url = message.url {
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
          let item = queryItems[0] // take the first item just to figure out which game this is going to
          if item.name.contains("coin") {
            controller = instantiateCoinGame(withMessage: message)
          } else if item.name.contains("scc") {
            // load ship, captain, and crew vc
          }
        }
      }
    }
    
    for child in childViewControllers {
      child.willMove(toParentViewController: nil)
      child.view.removeFromSuperview()
      child.removeFromParentViewController()
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
  
  private func instantiateCoinGame(withMessage message: MSMessage) -> UIViewController {
    guard let vc = storyboard?.instantiateViewController(withIdentifier: "Coin Game") as? CoinFlipVC else {
      fatalError("Can't load Coin Game")
    }
    vc.message = message
    print(message)
    vc.delegate = self
    return vc
  }
  
  private func instantiateCompactVC() -> UIViewController {
    guard let compactVC = storyboard?.instantiateViewController(withIdentifier: "Compact VC") as? CompactVC else {
      fatalError("Can't make a CompactVC")
    }
    return compactVC
  } 
  
  // MARK: - Conversation Handling
  
  override func willBecomeActive(with conversation: MSConversation) {
    presentVC(for: conversation, with: presentationStyle)
  }
  
  override func didResignActive(with conversation: MSConversation) {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dissmises the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
  }
  
  override func didReceive(_ message: MSMessage, conversation: MSConversation) {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
  }
  
  override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
    // Called when the user taps the send button.
  }
  
  override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
  }
  
  override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
    guard let conversation = activeConversation else {
      fatalError("No active conversation or something")
    }
    presentVC(for: conversation, with: .compact)
  }
  
  override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
  }

}

extension MessagesViewController: CoinFlipDelegate {
  
  // MARK: DELEGATE FUNCTIONS
  // MAY NEED TO RENAME THIS FUNCTION TO AVOID NAME CLASHES WITH OTHER DELEGATES FROM OTHER GAMES
  
  func composeMessage(forState state: CoinGameState, index: Int, pick: CoinFlipPick?, result: String?){
    self.requestPresentationStyle(.compact)
    
    let convo = activeConversation ?? MSConversation()
    let session = convo.selectedMessage?.session ?? MSSession()
    let layout = MSMessageTemplateLayout()
    if let choice = pick {
      layout.image = UIImage(named: "\(choice.rawValue)")
    } else {
      layout.image = UIImage(named: "heads")
    }
    layout.caption = "COIN FLIP CHALLENGE!"
    layout.subcaption = subCaptionsForState[index]
    
    let message = MSMessage(session: session)
    message.layout = layout
    
    var components = URLComponents()
    let queryItem = URLQueryItem(name: CoinQueryItemName.coinGameState.rawValue, value: nextGameState(from: state).rawValue)
    components.queryItems = [queryItem]
    if state == .pick, pick != nil {
      let queryItem = URLQueryItem(name: CoinQueryItemName.coinFlipChoice.rawValue, value: pick!.rawValue)
      let resultItem = URLQueryItem(name: CoinQueryItemName.coinFlipResult.rawValue, value: result!)
      components.queryItems?.append(queryItem)
      components.queryItems?.append(resultItem)
    }
    if state == .result, pick != nil {
      let queryItem = URLQueryItem(name: CoinQueryItemName.coinFlipChoice.rawValue, value: pick!.rawValue)
      let resultItem = URLQueryItem(name: CoinQueryItemName.coinFlipResult.rawValue, value: result!)
      components.queryItems?.append(queryItem)
      components.queryItems?.append(resultItem)
    }
    
    message.url = components.url
    message.summaryText = summaryTextForState[index] // IS THIS USED FOR *PRIOR* MESSAGE IN TRXSCRPT?
    
    convo.insert(message, completionHandler: { (error: Error?) in
      guard error == nil else {
        fatalError("error in inserting message into conversation")
      }
    })
  }
  
  internal func nextGameState(from state: CoinGameState?) -> CoinGameState {
    guard state != nil else {
      return .flip
    }
    switch state! {
    case .flip:
      return .pick
    case .pick:
      return .result
    case .over:
      return .flip
    default:
      return .flip
    }
  }
  
}
