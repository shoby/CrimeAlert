//
//  CRMSpotClimeAPIClient.h
//  CrimeAlert
//
//  Created by shoby on 2015/06/13.
//  Copyright © 2015年 shoby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRMSpotClimeAPIClient : NSObject
+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)fetchCrimesWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude completionHandler:(void (^)(NSArray *, NSError *))completionHandler;
@end
