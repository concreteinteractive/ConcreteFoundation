//
//  UIView+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "UIView+Concrete.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Concrete)

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    CGSize size = CGSizeMake(radius, radius);
    [self setRoundedCorners:corners radii:size];
}

- (void)setRoundedCorners:(UIRectCorner)corners radii:(CGSize)size
{
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer* maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
