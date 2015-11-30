//
//  CILocationService.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/23/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "CILocationService.h"
#import "NSObject+Concrete.h"

#define DEFAULT_MAP_APPS_KEY @"Default Maps App"

@interface CILocationService()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CILocationService

static NSUInteger timerLoopCount = 0;

// TODO: Change this to categories on CLLocationManager and MKMapItem

+ (CILocationService *)concreteSharedInstance
{
    return [super concreteSharedInstance];
}

- (CILocationService *)init
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.serviceTimeoutInterval = 0;
        [self requestUpdate];
    }
    return self;
}

- (void) startService
{
    [self.locationManager startUpdatingLocation];
    [self startShutoffTimer];
}

- (void) stopService
{
	[self.locationManager stopUpdatingLocation];
    [self.timer invalidate];
    if (nil == self.currentLocation) {
        [self.delegate locationServiceFailed];
    }
}

- (void) requestUpdate
{
	[self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
    [self startShutoffTimer];
}

- (void) startShutoffTimer
{
    if (self.serviceTimeoutInterval > 0)
    {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.serviceTimeoutInterval
                                                      target:self
                                                    selector:@selector(stopService)
                                                    userInfo:nil
                                                     repeats:false];
    }
}

// TODO: Implement low power tracking

- (BOOL) serviceIsEnabled
{
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways);
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    [self.delegate locationService:self didUpdateLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    self.currentLocation = location;
    [self.delegate locationService:self didUpdateLocation:location];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error \
{
    
}

- (void) dealloc
{
    [self.timer invalidate];
	[self.locationManager stopUpdatingLocation];
}

#pragma mark - Map Apps Methods

+ (BOOL)googleMapsIsInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
}

+ (CIMapDefaultApp)defaultMapsApp
{
    return (CIMapDefaultApp)[[NSUserDefaults standardUserDefaults] integerForKey:DEFAULT_MAP_APPS_KEY];
}

+ (void)setDefaultMapsApp:(CIMapDefaultApp)defaultApp
{
    [[NSUserDefaults standardUserDefaults] setInteger:defaultApp forKey:DEFAULT_MAP_APPS_KEY];
}

+ (void)openMapForCurrentLocation
{
    [self openMapForCurrentLocationwithViewFlags:CIMapViewFlagNone];
}

+ (void)openMapForCurrentLocationwithViewFlags:(CIMapViewFlags)viewFlags
{
    [self openMapForDirectionsFromLocation:CLLocationCoordinate2DMake(CGFLOAT_MAX, CGFLOAT_MAX) // CGFLOAT_MAX is obviously out of range, so we use
                             withPlaceName:nil                                                  // it to flag this parameter as "current location".
                                ToLocation:CLLocationCoordinate2DMake(CGFLOAT_MAX, CGFLOAT_MAX) // CGFLOAT_MAX is obviously out of range, so we
                             withPlaceName:nil                                                  // use it to flag this parameter as "not used".
                            directionsMode:CIMapDirectionsModeNone
                                 viewFlags:viewFlags];
}

+ (void)openMapForLocation:(CLLocationCoordinate2D)location
             withPlaceName:(NSString *)placeName
                 viewFlags:(CIMapViewFlags)viewFlags
{
    [self openMapForDirectionsFromLocation:location
                             withPlaceName:placeName
                                ToLocation:CLLocationCoordinate2DMake(CGFLOAT_MAX, CGFLOAT_MAX) // CGFLOAT_MAX is obviously out of range, so we
                             withPlaceName:nil                                                  // use it to flag this parameter as "not used".
                            directionsMode:CIMapDirectionsModeNone
                                 viewFlags:viewFlags];
}

+ (void)openMapForDirectionsFromCurrentLocationToLocation:(CLLocationCoordinate2D)location
                                            withPlaceName:(NSString *)placeName
                                           directionsType:(CIMapDirectionsMode)directionsMode
                                                viewFlags:(CIMapViewFlags)viewFlags
{
    [self openMapForDirectionsFromLocation:CLLocationCoordinate2DMake(CGFLOAT_MAX, CGFLOAT_MAX) // CGFLOAT_MAX is obviously out of range, so we use
                             withPlaceName:nil                                                  // it to flag this parameter as "current location".
                                ToLocation:location
                             withPlaceName:placeName
                            directionsMode:directionsMode
                                 viewFlags:viewFlags];
}

+ (void)openMapForDirectionsFromLocation:(CLLocationCoordinate2D)fromLocation
                           withPlaceName:(NSString *)fromPlaceName
                              ToLocation:(CLLocationCoordinate2D)toLocation
                           withPlaceName:(NSString *)toPlaceName
                          directionsMode:(CIMapDirectionsMode)directionsMode
                               viewFlags:(CIMapViewFlags)viewFlags
{
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        if ([self defaultMapsApp] == CIMapDefaultAppGoogle && [self googleMapsIsInstalled])
        {
            // Open in Google Maps
            NSString* formattedFromCoordinates = nil;
            NSString* formattedToCoordinates = nil;
            if (fabs(fromLocation.latitude) <= 90 && fabs(fromLocation.longitude) <= 180)
            {
                formattedFromCoordinates = [NSString stringWithFormat:@"%lf,%lf", fromLocation.latitude, fromLocation.longitude];
            }
            if (fabs(toLocation.latitude) <= 90 && fabs(toLocation.longitude) <= 180)
            {
                formattedToCoordinates = [NSString stringWithFormat:@"%lf,%lf", toLocation.latitude, toLocation.longitude];
            }
            [self openMapInGoogleMapsWithSearch:nil
                                       location:formattedFromCoordinates
                                     toLocation:formattedToCoordinates
                                 directionsMode:directionsMode
                                      viewFlags:viewFlags];
        } else
        {
            // Open in Apple Maps
            MKMapItem *fromMapItem = nil;
            if (fabs(fromLocation.latitude) <= 90 && fabs(fromLocation.longitude) <= 180)
            {
                // Create an MKMapItem to pass to the Maps app
                MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromLocation
                                                                   addressDictionary:nil];
                fromMapItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
                [fromMapItem setName:fromPlaceName];
            } else
            {
                if ([self concreteSharedInstance].currentLocation == nil)
                {
                    if (++timerLoopCount < 5)
                    {
                        // The previousLocation property was nil, meaning sharedInstance  was likely uninitialized until is was just called.
                        // We'll give the location service a second to get the initial result back and then call this method again.
                        SEL thisSelector = @selector(openMapForDirectionsFromLocation:withPlaceName:ToLocation:withPlaceName:directionsMode:viewFlags:);
                        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:thisSelector]];
                        [invocation setTarget:self];
                        [invocation setSelector:thisSelector];
                        [invocation setArgument:&fromLocation atIndex:2];
                        [invocation setArgument:&fromPlaceName atIndex:3];
                        [invocation setArgument:&toLocation atIndex:4];
                        [invocation setArgument:&toPlaceName atIndex:5];
                        [invocation setArgument:&directionsMode atIndex:6];
                        [invocation setArgument:&viewFlags atIndex:7];
                        [NSTimer scheduledTimerWithTimeInterval:1 invocation:invocation repeats:NO];
                        return;
                    } else
                    {
                        // Exit out to avoid an infinite loop. We should have gotten something by now.
                        timerLoopCount = 0;
                        return;
                    }
                }
                timerLoopCount = 0;
                MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:[self concreteSharedInstance].currentLocation.coordinate
                                                                   addressDictionary:nil];
                fromMapItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
                [fromMapItem setName:NSLocalizedString(@"Current Location", @"Current Location")];
            }
            
            MKMapItem *toMapItem = nil;
            if (fabs(toLocation.latitude) <= 90 && fabs(toLocation.longitude) <= 180)
            {
                // Create an MKMapItem to pass to the Maps app
                MKPlacemark *toPlacemark = [[MKPlacemark alloc] initWithCoordinate:toLocation
                                                                 addressDictionary:nil];
                toMapItem = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
                [toMapItem setName:toPlaceName];
            }
            
            NSMutableDictionary* launchOptions = nil;
            if (directionsMode != CIMapDirectionsModeNone || (viewFlags & !CIMapViewFlagTransit))
            {
                launchOptions = [NSMutableDictionary dictionaryWithCapacity:10];
                if (directionsMode == CIMapDirectionsModeWalking ||
                    directionsMode == CIMapDirectionsModeTransit)
                {
                    [launchOptions setObject:MKLaunchOptionsDirectionsModeWalking forKey:MKLaunchOptionsDirectionsModeKey];
                } else if (directionsMode == CIMapDirectionsModeDriving)
                {
                    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
                }
                if (viewFlags == CIMapViewFlagStandard)
                {
                    [launchOptions setObject:[NSNumber numberWithInt:MKMapTypeStandard] forKey:MKLaunchOptionsMapTypeKey];
                } else if (viewFlags == CIMapViewFlagHybrid)
                {
                    [launchOptions setObject:[NSNumber numberWithInt:MKMapTypeHybrid] forKey:MKLaunchOptionsMapTypeKey];
                } else if (viewFlags == CIMapViewFlagSatellite)
                {
                    [launchOptions setObject:[NSNumber numberWithInt:MKMapTypeSatellite] forKey:MKLaunchOptionsMapTypeKey];
                }
            }
            [MKMapItem openMapsWithItems:@[fromMapItem, toMapItem]
                           launchOptions:launchOptions];
        }
    }
    // TODO: Make compatible for < iOS6
}

+ (BOOL)openMapInGoogleMapsWithSearch:(NSString *)search
                             location:(NSString *)location
                           toLocation:(NSString *)toLocation
                       directionsMode:(CIMapDirectionsMode)directionsMode
                             viewFlags:(CIMapViewFlags)viewFlags
{
    if ([self googleMapsIsInstalled])
    {
        NSString* formattedSearchQuery = @"";
        NSString* formattedLocation = @"";
        NSString* formattedToLocation = @"";
        NSString* formattedDirectionsMode = @"";
        NSString* formattedViewType = @"";
        
        if (location == nil)
        {
            if ([self concreteSharedInstance].currentLocation == nil)
            {
                if (++timerLoopCount < 5)
                {
                    // The previousLocation property was nil, meaning sharedInstance  was likely uninitialized until is was just called.
                    // We'll give the location service a second to get the initial result back and then call this method again.
                    SEL thisSelector = @selector(openMapInGoogleMapsWithSearch:location:toLocation:directionsMode:viewFlags:);
                    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:thisSelector]];
                    [invocation setTarget:self];
                    [invocation setSelector:thisSelector];
                    [invocation setArgument:&search atIndex:2];
                    [invocation setArgument:&location atIndex:3];
                    [invocation setArgument:&toLocation atIndex:4];
                    [invocation setArgument:&directionsMode atIndex:5];
                    [invocation setArgument:&viewFlags atIndex:6];
                    [NSTimer scheduledTimerWithTimeInterval:1 invocation:invocation repeats:NO];
                    return FALSE;
                } else
                {
                    // Exit out to avoid an infinite loop. We should have gotten something by now.
                    timerLoopCount = 0;
                    return FALSE;
                }
            }
            timerLoopCount = 0;
            // Default to current position if no location was specified
            CLLocationCoordinate2D currentCoordinates = [self concreteSharedInstance].currentLocation.coordinate;
            location = [NSString stringWithFormat:@"%lf,%lf", currentCoordinates.latitude, currentCoordinates.longitude];
        }
        
        if (toLocation != nil)
        {
            // Format for directions if there is a "to location"
            formattedLocation = [NSString stringWithFormat:@"saddr=%@", [location stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
            formattedToLocation = [NSString stringWithFormat:@"&daddr=%@", [toLocation stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
            
            if (directionsMode == CIMapDirectionsModeDriving)
            {
                formattedDirectionsMode = @"&directionsmode=driving";
            } else if (directionsMode == CIMapDirectionsModeTransit)
            {
                formattedDirectionsMode = @"&directionsmode=transit";
            } else if (directionsMode == CIMapDirectionsModeWalking)
            {
                formattedDirectionsMode = @"&directionsmode=walking";
            }
        } else
        {
            // Format for map without directions
            if (search != nil)
            {
                // Add search query
                formattedSearchQuery = [NSString stringWithFormat:@"q=%@", [search stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
            }
            formattedLocation = [NSString stringWithFormat:@"center=%@", [search stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
        }
        
        // Add view flags
        if (viewFlags & CIMapViewFlagSatellite)
        {
            formattedViewType = @"satellite";
        }
        if (viewFlags & CIMapViewFlagTraffic)
        {
            if (![formattedViewType isEqualToString:@""])
            {
                formattedViewType = [formattedViewType stringByAppendingString:@","];
            }
            formattedViewType = [formattedViewType stringByAppendingString:@"traffic"];
        }
        if (viewFlags & CIMapViewFlagTransit)
        {
            if (![formattedViewType isEqualToString:@""])
            {
                formattedViewType = [formattedViewType stringByAppendingString:@","];
            }
            formattedViewType = [formattedViewType stringByAppendingString:@"transit"];
        }
        
        NSString* formattedURL = [NSString stringWithFormat:@"comgooglemaps://?%@%@%@%@&views=%@&mapmode=standard", formattedSearchQuery, formattedLocation, formattedToLocation, formattedDirectionsMode, formattedViewType];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:formattedURL]];
        return TRUE;
    }
    return FALSE;
}

@end

