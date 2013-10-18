//
//  UIImage+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 10/18/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Concrete)

// Returns an image that has been transformed using the original image's
// metadata to appear correctly in conexts where the metadata is ignored.
- (UIImage *)imageWithOrientationNormalized;

@end
