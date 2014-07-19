//
//  Bomd.h
//  QuantLibExample
//
//  Created by colman on 10.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuantDao.h"

@interface Bond : NSObject {
    
//    float * ZeroC3mQuote;
    float ZeroC3mQuote;
    float ZeroC6mQuote;
    float ZeroC1yQuote;
    
    int redemption_;
    
    // dirty price
    double zeroCoupongBondDirtyPrice;

    
    // Next Coupon
    double fixedRateBondNextCouponRate;
    double floatingRateBoneNextCouponRate;
    
    // Yield
    double zeroCouponBondYieldActual360CompoundedAnnual;
    double fixedRateBondYieldActual360CompoundedAnnual;
    double floatingRateBondYieldActual360CompoundedAnnual;
    
        int settleMentDays;

    NSMutableArray * maturityDates;
    NSMutableArray * newCouponRates;
    NSMutableArray * newMarketQuotes;
    
    NSMutableArray * liborForcastingCurveQuotes;
    NSMutableArray * swapQuotes;
    
    NSDate * fixedRateBondDate;

    //libor
    
    NSDate * floatingRateBondDate;
    
    
}

-(void) setupParameters;



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