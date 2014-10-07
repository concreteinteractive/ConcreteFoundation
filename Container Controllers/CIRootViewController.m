//
//  CIRootViewController.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 5/23/14.
//  Copyright (c) 2014 Concrete Interactive. All rights reserved.
//

#import "CIRootViewController.h"
#import "UIApplication+Concrete.h"
#import "NSObject+Concrete.h"

@interface CIRootViewController ()

@end

@implementation CIRootViewController

+ (CIRootViewController *)sharedInstance
{
    if ([[UIApplication rootViewController] isKindOfClass:[CIRootViewController class]])
    {
        return (CIRootViewController *)[UIApplication rootViewController];
    }
    return nil;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [self.delegate dismissViewControllerAnimated:flag completion:completion];
}

@end
