//
//  DmBond.h
//  QuantTrader
//
//  Created by colman on 19/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PersistManager.h"

@class DmAccruedAmount, DmCouponRates, DmFixedBondScheduleRateAndDate, DmFloatingBondScheduleRateAndDate, DmIssueDates, DmLiborForcastingCurveQutotes, DmMarketQuotes, DmMaturityDates, DmSwapQuotes, DmZeroCouponQuotes;

@interface DmBond : NSManagedObject

@property (nonatomic, retain) NSNumber * accruedAmount;
@property (nonatomic, retain) NSNumber * dirtyPrice;
@property (nonatomic, retain) NSNumber * faceAmount;
@property (nonatomic, retain) NSNumber * fixingDays;
@property (nonatomic, retain) NSNumber * nextCoupon;
@property (nonatomic, retain) NSNumber * numberOfBonds;
@property (nonatomic, retain) NSNumber * previousCoupon;
@property (nonatomic, retain) NSNumber * redemption;
@property (nonatomic, retain) NSNumber * yield;
@property (nonatomic, retain) NSData * zeroCouponQuote;
@property (nonatomic, retain) NSNumber * zeroDateCoupon;
@property (nonatomic, retain) NSSet *accruedAmountLink;
@property (nonatomic, retain) NSSet *couponRates;
@property (nonatomic, retain) NSSet *fixedBondScheduleRateAndDate;
@property (nonatomic, retain) NSSet *floatingBondScheduleRateAndDate;
@property (nonatomic, retain) NSSet *issueDates;
@property (nonatomic, retain) NSSet *liborForcastingCurveQuotes;
@property (nonatomic, retain) NSSet *marketQuotes;
@property (nonatomic, retain) NSSet *maturityDates;
@property (nonatomic, retain) NSSet *swapQuotes;
@property (nonatomic, retain) NSSet *zeroCouponQuotes;
@end

@interface DmBond (CoreDataGeneratedAccessors)

- (void)addAccruedAmountLinkObject:(DmAccruedAmount *)value;
- (void)removeAccruedAmountLinkObject:(DmAccruedAmount *)value;
- (void)addAccruedAmountLink:(NSSet *)values;
- (void)removeAccruedAmountLink:(NSSet *)values;

- (void)addCouponRatesObject:(DmCouponRates *)value;
- (void)removeCouponRatesObject:(DmCouponRates *)value;
- (void)addCouponRates:(NSSet *)values;
- (void)removeCouponRates:(NSSet *)values;

- (void)addFixedBondScheduleRateAndDateObject:(DmFixedBondScheduleRateAndDate *)value;
- (void)removeFixedBondScheduleRateAndDateObject:(DmFixedBondScheduleRateAndDate *)value;
- (void)addFixedBondScheduleRateAndDate:(NSSet *)values;
- (void)removeFixedBondScheduleRateAndDate:(NSSet *)values;

- (void)addFloatingBondScheduleRateAndDateObject:(DmFloatingBondScheduleRateAndDate *)value;
- (void)removeFloatingBondScheduleRateAndDateObject:(DmFloatingBondScheduleRateAndDate *)value;
- (void)addFloatingBondScheduleRateAndDate:(NSSet *)values;
- (void)removeFloatingBondScheduleRateAndDate:(NSSet *)values;

- (void)addIssueDatesObject:(DmIssueDates *)value;
- (void)removeIssueDatesObject:(DmIssueDates *)value;
- (void)addIssueDates:(NSSet *)values;
- (void)removeIssueDates:(NSSet *)values;

- (void)addLiborForcastingCurveQuotesObject:(DmLiborForcastingCurveQutotes *)value;
- (void)removeLiborForcastingCurveQuotesObject:(DmLiborForcastingCurveQutotes *)value;
- (void)addLiborForcastingCurveQuotes:(NSSet *)values;
- (void)removeLiborForcastingCurveQuotes:(NSSet *)values;

- (void)addMarketQuotesObject:(DmMarketQuotes *)value;
- (void)removeMarketQuotesObject:(DmMarketQuotes *)value;
- (void)addMarketQuotes:(NSSet *)values;
- (void)removeMarketQuotes:(NSSet *)values;

- (void)addMaturityDatesObject:(DmMaturityDates *)value;
- (void)removeMaturityDatesObject:(DmMaturityDates *)value;
- (void)addMaturityDates:(NSSet *)values;
- (void)removeMaturityDates:(NSSet *)values;

- (void)addSwapQuotesObject:(DmSwapQuotes *)value;
- (void)removeSwapQuotesObject:(DmSwapQuotes *)value;
- (void)addSwapQuotes:(NSSet *)values;
- (void)removeSwapQuotes:(NSSet *)values;

- (void)addZeroCouponQuotesObject:(DmZeroCouponQuotes *)value;
- (void)addZeroCouponQuoteAsNumber:(NSNumber *)value;
- (void)removeZeroCouponQuotesObject:(DmZeroCouponQuotes *)value;
- (void)addZeroCouponQuotes:(NSSet *)values;
- (void)removeZeroCouponQuotes:(NSSet *)values;

@end
