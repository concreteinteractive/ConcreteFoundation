//
//  NSMutableArray+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "NSMutableArray+Concrete.h"

@implementation NSMutableArray (Concrete)

+ (id)mutableArrayUsingUnretainedReferences {
    return [self mutableArrayUsingUnretainedReferencesWithCapacity:5];
}

+ (id)mutableArrayUsingUnretainedReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // We create a weak reference array
    return (id)CFBridgingRelease(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end
