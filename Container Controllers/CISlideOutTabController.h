//
//  CISlideOutTabController.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/11/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CISlideOutTabController;

@protocol CISlideOutTabControllerDelegate <NSObject>

@optional
- (BOOL)slideOutTabController:(CISlideOutTabController *)slideOutTabController shouldSelectViewController:(UIViewController *)viewController;
- (void)slideOutTabController:(CISlideOutTabController *)slideOutTabController didSelectViewController:(UIViewController *)viewController;

@end

@interface CISlideOutTabController : UIViewController

@property (nonatomic, weak)   id <CISlideOutTabControllerDelegate> delegate;
@property (nonatomic, strong) UIViewController*                    leftViewController;
@property (nonatomic, strong) UIViewController*                    rightViewController;
@property (nonatomic, strong) NSArray*                             viewControllers;
@property (nonatomic, weak)   UIViewController*                    selectedViewController;
@property (nonatomic)         NSUInteger                           selectedIndex;
@property (nonatomic)         CGFloat                              leftSlideOutWidth;
@property (nonatomic)         CGFloat                              rightSlideOutWidth;
@property (nonatomic)         CGFloat                              fullLeftSlideOutWidth;
@property (nonatomic)         CGFloat                              fullRightSlideOutWidth;

#pragma mark - Initializer methods
- (id)initWithViewControllers:(NSArray *)viewControllers
           leftViewController:(UIViewController *)leftViewController
          rightViewController:(UIViewController *)rightViewController;

#pragma mark - Sliding methods
- (void)toggleLeft;
- (void)toggleRight;
- (void)toggleLeftAnimated:(BOOL)animated;
- (void)toggleRightAnimated:(BOOL)animated;
- (void)showLeft;
- (void)showRight;
- (void)showCenter;
- (void)showLeftAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)showRightAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)showCenterAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

#pragma mark - Property setters
- (void)addViewController:(UIViewController *)viewController;
- (void)addViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)removeViewController:(UIViewController *)viewController;
- (void)removeViewControllerAtIndex:(NSUInteger)index;

@end
