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

- (NSArray *)delegates
{
    return [super delegates];
}

- (void)addDelegate:(id<CIRootViewControllerDelegate>)delegate
{
    [super addDelegate:delegate];
}

- (void)removeDelegate:(id<CIRootViewControllerDelegate>)delegate
{
    [super removeDelegate:delegate];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    for (id<CIRootViewControllerDelegate> delegate in self.delegates)
    {
        if ([delegate respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        {
            [delegate dismissViewControllerAnimated:flag completion:completion];
        }
    }
}

@end
