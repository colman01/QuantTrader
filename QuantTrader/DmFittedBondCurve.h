//
//  DmFittedBondCurve.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmFittedBondCurve : NSManagedObject

@property (nonatomic, retain) NSNumber * numberOfBonds;
@property (nonatomic, retain) NSData * lengths;
@property (nonatomic, retain) NSNumber * redemption;
@property (nonatomic, retain) NSNumber * dayCounter;
@property (nonatomic, retain) NSData * frequency;
@property (nonatomic, retain) NSData * coupons;
@property (nonatomic, retain) NSNumber * curveSettlementDays;
@property (nonatomic, retain) NSNumber * bondSettlementDays;

@end
