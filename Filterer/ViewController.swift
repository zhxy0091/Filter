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
  var originalImage:UIImage?
  var prevSelectedFilter:UIButton?
  var isFiltered:Bool = false
  var label = UILabel()
  @IBOutlet var imageView: UIImageView!
  
  @IBOutlet var secondaryMenu: UIView!

  @IBOutlet var bottomMenu: UIView!
 
  @IBOutlet weak var compareBtn: UIButton!
  
  @IBOutlet var filterButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    originalImage = imageView.image
    compareBtn.enabled = false
    imageView.userInteractionEnabled = true
    let tapRecognizer = UILongPressGestureRecognizer(target: self, action:Selector("imageTapped:"))
    tapRecognizer.minimumPressDuration = 0.1;
    imageView.addGestureRecognizer(tapRecognizer)
    let w = UIScreen.mainScreen().bounds.width
    let h = UIScreen.mainScreen().bounds.height
    label = UILabel(frame: CGRect(x: w/2, y: h/2, width:120, height:30))
    label.text = "Original"
    label.center=CGPoint(x:w/2, y:h/12)
    label.textAlignment = .Center
    label.backgroundColor = UIColor.blackColor()
    label.textColor = UIColor.whiteColor()
    self.view?.addSubview(label)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func imageTapped(sender: UILongPressGestureRecognizer) {
    if(isFiltered) {
      if(sender.state == .Began) {
        showOriginalImage()
        compareBtn.selected = true
        //print("began tap")
      }
      else if(sender.state == .Ended){
        showFilteredImage()
        compareBtn.selected = false
        //print("end tap")
      }
    }
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
      isFiltered = false
      prevSelectedFilter?.selected=false
      compareBtn.selected = false
      compareBtn.enabled = false
      originalImage = image
      filteredImage = image
      showOriginalImage()
    }
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  @IBAction func onFilter(sender: UIButton) {
    if(sender.selected) {
      hideSecondaryMenu()
      sender.selected = false
    }
    else {
      showSecondaryMenu()
      sender.selected = true
    }
  }
  
  @IBAction func onRedFilter(sender: UIButton) {
    if(sender.selected) {
      sender.selected = false
      isFiltered = false
      compareBtn.enabled = false
      showOriginalImage()
    }
    else {
      if(isFiltered) {
        prevSelectedFilter!.selected = false;
      }
      prevSelectedFilter = sender
      sender.selected = true
      isFiltered = true
      compareBtn.selected = false
      compareBtn.enabled = true
      redFilter()
      
    }
    
    
  }
  
  @IBAction func onGreenFilter(sender: UIButton) {
    if(sender.selected) {
      sender.selected = false
      isFiltered = false
      compareBtn.enabled = false
      showOriginalImage()
    }
    else {
      if(isFiltered) {
        prevSelectedFilter!.selected = false;
      }
      prevSelectedFilter = sender
      sender.selected = true
      isFiltered = true
      compareBtn.selected = false
      compareBtn.enabled = true
      brightnessFilter()
      
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
  
  func showOriginalImage() {
    UIView.transitionWithView(self.imageView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.imageView.image = self.originalImage}, completion: nil)
    self.view?.addSubview(label)

  }
  
  func showFilteredImage() {
    UIView.transitionWithView(self.imageView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.imageView.image = self.filteredImage}, completion: nil)
    self.label.removeFromSuperview()
  }
  
  @IBAction func onCompare(sender: UIButton) {
    if(sender.selected) {
      sender.selected = false
      showFilteredImage()
    }
    else {
      sender.selected = true
      showOriginalImage()
    }
  }
  
  func redFilter() {
    
    var rgbaImage = RGBAImage(image: originalImage!)!
    let avgRed = 107
    for y in 0..<rgbaImage.height {
      for x in 0..<rgbaImage.width {
        let index = y*rgbaImage.width + x
        var pixel = rgbaImage.pixels[index]
        let redDelta = Int(pixel.red) - avgRed
        var modifier = 1 + 4*(Double(y)/Double(rgbaImage.height))
        if(Int(pixel.red) < avgRed) {
          modifier = 1
        }
        pixel.red = UInt8(max(min(255,Int(round(Double(avgRed) + modifier * Double(redDelta)))), 0))
        rgbaImage.pixels[index] = pixel
      }
    }
    filteredImage = rgbaImage.toUIImage()
    showFilteredImage()
  }
  
  func brightnessFilter() {
    var rgbaImage = RGBAImage(image: originalImage!)!
    let brightness = 1.8
    for y in 0..<rgbaImage.height {
      for x in 0..<rgbaImage.width {
        let index = y * rgbaImage.width + x
        var pixel = rgbaImage.pixels[index]
        pixel.red = UInt8(max(0, min(255, brightness * Double(pixel.red))))
        pixel.green = UInt8(max(0, min(255, brightness * Double(pixel.green))))
        pixel.blue = UInt8(max(0, min(255, brightness * Double(pixel.blue))))
        rgbaImage.pixels[index] = pixel
      }
    }
    filteredImage = rgbaImage.toUIImage()
    showFilteredImage()
  }
}

