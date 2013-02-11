//
//  LocationManager.m
//  LocalToday
//
//  Created by Leo Lin on 3/07/12.
//  Copyright (c) 2012 SOHU. All rights reserved.
//
#import "LocationManager.h"

@implementation LocationManager
@synthesize locationManager;
@synthesize bestEffortAtLocation;
@synthesize locationServiceEnabled;
@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    if (self) 
    {
        self.locationServiceEnabled = YES;
    }
    return self;
}

- (void)startUpdatingLocation
{
    [[HUDHandler shareHandler] showHUDWithTitle:@"正在获取地理位置..." afterDelay:20 withTick:NO];
	if(!self.locationServiceEnabled)
	{
		return;
	}
	
	if (!self.locationManager)
	{
        CLLocationManager * manager = [[CLLocationManager alloc] init];
		self.locationManager = manager;
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = 10;
        self.locationManager.distanceFilter = 0;
	}
    
	
    if (self.locationManager.location) 
    {
        [self.locationManager startMonitoringSignificantLocationChanges];
        [_delegate didGetLocationWithLocation:self.locationManager.location];
    }
    else 
    {
        [self.locationManager startUpdatingLocation];
    }

    
//	[self performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:150.0];
}

- (void)stopUpdatingLocation
{
    self.locationManager.delegate = nil;
	[self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
	self.bestEffortAtLocation = nil;
}


#pragma mark --
#pragma mark CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) 
	{
		return;
	}
//    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) 
//	{
    self.bestEffortAtLocation = newLocation;
    [_delegate didGetLocationWithLocation:newLocation];
    [self stopUpdatingLocation];
//        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy)
//		{
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation) object:nil];
//            
//			[self stopUpdatingLocation];
//		}
//    }
   
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] != kCLErrorLocationUnknown)
	{
        [self stopUpdatingLocation];
    }
    [_delegate didFailedToGetLoaction];
}



@end
