//
//  UITableViewCell+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/16/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Concrete)

- (void)animateUpdates;
+ (CGFloat)cellHeightWithWidth:(CGFloat)width forObject:(id)object;

@end
