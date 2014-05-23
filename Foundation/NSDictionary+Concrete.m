//
//  NSDictionary+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/16/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "NSDictionary+Concrete.h"

@implementation NSDictionary (Concrete)

- (NSDictionary *)dictionaryWithNSNullValuesPurged
{
    NSMutableDictionary* newDictionary = [NSMutableDictionary dictionaryWithDictionary:self];
    NSArray* keys = [newDictionary allKeys];
    for (NSString* key in keys)
    {
        if ([newDictionary[key] isKindOfClass:[NSNull class]])
        {
            [newDictionary removeObjectForKey:key];
        }
    }
    if ([self isKindOfClass:[NSMutableDictionary class]])
    {
        return newDictionary;
    }
    return [NSDictionary dictionaryWithDictionary:newDictionary];
}

@end
