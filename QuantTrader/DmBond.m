//
//  DmBond.m
//  QuantTrader
//
//  Created by colman on 19/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "DmBond.h"
#import "DmAccruedAmount.h"
#import "DmCouponRates.h"
#import "DmFixedBondScheduleRateAndDate.h"
#import "DmFloatingBondScheduleRateAndDate.h"
#import "DmIssueDates.h"
#import "DmLiborForcastingCurveQutotes.h"
#import "DmMarketQuotes.h"
#import "DmMaturityDates.h"
#import "DmSwapQuotes.h"
#import "DmZeroCouponQuotes.h"


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
@dynamic accruedAmountLink;
@dynamic couponRates;
@dynamic fixedBondScheduleRateAndDate;
@dynamic floatingBondScheduleRateAndDate;
@dynamic issueDates;
@dynamic liborForcastingCurveQuotes;
@dynamic marketQuotes;
@dynamic maturityDates;
@dynamic swapQuotes;
@dynamic zeroCouponQuotes;



- (void)addZeroCouponQuoteAsNumber:(NSNumber *)value{
    
    NSMutableArray *quotes_;
    quotes_ = [NSKeyedUnarchiver unarchiveObjectWithData:self.zeroCouponQuote];
    [quotes_ addObject:value];
    
    NSSet *set = [[NSSet alloc] initWithArray:quotes_];
    if (!self.zeroCouponQuote) {
        self.zeroCouponQuote = [NSEntityDescription insertNewObjectForEntityForName:@"ZeroCouponQuote" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
    }
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:quotes_];
    self.zeroCouponQuote = arrayData;
    
    [[PersistManager instance] save];
    
    
}

@end
