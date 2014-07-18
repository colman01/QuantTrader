//
//  DmFloatingBondScheduleRateAndDate.h
//  QuantTrader
//
//  Created by colman on 18/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmFloatingBondScheduleRateAndDate : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * rate;

@end
