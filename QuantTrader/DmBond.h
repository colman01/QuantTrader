//
//  DmBond.h
//  QuantTrader
//
//  Created by colman on 21/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PersistManager.h"

@class DmFixedBondScheduleRateAndDate, DmFloatingBondScheduleRateAndDate;

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
@property (nonatomic, retain) NSData * liborForcastingCurveQuotes;
@property (nonatomic, retain) NSData * issueDates;
@property (nonatomic, retain) NSData * maturityDates;
@property (nonatomic, retain) NSData * swapQuotes;
@property (nonatomic, retain) NSData * depositQuotes;
@property (nonatomic, retain) NSData * zeroCouponQuotes;
@property (nonatomic, retain) NSData * marketQuotes;
@property (nonatomic, retain) NSData * couponRates;
@property (nonatomic, retain) NSSet *fixedBondScheduleRateAndDate;
@property (nonatomic, retain) NSSet *floatingBondScheduleRateAndDate;


@property (nonatomic, retain) NSDate *zeroCouponBondFirstDate            ; // date_1
@property (nonatomic, retain) NSDate *zeroCouponBondSecondDate           ; // date_2
@property (nonatomic, retain) NSDate *fixedBondScheduleFirstDate         ; // date_3
@property (nonatomic, retain) NSDate *fixedBondScheduleSecondDate        ; // date_4
@property (nonatomic, retain) NSDate *fixedRateBondFirstDate             ; // date_5
@property (nonatomic, retain) NSDate *addFixingFirstDate                 ; // date_6
@property (nonatomic, retain) NSDate *floatingBondScheduleFirstDate      ; // date_7
@property (nonatomic, retain) NSDate *floatingBondScheduleSecondDate     ; // date_8
@property (nonatomic, retain) NSDate *floatingRateBondScheduleFirstDate  ; // date_9

@property (nonatomic, retain) NSDate *settlementDate;




@property (nonatomic, retain) NSNumber *zeroCouponBondNPV;

@property (nonatomic, retain) NSNumber *fixedRateBondNPV;
@property (nonatomic, retain) NSNumber *floatingRateBondNPV;

@property (nonatomic, retain) NSNumber *zeroCouponBondCleanPrice;
@property (nonatomic, retain) NSNumber *fixedRateBondCleanPrice ;
@property (nonatomic, retain) NSNumber *floatingRateBondCleanPrice;

@property (nonatomic, retain) NSNumber *zeroCouponBondDirtyPrice ;
@property (nonatomic, retain) NSNumber *fixedRateBondDirtyPrice ;
@property (nonatomic, retain) NSNumber *floatingRateBondDirtyPrice;


@property (nonatomic, retain) NSNumber *zeroCouponBondAccruedAmount;
@property (nonatomic, retain) NSNumber *fixedRateBondAccruedAmount;
@property (nonatomic, retain) NSNumber *floatingRateBondAccruedAmount;

@property (nonatomic, retain) NSNumber *fixedRateBondPreviousCoupon;
@property (nonatomic, retain) NSNumber *floatingRateBondPreviousCoupon;


@property (nonatomic, retain) NSNumber *fixedRateBondNextCoupon;
@property (nonatomic, retain) NSNumber *floatingRateBondNextCoupon ;

@property (nonatomic, retain) NSNumber *zeroCouponBondYield;
@property (nonatomic, retain) NSNumber *fixedRateBondYield;
@property (nonatomic, retain) NSNumber *floatingRateBondYield;



@end

@interface DmBond (CoreDataGeneratedAccessors)

- (void)addFixedBondScheduleRateAndDateObject:(DmFixedBondScheduleRateAndDate *)value;
- (void)removeFixedBondScheduleRateAndDateObject:(DmFixedBondScheduleRateAndDate *)value;
- (void)addFixedBondScheduleRateAndDate:(NSSet *)values;
- (void)removeFixedBondScheduleRateAndDate:(NSSet *)values;

- (void)addFloatingBondScheduleRateAndDateObject:(DmFloatingBondScheduleRateAndDate *)value;
- (void)removeFloatingBondScheduleRateAndDateObject:(DmFloatingBondScheduleRateAndDate *)value;
- (void)addFloatingBondScheduleRateAndDate:(NSSet *)values;
- (void)removeFloatingBondScheduleRateAndDate:(NSSet *)values;

- (void)addLiborForcastingCurveQuotesObject:(NSManagedObject *)value;
- (void)removeLiborForcastingCurveQuotesObject:(NSManagedObject *)value;
- (void)addLiborForcastingCurveQuotes:(NSSet *)values;
- (void)removeLiborForcastingCurveQuotes:(NSSet *)values;

- (void)addZeroCouponQuoteAsNumber:(NSNumber *)value;
- (void)removeZeroCouponQuoteAsNumber:(NSNumber *)value;

- (void)addissueDateAsDate:(NSDate *)value;

- (void)addDate:(NSDate *)value toData:(NSData *) dateArray;
- (void)removeDate:(NSDate *)value fromData:(NSData *) dateArray;

- (void)addValue:(NSNumber *)value toData:(NSData *) dataArray;
- (void)removeValue:(NSNumber *)value fromData:(NSData *) dataArray;

- (NSNumber *)getValue:(int)position fromData:(NSData *) dataArray;



- (void)addSwapQuoteAsNumber:(NSNumber *)value;
- (void) removeSwapQuoteAsNumber:(NSNumber *)value;

- (void)addNumber:(NSNumber *)value toData:(NSData *) target;
- (void)removeNumber:(NSNumber *)value fromData:(NSData *) target;

- (void)addDepositQuoteAsNumber:(NSNumber *)value;
- (void)removeDepositQuoteAsNumber:(NSNumber *)value;


- (void)addCouponRateAsNumber:(NSNumber *)value;
- (void) removeCouponRateAsNumber:(NSNumber *)value ;


- (void)addMarketQuoteAsNumber:(NSNumber *)value;
- (void) removeMarketQuoteAsNumber:(NSNumber *)value;

- (void)addMaturityDateAsDate:(NSDate *)value;
- (void) removeMaturityeDateAsDate:(NSDate *) value;

@end
