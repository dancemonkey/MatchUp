//
//  TutorialVC.swift
//  MatchUp
//
//  Created by Drew Lanning on 11/21/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func donePressed(sender: UIButton) {
    Utils.animateButton(sender, withTiming: 0.02, completionClosure: {
      UIView.animate(withDuration: 0.5, animations: {
        self.view.alpha = 0.0
      }, completion: { complete in
        DispatchQueue.main.async {
          self.willMove(toParentViewController: nil)
          self.view.removeFromSuperview()
          self.removeFromParentViewController()
        }
      })
    })
  }
  
}
