//
//  LocationManager.h
//  LocalToday
//
//  Created by Leo Lin on 3/07/12.
//  Copyright (c) 2012 SOHU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol LocationManagerDelegate
- (void)didGetLocationWithLocation:(CLLocation *)location;
- (void)didFailedToGetLoaction;
@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;           //地理位置管理
@property (nonatomic, strong) CLLocation * bestEffortAtLocation;             //最佳的用户位置信息
@property (nonatomic) BOOL locationServiceEnabled;
@property (nonatomic, weak) id <LocationManagerDelegate> delegate;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
