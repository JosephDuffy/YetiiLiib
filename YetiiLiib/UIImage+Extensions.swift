//
//  UIImage+Extensions.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

extension UIImage {

    /**
     Returns a new UIImage with the a clipping mask applied
     
     See: http://iosdevelopertips.com/cocoa/how-to-mask-an-image.html
     
     - Parameter maskImage: The image mask to apply
     - Returns: The new `UIImage` with the mask applied, or `nil` in the case of an error
    */
    func imageAfterApplyingMask(maskImage: UIImage) -> UIImage? {
        let maskRef = maskImage.CGImage
        let mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
            CGImageGetHeight(maskRef),
            CGImageGetBitsPerComponent(maskRef),
            CGImageGetBitsPerPixel(maskRef),
            CGImageGetBytesPerRow(maskRef),
            CGImageGetDataProvider(maskRef), nil, false)

        if let maskedCGImage = CGImageCreateWithMask(self.CGImage, mask) {
            return UIImage(CGImage: maskedCGImage, scale: self.scale, orientation: .Up)
        } else {
            return nil
        }
    }

    func imageAfterApplyingAppIconMask() -> UIImage? {
        if let maskImage = Utilities.image(imageName: "iOS 7 Icon Mask", inBundle: Utilities.assetsBundle) {
            return self.imageAfterApplyingMask(maskImage)
        } else {
            return nil
        }
    }
}