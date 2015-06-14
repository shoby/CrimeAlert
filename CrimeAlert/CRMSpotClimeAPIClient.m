//
//  CRMSpotClimeAPIClient.m
//  CrimeAlert
//
//  Created by shoby on 2015/06/13.
//  Copyright © 2015年 shoby. All rights reserved.
//

#import "CRMSpotClimeAPIClient.h"
#import <AFNetworking/AFNetworking.h>
#import "CRMCrime.h"

static NSString *const APIBaseURL = @"http://api.spotcrime.com/";
static NSString *const APIKey = @"spotcrime-private-api-key";

@interface CRMSpotClimeAPIClient ()
@property (nonatomic) AFHTTPSessionManager *httpSessionManager;
@end

@implementation CRMSpotClimeAPIClient

+ (instancetype)sharedClient
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURL] sessionConfiguration:sessionConfiguration];
    }
    return self;
}

- (NSURLSessionDataTask *)fetchCrimesWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude completionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    NSNumber *radius = @(0.02);
    
    NSDictionary *parameters = @{@"key": APIKey,
                                 @"lat": latitude.stringValue,
                                 @"lon": longitude.stringValue,
                                 @"radius": radius.stringValue};
    
    return [self.httpSessionManager GET:@"crimes.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *crimes = [CRMCrime crimesWithJSONArray:responseObject[@"crimes"]];
        if (completionHandler) {
            completionHandler(crimes, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completionHandler) {
            completionHandler(nil, error);
        }
    }];
}

@end
