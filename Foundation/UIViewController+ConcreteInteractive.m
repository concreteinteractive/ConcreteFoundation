//
//  UIViewController+ConcreteInteractive.m
//  steve-and-kates-camp
//
//  Created by Vytautas Galaunia on 20/11/15.
//  Copyright © 2015 Concrete Interactive. All rights reserved.
//

#import "UIViewController+ConcreteInteractive.h"

@implementation UIViewController (ConcreteInteractive)

+ (instancetype)loadViewControllerFromStoryboardWithName:(NSString *)storyboardName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:bundle];
    NSAssert(storyboard != nil, @"Unable to find storyboard with name: \"%@\" in bundle: \"%@\"", storyboardName, bundle);

    id vcClass = [self class];
    UIViewController *vc = nil;
    if ([vcClass conformsToProtocol:@protocol(CIStoryboardLoading)]) {
        Class<CIStoryboardLoading> vcClassWithLoadingSupport = (Class<CIStoryboardLoading>)vcClass;
        vc = [storyboard instantiateViewControllerWithIdentifier:[vcClassWithLoadingSupport viewControllerIdentifier]];
    } else {
        NSAssert(false, @"ViewController %@ does NOT implement CIStoryboardLoading protocol", NSStringFromClass([self class]));
    }

    NSAssert(vc != nil, @"Unable to load ViewController: %@", NSStringFromClass([self class]));
    return vc;
}

@end
