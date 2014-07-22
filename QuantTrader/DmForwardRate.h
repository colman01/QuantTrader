//
//  DmForwardRate.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmForwardRate : NSManagedObject

@property (nonatomic, retain) NSDate * todaysDate;
@property (nonatomic, retain) NSData * threeMonthFraQuote;
@property (nonatomic, retain) NSData * monthsToStart;
@property (nonatomic, retain) NSNumber * fraTermMonths;
@property (nonatomic, retain) NSNumber * fraNotional;
@property (nonatomic, retain) NSNumber * freStrike;
@property (nonatomic, retain) NSNumber * forwardRate;
@property (nonatomic, retain) NSNumber * threeMonth;
@property (nonatomic, retain) NSNumber * spotValue;
@property (nonatomic, retain) NSNumber * forwardValue;
@property (nonatomic, retain) NSNumber * impliedYield;

@end
