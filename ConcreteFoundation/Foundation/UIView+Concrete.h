//
//  UIView+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Concrete)

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)setRoundedCorners:(UIRectCorner)corners radii:(CGSize)size;

@end
