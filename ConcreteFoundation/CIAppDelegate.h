//
//  CIAppDelegate.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CIMainViewController;

@interface CIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CIMainViewController *mainViewController;

@end
