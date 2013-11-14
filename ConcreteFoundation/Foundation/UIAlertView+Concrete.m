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
    va_list ap;
    va_start(ap, otherButtonTitles);
    self = [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, ap, nil];
    va_end(ap);
    if (self)
    {
        self.userInfo = userInfo;
    }
    return self;
}

- (NSDictionary *)userInfo
{
    @synchronized(NSStringFromClass([self class])) {
        if (objc_getAssociatedObject(self, USER_INFO_KEY) == nil) {
            [self setUserInfo:[[[self class] alloc] init]];
        }
        return objc_getAssociatedObject(self, USER_INFO_KEY);
    }
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    // OBJC_ASSOCIATION_RETAIN Specifies a strong reference to the associated object, and that the association is made atomically.
    objc_setAssociatedObject(self, USER_INFO_KEY, userInfo, OBJC_ASSOCIATION_RETAIN);
}

@end
