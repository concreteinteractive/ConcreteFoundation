//
//  CILocationService.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/23/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <MapKit/MapKit.h>
@class CILocationService;

typedef enum {
    CIMapDirectionsModeNone    = 0,
    CIMapDirectionsModeDriving = 1,
    CIMapDirectionsModeTransit = 2,  // defaults to walking if using Apple Maps
    CIMapDirectionsModeWalking = 3
} CIMapDirectionsMode;

typedef enum {
    CIMapViewFlagNone      = 0,
    CIMapViewFlagStandard  = 1,
    CIMapViewFlagSatellite = 2,
    CIMapViewFlagHybrid    = 3,      // defaults to satellite if using Google Maps
    CIMapViewFlagTraffic   = 1 << 2,
    CIMapViewFlagTransit   = 1 << 3  // Google Maps only
} CIMapViewFlags;

typedef enum {
    CIMapDefaultAppNotSet = 0,
    CIMapDefaultAppApple  = 1,
    CIMapDefaultAppGoogle = 2
} CIMapDefaultApp;

@protocol CILocationDelegate
- (void)locationService:(CILocationService *)locationService didUpdateLocation:(CLLocation *)location;
- (void)locationServiceFailed;
@end

@interface CILocationService : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, weak) id<CILocationDelegate> delegate;
@property (nonatomic) NSTimeInterval serviceTimeoutInterval;

+ (CILocationService *)sharedInstance;

- (void) startService;
- (void) stopService;
- (void) requestUpdate;
- (BOOL) serviceIsEnabled;

#pragma mark - Map Apps Methods

+ (BOOL)googleMapsIsInstalled;

// Setting for default Maps app
+ (CIMapDefaultApp)defaultMapsApp;
+ (void)setDefaultMapsApp:(CIMapDefaultApp)defaultApp;

// Opens the map in the default Maps app if it is installed, otherwise falls back on Apple Maps
+ (void)openMapForCurrentLocation;

+ (void)openMapForCurrentLocationwithViewFlags:(CIMapViewFlags)viewFlags;

+ (void)openMapForLocation:(CLLocationCoordinate2D)location
             withPlaceName:(NSString *)placeName
                 viewFlags:(CIMapViewFlags)viewFlags;

+ (void)openMapForDirectionsFromCurrentLocationToLocation:(CLLocationCoordinate2D)location
                                            withPlaceName:(NSString *)placeName
                                           directionsType:(CIMapDirectionsMode)directionsMode
                                                viewFlags:(CIMapViewFlags)viewFlags;

+ (void)openMapForDirectionsFromLocation:(CLLocationCoordinate2D)fromLocation
                           withPlaceName:(NSString *)fromPlaceName
                              ToLocation:(CLLocationCoordinate2D)toLocation
                           withPlaceName:(NSString *)toPlaceName
                          directionsMode:(CIMapDirectionsMode)directionsMode
                               viewFlags:(CIMapViewFlags)viewFlags;

@end
