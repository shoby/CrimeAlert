//
//  CRMLocationManager.m
//  CrimeAlert
//
//  Created by shoby on 2015/06/13.
//  Copyright © 2015年 shoby. All rights reserved.
//

#import "CRMLocationManager.h"

@interface CRMLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation CRMLocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 40; // 30sec in walk
        _locationManager.activityType = CLActivityTypeFitness;
    }
    return self;
}

- (void)dealloc
{
    [self.locationManager stopUpdatingLocation];
}

- (void)startUpdatingLocation
{
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation
{
    [self.locationManager requestAlwaysAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations.firstObject;
    
    if ([self.delegate respondsToSelector:@selector(locationManager:didUpdateLocation:)]) {
        [self.delegate locationManager:self didUpdateLocation:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}

@end
