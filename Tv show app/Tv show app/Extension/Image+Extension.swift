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
  
    func extractColor(image: UIImage){
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        //CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.cgImage)
        context?.draw((context?.makeImage())!, in: CGRect(origin: .zero, size: CGSize(width: 1, height: 1)), byTiling: (image.cgImage != nil))
//        context.draw(image!.cgImage!, in: CGRect(x: 0.0,y: 0.0,width: image!.size.width,height: image!.size.height))

        
        var color: UIColor? = nil
        
        if pixel[3] > 0 {
            let alpha:CGFloat = CGFloat(pixel[3]) / 255.0
            let multiplier:CGFloat = alpha / 255.0
            
            color = UIColor(red: CGFloat(pixel[0]) * multiplier, green: CGFloat(pixel[1]) * multiplier, blue: CGFloat(pixel[2]) * multiplier, alpha: alpha)
        }else{
            
            color = UIColor(red: CGFloat(pixel[0]) / 255.0, green: CGFloat(pixel[1]) / 255.0, blue: CGFloat(pixel[2]) / 255.0, alpha: CGFloat(pixel[3]) / 255.0)
        }
        
        if color != nil {
            print( self.toHexString(color: color!) )
        }
        pixel.deallocate(capacity: 4)
    }
    
    func toHexString(color: UIColor) -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    
}

extension UIImageView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.cornerRadius = 5
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}
extension UIView{
    func getRandomColor(alpha: CGFloat) {
        let red   = Float((arc4random() % 256)) / 255.0
        let green = Float((arc4random() % 256)) / 255.0
        let blue  = Float((arc4random() % 256)) / 255.0
        let alpha = alpha
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options:[.repeat, .autoreverse], animations: {
            //self.backgroundColor = UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: alpha)
            self.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        }, completion:nil)
    }
}

