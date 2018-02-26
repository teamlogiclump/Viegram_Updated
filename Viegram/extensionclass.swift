//
//  extensionclass.swift
//  MS MAYA
//
//  Created by Jagdeep on 26/08/16.
//  Copyright © 2016 relinns. All rights reserved.
//



import UIKit
//import MRProgress
class extensionclass: NSObject {
    
    static let sharedInstance = extensionclass()
    
    
    func getArray() -> NSArray?{
        if let path = Bundle.main.path(forResource: "isd", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else {
                  print("serialization failed in get country code data")
                    return  nil
                }
                print(json)
                return json
                
            } catch let error {
                print(error.localizedDescription)
                return nil
                
            }
        } else {
            print("Invalid filename/path.")
            return nil
        }
    }
    
}
extension UIViewController{
    func showalertViewcontroller(message:String,handler:@escaping () -> Void){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        //alert.setValue(apppurple, forKey: "OK")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            
            DispatchQueue.main.async {
                handler()
                //alert.setValue(apppurple, forKey: "OK")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String
{
    
    
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailFormat).evaluate(with: self)
    }
    
    
    func validate() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
        
    }
    
    func checkCapital() -> Bool{
        
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        return capitalresult
    
    
        }
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.unicode)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ,
                NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2: NSAttributedString? {
        return html2AttributedString?.string.html2AttributedString
    }
}


extension UIView {
    
    func startProgresshud(){
       DispatchQueue.main.async {
            
            
            if let _ = self.viewWithTag(40) {
                //View is already locked
            }
            else {
                self.isUserInteractionEnabled = false
                let lockView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 4, height: self.frame.size.width / 4))
                lockView.layer.cornerRadius = 10
                lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
                lockView.tag = 40
                lockView.alpha = 0.0
                let activity = UIActivityIndicatorView()
                
                activity.center = lockView.center
                activity.startAnimating()
                lockView.addSubview(activity)
                
                self.addSubview(lockView)
                
                UIView.animate(withDuration: 0.2) {
                    lockView.alpha = 1.0
                }
                lockView.center = self.center
            }
        }
    }
    
    func stopProgressHud() {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = true
            if let lockView = self.viewWithTag(40) {
                UIView.animate(withDuration: 0.2, animations: {
                    lockView.alpha = 0.0
                }) { finished in
                    lockView.removeFromSuperview()
                }
            }
        }
    }
    
    func addshodow(view:UIView){
        let shadowSize : CGFloat = 0.2
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: view.frame.size.width + shadowSize,
                                                   height: view.frame.size.height + shadowSize))
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowPath = shadowPath.cgPath    }

   

}
extension UIViewController{
    func addshodow(view:UIView){
        let shadowSize : CGFloat = 0.1
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: view.frame.size.width + shadowSize,
                                                   height: view.frame.size.height + shadowSize))
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowPath = shadowPath.cgPath
    }

    func showalertview(messagestring:String){
       DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: messagestring, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAlert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        
        alert.addAction(cancelAlert)
        
                        self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func showalertview(messagestring:String, Buttonmessage: String ,handler:@escaping () -> Void ){
       DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: messagestring, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Buttonmessage, style: .default, handler: { action  in
               DispatchQueue.main.async {
                    handler()
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }}
    
extension UIColor {
        convenience init(red: Int, green: Int, blue: Int) {
            assert(red >= 0 && red <= 255, "Invalid red component")
            assert(green >= 0 && green <= 255, "Invalid green component")
            assert(blue >= 0 && blue <= 255, "Invalid blue component")
            
            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        }
        
        convenience init(netHex:Int) {
            self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
        }
    }

extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType? {
        guard iPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return nil
        }
    }



}
extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
}


// extension for impage uploading
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
    
}
extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: characters.index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: characters.index(endIndex, offsetBy: -count))
    }
}
extension String {
    subscript(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    subscript(range: CountableRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex)]
    }
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex)]
    }
}
extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func compressImage() -> Data {
        
        let imageData = UIImagePNGRepresentation(self)
        var image = UIImage(data: imageData!)
        func compressImage(image:UIImage) -> Data {
            // Reducing file size to a 10th
            var actualHeight : CGFloat = image.size.height
            var actualWidth : CGFloat = image.size.width
            let maxHeight : CGFloat = 1136.0
            let maxWidth : CGFloat = 640.0
            var imgRatio : CGFloat = actualWidth/actualHeight
            let maxRatio : CGFloat = maxWidth/maxHeight
            var compressionQuality : CGFloat = 0.5
            
            if (actualHeight > maxHeight || actualWidth > maxWidth){
                if(imgRatio < maxRatio){
                    //adjust width according to maxHeight
                    imgRatio = maxHeight / actualHeight;
                    actualWidth = imgRatio * actualWidth;
                    actualHeight = maxHeight;
                }
                else if(imgRatio > maxRatio){
                    //adjust height according to maxWidth
                    imgRatio = maxWidth / actualWidth;
                    actualHeight = imgRatio * actualHeight;
                    actualWidth = maxWidth;
                }
                else{
                    actualHeight = maxHeight;
                    actualWidth = maxWidth;
                    compressionQuality = 1;
                }
            }
            let rect = CGRect(x:0.0,y: 0.0,width: actualWidth,height: actualHeight);
            UIGraphicsBeginImageContext(rect.size);
            image.draw(in: rect)
            let img = UIGraphicsGetImageFromCurrentImageContext();
            let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
            UIGraphicsEndImageContext();
            return imageData!;
        }
        let compressedImage = compressImage(image: image!)
        return compressedImage
    }
}
