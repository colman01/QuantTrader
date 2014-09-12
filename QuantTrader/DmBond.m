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

@dynamic zeroCouponBondFirstDate;
@dynamic zeroCouponBondSecondDate;
@dynamic fixedBondScheduleFirstDate;
@dynamic fixedBondScheduleSecondDate;
@dynamic fixedRateBondFirstDate;
@dynamic addFixingFirstDate;
@dynamic floatingBondScheduleFirstDate;
@dynamic floatingBondScheduleSecondDate;
@dynamic floatingRateBondScheduleFirstDate;
@dynamic settlementDate;

@dynamic zeroCouponBondNPV;
@dynamic fixedRateBondNPV;
@dynamic floatingRateBondNPV;
@dynamic zeroCouponBondCleanPrice;
@dynamic fixedRateBondCleanPrice ;
@dynamic floatingRateBondCleanPrice;
@dynamic zeroCouponBondDirtyPrice ;
@dynamic fixedRateBondDirtyPrice ;
@dynamic floatingRateBondDirtyPrice;
@dynamic zeroCouponBondAccruedAmount;
@dynamic fixedRateBondAccruedAmount;
@dynamic floatingRateBondAccruedAmount;
@dynamic fixedRateBondPreviousCoupon;
@dynamic floatingRateBondPreviousCoupon;
@dynamic fixedRateBondNextCoupon;
@dynamic floatingRateBondNextCoupon ;
@dynamic zeroCouponBondYield;
@dynamic fixedRateBondYield;
@dynamic floatingRateBondYield;



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

    dates_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.issueDates];
    if (!dates_)
        dates_ = [[NSMutableArray alloc] init];
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


- (void)addMaturityDateAsDate:(NSDate *)value{
    
    NSMutableArray *dates_;

    dates_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.maturityDates];
    if (!dates_)
        dates_ = [[NSMutableArray alloc] init];
    [dates_ addObject:value];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:dates_];
    self.maturityDates = arrayData;
    [[PersistManager instance] save];
}

- (void) removeMaturityeDateAsDate:(NSDate *) value {
    NSMutableArray *dates_;
    dates_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.maturityDates];
    
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
    dataArray = [NSKeyedArchiver archivedDataWithRootObject:data_];
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


- (NSNumber *)getValue:(int)position fromData:(NSData *) dataArray{
    // array to add value
    NSMutableArray *data_;
    data_ = [NSKeyedUnarchiver unarchiveObjectWithData:dataArray];
    if (!data_)
        data_ = [[NSMutableArray alloc] init];
    // create nsdata for all dates
    return [data_ objectAtIndex:position];
}



- (void)addSwapQuoteAsNumber:(NSNumber *)value{
    
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.swapQuotes];
    if (!quotes_) {
        quotes_ = [[NSMutableArray alloc] init];
    }
    [quotes_ addObject:value];
    if (!self.swapQuotes)
        self.swapQuotes  = [[NSData alloc] init];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:quotes_];
    self.swapQuotes = arrayData;
    
    [[PersistManager instance] save];
}


- (void) removeSwapQuoteAsNumber:(NSNumber *)value {
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.swapQuotes];
    
    for (NSNumber *num in quotes_) {
        if ([num doubleValue] == [value doubleValue]) {
            [quotes_ removeObject:num];
        }
    }
    [[PersistManager instance] save];
}

- (void)addDepositQuoteAsNumber:(NSNumber *)value{
    
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.depositQuotes];
    if (!quotes_) {
        quotes_ = [[NSMutableArray alloc] init];
    }
    [quotes_ addObject:value];
    if (!self.depositQuotes)
        self.depositQuotes  = [[NSData alloc] init];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:quotes_];
    self.depositQuotes = arrayData;
    
    [[PersistManager instance] save];
}


- (void) removeDepositQuoteAsNumber:(NSNumber *)value {
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.depositQuotes];
    
    for (NSNumber *num in quotes_) {
        if ([num doubleValue] == [value doubleValue]) {
            [quotes_ removeObject:num];
        }
    }
    [[PersistManager instance] save];
}

- (void)addCouponRateAsNumber:(NSNumber *)value{
    
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.couponRates];
    if (!quotes_) {
        quotes_ = [[NSMutableArray alloc] init];
    }
    [quotes_ addObject:value];
    if (!self.couponRates)
        self.couponRates  = [[NSData alloc] init];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:quotes_];
    self.couponRates = arrayData;
    
    [[PersistManager instance] save];
}

- (void) removeCouponRateAsNumber:(NSNumber *)value {
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.couponRates];
    
    for (NSNumber *num in quotes_) {
        if ([num doubleValue] == [value doubleValue]) {
            [quotes_ removeObject:num];
        }
    }
    [[PersistManager instance] save];
}

- (void)addMarketQuoteAsNumber:(NSNumber *)value{
    
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.marketQuotes];
    if (!quotes_) {
        quotes_ = [[NSMutableArray alloc] init];
    }
    [quotes_ addObject:value];
    if (!self.marketQuotes)
        self.marketQuotes  = [[NSData alloc] init];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:quotes_];
    self.marketQuotes = arrayData;
    
    [[PersistManager instance] save];
}


- (void) removeMarketQuoteAsNumber:(NSNumber *)value {
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.marketQuotes];
    
    for (NSNumber *num in quotes_) {
        if ([num doubleValue] == [value doubleValue]) {
            [quotes_ removeObject:num];
        }
    }
    [[PersistManager instance] save];
}



- (void)addNumber:(NSNumber *)value toData:(NSData *) target{
    
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:target];
    if (!quotes_) {
        quotes_ = [[NSMutableArray alloc] init];
    }
    [quotes_ addObject:value];
    if (!target)
        target  = [[NSData alloc] init];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:quotes_];
    target = arrayData;
    
    [[PersistManager instance] save];
}


- (void) removeNumber:(NSNumber *)value fromData:(NSData *) target {
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:target];
    
    for (NSNumber *num in quotes_) {
        if ([num doubleValue] == [value doubleValue]) {
            [quotes_ removeObject:num];
        }
    }
    [[PersistManager instance] save];
}




@end
