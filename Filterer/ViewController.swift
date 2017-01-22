//
//  ViewController.swift
//  Filterer
//
//  Created by Cyrus on 1/15/17.
//  Copyright © 2017 Cyrus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var filteredImage:UIImage?
  @IBOutlet var imageView: UIImageView!
  
  @IBOutlet var secondaryMenu: UIView!

  @IBOutlet var bottomMenu: UIView!
  
  @IBOutlet var filterButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  @IBAction func onFilter(sender: UIButton) {
    if(sender.selected) {
      hideSecondaryMenu()
      sender.selected =
      false
    }
    else {
      showSecondaryMenu()
      sender.selected = true
    }
  }
  
  func showSecondaryMenu() {
    view.addSubview(secondaryMenu)
    secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
    let bottomContraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
    let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
    let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
    let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
    NSLayoutConstraint.activateConstraints([bottomContraint, leftConstraint, rightConstraint, heightConstraint])
    view.layoutIfNeeded()
    
    secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
  }
  
  func hideSecondaryMenu() {
    secondaryMenu.removeFromSuperview()
  }
}

