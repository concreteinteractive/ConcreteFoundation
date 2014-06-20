//
//  UIDevice+Concrete.h
//  wonolo
//
//  Created by Joshua Dudley on 6/19/14.
//  Copyright (c) 2014 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Concrete)

@property (readonly) NSString*  platform;
@property (readonly) NSUInteger cpuFrequency;
@property (readonly) NSUInteger busFrequency;
@property (readonly) NSUInteger totalMemory;
@property (readonly) NSUInteger userMemory;
@property (readonly) NSUInteger maxSocketBufferSize;

- (NSString *)userReadablePlatform;

@end
