//
//  NSMutableArray+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Concrete)

+ (id)mutableArrayUsingWeakReferences;
+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;

@end
