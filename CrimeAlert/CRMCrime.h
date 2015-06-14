//
//  CRMCrime.h
//  CrimeAlert
//
//  Created by shoby on 2015/06/13.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface CRMCrime : MTLModel<MTLJSONSerializing>

@property (readonly, nonatomic) NSInteger cdid;
@property (readonly, nonatomic) NSDate *date;
@property (readonly, nonatomic) NSNumber *latitude;
@property (readonly, nonatomic) NSNumber *longitude;
@property (readonly, nonatomic) NSString *address;

+ (NSArray *)crimesWithJSONArray:(NSArray *)jsonArray;

@end
