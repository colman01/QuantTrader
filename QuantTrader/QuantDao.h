//
//  QuantDao.h
//  QuantTrader
//
//  Created by colman on 18/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.h"
#import "PersistManager.h"

@interface QuantDao : NSObject

@property (strong, nonatomic) DmBond *bond;


+ (QuantDao *) instance;
- (NSMutableArray*) getBond;
- (DmBond *) loadById:(NSNumber *) id;
- (void)remove:(DmBond *)bond;
- (NSMutableArray*) getEquity;


@end
