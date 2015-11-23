//
//  UIViewController+ConcreteInteractive.h
//  steve-and-kates-camp
//
//  Created by Vytautas Galaunia on 20/11/15.
//  Copyright © 2015 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CIStoryboardLoading <NSObject>

+ (NSString *)viewControllerIdentifier;

@end

@interface UIViewController (ConcreteInteractive)

+ (instancetype)loadViewControllerFromStoryboardWithName:(NSString *)storyboardName;

@end
