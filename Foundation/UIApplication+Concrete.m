//
//  UIApplication+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "UIApplication+Concrete.h"

@implementation UIApplication (Concrete)

static NSInteger networkOperationCount = 0;

+ (UIViewController *)rootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

+ (void)setRootViewController:(UIViewController *)viewController
{
    [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
}

+ (void)setRootViewControllerFromStoryboard:(NSString *)storyboardName withViewControllerId:(NSString *)viewControllerId
{
    UIViewController* viewController = [UIApplication viewControllerFromStoryboard:storyboardName withViewControllerId:viewControllerId];
    [UIApplication setRootViewController:viewController];
}

+ (id)viewControllerFromStoryboard:(NSString *)storyboardName withViewControllerId:(NSString *)viewControllerId
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    if(storyboard == nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Unable to find storyboard with name: %@",storyboardName] userInfo:nil];
    }
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerId];
    
    if(viewController == nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Unable to find viewController with id: %@ in storyboard: %@", viewControllerId, storyboardName] userInfo:nil];
    }
    return viewController;
}

+ (void)startNetworkActivity {
    networkOperationCount++;
    [[UIApplication sharedApplication] updateNetworkActivityIndicator];
}

+ (void)finishNetworkActivity {
    if (networkOperationCount > 0)
    {
        networkOperationCount--;
    }
    [[UIApplication sharedApplication] updateNetworkActivityIndicator];
}

- (void)updateNetworkActivityIndicator {
    [self setNetworkActivityIndicatorVisible:(networkOperationCount > 0 ? TRUE : FALSE)];
}

@end
