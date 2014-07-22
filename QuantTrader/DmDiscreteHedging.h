//
//  DmDiscreteHedging.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmDiscreteHedging : NSManagedObject

@property (nonatomic, retain) NSData * type;
@property (nonatomic, retain) NSNumber * maturity;
@property (nonatomic, retain) NSNumber * strike;
@property (nonatomic, retain) NSNumber * underlying;
@property (nonatomic, retain) NSNumber * volatility;

@end
