//
//  DmMarketModel.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmMarketModel : NSManagedObject

@property (nonatomic, retain) NSNumber * numberRates;
@property (nonatomic, retain) NSNumber * accrual;
@property (nonatomic, retain) NSNumber * firstTime;
@property (nonatomic, retain) NSNumber * fixedRate;
@property (nonatomic, retain) NSNumber * receive;
@property (nonatomic, retain) NSNumber * seed;
@property (nonatomic, retain) NSNumber * trainingPaths;
@property (nonatomic, retain) NSNumber * paths;
@property (nonatomic, retain) NSNumber * vegaPaths;
@property (nonatomic, retain) NSNumber * rateLevel;
@property (nonatomic, retain) NSNumber * initialNumeraireValue;
@property (nonatomic, retain) NSNumber * volLevel;
@property (nonatomic, retain) NSNumber * beta;
@property (nonatomic, retain) NSNumber * gamma;
@property (nonatomic, retain) NSNumber * numberOfFactors;
@property (nonatomic, retain) NSNumber * displacementLevel;
@property (nonatomic, retain) NSNumber * innerPaths;
@property (nonatomic, retain) NSNumber * outterPaths;
@property (nonatomic, retain) NSNumber * strike;
@property (nonatomic, retain) NSNumber * fixedMultiplier;
@property (nonatomic, retain) NSNumber * floatingSpread;
@property (nonatomic, retain) NSNumber * payer;

@end
