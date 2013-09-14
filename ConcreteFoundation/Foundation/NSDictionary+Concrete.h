//
//  NSDictionary+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/16/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Concrete)

// TODO override objectForKey: etc. to return nil for NSNull instead

- (NSDictionary *)dictionaryWithNSNullValuesPurged;

@end
