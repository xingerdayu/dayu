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