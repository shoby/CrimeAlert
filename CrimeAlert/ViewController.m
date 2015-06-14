//
//  ViewController.m
//  CrimeAlert
//
//  Created by shoby on 2015/06/13.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "ViewController.h"
#import "CRMLocationManager.h"
#import "CRMSpotClimeAPIClient.h"
#import "CRMCrime.h"

static const NSInteger DetectionRange = 400; // 5min in walk
static const NSInteger DangerAreaThreshold = 3;

@interface ViewController ()<CRMLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *crimeCountLabel;
@property (nonatomic) CRMLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CRMLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CRMLocationManager *)locationManager didUpdateLocation:(CLLocation *)location
{
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    [[CRMSpotClimeAPIClient sharedClient] fetchCrimesWithLatitude:@(coordinate.latitude) longitude:@(coordinate.longitude) completionHandler:^(NSArray *crimes, NSError *error) {
        if (error) {
            NSLog(@"error:%@", error);
            return;
        }
        NSArray *nearestCrimes = [self nearestCrimesWithCurrentLocation:location crimes:crimes];
        
        [self nofityAlertWithClimes:nearestCrimes];
    }];
}

- (NSArray *)nearestCrimesWithCurrentLocation:(CLLocation *)currentLocation crimes:(NSArray *)crimes
{
    NSMutableArray *nearestCrimes = [@[] mutableCopy];
    
    for (CRMCrime *crime in crimes) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:crime.latitude.doubleValue longitude:crime.longitude.doubleValue];
        CLLocationDistance distance = [currentLocation distanceFromLocation:location];
        
        if (distance <= DetectionRange) {
            [nearestCrimes addObject:crime];
        }
    }
    return nearestCrimes;
}

- (void)nofityAlertWithClimes:(NSArray *)crimes
{
    self.crimeCountLabel.text = [NSString stringWithFormat:@"%ld", crimes.count];
    
    if (crimes.count < DangerAreaThreshold) {
        return;
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertTitle = @"早めに移動してください";
    localNotification.alertBody = @"危険な地域に入りました";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
