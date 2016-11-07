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
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var playBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if delegate != nil, delegate?.getPresentationStyle() != .expanded {
      delegate!.expand(toPresentationStyle: .expanded)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if delegate?.getPresentationStyle() == .compact {
      hideAllViews()
    } else {
      showAllViews()
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
  
  @IBAction func playBtnTapped(sender: UIButton) {
    delegate?.expand(toPresentationStyle: .expanded)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
