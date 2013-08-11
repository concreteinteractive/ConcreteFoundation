//
//  UINavigationController+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UINavigationControllerAnimationOptions) {
    UINavigationControllerAnimationOptionCurveEaseInOut            = 0 << 0, // default
    UINavigationControllerAnimationOptionCurveEaseIn               = 1 << 0,
    UINavigationControllerAnimationOptionCurveEaseOut              = 2 << 0,
    UINavigationControllerAnimationOptionCurveLinear               = 3 << 0,
    
    UINavigationControllerAnimationOptionTransitionNone            = 0 << 4, // default
    UINavigationControllerAnimationOptionTransitionFlipFromLeft    = 1 << 4,
    UINavigationControllerAnimationOptionTransitionFlipFromRight   = 2 << 4,
    UINavigationControllerAnimationOptionTransitionCurlUp          = 3 << 4,
    UINavigationControllerAnimationOptionTransitionCurlDown        = 4 << 4,
    UINavigationControllerAnimationOptionTransitionCrossDissolve   = 5 << 4,
    UINavigationControllerAnimationOptionTransitionFlipFromTop     = 6 << 4,
    UINavigationControllerAnimationOptionTransitionFlipFromBottom  = 7 << 4,
    UINavigationControllerAnimationOptionTransitionSlideIn         = 8 << 4,
    UINavigationControllerAnimationOptionTransitionSlideOut       = 16 << 4,
    UINavigationControllerAnimationOptionTransitionSlideInOut     = 24 << 4,
} NS_ENUM_AVAILABLE_IOS(4_0);

@interface UINavigationController (Concrete)

// An array of objects that conform to the UINavigationControllerDelegate protocol.
@property(nonatomic, strong, readonly) NSMutableArray *delegates;

// Adds a delegate to the delegates array
- (void) addDelegate:(id <UINavigationControllerDelegate>)delegate;

// Removes a delegate from the delegates array
- (void) removeDelegate:(id <UINavigationControllerDelegate>)delegate;

// Pops the top viewController off of the navigation stack, then pushes the new view controller.
// Returns the popped controller.
- (UIViewController *)popViewControllerThenPushViewController:(UIViewController *)viewControllerToPush
                                         withAnimationOptions:(UINavigationControllerAnimationOptions)animationOptions;

// Pops view controllers until the one specified is on top, the pushes the new viewControllers.
// Returns the popped controllers.
- (NSArray *)popToViewController:(UIViewController *)stopAtViewController
         thenPushViewControllers:(NSArray *)viewControllersToPush
            withAnimationOptions:(UINavigationControllerAnimationOptions)animationOptions;

// Pops until there's only a single view controller left on the stack, the pushes the new viewControllers.
// Returns the popped controllers.
- (NSArray *)popToRootViewControllerThenPushViewControllers:(NSArray *)viewControllersToPush
                                       withAnimationOptions:(UINavigationControllerAnimationOptions)animationOptions;

@end
