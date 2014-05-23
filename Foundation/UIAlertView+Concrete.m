//
//  UIAlertView+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 11/14/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "UIAlertView+Concrete.h"
#import "objc/message.h"

#define USER_INFO_KEY @"User Info"

@implementation UIAlertView (Concrete)

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate userInfo:(NSDictionary *)userInfo cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self)
    {
        if (otherButtonTitles != nil)
        {
            if ([otherButtonTitles isKindOfClass:[NSString class]])
            {
                [self addButtonWithTitle:otherButtonTitles];
            }
            va_list argumentList;
            va_start(argumentList, otherButtonTitles);
            id buttonTitle = nil;
            while((buttonTitle = va_arg(argumentList, id)))
            {
                if ([buttonTitle isKindOfClass:[NSString class]])
                {
                    [self addButtonWithTitle:buttonTitle];
                }
            }
            va_end(argumentList);
        }
        self.userInfo = userInfo;
    }
    return self;
}

- (NSDictionary *)userInfo
{
    return objc_getAssociatedObject(self, USER_INFO_KEY);
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    // OBJC_ASSOCIATION_RETAIN Specifies a strong reference to the associated object, and that the association is made atomically.
    objc_setAssociatedObject(self, USER_INFO_KEY, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
