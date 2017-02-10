//
//  UIButtonExt.m
//  motoon
//
//  Created by xiongfei on 15/5/11.
//  Copyright (c) 2015年 mthk. All rights reserved.
//

#import "UIButtonExt.h"
# import <CommonCrypto/CommonDigest.h>
@implementation UIButtonExt

- (void)setText:(NSString *)text
{
    [self setTitle:text forState:UIControlStateNormal];
    [self setTitle:text forState:UIControlStateHighlighted];
    [self setTitle:text forState:UIControlStateSelected];
    
}

@end
@implementation UIImage(extension)

+ (UIImage*)stretchImage:(NSString*)name
{
    UIImage *image = nil;
    if (name && name.length > 0) {
        image = [self imageNamed:name];
        CGSize imgSize = image.size;
        CGPoint pt = CGPointMake(.5, .5);
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(imgSize.height * pt.y,
                                                                    imgSize.width * pt.x,
                                                                    imgSize.height * (1 - pt.y),
                                                                    imgSize.width * (1 - pt.x))];
        
        return image;
    }
    return nil;
}
//- (UIImage*)imageBlur:(CGBlur*)blur maskImage:(UIImage*)maskImage {
//    if (blur == nil)
//        return self;
//    return [self imageBlurWithRadius:blur.radius
//                           tintColor:[UIColor colorWithCGColor:blur.tintColor]
//               saturationDeltaFactor:blur.saturation
//                           maskImage:maskImage];
//}

//- (UIImage*)imageBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
//    // Check pre-conditions.
//    if (self.size.width < 1 || self.size.height < 1) {
//        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
//        return nil;
//    }
//    if (!self.CGImage) {
//        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
//        return nil;
//    }
//    if (maskImage && !maskImage.CGImage) {
//        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
//        return nil;
//    }
//    
//    CGRect imageRect = { CGPointZero, self.size };
//    UIImage *effectImage = self;
//    
//    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
//    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
//    if (hasBlur || hasSaturationChange) {
//        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
//        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
//        CGContextScaleCTM(effectInContext, 1.0, -1.0);
//        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
//        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
//        
//        vImage_Buffer effectInBuffer;
//        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
//        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
//        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
//        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
//        
//        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
//        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
//        vImage_Buffer effectOutBuffer;
//        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
//        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
//        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
//        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
//        
//        if (hasBlur) {
//            // A description of how to compute the box kernel width from the Gaussian
//            // radius (aka standard deviation) appears in the SVG spec:
//            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
//            //
//            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
//            // successive box-blurs build a piece-wise quadratic convolution kernel, which
//            // approximates the Gaussian kernel to within roughly 3%.
//            //
//            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
//            //
//            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
//            //
//            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
//            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
//            if (radius % 2 != 1) {
//                radius += 1; // force radius to be odd so that the three box-blur methodology works.
//            }
//            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
//            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
//            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
//        }
//        BOOL effectImageBuffersAreSwapped = NO;
//        if (hasSaturationChange) {
//            CGFloat s = saturationDeltaFactor;
//            CGFloat floatingPointSaturationMatrix[] = {
//                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
//                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
//                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
//                0,                    0,                    0,  1,
//            };
//            const int32_t divisor = 256;
//            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
//            int16_t saturationMatrix[matrixSize];
//            for (NSUInteger i = 0; i < matrixSize; ++i) {
//                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
//            }
//            if (hasBlur) {
//                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
//                effectImageBuffersAreSwapped = YES;
//            }
//            else {
//                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
//            }
//        }
//        if (!effectImageBuffersAreSwapped)
//            effectImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        if (effectImageBuffersAreSwapped)
//            effectImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    
//    // Set up output context.
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
//    CGContextRef outputContext = UIGraphicsGetCurrentContext();
//    CGContextScaleCTM(outputContext, 1.0, -1.0);
//    CGContextTranslateCTM(outputContext, 0, -self.size.height);
//    
//    // Draw base image.
//    CGContextDrawImage(outputContext, imageRect, self.CGImage);
//    
//    // Draw effect image.
//    if (hasBlur) {
//        CGContextSaveGState(outputContext);
//        if (maskImage) {
//            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
//        }
//        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
//        CGContextRestoreGState(outputContext);
//    }
//    
//    // Add in color tint.
//    if (tintColor) {
//        
//        CGContextSaveGState(outputContext);
//        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
//        CGContextFillRect(outputContext, imageRect);
//        CGContextRestoreGState(outputContext);
//    }
//    
//    // Output image is ready.
//    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return outputImage;
//}

@end
static NSUInteger kCUSTOM_NAVIGATION_ITEM_BAR_BADGE_TAG = 100;

@implementation UIBarButtonItem(ext)

+ (instancetype)initWithImage:(NSString *)image delegate:(id)delegate action:(SEL)action
{
    UIImage* imageN = [UIImage imageNamed:image];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageN.size.width , imageN.size.height )];
    button.tag = kCUSTOM_NAVIGATION_ITEM_BAR_BADGE_TAG;
    [button setImage:imageN forState:UIControlStateNormal];
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
+ (instancetype)initWithTitle:(NSString *)title delegate:(id)delegate action:(SEL)action
{
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40,44)];
    button.tag = kCUSTOM_NAVIGATION_ITEM_BAR_BADGE_TAG;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
//- (void)setBadgeNum:(NSUInteger)num
//{
//    YKBadge *badge = (YKBadge *)[self.customView viewWithTag:kCUSTOM_NAVIGATION_ITEM_BAR_BADGE_TAG];
//    if (!badge) {
//        badge = [[YKBadge alloc] init];
//        badge.center = CGPointOffset( CGRectRightTop(self.customView.frame), -30, 3);
//        [self.customView addSubview:badge];
//    }
//    if ([badge isKindOfClass:[YKBadge class]]) {
//        badge.num = num;
//    }
//}
@end


@implementation NSString (extension)
-(NSString *)md5
{
    const char *str = [self UTF8String];
    if (str == NULL)
    {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
    
}
@end
