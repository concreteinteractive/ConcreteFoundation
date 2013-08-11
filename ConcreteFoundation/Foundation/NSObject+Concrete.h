//
//  NSObject+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Concrete)

- (id)performSelector:(SEL)aSelector withCompletionBlock:(void (^)(void))block;
- (id)performSelector:(SEL)aSelector withObjects:(id)objects, ... NS_REQUIRES_NIL_TERMINATION;
- (id)performSelector:(SEL)aSelector withCompletionBlock:(void (^)(void))block withObjects:(id)objects, ... NS_REQUIRES_NIL_TERMINATION;

@end
