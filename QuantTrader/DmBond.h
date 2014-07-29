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
@property (nonatomic, retain) NSData * liborForcastingCurveQutotes;
@property (nonatomic, retain) NSData * issueDates;
@property (nonatomic, retain) NSData * maturityDates;
@property (nonatomic, retain) NSData * swapQuotes;
@property (nonatomic, retain) NSData * depositQuotes;
@property (nonatomic, retain) NSData * zeroCouponQuotes;
@property (nonatomic, retain) NSData * marketQuotes;
@property (nonatomic, retain) NSData * couponRates;
@property (nonatomic, retain) NSSet *fixedBondScheduleRateAndDate;
@property (nonatomic, retain) NSSet *floatingBondScheduleRateAndDate;
@property (nonatomic, retain) NSSet *liborForcastingCurveQuotes;

@property (nonatomic, retain) NSDate *zeroCouponBondFirstDate            ; // date_1
@property (nonatomic, retain) NSDate *zeroCouponBondSecondDate           ; // date_2
@property (nonatomic, retain) NSDate *fixedBondScheduleFirstDate         ; // date_3
@property (nonatomic, retain) NSDate *fixedBondScheduleSecondDate        ; // date_4
@property (nonatomic, retain) NSDate *fixedRateBondFirstDate             ; // date_5
@property (nonatomic, retain) NSDate *addFixingFirstDate                 ; // date_6
@property (nonatomic, retain) NSDate *floatingBondScheduleFirstDate      ; // date_7
@property (nonatomic, retain) NSDate *floatingBondScheduleSecondDate     ; // date_8
@property (nonatomic, retain) NSDate *floatingRateBondScheduleFirstDate  ; // date_9


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

@end
