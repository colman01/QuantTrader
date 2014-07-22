//
//  DmCallableBonds.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmCallableBonds : NSManagedObject

@property (nonatomic, retain) NSDate * today;
@property (nonatomic, retain) NSNumber * forward;
@property (nonatomic, retain) NSNumber * daycounter;
@property (nonatomic, retain) NSNumber * compounding;
@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSNumber * bbCurveRate;
@property (nonatomic, retain) NSNumber * callPrice;
@property (nonatomic, retain) NSNumber * numberOfCallDates;
@property (nonatomic, retain) NSDate * callDate;
@property (nonatomic, retain) NSNumber * settlementDays;
@property (nonatomic, retain) NSDate * maturity;
@property (nonatomic, retain) NSDate * issue;
@property (nonatomic, retain) NSDate * dated;
@property (nonatomic, retain) NSNumber * accuracy;
@property (nonatomic, retain) NSNumber * maxIterations;
@property (nonatomic, retain) NSNumber * faceAmount;
@property (nonatomic, retain) NSNumber * redemption;
@property (nonatomic, retain) NSNumber * coupon;
@property (nonatomic, retain) NSNumber * gridIntervals;
@property (nonatomic, retain) NSNumber * reversionParameter;

@end
