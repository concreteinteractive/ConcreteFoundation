//
//  NSObject+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "NSObject+Concrete.h"
#import "objc/message.h"

@implementation NSObject (Concrete)

- (NSInvocation *)invocationForSelector:(SEL)aSelector
{
    NSMethodSignature* signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    return invocation;
}

- (id)invokeInvocation:(NSInvocation *)invocation withCompletionBlock:(void (^)(void))block
{
    id anObject = nil;
    [invocation invoke];
    [invocation getReturnValue:&anObject];
    block();
    return anObject;
}

- (id)performSelector:(SEL)aSelector withCompletionBlock:(void (^)(void))block
{
    //NSInvocation* invocation = [self invocationForSelector:aSelector];
    //return [self invokeInvocation:invocation withCompletionBlock:block];
    id result = objc_msgSend(self, aSelector, nil);
    block();
    return result;
}

- (id)performSelector:(SEL)aSelector withObjects:(id)objects, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list argumentlist;
    va_start(argumentlist, objects);
    id result = objc_msgSend(self, aSelector, va_arg(argumentlist, id), nil);
    va_end(argumentlist);
    return result;
}

- (id)performSelector:(SEL)aSelector withCompletionBlock:(void (^)(void))block withObjects:(id)objects, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list argumentlist;
    va_start(argumentlist, objects);
    id result = objc_msgSend(self, aSelector, va_arg(argumentlist, id), nil);
    va_end(argumentlist);
    block();
    return result;
}

@end
