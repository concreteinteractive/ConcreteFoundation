//
//  UITableViewCell+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/16/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "UITableViewCell+Concrete.h"

@implementation UITableViewCell (Concrete)

- (void)animateUpdates
{
    if ([self.superview isKindOfClass:[UITableView class]])
    {
        [(UITableView *)self.superview beginUpdates];
        [(UITableView *)self.superview endUpdates];
    }
}

+ (CGFloat)cellHeightForObject:(id)object
{
    return 44.0;
}

@end
