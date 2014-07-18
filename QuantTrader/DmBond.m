//
//  DmBond.m
//  QuantTrader
//
//  Created by colman on 18/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "DmBond.h"
#import "DmFixedBondScheduleRateAndDate.h"
#import "DmAccruedAmount.h"
#import "DmCouponRates.h"
#import "DmFloatingBondScheduleRateAndDate.h"
#import "DmIssueDates.h"
#import "DmLiborForcastingCurveQutotes.h"
#import "DmMarketQuotes.h"
#import "DmMaturityDates.h"
#import "DmSwapQuotes.h"


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
@dynamic fixedBondScheduleRateAndDate;
@dynamic floatingBondScheduleRateAndDate;
@dynamic liborForcastingCurveQuotes;
@dynamic marketQuotes;
@dynamic maturityDates;
@dynamic swapQuotes;
@dynamic issueDates;
@dynamic couponRates;




//- (void)addVideoObject:(DmVideo *)value {
//    NSSet *tempSet = [NSSet setWithObjects:self.video, nil];
//    
//    NSArray *vids = [self.video allObjects];
//    NSMutableArray *vids_ = [[NSMutableArray alloc] initWithArray:vids];
//    [vids_ addObject:value];
//    self.video = [[NSSet alloc] initWithArray:[[NSArray alloc] initWithArray:vids_]];
//    
//    //
//    //    NSMutableOrderedSet* tempSet_ = [NSMutableOrderedSet orderedSetWithOrderedSet:self.video];
//    //    [tempSet_ addObject:value];
//    //    self.video = [NSSet set
//    
//    
//    //	NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.images];
//    //	[tempSet addObject:value];
//    //	self.images = tempSet;
//}
//
//
//- (void)addQuestionObject:(DmQuestion *)value{
//    NSSet *tempSet = [NSSet setWithObjects:self.question, nil];
//    
//    NSArray *question = [self.question allObjects];
//    NSMutableArray *question_ = [[NSMutableArray alloc] initWithArray:question];
//    [question_ addObject:value];
//    self.question = [[NSSet alloc] initWithArray:[[NSArray alloc] initWithArray:question_]];
//    if (!self.questionObject) {
//        questionObject = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
//    }
//    self.questionObject = value;
//    
//}



- (void)addAccruedAmountLinkObject:(DmAccruedAmount *)value{};
- (void)removeAccruedAmountLinkObject:(DmAccruedAmount *)value{};
- (void)addAccruedAmountLink:(NSSet *)values{};
- (void)removeAccruedAmountLink:(NSSet *)values{};

- (void)addFixedBondScheduleRateAndDateObject:(DmFixedBondScheduleRateAndDate *)value{};
- (void)removeFixedBondScheduleRateAndDateObject:(DmFixedBondScheduleRateAndDate *)value{};
- (void)addFixedBondScheduleRateAndDate:(NSSet *)values{};
- (void)removeFixedBondScheduleRateAndDate:(NSSet *)values{};

- (void)addFloatingBondScheduleRateAndDateObject:(DmFloatingBondScheduleRateAndDate *)value{};
- (void)removeFloatingBondScheduleRateAndDateObject:(DmFloatingBondScheduleRateAndDate *)value{};
- (void)addFloatingBondScheduleRateAndDate:(NSSet *)values{};
- (void)removeFloatingBondScheduleRateAndDate:(NSSet *)values{};

- (void)addLiborForcastingCurveQuotesObject:(DmLiborForcastingCurveQutotes *)value{};
- (void)removeLiborForcastingCurveQuotesObject:(DmLiborForcastingCurveQutotes *)value{};
- (void)addLiborForcastingCurveQuotes:(NSSet *)values{};
- (void)removeLiborForcastingCurveQuotes:(NSSet *)values{};

- (void)addMarketQuotesObject:(DmMarketQuotes *)value{};
- (void)removeMarketQuotesObject:(DmMarketQuotes *)value{};
- (void)addMarketQuotes:(NSSet *)values{};
- (void)removeMarketQuotes:(NSSet *)values{};

- (void)addMaturityDatesObject:(DmMaturityDates *)value{};
- (void)removeMaturityDatesObject:(DmMaturityDates *)value{};
- (void)addMaturityDates:(NSSet *)values{};
- (void)removeMaturityDates:(NSSet *)values{};

- (void)addSwapQuotesObject:(DmSwapQuotes *)value{};
- (void)removeSwapQuotesObject:(DmSwapQuotes *)value{};
- (void)addSwapQuotes:(NSSet *)values{};
- (void)removeSwapQuotes:(NSSet *)values{};

- (void)addIssueDatesObject:(DmIssueDates *)value{};
- (void)removeIssueDatesObject:(DmIssueDates *)value{};
- (void)addIssueDates:(NSSet *)values{};
- (void)removeIssueDates:(NSSet *)values{};

- (void)addCouponRatesObject:(DmCouponRates *)value{};
- (void)removeCouponRatesObject:(DmCouponRates *)value{};
- (void)addCouponRates:(NSSet *)values{};
- (void)removeCouponRates:(NSSet *)values{};


@end
