//
//  UITableView+customReload.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 30/1/16.
//  Copyright © 2016 Guillem Budia Tirado. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIViewController{
    func customViewWillAppear(){}//Abstract method to be override!
    func customViewWillDisappear(){}//Abstract method to be override!
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    

}

@objc extension UIScrollView{
    
    func hasReachedEnd(with margin: CGFloat = 0) -> Bool {
        
        let bottomEdge = contentOffset.y + bounds.height;
        return bottomEdge >= contentSize.height - margin
            
    }
    
    
}

extension String {
    
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html), convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.characterEncoding): String.Encoding.utf8.rawValue]), documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    //Returns True if string value is a valid email, False otherwise
    func isValidEmail() -> Bool {
        let emailRegularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegularExpression)
        return emailTest.evaluate(with: self)
    }
    
    //TODO: geneal zip code validation
    func isValidSpanishZipCode() -> Bool {
        
        let rx = "^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$"
        let zipTest = NSPredicate(format:"SELF MATCHES %@", rx)
        return zipTest.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isValidSpanishPhoneNumber() -> Bool {
        let regex = "^(\\+34|0034|34)?[6|7|9][0-9]{8}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return phoneTest.evaluate(with: self)
    }
    
    func hasNoSpecialChars() -> Bool {
        let characterset = CharacterSet(charactersIn: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._,!?¿¡()-")
        return self.rangeOfCharacter(from: characterset.inverted) == nil
    }
    
    static func localized(forKey key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    static func localized(forKey key: String, withArguments arguments: CVarArg...) -> String {
        return withVaList(arguments) {
            return NSString(format: self.localized(forKey: key), arguments: $0) as String
        }
    }

}

extension UIView {
    
    static func setHidden(toViews views: [UIView], toHide hide: Bool) {
        for view in views {
            view.isHidden = hide
        }
    }
    
    static func setBackground(ofViews views: [UIView], withColor color: UIColor) {
        for view in  views {
            view.backgroundColor = color
        }
    }
    
    static func setRound(toViews views: [UIView], toRound: Bool) {
        for view in views {
            toRound ? view.makeCircular() : view.makeRound(radiusPoints: 0)
        }
    }
    
    static func setRound(toViews views: [UIView], by points: CGFloat, toRound: Bool) {
        for view in views {
            toRound ? view.makeRound(radiusPoints: points) : view.makeRound(radiusPoints: 0)
        }
    }
    
    static func setTransorm(toViews views: [UIView], transform: CGAffineTransform) {
        for view in views {
            view.transform = transform
        }
    }

    
    func makeCircular(clipToBounds: Bool = true){
        self.clipsToBounds = clipToBounds
        self.layer.cornerRadius = self.bounds.height*0.5
    }
    
    func makeRound(radius: CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height*radius
    }
    func makeRound(radiusPoints points: CGFloat, clipToBounds: Bool = true) {
        self.clipsToBounds = clipToBounds
        self.layer.cornerRadius = points
    }
    func setBorder(borderWidth width: CGFloat, borderColor color: CGColor){
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
    
    func addBottomLine(height: CGFloat, customColor: CGColor?){
        let bottomBorder = CALayer()
        
        bottomBorder.frame = CGRect(x: 0, y: self.bounds.height-height, width: self.bounds.width, height: height)
        if customColor != nil{
            bottomBorder.backgroundColor = customColor
        }else{
            bottomBorder.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6).cgColor
        }
        self.layer.addSublayer(bottomBorder)
    }
    
    func addBottomLine(withLayerReference bottomBorder: CALayer, height: CGFloat, customColor: CGColor?, offSet: CGFloat){
        bottomBorder.frame = CGRect(x: 0, y: self.bounds.height-height+offSet, width: self.bounds.width, height: height)
        if customColor != nil{
            bottomBorder.backgroundColor = customColor
        }else{
            bottomBorder.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6).cgColor
        }
        self.layer.addSublayer(bottomBorder)
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func bounceAnimation(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    func setSuperPosedShadow(){
        if let _superView: UIView = self.superview{
            
            
            if let shadowView = _superView.viewWithTag(100) {
                shadowView.frame = self.frame
                return
            }
            
            let shadowView = UIView(frame: self.frame)
            shadowView.tag = 100
            
            _superView.insertSubview(shadowView, belowSubview: self)
            
            shadowView.backgroundColor = UIColor.clear
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
            shadowView.layer.shadowOpacity = 0.3
            shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
            shadowView.layer.shadowRadius = 5
            
            shadowView.translatesAutoresizingMaskIntoConstraints = false

            
            let width = NSLayoutConstraint(item: shadowView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0)
            let height = NSLayoutConstraint(item: shadowView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0)
            let top = NSLayoutConstraint(item: shadowView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
            let leading = NSLayoutConstraint(item: shadowView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
            
            _superView.addConstraint(width)
            _superView.addConstraint(height)
            _superView.addConstraint(top)
            _superView.addConstraint(leading)
            

        }
    }
    
}


extension UIImage {
    func getPixelColor() -> UIColor {
        let pixelData = self.cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let y = self.size.height-10
        let x = self.size.width/2
        
        
        print(self.size)
        let pixelInfo1: Int = ((Int(self.size.width) * Int(y)) + Int(x)) * 4
        let pixelInfo2: Int = ((Int(self.size.width) * Int(y-10)) + Int(x)) * 4
        let pixelInfo3: Int = ((Int(self.size.width) * Int(y-2)) + Int(x-5)) * 4
        let pixelInfo4: Int = ((Int(self.size.width) * Int(y-2)) + Int(x+5)) * 4


        let r = (CGFloat(data[pixelInfo1])+CGFloat(data[pixelInfo2])+CGFloat(data[pixelInfo3])+CGFloat(data[pixelInfo4])) / (CGFloat(255.0)*4)
        let g = (CGFloat(data[pixelInfo1+1])+CGFloat(data[pixelInfo2+1])+CGFloat(data[pixelInfo3+1])+CGFloat(data[pixelInfo4+1])) / (CGFloat(255.0)*4)
        
        
        let b1 = (CGFloat(data[pixelInfo1+2])/CGFloat(255.0))
        print(b1)
        let b2 = (CGFloat(data[pixelInfo2+2])/CGFloat(255.0))
        print(b2)
        let b3 = (CGFloat(data[pixelInfo3+2])/CGFloat(255.0))
        print(b3)
        let b4 = (CGFloat(data[pixelInfo4+2])/CGFloat(255.0))
        print(b4)


        let b = (b1+b2+b3+b4)/4
        
        let a = CGFloat(data[pixelInfo1+3]) / CGFloat(255.0)
        
        if(r>0.9 && g>0.9 && b>0.9 ){
         return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        }else{
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        
    }
    
    func makeTemplate()->UIImage{
        return self.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
    func makeOriginal()->UIImage{
        return self.withRenderingMode(.alwaysOriginal)
    }
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


extension UIViewController{
    
    func showTextFieldAlert(title: String, subtitle: String, placeholder: String, onCompletion: @escaping (String)->()) {
        
        let alert = UIAlertController(title: title,
                                      message: subtitle,
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = placeholder
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let text = alert?.textFields?.first?.text, !text.isEmpty else { return }
            
            onCompletion(text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showMessage(title: String, message: String, actions: [UIAlertAction]) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            for action in actions {
                alertController.addAction(action)
            }
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func showMessage(title: String, message: String, onCompletion: (() -> ())?=nil){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {alert in
                onCompletion?()
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
    
    
    
    func showLocalizedMessage(localizedTitle: String, localizedMessage: String, localizedButtonText: String = "OK", onCompletion: (() -> ())?=nil){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: NSLocalizedString(localizedTitle, comment: ""), message: NSLocalizedString(localizedMessage, comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: String.localized(forKey: localizedButtonText), style: UIAlertAction.Style.default,handler: {alert in
                onCompletion?()
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
    
    func setMMBackgroundColor(){
        self.view.backgroundColor = UIColor.mmBackground()
    }
    
    func showActionSheet(title: String, message: String? = nil, actions: [UIAlertAction], completion: (()->())? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: String.localized(forKey: "Cancel"), style: UIAlertAction.Style.cancel)
        
        alertController.addAction(cancelAction)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        present(alertController, animated: true, completion: completion)
    }
}

extension UILabel{
    
    //Attribute for spacing between characters
    @IBInspectable var kerning: Float {
        get {
            var range = NSMakeRange(0, (text ?? "").count)
            guard let kern = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: &range),
                let value = kern as? NSNumber
                else {
                    return 0
            }
            return value.floatValue
        }
        set {
            var attText:NSMutableAttributedString
            
            if let attributedText = attributedText {
                attText = NSMutableAttributedString(attributedString: attributedText)
            } else if let text = text {
                attText = NSMutableAttributedString(string: text)
            } else {
                attText = NSMutableAttributedString(string: "")
            }
            
            let range = NSMakeRange(0, attText.length)
            attText.addAttribute(NSAttributedString.Key.kern, value: NSNumber(value: newValue), range: range)
            self.attributedText = attText
        }
    }
}

extension UITextField{
    
    //Attribute for spacing between characters
    @IBInspectable var kerning: Float {
        get {
            var range = NSMakeRange(0, (text ?? "").count)
            guard let kern = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: &range),
                let value = kern as? NSNumber
                else {
                    return 0
            }
            return value.floatValue
        }
        set {
            var attText:NSMutableAttributedString
            
            if let attributedText = attributedText {
                attText = NSMutableAttributedString(attributedString: attributedText)
            } else if let text = text {
                attText = NSMutableAttributedString(string: text)
            } else {
                attText = NSMutableAttributedString(string: "")
            }
            
            let range = NSMakeRange(0, attText.length)
            attText.addAttribute(NSAttributedString.Key.kern, value: NSNumber(value: newValue), range: range)
            self.attributedText = attText
        }
    }
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    var hour0x: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh"
        return dateFormatter.string(from: self)
    }
    var minute0x: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
    
    func formatToMMMdYYYY() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM d, yyyy"
        return dateFormater.string(from: self)
    }
    
    func formatToHHdMMMYYYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm d MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func formatToHHdMMMYYYYSS() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm:ss d MMM yyyy"
        return dateFormatter.string(from: self)
    }
}

extension UIImageView{
    func loadImage(withImage image:UIImage?){
        self.image = image
    }
    func loadImage(withURL url: URL?, placeholder: UIImage? = nil){
        
        self.kf.setImage(with: url,
                         placeholder: placeholder,
                         options: [.transition(ImageTransition.fade(0.2))])
        
        
    }
    
    func loadImage(withPath path:String){
        if let image = UIImage(contentsOfFile: path){
            self.loadImage(withImage: image)
        }
    }
    func loadImage(withPath path: String, placeholder: UIImage){
        self.image = UIImage(contentsOfFile: path) ?? placeholder
    }
}

extension UIColor {
    
    static let mmSkeletonGray = UIColor.groupTableViewBackground
    
    static let mmYellow: UIColor = UIColor(red: 250, green: 210, blue: 55)
    
    static let mmPurple: UIColor = UIColor(red: 107, green: 69, blue: 255)
    
    static func mmBlue() -> UIColor {
        return UIColor(red: 0, green: 183/255, blue: 251/255, alpha: 1)
    }
    static func mmBackground() -> UIColor {
        return UIColor.white
    }
    static func mmGreen() -> UIColor {
        return UIColor(red: 0, green: 1, blue: 155/255, alpha: 1)
    }
    static func mmRed() -> UIColor {
        return UIColor(red: 1.0, green: 75/255, blue: 87/255, alpha: 1)
    }
    static func mmTranslucentLightGray() -> UIColor {
        return lightGray.withAlphaComponent(0.65)
    }
    
    static func mmGrey() -> UIColor {
        return UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
    }
    
    static func mmBlueFacebook() -> UIColor {
        return UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    }
    
    static func officialApplePlaceholderGray() -> UIColor {
        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
    
    static func mmGrayLighten30() -> UIColor {
        return UIColor(red: 116.0/255.0, green: 118.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    }
    
    static func mmSilverBase() -> UIColor {
        return UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    }
    
    static func mmRedBase() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }
    
    static func mmVioletBase() -> UIColor {
        return UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
    }
    
    static func mmWildWatermelon() -> UIColor {
        return UIColor(red: 1, green: 80.0/255.0, blue: 124.0/255.0, alpha: 1.0)
    }
    static func mmPurpleBlue() -> UIColor {
        return UIColor(red: 82.0/255.0, green: 87.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }
    
    static func mmYellowTerms() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 221.0/255.0, blue: 126.0/255.0, alpha: 1.0)
    }
    
    static func mmGrayLight() -> UIColor {
        return UIColor(red: 116.0/255.0, green: 118.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    }
    
    func readableBackgroundMatchingColor() -> UIColor{
        
        var darknessScore: CGFloat = 1

        if let cgColorComponents = self.cgColor.components{
            let colorComponents = cgColorComponents.map({$0 * CGFloat(255)})
     
            if(colorComponents.count == 0){
                darknessScore = ((colorComponents[0]*299) + (colorComponents[0]*587) + (colorComponents[0]*114))
            }else{
                darknessScore = ((colorComponents[0]*299) + (colorComponents[1]*587) + (colorComponents[2]*114))
            }
        }
        
        if(darknessScore/1000 >= 125){
            return UIColor.black
        }
        return UIColor.white
    }
}


extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid rearrange indexes")
        insert(remove(at: from), at: to)
    }
}

extension UIFont {
    
    var monospacedDigitFont: UIFont {
        let oldFontDescriptor = fontDescriptor
        let newFontDescriptor = oldFontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
    
}

private extension UIFontDescriptor {
    
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [[convertFromUIFontDescriptorFeatureKey(UIFontDescriptor.FeatureKey.featureIdentifier): kNumberSpacingType, convertFromUIFontDescriptorFeatureKey(UIFontDescriptor.FeatureKey.typeIdentifier): kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [convertFromUIFontDescriptorAttributeName(UIFontDescriptor.AttributeName.featureSettings): fontDescriptorFeatureSettings]
        let fontDescriptor = self.addingAttributes(convertToUIFontDescriptorAttributeNameDictionary(fontDescriptorAttributes))
        return fontDescriptor
    }
    
}

extension UINavigationController{
    func  setBarTextFont(font: UIFont){
        self.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([ NSAttributedString.Key.font.rawValue: font])
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension NSMutableAttributedString {
    
    public func attachToLink(textToFind:String, linkURL:String){
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
        }
    }
}

extension Dictionary{
    public func toJSONObject() -> JSON? {
        var jsonString: String = "{"
        for key in self.keys{
            jsonString += "\"\(key)\": \"\(self[key]!)\","
        }
        jsonString = jsonString.substring(to: jsonString.index(before: jsonString.endIndex))
        jsonString += "}"
        
        return JSON(uncheckedData: jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
    }
}

private var changeNavBarStyle: Bool = true
private var navBarStylingFinished: Bool = true
extension UINavigationBar{
    
    public func makeTransparent(){
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
    
    public func setDefaultStyle(isTranslucent: Bool = false, setAlsoStatusBar: Bool = true){
        if(!navBarStylingFinished){changeNavBarStyle = false}
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = nil        
        self.tintColor = UIColor.mmBlue()
        if(setAlsoStatusBar){
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    public func defaultBackground(){
        self.backgroundColor = nil
        UIApplication.shared.statusBarView?.backgroundColor = nil
    }
    
    public func opaque(withAlpha alpha: CGFloat = 1, color: UIColor = UIColor.white) {
        self.backgroundColor = color.withAlphaComponent(alpha)
        UIApplication.shared.statusBarView?.backgroundColor = color.withAlphaComponent(alpha)
    }
    
}

extension UINavigationItem {
    
    func setSingleTitle(_ title: String, labelReference: UILabel? = nil) {
        let one = labelReference ?? UILabel()
        one.text = title
        one.font = UIFont.boldSystemFont(ofSize: 16)
        one.sizeToFit()
        
        self.titleView = one
    }
    
    func setTitle(title:String, subtitle:String) {
        
        let one = UILabel()
        one.text = title
        one.font = UIFont.boldSystemFont(ofSize: 16)
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.font = UIFont.systemFont(ofSize: 12)
        two.textAlignment = .center
        two.sizeToFit()
        
        
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        self.titleView = stackView
    }
}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIFontDescriptorFeatureKey(_ input: UIFontDescriptor.FeatureKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIFontDescriptorAttributeName(_ input: UIFontDescriptor.AttributeName) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIFontDescriptorAttributeNameDictionary(_ input: [String: Any]) -> [UIFontDescriptor.AttributeName: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIFontDescriptor.AttributeName(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
