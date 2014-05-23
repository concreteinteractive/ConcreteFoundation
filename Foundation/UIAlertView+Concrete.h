//
//  UIAlertView+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 11/14/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Concrete)

@property (nonatomic, strong) NSDictionary* userInfo;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate userInfo:(NSDictionary *)userInfo cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
