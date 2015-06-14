//
//  CRMCrime.m
//  CrimeAlert
//
//  Created by shoby on 2015/06/13.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CRMCrime.h"

@implementation CRMCrime

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"cdid": @"cdid",
             @"date": @"date",
             @"latitude": @"lat",
             @"longitude": @"lon",
             @"address": @"address"};
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"MM/dd/yy HH:mm a";
    return dateFormatter;
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:value];
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:value];
    }];
}

+ (NSArray *)crimesWithJSONArray:(NSArray *)jsonArray
{
    return [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:jsonArray error:nil];
}

@end
