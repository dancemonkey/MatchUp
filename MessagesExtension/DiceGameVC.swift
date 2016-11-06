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
  
  var delegate: ExpandViewDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate.expand(toPresentationStyle: .expanded)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if delegate.getPresentationStyle() == .compact {
      print("load compact VC")
    } else {
      print("load expanded VC")
    }
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
