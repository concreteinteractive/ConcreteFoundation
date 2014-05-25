//
//  NSObject+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "NSObject+Concrete.h"
#import "objc/message.h"

#define SHARED_INSTANCE_KEY @"Shared Instance"
#define DELEGATES_KEY @"Object Delegates"

@implementation NSObject (Concrete)

+ (instancetype)sharedInstance
{
    @synchronized(NSStringFromClass([self class])) {
        if (objc_getAssociatedObject(self, SHARED_INSTANCE_KEY) == nil) {
            [self setSharedInstance:[[[self class] alloc] init]];
        }
        return objc_getAssociatedObject(self, SHARED_INSTANCE_KEY);
    }
}

+ (void)setSharedInstance:(id)sharedInstance
{
    // OBJC_ASSOCIATION_RETAIN Specifies a strong reference to the associated object, and that the association is made atomically.
    objc_setAssociatedObject(self, SHARED_INSTANCE_KEY, sharedInstance, OBJC_ASSOCIATION_RETAIN);
}

+ (BOOL)sharedInstanceExists
{
    id instance = objc_getAssociatedObject(self, SHARED_INSTANCE_KEY);
    return instance != nil;
}

+ (void)purgeSharedInstance
{
    @synchronized(NSStringFromClass([self class])) {
        [self setSharedInstance:nil];
    }
}

+ (instancetype)threadInstance
{
    NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
    id threadInstance = [threadDictionary objectForKey:NSStringFromClass([self class])];
    if (threadInstance == nil)
    {
        threadInstance = [[[self class] alloc] init];
        [threadDictionary setObject:threadInstance forKey:NSStringFromClass([self class])];
    }
    return threadInstance;
}

+ (BOOL)threadInstanceExists
{
    NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
    id instance = [threadDictionary objectForKey:NSStringFromClass([self class])];
    return instance != nil;
}

+ (void)purgeThreadInstance
{
    [[[NSThread currentThread] threadDictionary] removeObjectForKey:NSStringFromClass([self class])];
}

- (NSArray *)delegates
{
    return [self delegatesArray].allObjects;
}

- (NSPointerArray *)delegatesArray
{
    if (objc_getAssociatedObject(self, DELEGATES_KEY) == nil)
    {
        objc_setAssociatedObject(self, DELEGATES_KEY, [NSPointerArray weakObjectsPointerArray], OBJC_ASSOCIATION_RETAIN);
    }
    return ((NSPointerArray *)objc_getAssociatedObject(self, DELEGATES_KEY));
}

- (void) addDelegate:(id)delegate {
    [[self delegatesArray] compact];
    if(delegate != nil && ![self.delegates containsObject:delegate]){
        [[self delegatesArray] addPointer:(__bridge void *)(delegate)];
    }
}

- (void) removeDelegate:(id)delegate {
    [[self delegatesArray] compact];
    if(delegate != nil){
        NSUInteger pointerCount = [[self delegatesArray] count];
        for (NSUInteger i = 0; i < pointerCount; ++i)
        {
            if ([[self delegatesArray] pointerAtIndex:i] == (__bridge void *)(delegate))
            {
                [[self delegatesArray] removePointerAtIndex:i];
                break;
            }
        }
    }
}

- (id)performSelector:(SEL)aSelector withObjects:(id)objects, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list argumentlist;
    va_start(argumentlist, objects);
    id result = objc_msgSend(self, aSelector, va_arg(argumentlist, id), nil);
    va_end(argumentlist);
    return result;
}

- (void *)performSelector:(SEL)aSelector withArgumentPointers:(void *)argumentPointers, ... NS_REQUIRES_NIL_TERMINATION
{
    void* returnValue = NULL;
    NSMethodSignature* signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    va_list argumentlist;
    va_start(argumentlist, argumentPointers);
    NSInteger index = 2;
    for (void* argument = argumentPointers; argument > 0; argument = va_arg(argumentlist, void*))
    {
        [invocation setArgument:argument atIndex:index];
        ++index;
    }
    va_end(argumentlist);
    [invocation invoke];
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

/*

- (id)performSelector:(SEL)aSelector withCompletionBlock:(void (^)(void))block
{
    id result = objc_msgSend(self, aSelector, nil);
    block();
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

- (void *)performSelector:(SEL)aSelector withCompletionBlock:(void (^)(void))block withArgumentPointers:(void *)argumentPointers, ... NS_REQUIRES_NIL_TERMINATION
{
    void* returnValue = NULL;
    NSMethodSignature* signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    va_list argumentlist;
    va_start(argumentlist, argumentPointers);
    NSInteger index = 2;
    for (void* argument = argumentPointers; argument > 0; argument = va_arg(argumentlist, void*))
    {
        [invocation setArgument:argument atIndex:index];
        ++index;
    }
    va_end(argumentlist);
    [invocation invoke];
    [invocation getReturnValue:&returnValue];
    if (block != nil)
    {
        block();
    }
    return returnValue;
}
 
 */

@end
