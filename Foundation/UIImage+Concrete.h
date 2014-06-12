//
//  UIImage+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 10/18/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#import "UIImage+ImageEffects.h"
#endif

@interface UIImage (Concrete)

// Returns an image that has been transformed using the original image's
// metadata to appear correctly in contexts where the metadata is ignored.
- (UIImage *)imageWithOrientationNormalized;


#pragma mark - Resizing
- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

#pragma mark - Grayscale
- (UIImage *)grayscaleImage:(UIImage *)initialImage;

#pragma mark - Alpha support
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

#pragma mark - Rounded corners
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

@end
