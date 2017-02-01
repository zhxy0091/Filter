//
//  ViewController.swift
//  Filterer
//
//  Created by Cyrus on 1/15/17.
//  Copyright © 2017 Cyrus. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
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
  @IBAction func onShare(sender: AnyObject) {
    let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
    presentViewController(activityController, animated: true, completion: nil)
  }
  @IBAction func onNewPhoto(sender: AnyObject) {
    let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {action in self.showCamera()
    }))
  
    actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: {action in self.showAlbum()
    }))
  
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    presentViewController(actionSheet, animated:true, completion: nil)
  }
  
  func showCamera() {
    let cameraPicker = UIImagePickerController();
    cameraPicker.delegate = self
    cameraPicker.sourceType = .Camera
    presentViewController(cameraPicker, animated: true, completion: nil)
  }

  func showAlbum() {
    let cameraPicker = UIImagePickerController();
    cameraPicker.delegate = self
    cameraPicker.sourceType = .PhotoLibrary
    presentViewController(cameraPicker, animated: true, completion: nil)
  }
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    dismissViewControllerAnimated(true, completion: nil)
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = image
    }
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
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
    self.secondaryMenu.alpha = 0
    UIView.animateWithDuration(1) {
      self.secondaryMenu.alpha = 0.6
    }
  }
  
  func hideSecondaryMenu() {
    //secondaryMenu.removeFromSuperview()
    UIView.animateWithDuration(0.4, animations: { self.secondaryMenu.alpha=0
    }) { completed in
      if completed == true {
        self.secondaryMenu.removeFromSuperview()
      }
    }
  }
}

