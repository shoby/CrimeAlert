//
//  CRMLocationManager.h
//  CrimeAlert
//
//  Created by shoby on 2015/06/13.
//  Copyright © 2015年 shoby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CRMLocationManagerDelegate;

@interface CRMLocationManager : NSObject
@property (nonatomic, weak) id<CRMLocationManagerDelegate> delegate;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
@end

@protocol CRMLocationManagerDelegate <NSObject>
- (void)locationManager:(CRMLocationManager *)locationManager didUpdateLocation:(CLLocation *)location;
@end
