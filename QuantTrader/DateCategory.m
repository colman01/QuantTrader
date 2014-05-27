//
//  DateCategory.m
//  QuantLibExample
//
//  Created by colman on 22.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import "DateCategory.h"

@implementation DateCategory

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

@end
