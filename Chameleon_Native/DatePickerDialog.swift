//
//  DatePicker.swift

import Foundation
import UIKit
import QuartzCore


class DatePickerDialog: UIView {
    
    /* Consts */
    fileprivate let kDatePickerDialogDefaultButtonHeight: CGFloat = 50
    fileprivate let kDatePickerDialogDefaultButtonSpacerHeight: CGFloat = 1
    fileprivate let kDatePickerDialogCornerRadius: CGFloat = 7
    fileprivate let kDatePickerDialogCancelButtonTag: Int = 1
    fileprivate let kDatePickerDialogDoneButtonTag: Int = 2
    
    /* Views */
    fileprivate var dialogView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var datePicker: UIDatePicker!
    fileprivate var cancelButton: UIButton!
    fileprivate var doneButton: UIButton!
    
    /* Vars */
    fileprivate var title: String!
    fileprivate var doneButtonTitle: String!
    fileprivate var cancelButtonTitle: String!
    fileprivate var defaultDate: Date!
    fileprivate var datePickerMode: UIDatePickerMode!
    fileprivate var callback: ((_ date: Date) -> Void)!
    
    
    /* Overrides */
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        NotificationCenter.default.addObserver(self, selector: #selector(DatePickerDialog.deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Handle device orientation changes */
    func deviceOrientationDidChange(_ notification: Notification) {
        /* TODO */
    }
    
    /* Create the dialog view, and animate opening the dialog */
    func show(_ title: String, datePickerMode: UIDatePickerMode = .dateAndTime, callback: @escaping ((_ date: Date) -> Void)) {
        show(title, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: datePickerMode, callback: callback)
    }
    
    func show(_ title: String, doneButtonTitle: String, cancelButtonTitle: String, defaultDate: Date = Date(), datePickerMode: UIDatePickerMode = .dateAndTime, callback: @escaping ((_ date: Date) -> Void)) {
        self.title = title
        self.doneButtonTitle = doneButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
        self.datePickerMode = datePickerMode
        self.callback = callback
        self.defaultDate = defaultDate
        
        self.dialogView = createContainerView()
        
        self.dialogView!.layer.shouldRasterize = true
        self.dialogView!.layer.rasterizationScale = UIScreen.main.scale
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.dialogView!.layer.opacity = 0.5
        self.dialogView!.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.addSubview(self.dialogView!)
        
        /* Attached to the top most window (make sure we are using the right orientation) */
        let interfaceOrientation = UIApplication.shared.statusBarOrientation
        
        switch(interfaceOrientation) {
        case UIInterfaceOrientation.landscapeLeft:
            let t: Double = M_PI * 270 / 180
            self.transform = CGAffineTransform(rotationAngle: CGFloat(t))
            break
            
        case UIInterfaceOrientation.landscapeRight:
            let t: Double = M_PI * 90 / 180
            self.transform = CGAffineTransform(rotationAngle: CGFloat(t))
            break
            
        case UIInterfaceOrientation.portraitUpsideDown:
            let t: Double = M_PI * 180 / 180
            self.transform = CGAffineTransform(rotationAngle: CGFloat(t))
            break
            
        default:
            break
        }
        
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.size.height)
        UIApplication.shared.windows.first!.addSubview(self)
        
        /* Anim */
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: { () -> Void in
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.dialogView!.layer.opacity = 1
                self.dialogView!.layer.transform = CATransform3DMakeScale(1, 1, 1)
            },
            completion: nil
        )
    }
    
    /* Dialog close animation then cleaning and removing the view from the parent */
    fileprivate func close() {
        let currentTransform = self.dialogView.layer.transform
        
        let startRotation = (self.value(forKeyPath: "layer.transform.rotation.z") as? NSNumber) as? Double ?? 0.0
        let rotation = CATransform3DMakeRotation((CGFloat)(-startRotation + M_PI * 270 / 180), 0, 0, 0)
        
        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        self.dialogView.layer.opacity = 1
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: { () -> Void in
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
                self.dialogView.layer.opacity = 0
        }) { (finished: Bool) -> Void in
            for v in self.subviews {
                v.removeFromSuperview()
            }
            
            self.removeFromSuperview()
        }
    }
    
    /* Creates the container view here: create the dialog, then add the custom content and buttons */
    fileprivate func createContainerView() -> UIView {
        let screenSize = countScreenSize()
        let dialogSize = CGSize(
            width: 300,
            height: 230
                + kDatePickerDialogDefaultButtonHeight
                + kDatePickerDialogDefaultButtonSpacerHeight)
        
        // For the black background
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        // This is the dialog's container; we attach the custom content and the buttons to this one
        let dialogContainer = UIView(frame: CGRect(x: (screenSize.width - dialogSize.width) / 2, y: (screenSize.height - dialogSize.height) / 2, width: dialogSize.width, height: dialogSize.height))
        
        // First, we style the dialog to match the iOS8 UIAlertView >>>
        let gradient: CAGradientLayer = CAGradientLayer(layer: self.layer)
        gradient.frame = dialogContainer.bounds
        gradient.colors = [UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor,
                           UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1).cgColor,
                           UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor]
        
        let cornerRadius = kDatePickerDialogCornerRadius
        gradient.cornerRadius = cornerRadius
        dialogContainer.layer.insertSublayer(gradient, at: 0)
        
        dialogContainer.layer.cornerRadius = cornerRadius
        dialogContainer.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
        dialogContainer.layer.borderWidth = 1
        dialogContainer.layer.shadowRadius = cornerRadius + 5
        dialogContainer.layer.shadowOpacity = 0.1
        dialogContainer.layer.shadowOffset = CGSize(width: 0 - (cornerRadius + 5) / 2, height: 0 - (cornerRadius + 5) / 2)
        dialogContainer.layer.shadowColor = UIColor.black.cgColor
        dialogContainer.layer.shadowPath = UIBezierPath(roundedRect: dialogContainer.bounds, cornerRadius: dialogContainer.layer.cornerRadius).cgPath
        
        // There is a line above the button
        let lineView = UIView(frame: CGRect(x: 0, y: dialogContainer.bounds.size.height - kDatePickerDialogDefaultButtonHeight - kDatePickerDialogDefaultButtonSpacerHeight, width: dialogContainer.bounds.size.width, height: kDatePickerDialogDefaultButtonSpacerHeight))
        lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        dialogContainer.addSubview(lineView)
        // ˆˆˆ
        
        //Title
        self.titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 280, height: 30))
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleLabel.text = self.title
        dialogContainer.addSubview(self.titleLabel)
        
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 30, width: 0, height: 0))
        self.datePicker.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
        self.datePicker.frame.size.width = 300
        self.datePicker.datePickerMode = self.datePickerMode
        self.datePicker.date = self.defaultDate
//        self.datePicker.locale = Locale.system
        self.datePicker.minimumDate = Date()
        dialogContainer.addSubview(self.datePicker)
        
        // Add the buttons
        addButtonsToView(dialogContainer)
        
        return dialogContainer
    }
    
    /* Add buttons to container */
    fileprivate func addButtonsToView(_ container: UIView) {
        let buttonWidth = container.bounds.size.width / 2
        
        self.cancelButton = UIButton(type: UIButtonType.custom) as UIButton
        self.cancelButton.frame = CGRect(
            x: 0,
            y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight,
            width: buttonWidth,
            height: kDatePickerDialogDefaultButtonHeight
        )
        self.cancelButton.tag = kDatePickerDialogCancelButtonTag
        self.cancelButton.setTitle(self.cancelButtonTitle, for: UIControlState())
        self.cancelButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: UIControlState())
        self.cancelButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5), for: UIControlState.highlighted)
        self.cancelButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.cancelButton.layer.cornerRadius = kDatePickerDialogCornerRadius
        self.cancelButton.addTarget(self, action: #selector(DatePickerDialog.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
        container.addSubview(self.cancelButton)
        
        self.doneButton = UIButton(type: UIButtonType.custom) as UIButton
        self.doneButton.frame = CGRect(
            x: buttonWidth,
            y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight,
            width: buttonWidth,
            height: kDatePickerDialogDefaultButtonHeight
        )
        self.doneButton.tag = kDatePickerDialogDoneButtonTag
        self.doneButton.setTitle(self.doneButtonTitle, for: UIControlState())
        self.doneButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: UIControlState())
        self.doneButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5), for: UIControlState.highlighted)
        self.doneButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.doneButton.layer.cornerRadius = kDatePickerDialogCornerRadius
        self.doneButton.addTarget(self, action: #selector(DatePickerDialog.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
        container.addSubview(self.doneButton)
    }
    
    func buttonTapped(_ sender: UIButton!) {
        if sender.tag == kDatePickerDialogDoneButtonTag {
            self.callback(self.datePicker.date)
        } else if sender.tag == kDatePickerDialogCancelButtonTag {
            //There's nothing do to here \o\
        }
        
        close()
    }
    
    /* Helper function: count and return the screen's size */
    func countScreenSize() -> CGSize {
        var screenWidth = UIScreen.main.bounds.size.width
        var screenHeight = UIScreen.main.bounds.size.height
        
        let interfaceOrientaion = UIApplication.shared.statusBarOrientation
        
        if UIInterfaceOrientationIsLandscape(interfaceOrientaion) {
            let tmp = screenWidth
            screenWidth = screenHeight
            screenHeight = tmp
        }
        
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
}
