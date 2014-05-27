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
    double fixedRateBondDirtyPrice;
    double floatingRateBondDirtyPrice;
    
    // Accured amount
    double zeroCouponBondAccruedAmount;
    double fixedRateBondAccruedAmount;
    double floatingRateBondAccruedAmount;
    
    // Previous Coupon
    double fixedrateBondPreviousCouponRate;
    double floatingRateBontPreviousCouponRate;
    
    // Next Coupon
    double fixedRateBondNextCouponRate;
    double floatingRateBoneNextCouponRate;
    
    // Yield
    double zeroCouponBondYieldActual360CompoundedAnnual;
    double fixedRateBondYieldActual360CompoundedAnnual;
    double floatingRateBondYieldActual360CompoundedAnnual;
    
    
    int fiXingDays;
    int settleMentDays;
    
    float zeroCoupon3mQuote;
    float zeroCoupon6mQuote;
    float zeroCoupon1yQuote;
    
    double redemp;
    
    int numBonds;
    
    NSMutableArray * newIssueDates;
    NSMutableArray * maturityDates;
    NSMutableArray * newCouponRates;
    NSMutableArray * newMarketQuotes;
    
    NSMutableArray * liborForcastingCurveQuotes;
    NSMutableArray * swapQuotes;
    
    float faceamount;
    
    NSDate * zeroCouponDate1;
    NSDate * zeroCouponDate2;
    
    NSDate * fixedBondScheduleDate_1;
    NSDate * fixedBondScheduleDate_2;
    
    NSDate * fixedRateBondDate;

    //libor
    
    NSDate * floatingBondScheduleDate_1;
    NSDate * floatingBondScheduleDate_2;
    
    NSDate * floatingRateBondDate;
    
    
}

-(void) setFixingDays:(int)numberOfDays;
-(void) setSettlementDays:(int)numberOfDays;
-(void) setRedemption:(double)redemption;
-(void) setBondNumber:(int)bondNumber;
-(void) setFaceAmount:(float)amount;
-(void) setZeroCouponDate:(NSDate *)first:(NSDate *)second;
-(void) setFixedBondDate:(NSDate *)first:(NSDate *)second;
-(void) setFixedRateBondDate:(NSDate *)first;

-(void) setFloatBondSchedule:(NSDate *)first:(NSDate *)second;
-(void) setFloatingBondRate:(NSDate *)first;


// dirty price
@property (nonatomic) double zeroCoupongBondDirtyPrice;
@property (nonatomic) double fixedRateBondDirtyPrice;
@property (nonatomic) double floatingRateBondDirtyPrice;

// Accured amount
@property (nonatomic) double zeroCouponBondAccruedAmount;
@property (nonatomic) double fixedRateBondAccruedAmount;
@property (nonatomic) double floatingRateBondAccruedAmount;

// Previous Coupon
@property (nonatomic) double fixedrateBondPreviousCouponRate;
@property (nonatomic) double floatingRateBontPreviousCouponRate;

// Next Coupon
@property (nonatomic) double fixedRateBondNextCouponRate;
@property (nonatomic) double floatingRateBoneNextCouponRate;

// Yield
@property (nonatomic) double zeroCouponBondYieldActual360CompoundedAnnual;
@property (nonatomic) double fixedRateBondYieldActual360CompoundedAnnual;
@property (nonatomic) double floatingRateBondYieldActual360CompoundedAnnual;

-(void) calculate;



@end
