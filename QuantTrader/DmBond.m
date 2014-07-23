//
//  DmBond.m
//  QuantTrader
//
//  Created by colman on 21/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "DmBond.h"
#import "DmFixedBondScheduleRateAndDate.h"
#import "DmFloatingBondScheduleRateAndDate.h"


@implementation DmBond

@dynamic accruedAmount;
@dynamic dirtyPrice;
@dynamic faceAmount;
@dynamic fixingDays;
@dynamic nextCoupon;
@dynamic numberOfBonds;
@dynamic previousCoupon;
@dynamic redemption;
@dynamic yield;
@dynamic zeroCouponQuote;
@dynamic zeroDateCoupon;
@dynamic liborForcastingCurveQutotes;
@dynamic issueDates;
@dynamic maturityDates;
@dynamic swapQuotes;
@dynamic depositQuotes;
@dynamic zeroCouponQuotes;
@dynamic marketQuotes;
@dynamic couponRates;
@dynamic fixedBondScheduleRateAndDate;
@dynamic floatingBondScheduleRateAndDate;
@dynamic liborForcastingCurveQuotes;



- (void)addZeroCouponQuoteAsNumber:(NSNumber *)value{
    
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.zeroCouponQuote];
    if (!quotes_) {
        quotes_ = [[NSMutableArray alloc] init];
    }
    [quotes_ addObject:value];
    if (!self.zeroCouponQuote)
        self.zeroCouponQuote  = [[NSData alloc] init];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:quotes_];
    self.zeroCouponQuote = arrayData;
    
    [[PersistManager instance] save];
}


- (void) removeZeroCouponQuoteAsNumber:(NSNumber *)value {
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.zeroCouponQuote];
    
    for (NSNumber *num in quotes_) {
        if ([num doubleValue] == [value doubleValue]) {
            [quotes_ removeObject:num];
        }
    }
    [[PersistManager instance] save];
}



- (void)addissueDateAsDate:(NSDate *)value{
    
    NSMutableArray *dates_;
    if (!dates_)
        dates_ = [[NSMutableArray alloc] init];
    dates_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.issueDates];
    [dates_ addObject:value];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:dates_];
    self.issueDates = arrayData;
    [[PersistManager instance] save];
}

- (void) removeIssueDateAsDate:(NSDate *) value {
    NSMutableArray *dates_;
    dates_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.issueDates];
    
    for (NSDate *existingDate in dates_) {
        if ([existingDate compare:value]) {
            [dates_ removeObject:existingDate];
        }
    }
    [[PersistManager instance] save];
    
}



- (void)addDate:(NSDate *)value toData:(NSData *) dateArray{
    // array to add value
    NSMutableArray *dates_;
    dates_ = [NSKeyedUnarchiver unarchiveObjectWithData:dateArray];
    if (!dates_)
        dates_ = [[NSMutableArray alloc] init];
    [dates_ addObject:value];
    // create nsdata for all dates
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:dates_];
    dateArray = arrayData;
    [[PersistManager instance] save];
    
}


- (void) removeDate:(NSDate *)value fromData:(NSData *) dateArray {
    NSMutableArray *dates_;
    dates_ = [NSKeyedUnarchiver unarchiveObjectWithData:dateArray];
    for (NSDate *existingDate in dates_) {
        if ([existingDate compare:value]) {
            [dates_ removeObject:existingDate];
        }
    }
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:dates_];
    dateArray = arrayData;
    [[PersistManager instance] save];
}

- (void)addValue:(NSNumber *)value toData:(NSData *) dataArray{
    // array to add value
    NSMutableArray *data_;
    data_ = [NSKeyedUnarchiver unarchiveObjectWithData:dataArray];
    if (!data_)
        data_ = [[NSMutableArray alloc] init];
    [data_ addObject:value];
    // create nsdata for all dates
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:data_];
    dataArray = arrayData;
    [[PersistManager instance] save];
    
}

- (void) removeValue:(NSNumber *)value fromData:(NSData *) dataArray {
    NSMutableArray *data_;
    data_ = [NSKeyedUnarchiver unarchiveObjectWithData:dataArray];
    for (NSNumber *coupon in data_) {
        if ([coupon isEqualToValue:value]) {
            [data_ removeObject:coupon];
        }
    }
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:data_];
    dataArray = arrayData;
    [[PersistManager instance] save];
}




@end
