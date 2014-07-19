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
    
    NSArray *quotes = [self.zeroCouponQuotes allObjects];
    NSMutableArray *quotes_ = [[NSMutableArray alloc] initWithArray:quotes];
    [quotes_ addObject:value];
    self.zeroCouponQuotes = [[NSSet alloc] initWithArray:[[NSArray alloc] initWithArray:quotes_]];
    if (!self.zeroCouponQuotes) {
        self.zeroCouponQuotes = [NSEntityDescription insertNewObjectForEntityForName:@"ZeroCouponQuotes" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
    }
    self.zeroCouponQuotes = [NSSet setWithArray:quotes_];
 
}


@end
