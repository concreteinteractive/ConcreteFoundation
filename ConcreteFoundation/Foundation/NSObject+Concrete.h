//
//  NSObject+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Concrete)

@property (nonatomic, strong, readonly) NSArray* delegates;

+ (instancetype)sharedInstance;
+ (BOOL)sharedInstanceExists;
+ (void)purgeSharedInstance;

+ (instancetype)threadInstance;
+ (BOOL)threadInstanceExists;
+ (void)purgeThreadInstance;

- (void) addDelegate:(id)delegate;
- (void) removeDelegate:(id)delegate;

- (id)performSelector:(SEL)aSelector withObjects:(id)objects, ... NS_REQUIRES_NIL_TERMINATION;

// The following method works similar to the normal perfomSelector methods,
// but can handle arguments and returns with standard C data types as well as NSObjects.
// All arguments must be passed as pointers to the normal argument, and the return value
// may need to be cast. This have not been throughly tested, so use with caution.
- (void *)performSelector:(SEL)aSelector withArgumentPointers:(void *)argumentPointers, ... NS_REQUIRES_NIL_TERMINATION;



/*
 
////// These are not correct. Need to research if there is a way to add completion blocks to arbatrary methods /////////
 
- (id)performSelector:(SEL)aSelector withCompletionBlock:(void (^)(void))block;
- (id)performSelector:(SEL)aSelector withCompletionBlock:(void (^)(void))block withObjects:(id)objects, ... NS_REQUIRES_NIL_TERMINATION;

- (void *)performSelector:(SEL)aSelector withCompletionBlock:(void (^)(void))block withArgumentPointers:(void *)argumentPointers, ... NS_REQUIRES_NIL_TERMINATION;
 
*/

@end
