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
  
  var tutorial: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func presentVC(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
    
    var controller: UIViewController
    
    if presentationStyle == .compact {
      controller = instantiateCompactVC()
    } else {
      controller = instantiateExpandedVC(forConversation: conversation)
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
  
  private func instantiateExpandedVC(forConversation conversation: MSConversation) -> UIViewController {
    guard let vc = storyboard?.instantiateViewController(withIdentifier: "SCC Game") as? DiceGameVC else {
      fatalError("No dice game VC man")
    }
    
    if let message = conversation.selectedMessage, let url = message.url {
      if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
          for item in queryItems {
            if item.name.contains("scc") {
              vc.message = message
            }
          }
        }
      }
    }
    
    vc.messageDelegate = self
    vc.tutorialOn = self.tutorial
    
    return vc
  }
  
  private func instantiateCompactVC() -> UIViewController {
    guard let compactVC = storyboard?.instantiateViewController(withIdentifier: "Compact VC") as? CompactVC else {
      fatalError("Can't make a CompactVC")
    }
    
    compactVC.delegate = self
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
    presentVC(for: conversation, with: presentationStyle)
  }
  
  override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
  }
  
  override func didSelect(_ message: MSMessage, conversation: MSConversation) {
    guard let conversation = activeConversation else {
      fatalError("No active conversation or something")
    }
    presentVC(for: conversation, with: presentationStyle)
  }
  
}

// MARK: DELEGATE FUNCTIONS

extension MessagesViewController: DiceGameDelegate {
  
  func composeMessage(fromGame game: SCCGame, hasWinner: Bool) {
    let convo = activeConversation ?? MSConversation()
    let session = convo.selectedMessage?.session ?? MSSession()
    
    let layout = MSMessageTemplateLayout()
    layout.caption = "Ship, Captain, and Crew"
    if hasWinner == true {
      layout.subcaption = "$\(convo.localParticipantIdentifier) won, with a score of \(game.totalScore)!"
    } else {
      layout.subcaption = "$\(convo.localParticipantIdentifier) scored \(game.score) points!"
    }
    layout.image = UIImage(named: "msgBackground")
    
    let message = MSMessage(session: session)
    message.layout = layout
    
    var components = URLComponents()
    let queryItemScore = URLQueryItem(name: "sccScore", value: "\(game.score)")
    let queryItemTotalScore = URLQueryItem(name: "sccTotalScore", value: "\(game.totalScore)")
    let queryItemOppScore = URLQueryItem(name: "sccOppScore", value: "\(game.opponentScore)")
    let queryItemWins = URLQueryItem(name: "sccMyWins", value: "\(game.oppWins)")
    let queryItemOppWins = URLQueryItem(name: "sccOppWins", value: "\(game.myWins)")
    components.queryItems = [queryItemScore, queryItemTotalScore, queryItemOppScore, queryItemWins, queryItemOppWins]

    if hasWinner == true {
      let queryItem = URLQueryItem(name: "sccWinner", value: "\(convo.selectedMessage?.senderParticipantIdentifier)")
      components.queryItems?.append(queryItem)
      message.summaryText = "$\(convo.localParticipantIdentifier) Won, with a score of \(game.totalScore)!"
    } else {
      message.summaryText = "$\(convo.localParticipantIdentifier) Scored \(game.score) points."
    }
    
    message.url = components.url
    
    convo.insert(message) { (error) in
      //self.requestPresentationStyle(.compact)
      guard error == nil else {
        fatalError("error in inserting message into conversation")
      }
    }
    
    dismiss()
  }
  
}

extension MessagesViewController: ExpandViewDelegate {
  func expand(toPresentationStyle presentationStyle: MSMessagesAppPresentationStyle, tutorial: Bool) {
    self.tutorial = tutorial
    requestPresentationStyle(presentationStyle)
  }
  func getPresentationStyle() -> MSMessagesAppPresentationStyle {
    return self.presentationStyle
  }
}
