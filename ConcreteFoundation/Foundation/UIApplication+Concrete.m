//
//  UIApplication+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "UIApplication+Concrete.h"

@implementation UIApplication (Concrete)

static NSInteger networkOperationCount;

+ (void)startNetworkActivity {
    networkOperationCount++;
    [[UIApplication sharedApplication] updateNetworkActivityIndicator];
}

+ (void)finishNetworkActivity {
    networkOperationCount--;
    [[UIApplication sharedApplication] updateNetworkActivityIndicator];
}

- (void)updateNetworkActivityIndicator {
    [self setNetworkActivityIndicatorVisible:(networkOperationCount > 0 ? TRUE : FALSE)];
}

@end
