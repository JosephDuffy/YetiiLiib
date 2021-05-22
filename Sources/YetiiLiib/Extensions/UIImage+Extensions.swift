import UIKit

extension UIImage {

    /**
     Returns a new UIImage with the a clipping mask applied
     
     See: http://iosdevelopertips.com/cocoa/how-to-mask-an-image.html
     
     - Parameter maskImage: The image mask to apply
     - Returns: The new `UIImage` with the mask applied, or `nil` in the case of an error
    */
    public func imageAfterApplyingMask(_ maskImage: UIImage) -> UIImage? {
        let maskRef = maskImage.cgImage
        let mask = CGImage(maskWidth: (maskRef?.width)!,
            height: (maskRef?.height)!,
            bitsPerComponent: (maskRef?.bitsPerComponent)!,
            bitsPerPixel: (maskRef?.bitsPerPixel)!,
            bytesPerRow: (maskRef?.bytesPerRow)!,
            provider: (maskRef?.dataProvider!)!, decode: nil, shouldInterpolate: false)

        if let maskedCGImage = self.cgImage?.masking(mask!) {
            return UIImage(cgImage: maskedCGImage, scale: self.scale, orientation: .up)
        } else {
            return nil
        }
    }

    public func imageAfterApplyingAppIconMask() -> UIImage? {
        if let maskImage = UIImage(named: "iOS 7 Icon Mask", in: Bundle.framework, compatibleWith: nil) {
            return self.imageAfterApplyingMask(maskImage)
        } else {
            return nil
        }
    }
}
