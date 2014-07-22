//
//  DmReplication.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmReplication : NSManagedObject

@property (nonatomic, retain) NSDate * today;
@property (nonatomic, retain) NSData * barrierType;
@property (nonatomic, retain) NSNumber * rebate;
@property (nonatomic, retain) NSData * optionType;
@property (nonatomic, retain) NSNumber * underlyingValue;
@property (nonatomic, retain) NSNumber * strike;
@property (nonatomic, retain) NSNumber * riskFreeRate;
@property (nonatomic, retain) NSNumber * volatility;

@end
