//
//  DmBermudanSwaption.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmBermudanSwaption : NSManagedObject

@property (nonatomic, retain) NSNumber * numRows;
@property (nonatomic, retain) NSNumber * numCols;
@property (nonatomic, retain) NSData * swapLenghts;
@property (nonatomic, retain) NSDate * today;
@property (nonatomic, retain) NSData * swaptionVols;
@property (nonatomic, retain) NSDate * settlementDate;
@property (nonatomic, retain) NSNumber * flatRateSimpleQuote;

@end
