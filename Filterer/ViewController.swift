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
  
  var avgRed:Int?
  var avgGreen:Int?
  var avgBlue:Int?
  var filterIntensity:Double = 4.0
  var filteredImageDict:[String:UIImage] = [:]
  var filters = ["red", "green", "blue", "yellow", "purple"]
  @IBOutlet var imageView: UIImageView!
  
  @IBOutlet var secondaryMenu: UIView!

  @IBOutlet var bottomMenu: UIView!
 
  @IBOutlet weak var compareBtn: UIButton!
  
  @IBOutlet var filterPurpleButton: UIButton!
  @IBOutlet var filterYellowButton: UIButton!
  @IBOutlet var filterBlueButton: UIButton!
  @IBOutlet var filterGreenButton: UIButton!
  @IBOutlet var filterRedButton: UIButton!
  @IBOutlet var filterButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    originalImage = imageView.image
    compareBtn.enabled = false
    preCalculation()
    //tap to compare
    imageView.userInteractionEnabled = true
    let tapRecognizer = UILongPressGestureRecognizer(target: self, action:Selector("imageTapped:"))
    tapRecognizer.minimumPressDuration = 0.1;
    imageView.addGestureRecognizer(tapRecognizer)
    
    //origin label set up
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
    if filterButton.selected == true {
      onFilter(filterButton)
    }
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
      preCalculation()
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
    filterBtnAction(sender, filterName: "red")

  }
  
  @IBAction func onGreenFilter(sender: UIButton) {
    filterBtnAction(sender, filterName: "green")

  }
  
  @IBAction func onBlueFilter(sender: UIButton) {
    filterBtnAction(sender, filterName: "blue")
  }
  @IBAction func onYellowFilter(sender: UIButton) {
    filterBtnAction(sender, filterName: "yellow")
  }
  
  @IBAction func onPurpleFilter(sender: UIButton) {
    filterBtnAction(sender, filterName: "purple")
  }
  
  func filterBtnAction(sender:UIButton, filterName:String) {
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
      filteredImage = applyFilter(filterName)
      showFilteredImage()
    }
  }
  
  func showSecondaryMenu() {
    displayFilterImageAsFilterSubButton()
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
  
  func preCalculation() {
    
    let image = originalImage
    let rgbaImage = RGBAImage(image: image!)!
    
    var totalRed = 0
    var totalGreen = 0
    var totalBlue = 0
    
    let totalPixel = rgbaImage.height * rgbaImage.width
    
    for y in 0..<rgbaImage.height {
      for x in 0..<rgbaImage.width {
        let index = y * rgbaImage.width + x
        
        var pixel = rgbaImage.pixels[index]
        
        totalRed += Int(pixel.red)
        totalGreen += Int(pixel.green)
        totalBlue += Int(pixel.blue)
        
      }
      
    }
    
    avgRed = totalRed / totalPixel
    avgGreen = totalGreen / totalPixel
    avgBlue = totalBlue / totalPixel
    
    for filter in filters {
      filteredImageDict[filter]=applyFilter(filter)
    }
  }

  
  func applyFilter(filter:String)->UIImage {
    
    var rgbaImage = RGBAImage(image: originalImage!)!
    
    for y in 0..<rgbaImage.height {
      for x in 0..<rgbaImage.width {
        let index = y*rgbaImage.width + x
        var pixel = rgbaImage.pixels[index]
        
        var modifier = 1 + filterIntensity*(Double(y)/Double(rgbaImage.height))
        
        switch filter {
          case "red":
            let redDelta = Int(pixel.red) - avgRed!
            if(Int(pixel.red) < avgRed) {
              modifier = 1
            }
            pixel.red = UInt8(max(min(255,Int(round(Double(avgRed!) + modifier * Double(redDelta)))), 0))
            rgbaImage.pixels[index] = pixel
          case "green":
            let greenDelta = Int(pixel.green) - avgGreen!
            
            if (Int(pixel.green) < avgGreen) {
              modifier = 1
            }
            
            pixel.green = UInt8(max(min(255, Int(round(Double(avgGreen!) + modifier * Double(greenDelta)))), 0))
            rgbaImage.pixels[index] = pixel
          
          case "blue":
            let blueDelta = Int(pixel.blue) - avgBlue!
            
            if (Int(pixel.blue) < avgBlue) {
              modifier = 1
            }
            
            pixel.blue = UInt8(max(min(255, Int(round(Double(avgBlue!) + modifier * Double(blueDelta)))), 0))
            rgbaImage.pixels[index] = pixel
            
          case "yellow":
            let redDelta = Int(pixel.red) - avgRed!
            let greenDelta = Int(pixel.green) - avgGreen!
            
            var redModifier = 1 + filterIntensity * (Double(y) / Double(rgbaImage.height))
            var greenModifier = 1 + filterIntensity * (Double(y) / Double(rgbaImage.height))
            
            if (Int(pixel.red) < avgRed) {
              redModifier = 1
            }
            if (Int(pixel.green) < avgGreen) {
              greenModifier = 1
            }
            
            pixel.red = UInt8(max(min(255, Int(round(Double(avgRed!) + redModifier * Double(redDelta)))), 0))
            pixel.green = UInt8(max(min(255, Int(round(Double(avgGreen!) + greenModifier * Double(greenDelta)))), 0))
            
            rgbaImage.pixels[index] = pixel
            
          case "purple":
            let redDelta = Int(pixel.red) - avgRed!
            let blueDelta = Int(pixel.blue) - avgBlue!
            
            var redModifier = 1 + filterIntensity * (Double(y) / Double(rgbaImage.height))
            var blueModifier = 1 + filterIntensity * (Double(y) / Double(rgbaImage.height))
            
            if (Int(pixel.red) < avgRed) {
              redModifier = 1
            }
            if (Int(pixel.blue) < avgBlue) {
              blueModifier = 1
            }
            
            pixel.red = UInt8(max(min(255, Int(round(Double(avgRed!) + redModifier * Double(redDelta)))), 0))
            pixel.blue = UInt8(max(min(255, Int(round(Double(avgBlue!) + blueModifier * Double(blueDelta)))), 0))
            
            rgbaImage.pixels[index] = pixel
            
          default:
            print("color unrecogized")
            break
        }
        
        
      }
    }
    filteredImage = rgbaImage.toUIImage()
    return filteredImage!
  }

  func displayFilterImageAsFilterSubButton() {
    
    filterRedButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
    
    filterGreenButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
    
    filterBlueButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
    
    filterYellowButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
    
    filterPurpleButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
    
    filterRedButton.setBackgroundImage(filteredImageDict["red"], forState: .Normal)
    
    filterGreenButton.setBackgroundImage(filteredImageDict["green"], forState: .Normal)
    
    filterBlueButton.setBackgroundImage(filteredImageDict["blue"], forState: .Normal)
    
    filterYellowButton.setBackgroundImage(filteredImageDict["yellow"], forState: .Normal)
    
    filterPurpleButton.setBackgroundImage(filteredImageDict["purple"], forState: .Normal)
    
  }

}

