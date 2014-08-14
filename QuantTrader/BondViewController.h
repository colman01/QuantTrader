//
//  BondViewController.h
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bond.h"
#import "QuantDao.h"
#import "ParameterInitializer.h"

typedef void (^SetCompletionHandler) (NSString *value);

@interface BondViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Bond *bond;

@property (nonatomic, strong) ParameterInitializer *bondParameterInit;

@property (nonatomic, weak) IBOutlet UITableView *table;

//    float * ZeroC3mQuote;
@property (nonatomic) float ZeroC3mQuote;
@property (nonatomic) float ZeroC6mQuote;
@property (nonatomic) float ZeroC1yQuote;

@property (nonatomic) int redemption_;

@property (nonatomic) int fiXingDays;
@property (nonatomic) int settleMentDays;

//19
@property (nonatomic) float zeroCoupon3mQuote;
@property (nonatomic) float zeroCoupon6mQuote;
@property (nonatomic) float zeroCoupon1yQuote;

@property (nonatomic) double redemp;

@property (nonatomic) int numBonds;


@property (nonatomic, strong) NSMutableArray * issueDates;
@property (nonatomic, strong) NSMutableArray * maturityDates;
@property (nonatomic, strong) NSMutableArray * couponRates;
@property (nonatomic, strong) NSMutableArray * marketQuotes;

@property (nonatomic) NSMutableArray * liborForcastingCurveQuotes;
@property (nonatomic) NSMutableArray * swapQuotes;

@property (nonatomic) float faceamount;

@property (nonatomic) NSDate * zeroCouponDate1;
@property (nonatomic) NSDate * zeroCouponDate2;

@property (nonatomic) NSDate * fixedBondScheduleDate_1;
@property (nonatomic) NSDate * fixedBondScheduleDate_2;
//12
@property (nonatomic) NSDate * fixedRateBondDate;

//libor
//13
@property (nonatomic) NSDate * floatingBondScheduleDate_1;
@property (nonatomic) NSDate * floatingBondScheduleDate_2;

@property (nonatomic) NSDate * floatingRateBondDate;

// dirty price 14
@property (nonatomic) double zeroCouponBondDirtyPrice;
@property (nonatomic) double fixedRateBondDirtyPrice;
@property (nonatomic) double floatingRateBondDirtyPrice;

// Accured amount 15
@property (nonatomic) double zeroCouponBondAccruedAmount;
@property (nonatomic) double fixedRateBondAccruedAmount;
@property (nonatomic) double floatingRateBondAccruedAmount;

// Previous Coupon 16
@property (nonatomic) double fixedrateBondPreviousCouponRate;
@property (nonatomic) double floatingRateBontPreviousCouponRate;

// Next Coupon 17
@property (nonatomic) double fixedRateBondNextCouponRate;
@property (nonatomic) double floatingRateBoneNextCouponRate;

// Yield 18
@property (nonatomic) double zeroCouponBondYieldActual360CompoundedAnnual;
@property (nonatomic) double fixedRateBondYieldActual360CompoundedAnnual;
@property (nonatomic) double floatingRateBondYieldActual360CompoundedAnnual;




@end
