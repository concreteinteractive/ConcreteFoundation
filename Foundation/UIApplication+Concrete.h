//
//  UIApplication+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Concrete)

+ (id)viewControllerFromStoryboard:(NSString *)storyboardName withViewControllerId:(NSString *)viewControllerId;

+ (void)startNetworkActivity;
+ (void)finishNetworkActivity;

@end
