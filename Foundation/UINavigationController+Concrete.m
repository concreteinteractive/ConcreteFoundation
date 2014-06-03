//
//  UINavigationController+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "UINavigationController+Concrete.h"

@interface UINavigationController ()
@end

@implementation UINavigationController (Concrete)

// Pops the top viewController off of the navigation stack, then pushes the new view controller.
// Returns the popped controller.
- (UIViewController *)popViewControllerThenPushViewController:(UIViewController *)viewControllerToPush
                                         withAnimationOptions:(UINavigationControllerAnimationOptions)animationOptions
{
    NSArray* result = [self popToViewController:[self.viewControllers objectAtIndex:[self.viewControllers count] - 2]
                        thenPushViewControllers:[NSArray arrayWithObject:viewControllerToPush]
                           withAnimationOptions:animationOptions];
    return [result lastObject];
}

// Pops view controllers until the one specified is on top, the pushes the new viewControllers.
// Returns the popped controllers.
- (NSArray *)popToViewController:(UIViewController *)stopAtViewController
         thenPushViewControllers:(NSArray *)viewControllersToPush
            withAnimationOptions:(UINavigationControllerAnimationOptions)animationOptions
{
//    UINavigationControllerAnimationOptions curveOption = animationOptions & 3;
//    UINavigationControllerAnimationOptions transitionOption = animationOptions ^ curveOption;
    NSArray* poppedViewControllers = nil;
//    if (transitionOption & UINavigationControllerAnimationOptionTransitionSlideInOut)
//    {
//        BOOL slideIn = transitionOption & UINavigationControllerAnimationOptionTransitionSlideIn;
//        BOOL slideOut = transitionOption & UINavigationControllerAnimationOptionTransitionSlideOut;
//        if (slideIn && slideOut)
//        {
//            poppedViewControllers = [self popToViewController:stopAtViewController animated:YES];
//            for (UIViewController* viewController in viewControllersToPush)
//            {
//                if ([viewController isKindOfClass:[UIViewController class]])
//                {
//                    [self pushViewController:viewController animated:YES];
//                }
//            }
//            return poppedViewControllers;
//        } else if (slideIn)
//        {
//            NSMutableArray* viewControllers = [self.viewControllers mutableCopy];
//            if ([viewControllers lastObject] != stopAtViewController && [viewControllers containsObject:stopAtViewController])
//            {
//                NSUInteger loc = [viewControllers indexOfObject:stopAtViewController] + 1;
//                NSUInteger len = [viewControllers count] - 1 - loc;
//                NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, len)];
//                poppedViewControllers = [viewControllers objectsAtIndexes:indexSet];
//                [viewControllers removeObjectsAtIndexes:indexSet];
//            }
//            [self setViewControllers:[viewControllers arrayByAddingObjectsFromArray:viewControllersToPush] animated:YES];
//            return poppedViewControllers;
//        } else if (slideOut)
//        {
//            NSMutableArray* viewControllers = [self.viewControllers mutableCopy];
//            if ([viewControllers lastObject] != stopAtViewController && [viewControllers containsObject:stopAtViewController])
//            {
//                NSUInteger loc = [viewControllers indexOfObject:stopAtViewController] + 1;
//                NSUInteger len = [viewControllers count] - 1 - loc;
//                NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, len)];
//                poppedViewControllers = [viewControllers objectsAtIndexes:indexSet];
//                [viewControllers removeObjectsAtIndexes:indexSet];
//            }
//            NSArray* endViewControllers = [viewControllers arrayByAddingObjectsFromArray:viewControllersToPush];
//            [self setViewControllers:[endViewControllers arrayByAddingObjectsFromArray:poppedViewControllers] animated:NO];
//            [self setViewControllers:endViewControllers animated:YES];
//            return poppedViewControllers;
//        }
//    }
    UIViewAnimationOptions viewAnimationOptions = (animationOptions & 127) << 16;
    NSMutableArray* viewControllers = [self.viewControllers mutableCopy];
    if ([viewControllers lastObject] != stopAtViewController && [viewControllers containsObject:stopAtViewController])
    {
        NSUInteger loc = [viewControllers indexOfObject:stopAtViewController] + 1;
        NSUInteger len = [viewControllers count] - 1 - loc;
        poppedViewControllers = [viewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, len)]];
    }
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:viewAnimationOptions
                     animations:^(void){
                         [self popToViewController:stopAtViewController animated:NO];
                         for (UIViewController* viewController in viewControllersToPush)
                         {
                             if ([viewController isKindOfClass:[UIViewController class]])
                             {
                                 [self pushViewController:viewController animated:NO];
                             }
                         }
                     }
                     completion:^(BOOL finished){}];
    
    return poppedViewControllers;
}

// Pops until there's only a single view controller left on the stack, the pushes the new viewControllers.
// Returns the popped controllers.
- (NSArray *)popToRootViewControllerThenPushViewControllers:(NSArray *)viewControllersToPush
                                       withAnimationOptions:(UINavigationControllerAnimationOptions)animationOptions
{
    return [self popToViewController:[self.viewControllers objectAtIndex:0]
             thenPushViewControllers:viewControllersToPush
                withAnimationOptions:animationOptions];
}

@end
