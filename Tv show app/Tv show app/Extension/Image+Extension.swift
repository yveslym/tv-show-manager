//
//  Image+Extension.swift
//  Tv show app
//
//  Created by Yveslym on 1/16/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    static func blurImage(image:UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: image)
        let originalOrientation = image.imageOrientation
        let originalScale = image.scale
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(10.0, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        
        var cgImage:CGImage?
        
        if let asd = outputImage
        {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }
        
        if let cgImageA = cgImage
        {
            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
        }
        
        return nil
    }
    
   
    
    static func blurEffect(image: UIImage) ->UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
  
//        
//        func tintWithColor(color:UIColor)->UIImage {
//            
//            UIGraphicsBeginImageContext(self.size)
//            let context = UIGraphicsGetCurrentContext()
//            
//            // flip the image
//            CGContextScaleCTM(context!, 1.0, -1.0)
//            CGContext.scaleBy(x:1.0,y:-1.0)
//            
//            CGContextTranslateCTM(context, 0.0, -self.size.height)
//            
//            // multiply blend mode
//            CGContextSetBlendMode(context, kCGBlendModeMultiply)
//            
//            let rect = CGRectMake(0, 0, self.size.width, self.size.height)
//            CGContextClipToMask(context, rect, self.CGImage)
//            color.setFill()
//            CGContextFillRect(context, rect)
//            
//            // create uiimage
//            let newImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            return newImage
//            
//        }
        
    
}
