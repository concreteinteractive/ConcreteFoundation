//
//  CIRootViewController.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 5/23/14.
//  Copyright (c) 2014 Concrete Interactive. All rights reserved.
//

@protocol CIRootViewControllerDelegate <NSObject>

@optional
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end


@interface CIRootViewController : UIViewController

@property (nonatomic, readonly)NSArray* delegates;

+ (CIRootViewController *)sharedInstance;
- (void)addDelegate:(id<CIRootViewControllerDelegate>)delegate;
- (void)removeDelegate:(id<CIRootViewControllerDelegate>)delegate;

@end
