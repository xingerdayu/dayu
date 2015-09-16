//
//  Extension.swift
//  Community
//
//  Created by Xinger on 15/3/18.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//
extension NSString {
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if CGSizeEqualToSize(size, CGSizeZero) {
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            textSize = self.sizeWithAttributes(attributes)
        } else {
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
}

extension String {
    var md5 : String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
            let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
            
            CC_MD5(str!, strLen, result);
            
            var hash = NSMutableString();
            for i in 0 ..< digestLen {
                hash.appendFormat("%02x", result[i]);
            }
            result.destroy();
            
            return String(format: hash).lowercaseString
    }}

extension UIImage {
    func scaleToSize(newSize:CGSize) -> UIImage {
        // Create a graphics image context
        UIGraphicsBeginImageContext(newSize);
        
        // Tell the old image to draw in this new context, with the desired
        // new size
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        // Get the new image from the context
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // End the context
        UIGraphicsEndImageContext();
        
        return newImage
    }
}