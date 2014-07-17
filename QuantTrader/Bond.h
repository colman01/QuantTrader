//
//  Bomd.h
//  QuantLibExample
//
//  Created by colman on 10.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bond : NSObject {
    
//    float * ZeroC3mQuote;
    float ZeroC3mQuote;
    float ZeroC6mQuote;
    float ZeroC1yQuote;
    
    int redemption_;
    
    // dirty price
    double zeroCoupongBondDirtyPrice;
//    double fixedRateBondDirtyPrice;
//    double floatingRateBondDirtyPrice;
    
    // Accured amount
//    double zeroCouponBondAccruedAmount;
//    double fixedRateBondAccruedAmount;
//    double floatingRateBondAccruedAmount;
    
    // Previous Coupon
//    double fixedrateBondPreviousCouponRate;
//    double floatingRateBontPreviousCouponRate;
    
    // Next Coupon
    double fixedRateBondNextCouponRate;
    double floatingRateBoneNextCouponRate;
    
    // Yield
    double zeroCouponBondYieldActual360CompoundedAnnual;
    double fixedRateBondYieldActual360CompoundedAnnual;
    double floatingRateBondYieldActual360CompoundedAnnual;
    
    
//    int fiXingDays;
    int settleMentDays;
    
//    float zeroCoupon3mQuote;
//    float zeroCoupon6mQuote;
//    float zeroCoupon1yQuote;
    
//    double redemp;
    
//    int numBonds;
    
//    NSMutableArray * formatedIssueDates;
    NSMutableArray * maturityDates;
    NSMutableArray * newCouponRates;
    NSMutableArray * newMarketQuotes;
    
    NSMutableArray * liborForcastingCurveQuotes;
    NSMutableArray * swapQuotes;
    
//    float faceamount;
    
//    NSDate * zeroCouponDate1;
//    NSDate * zeroCouponDate2;
    
//    NSDate * fixedBondScheduleDate_1;
//    NSDate * fixedBondScheduleDate_2;
    
    NSDate * fixedRateBondDate;

    //libor
    
//    NSDate * floatingBondScheduleDate_1;
//    NSDate * floatingBondScheduleDate_2;
    
    NSDate * floatingRateBondDate;
    
    
}

-(void) setupParameters;

-(void) setFixingDays:(int)numberOfDays;
-(void) setSettlementDays:(int)numberOfDays;
-(void) setRedemption:(double)redemption;
-(void) setBondNumber:(int)bondNumber;
-(void) setFaceAmount:(float)amount;
-(void) setZeroCouponDate:(NSDate *) first:(NSDate *)second;
-(void) setFixedBondDate:(NSDate *) first:(NSDate *)second;
-(void) setFixedRateBondDate:(NSDate *)first;

-(void) setFloatBondSchedule:(NSDate *) first:(NSDate *)second;
-(void) setFloatingBondRate:(NSDate *)first;


// dirty price
//@property (nonatomic) double zeroCoupongBondDirtyPrice;
//@property (nonatomic) double fixedRateBondDirtyPrice;
//@property (nonatomic) double floatingRateBondDirtyPrice;

// Accured amount
//@property (nonatomic) double zeroCouponBondAccruedAmount;
//@property (nonatomic) double fixedRateBondAccruedAmount;
//@property (nonatomic) double floatingRateBondAccruedAmount;

// Previous Coupon
//@property (nonatomic) double fixedrateBondPreviousCouponRate;
//@property (nonatomic) double floatingRateBontPreviousCouponRate;

// Next Coupon
//@property (nonatomic) double fixedRateBondNextCouponRate;
//@property (nonatomic) double floatingRateBoneNextCouponRate;

// Yield
@property (nonatomic) double zeroCouponBondYieldActual360CompoundedAnnual;
@property (nonatomic) double fixedRateBondYieldActual360CompoundedAnnual;
@property (nonatomic) double floatingRateBondYieldActual360CompoundedAnnual;

@property (nonatomic) int fiXingDays;


@property (strong, nonatomic)     NSMutableArray * formatedIssueDates;
@property (strong, nonatomic)     NSMutableArray * formatedMaturiyDates;

@property ( nonatomic) float zeroCoupon3mQuote;
@property ( nonatomic) float zeroCoupon6mQuote;
@property ( nonatomic) float zeroCoupon1yQuote;


@property (nonatomic, strong) NSNumber *redemp;

@property (nonatomic) int numBonds;

@property (strong, nonatomic) NSMutableArray * bondCouponRates;
@property (strong, nonatomic) NSMutableArray * bondMarketQuotes;

@property (strong, nonatomic) NSMutableArray * bondLiborForcastingCurveQuotes;

@property (strong, nonatomic) NSMutableArray * bondSwapQuotes;

@property (nonatomic) float faceamount;


@property (strong, nonatomic) NSString * zeroCouponDate1;
@property (strong, nonatomic) NSString * zeroCouponDate2;

@property (strong, nonatomic) NSDate * fixedBondScheduleDate_1;
@property (strong, nonatomic) NSDate * fixedBondScheduleDate_2;

@property (strong, nonatomic) NSDate * floatingBondScheduleDate_1;
@property (strong, nonatomic) NSDate * floatingBondScheduleDate_2;

// Net present value
@property (strong, nonatomic) NSNumber *zeroCouponBondNPV;
@property (strong, nonatomic) NSNumber *fixedRateBondNPV;
@property (strong, nonatomic) NSNumber *floatingRateBondNPV;

// Clean price
@property (strong, nonatomic) NSNumber *zeroCouponBondCleanPrice;
@property (strong, nonatomic) NSNumber *fixedRateBondCleanPrice;
@property (strong, nonatomic) NSNumber *floatingRateBondCleanPrice;

// Dirty price
@property (strong, nonatomic) NSNumber *zeroCouponBondDirtyPrice;
@property (strong, nonatomic) NSNumber *fixedRateBondDirtyPrice;
@property (strong, nonatomic) NSNumber *floatingRateBondDirtyPrice;

// Accruced coupon
@property (strong, nonatomic) NSNumber *zeroCouponBondAccruedAmount;
@property (strong, nonatomic) NSNumber *fixedRateBondAccruedAmount;
@property (strong, nonatomic) NSNumber *floatingRateBondAccruedAmount;

// Previous coupon
@property (strong, nonatomic) NSNumber *zeroCouponBondPreviousCoupon;
@property (strong, nonatomic) NSNumber *fixedRateBondPreviousCoupon;
@property (strong, nonatomic) NSNumber *floatingRateBondPreviousCoupon;

// Next coupon
@property (strong, nonatomic) NSNumber *zeroCouponBondNextCoupon;
@property (strong, nonatomic) NSNumber *fixedRateBondNextCoupon;
@property (strong, nonatomic) NSNumber *floatingRateBondNextCoupon;

// Yield
@property (strong, nonatomic) NSNumber *zeroCouponBondYield;
@property (strong, nonatomic) NSNumber *fixedRateBondYield;
@property (strong, nonatomic) NSNumber *floatingRateBondYield;




-(void) calculate;



@end


////////////////////////////
// chunk setupParameters
////////////////////////////

//    self.newIssueDates = issueDates;
//
//    QuantLib::Date maturities[] = {
//        QuantLib::Date (31, QuantLib::August, 2010),
//        QuantLib::Date (31, QuantLib::August, 2011),
//        QuantLib::Date (31, QuantLib::August, 2013),
//        QuantLib::Date (15, QuantLib::August, 2018),
//        QuantLib::Date (15, QuantLib::May, 2038)
//    };
//
//    self.maturityDates = maturities;
//    Real couponRates[] = {
//        0.02375,
//        0.04625,
//        0.03125,
//        0.04000,
//        0.04500
//    };
//
//    Real marketQuotes[] = {
//        100.390625,
//        106.21875,
//        100.59375,
//        101.6875,
//        102.140625
//    };

// end chunk