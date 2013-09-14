//
//  CISlideOutTabController.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/11/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "CISlideOutTabController.h"

#define SLIDE_OUT_ANIMATION_DURATION 0.3
#define DEFAULT_SLIDE_OUT_WIDTH      245
#define DEFAULT_FULL_SLIDE_OUT_WIDTH 320

@interface CISlideOutTabController ()
@property (nonatomic, strong) UIView* rightSlideOutContainerView;
@property (nonatomic, strong) UIView* mainView;
@end

@implementation CISlideOutTabController

- (id)initWithViewControllers:(NSArray *)viewControllers
           leftViewController:(UIViewController *)leftViewController
          rightViewController:(UIViewController *)rightViewController
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        self.rightSlideOutContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.rightSlideOutContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.rightSlideOutContainerView];
        self.mainView  = [[UIView alloc] initWithFrame:self.rightSlideOutContainerView.bounds];
        self.mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.rightSlideOutContainerView addSubview:self.mainView];
        self.leftViewController = leftViewController;
        self.rightViewController = rightViewController;
        self.viewControllers = viewControllers;
        self.leftSlideOutWidth = DEFAULT_SLIDE_OUT_WIDTH;
        self.rightSlideOutWidth = DEFAULT_SLIDE_OUT_WIDTH;
        self.fullLeftSlideOutWidth = DEFAULT_FULL_SLIDE_OUT_WIDTH;
        self.fullRightSlideOutWidth = DEFAULT_FULL_SLIDE_OUT_WIDTH;
        self.selectedIndex = 0;
    }
    return self;
}

#pragma mark - Sliding methods

- (void)toggleLeft
{
    [self toggleLeftAnimated:YES];
}

- (void)toggleRight
{
    [self toggleRightAnimated:YES];
}

- (void)toggleLeftAnimated:(BOOL)animated
{
    if (self.rightSlideOutContainerView.frame.origin.x > 0)
    {
        [self showCenterAnimated:animated completion:nil];
    } else
    {
        [self showLeftAnimated:animated completion:nil];
    }
}

- (void)toggleRightAnimated:(BOOL)animated
{
    if (self.mainView.frame.origin.x < 0)
    {
        [self showCenterAnimated:animated completion:nil];
    } else
    {
        [self showRightAnimated:animated completion:nil];
    }
}

- (void)showLeft
{
    [self showLeftAnimated:YES completion:nil];
}

- (void)showRight
{
    [self showRightAnimated:YES completion:nil];
}

- (void)showCenter
{
    [self showCenterAnimated:YES completion:nil];
}

- (void)showLeftAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (self.leftViewController != nil)
    {
        __weak CISlideOutTabController *weakSelf = self;
        CGRect newFrame = CGRectMake(self.leftSlideOutWidth,
                                     0,
                                     self.rightSlideOutContainerView.frame.size.width,
                                     self.rightSlideOutContainerView.frame.size.height);
        void (^showLeft)(void) = nil;
        if (animated)
        {
            showLeft = ^{[UIView animateWithDuration:SLIDE_OUT_ANIMATION_DURATION
                                          animations:^{weakSelf.rightSlideOutContainerView.frame = newFrame;}
                                          completion:completion];};
        } else
        {
            showLeft = ^{weakSelf.rightSlideOutContainerView.frame = newFrame;};
        }
        if (self.mainView.frame.origin.x < 0)
        {
            [self showCenterAnimated:animated completion:^(BOOL finished){showLeft();}];
        } else
        {
            showLeft();
        }
    }
}

- (void)showRightAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (self.rightViewController != nil)
    {
        __weak CISlideOutTabController *weakSelf = self;
        CGRect newFrame = CGRectMake(-self.rightSlideOutWidth,
                                     0,
                                     self.mainView.frame.size.width,
                                     self.mainView.frame.size.height);
        void (^showRight)(void) = nil;
        if (animated)
        {
            showRight = ^{[UIView animateWithDuration:SLIDE_OUT_ANIMATION_DURATION
                                           animations:^{weakSelf.mainView.frame = newFrame;}
                                           completion:completion];};
        } else
        {
            showRight = ^{weakSelf.mainView.frame = newFrame;};
        }
        if (self.rightSlideOutContainerView.frame.origin.x > 0)
        {
            [self showCenterAnimated:animated completion:^(BOOL finished){showRight();}];
        } else
        {
            showRight();
        }
    }
}

- (void)showCenterAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    __weak CISlideOutTabController *weakSelf = self;
    CGRect newMainFrame = CGRectMake(0,
                                 0,
                                 self.mainView.frame.size.width,
                                 self.mainView.frame.size.height);
    CGRect newRightFrame = CGRectMake(0,
                                 0,
                                 self.rightSlideOutContainerView.frame.size.width,
                                 self.rightSlideOutContainerView.frame.size.height);
    if (animated)
    {
        [UIView animateWithDuration:SLIDE_OUT_ANIMATION_DURATION
                         animations:^{
                             weakSelf.mainView.frame = newMainFrame;
                             weakSelf.rightSlideOutContainerView.frame = newRightFrame;
                         }
                         completion:completion];
    } else
    {
        self.mainView.frame = newMainFrame;
        self.rightSlideOutContainerView.frame = newRightFrame;
    }
}

#pragma mark - ViewController array accessors

- (void)addViewController:(UIViewController *)viewController
{
    [self addViewController:viewController atIndex:[self.viewControllers count]];
}

- (void)addViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    if ([viewController isKindOfClass:[UIViewController class]])
    {
        [(NSMutableArray *)self.viewControllers insertObject:viewController atIndex:index];
        [self addChildViewController:viewController];
        viewController.view.frame = self.mainView.bounds;
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.mainView insertSubview:viewController.view atIndex:(NSInteger)index];
        [viewController didMoveToParentViewController:self];
    } else {
        NSLog(@"[CISlideOutTabController addViewController:] rejected object:\n%@", [viewController description]);
    }
    // Refresh tab visibility
    self.selectedIndex = self.selectedIndex;
}

- (void)removeViewController:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [(NSMutableArray *)self.viewControllers removeObject:viewController];
    [viewController removeFromParentViewController];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    [self removeViewController:[self.viewControllers objectAtIndex:index]];
}

#pragma mark - Property setters

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    __weak CISlideOutTabController *weakSelf = self;
    _selectedViewController = selectedViewController;
    
    void (^showSelected)(BOOL) = ^(BOOL notUsed){
        for (UIViewController* viewController in self.viewControllers)
        {
            if (viewController == self.selectedViewController)
            {
                viewController.view.hidden = FALSE;
            } else
            {
                viewController.view.hidden = TRUE;
            }
        }
        [self showCenter];};
    
    if (self.rightSlideOutContainerView.frame.origin.x > 0)
    {
        CGRect newFrame = CGRectMake(self.fullLeftSlideOutWidth,
                                     0,
                                     self.rightSlideOutContainerView.frame.size.width,
                                     self.rightSlideOutContainerView.frame.size.height);
        [UIView animateWithDuration:SLIDE_OUT_ANIMATION_DURATION *
         (self.fullLeftSlideOutWidth - self.rightSlideOutContainerView.frame.origin.x) /
         self.leftSlideOutWidth
                         animations:^{weakSelf.rightSlideOutContainerView.frame = newFrame;}
                         completion:showSelected];
    } else if (self.mainView.frame.origin.x < 0)
    {
        CGRect newFrame = CGRectMake(-self.fullRightSlideOutWidth,
                                     0,
                                     self.mainView.frame.size.width,
                                     self.mainView.frame.size.height);
        [UIView animateWithDuration:SLIDE_OUT_ANIMATION_DURATION *
         (self.fullRightSlideOutWidth + self.mainView.frame.origin.x) /
         self.rightSlideOutWidth
                         animations:^{weakSelf.mainView.frame = newFrame;}
                         completion:showSelected];
    } else {
        showSelected(YES);
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= [self.viewControllers count])
    {
        selectedIndex = 0;
    }
    _selectedIndex = selectedIndex;
    self.selectedViewController = [self.viewControllers objectAtIndex:selectedIndex];
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    [self.leftViewController willMoveToParentViewController:nil];
    [self.leftViewController.view removeFromSuperview];
    [self.leftViewController removeFromParentViewController];
    _leftViewController = leftViewController;
    if (leftViewController != nil)
    {
        [self addChildViewController:self.leftViewController];
        self.leftViewController.view.frame = self.mainView.bounds;
        self.leftViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:self.leftViewController.view belowSubview:self.rightSlideOutContainerView];
        [self.leftViewController didMoveToParentViewController:self];
    }
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    [self.rightViewController willMoveToParentViewController:nil];
    [self.rightViewController.view removeFromSuperview];
    [self.rightViewController removeFromParentViewController];
    _rightViewController = rightViewController;
    if (rightViewController != nil)
    {
        [self addChildViewController:self.rightViewController];
        self.rightViewController.view.frame = self.mainView.bounds;
        self.rightViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.rightSlideOutContainerView insertSubview:self.rightViewController.view belowSubview:self.mainView];
        [self.rightViewController didMoveToParentViewController:self];
    }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    // Make sure previous viewControllers are removed as children
    for (UIViewController* viewController in self.viewControllers)
    {
        [self removeViewController:viewController];
    }
    
    // Create new array
    _viewControllers = [NSMutableArray array];
    
    // Add new viewControllers
    for (UIViewController* viewController in viewControllers)
    {
        [self addViewController:viewController];
    }
}

@end
