//
//  UINavigationController+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "UINavigationController+Concrete.h"
#import "NSMutableArray+Concrete.h"
#import <objc/runtime.h>

const void* kDelegatesKey;

@interface UINavigationController ()

// An array of objects that conform to the UINavigationControllerDelegate protocol.
@property(nonatomic, strong, readwrite) NSMutableArray *delegates;

@end

@implementation UINavigationController (Concrete)

// Adds a delegate to the delegates array
- (void) addDelegate:(id <UINavigationControllerDelegate>)delegate
{
    if (self.delegates == nil)
    {
        self.delegates = [NSMutableArray mutableArrayUsingWeakReferences];
    }
    if(delegate != nil && ![self.delegates containsObject:delegate]){
        [self.delegates addObject:delegate];
    }
}

// Removes a delegate from the delegates array
- (void) removeDelegate:(id <UINavigationControllerDelegate>)delegate
{
    if(delegate != nil){
        [self.delegates removeObject:delegate];
    }
}

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
    UINavigationControllerAnimationOptions curveOption = animationOptions & 3;
    UINavigationControllerAnimationOptions transitionOption = animationOptions ^ curveOption;
    NSArray* poppedViewControllers = nil;
    if (transitionOption & UINavigationControllerAnimationOptionTransitionSlideInOut)
    {
        BOOL slideIn = transitionOption & UINavigationControllerAnimationOptionTransitionSlideIn;
        BOOL slideOut = transitionOption & UINavigationControllerAnimationOptionTransitionSlideOut;
        if (slideIn && slideOut)
        {
            poppedViewControllers = [self popToViewController:stopAtViewController animated:YES];
            for (UIViewController* viewController in viewControllersToPush)
            {
                if ([viewController isKindOfClass:[UIViewController class]])
                {
                    [self pushViewController:viewController animated:YES];
                }
            }
            return poppedViewControllers;
        } else if (slideIn)
        {
            NSMutableArray* viewControllers = [self.viewControllers mutableCopy];
            if ([viewControllers lastObject] != stopAtViewController && [viewControllers containsObject:stopAtViewController])
            {
                NSUInteger loc = [viewControllers indexOfObject:stopAtViewController] + 1;
                NSUInteger len = [viewControllers count] - 1 - loc;
                NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, len)];
                poppedViewControllers = [viewControllers objectsAtIndexes:indexSet];
                [viewControllers removeObjectsAtIndexes:indexSet];
            }
            [self setViewControllers:[viewControllers arrayByAddingObjectsFromArray:viewControllersToPush] animated:YES];
            return poppedViewControllers;
        } else if (slideOut)
        {
            NSMutableArray* viewControllers = [self.viewControllers mutableCopy];
            if ([viewControllers lastObject] != stopAtViewController && [viewControllers containsObject:stopAtViewController])
            {
                NSUInteger loc = [viewControllers indexOfObject:stopAtViewController] + 1;
                NSUInteger len = [viewControllers count] - 1 - loc;
                NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, len)];
                poppedViewControllers = [viewControllers objectsAtIndexes:indexSet];
                [viewControllers removeObjectsAtIndexes:indexSet];
            }
            NSArray* endViewControllers = [viewControllers arrayByAddingObjectsFromArray:viewControllersToPush];
            [self setViewControllers:[endViewControllers arrayByAddingObjectsFromArray:poppedViewControllers] animated:NO];
            [self setViewControllers:endViewControllers animated:YES];
            return poppedViewControllers;
        }
    }
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
    
    /*
     UIViewController* poppedViewController = self.topViewController;
     [UIView beginAnimations:@"View Flip" context:nil];
     [UIView setAnimationDuration:0.80];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [UIView setAnimationTransition: animationTransition forView:self.view cache:NO];
     [self popViewControllerAnimated:YES];
     [self pushViewController:viewController animated:YES];
     [UIView commitAnimations];
     */
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

#pragma mark - @property delegates accessors

- (void)setDelegates:(NSMutableArray *)delegates
{
    objc_setAssociatedObject(self, kDelegatesKey, delegates, OBJC_ASSOCIATION_RETAIN);
}

- (NSString*)delegates
{
    return objc_getAssociatedObject(self, kDelegatesKey);
}

#pragma mark - @property delegate override

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    if (delegate != nil)
    {
        NSLog(@"UINavigationController delegate property has been overridden. Adding object to the delegates array.");
        [self addDelegate:delegate];
    } else
    {
        NSLog(@"UINavigationController delegate property has been overridden. Please use [UINavigationController removeDelegate:].");
    }
}

- (id<UINavigationControllerDelegate>)delegate
{
    NSLog(@"UINavigationController delegate property has been overridden. Returning the last object in the delegates array.");
    return [self.delegates lastObject];
}

#pragma mark - UINavigationControllerDelegate

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    SEL selector = @selector(navigationController:willShowViewController:animated:);
    for (id delegate in self.delegates) {
        if ([delegate respondsToSelector:selector]) {
            [delegate navigationController:navigationController willShowViewController:viewController animated:animated];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    SEL selector = @selector(navigationController:didShowViewController:animated:);
    for (id delegate in self.delegates) {
        if ([delegate respondsToSelector:selector]) {
            [delegate navigationController:navigationController didShowViewController:viewController animated:animated];
        }
    }
}

@end
